var base64 = require('base64-stream');
var Imap = require('imap');
var imap = new Imap({
    user: 'xxxxx',
    password: 'xxxxx',
    host: 'imap.gmail.com',
    port: 993,
    tls: true
    ,debug: function(msg){console.log('imap:', msg);}
});

helloWorld = function (req, res) {
    console.log('Starting the app');
    const gcpConfig = {
        bucketName: 'pgadmin-binaries',
        folderName: 'patches'
    };

    let allFilesDownloading = [];
    const Storage = require('@google-cloud/storage');
    // Creates a client
    const storage = new Storage();

    function getPublicUrl(filename) {
        return `https://storage.googleapis.com/${gcpConfig.bucketName}/${gcpConfig.folderName}/${filename}`;
    }

    function isNewAttachment(filename) {
        const gcsname = filename;

        const file = storage
            .bucket(gcpConfig.bucketName)
            .file(gcpConfig.folderName + '/' + gcsname);

        return file.exists()
            .then(function (exists) {
                if (exists[0]
                ) {
                    return Promise.reject("File exits");
                }
            })
    }

    function sendUploadToGCS(filename, encoding, stream, seqno) {
        var prefix = '(#' + seqno + ') ';
        const gcsname = filename;
        // const file = bucket.file(gcpConfig.bucketName);

        const file = storage
            .bucket(gcpConfig.bucketName)
            .file(gcpConfig.folderName + '/' + gcsname);

        const gcpStream = file.createWriteStream();

        gcpStream.on('error', function (err) {
            console.log('pifo');
            console.error('Error while uploading ', filename, ': ', err)
        });

        gcpStream.on('finish', function () {
            console.log(prefix + 'Finished updloading: ', filename);
            file.makePublic().then(function () {
                console.log('Now is public');
                console.log(getPublicUrl(gcsname));
            });
        });
        console.log(prefix + 'Start stream', filename);
        if (encoding.toUpperCase() === 'BASE64') {
            //the stream is base64 encoded, so here the stream is decode on the fly and piped to the write stream (file)
            stream.pipe(base64.decode()).pipe(gcpStream);
        } else {
            //here we have none or some other decoding streamed directly to the file which renders it useless probably
            stream.pipe(gcpStream);
        }

        // gcpStream.end(req.file.buffer);
    }

    function findAttachmentParts(struct, attachments) {
        attachments = attachments || [];
        for (var i = 0, len = struct.length, r; i < len; ++i) {
            if (Array.isArray(struct[i])) {
                findAttachmentParts(struct[i], attachments);
            } else {
                if (struct[i].disposition && ['INLINE', 'ATTACHMENT'].indexOf(struct[i].disposition.type) > -1) {
                    attachments.push(struct[i]);
                }
            }
        }
        return attachments;
    }

    function buildAttMessageFunction(attachment, promise) {
        var filename = attachment.params.name;
        var encoding = attachment.encoding;

        return function (msg, seqno) {
            var prefix = '(#' + seqno + ') ';
            msg.on('body', function (stream, info) {
                //Create a write stream so that we can stream the attachment to file;
                console.log('shazaammmm')
                console.log(prefix + 'Streaming this attachment to file', filename, info);
                sendUploadToGCS(filename, encoding, stream, seqno);
            });
            msg.once('end', function () {
                console.log(prefix + 'Finished attachment %s', filename);
                Promise.resolve(promise);
            });
        };
    }

    imap.once('ready', function () {
        imap.openBox('INBOX', true, function (err, box) {
            if (err) throw err;
            let lastMessages = 100;
            if (box.messages.total < lastMessages) {
                lastMessages = 1;
            }
            var f = imap.seq.fetch(lastMessages + ':*', {
                bodies: ['HEADER.FIELDS (FROM TO SUBJECT DATE)'],
                struct: true
            });
            f.on('message', function (msg, seqno) {
                console.log('Message #%d', seqno);
                var prefix = '(#' + seqno + ') ';
                msg.on('body', function (stream, info) {
                    var buffer = '';
                    stream.on('data', function (chunk) {
                        buffer += chunk.toString('utf8');
                    });
                    stream.once('end', function () {
                        console.log(prefix + 'Parsed header: %s', Imap.parseHeader(buffer));
                    });
                });
                msg.once('attributes', function (attrs) {
                    var attachments = findAttachmentParts(attrs.struct);
                    console.log(prefix + 'Has attachments: %d', attachments.length);
                    for (var i = 0, len = attachments.length; i < len; ++i) {
                        var attachment = attachments[i];
                        /*This is how each attachment looks like {
                            partID: '2',
                            type: 'application',
                            subtype: 'octet-stream',
                            params: { name: 'file-name.ext' },
                            id: null,
                            description: null,
                            encoding: 'BASE64',
                            size: 44952,
                            md5: null,
                            disposition: { type: 'ATTACHMENT', params: { filename: 'file-name.ext' } },
                            language: null
                          }
                        */
                        allFilesDownloading.push(new Promise(function () {
                        }));
                        let promise = allFilesDownloading[allFilesDownloading.length - 1]
                        isNewAttachment(attachment.params.name)
                            .then(function () {
                                console.log(prefix + 'Fetching attachment %s', attachment.params.name);
                                var f = imap.fetch(attrs.uid, {
                                    bodies: [attachment.partID],
                                    struct: true
                                });
                                //build function to process attachment message
                                f.on('message', buildAttMessageFunction(attachment, promise));
                            })
                            .catch(function () {
                                console.log('file "%s" already exists!!', attachment.params.name)
                                return Promise.resolve(promise);
                            });

                    }
                });
                msg.once('end', function () {
                    console.log(prefix + 'Finished email');
                });
            });
            f.once('error', function (err) {
                console.log('Fetch error: ' + err);
            });
            f.once('end', function () {
                console.log('Possibly ending');
                console.log('At the end: ', allFilesDownloading)
                Promise.all(allFilesDownloading).then(function () {
                    console.log('Done fetching all messages!');
                    imap.end();
                    res.status(200).send('Success: ' + req.body.message);
                }).catch(function (error) {
                    console.log('Error: ', error);
                    imap.end();
                    res.status(200).send('Success: ' + req.body.message);
                })

            });
        });
    });

    imap.once('error', function (err) {
        console.log(err);
    });

    imap.once('end', function () {
        console.log('Connection ended');
    });

    // Example input: {"message": "Hello!"}
    if (req.body.message === undefined) {
        // This is an error case, as "message" is required.
        res.status(400).send('No message defined!');
    } else {
        // Everything is okay.
        imap.connect();
        console.log(req.body.message);
        // res.status(200).send('Success: ' + req.body.message);
    }
};

// helloWorld({body: {message: 'bammm'}}, {});
exports.helloWorld = helloWorld;