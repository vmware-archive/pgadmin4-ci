# currently published as pivotaldata/pgadmin:postgres-10

FROM pivotaldata/pgadmin:base-python-selenium-chrome

### Build postgres 10 from source

RUN set -ex; \
	if ! command -v gpg > /dev/null; then \
		apt-get update; \
		apt-get install -y --no-install-recommends \
			gnupg2 \
			dirmngr \
		; \
		rm -rf /var/lib/apt/lists/*; \
	fi

# explicitly set user/group IDs
RUN groupadd -r postgres --gid=999 && useradd -m -r -g postgres --uid=999 postgres

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
	&& export GNUPGHOME="$(mktemp -d)" \
	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
	&& chmod +x /usr/local/bin/gosu \
	&& gosu nobody true

# make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
 && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8 \
 && mkdir /docker-entrypoint-initdb.d

RUN set -ex; \
# pub   4096R/ACCC4CF8 2011-10-13 [expires: 2019-07-02]
#       Key fingerprint = B97B 0AFC AA1A 47F0 44F2  44A0 7FCC 7D46 ACCC 4CF8
# uid                  PostgreSQL Debian Repository
	key='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8'; \
	export GNUPGHOME="$(mktemp -d)"; \
	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
	gpg --export "$key" > /etc/apt/trusted.gpg.d/postgres.gpg; \
	rm -rf "$GNUPGHOME"; \
	apt-key list

ENV LANG en_US.utf8
ENV PG_MAJOR 10
ENV PG_VERSION 10.1-1.pgdg90+1

# Recommend pg10 libraries
#RUN wget http://archive.ubuntu.com/ubuntu/pool/main/i/icu/icu_52.1.orig.tar.gz && apt-get install icu_52.1.orig.tar.gz
RUN echo 'deb http://security.ubuntu.com/ubuntu trusty-security main' > /etc/apt/sources.list.d/bamm.list \
 && echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list \
 && apt-get update && apt-get install -y libicu52 \
 && apt-get install -y postgresql-common \
    postgresql-$PG_MAJOR \
    postgresql-contrib-$PG_MAJOR \
 && sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
 && rm -rf /var/lib/apt/lists/*

# make the sample config easier to munge (and "correct by default")
RUN mv -v /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample /usr/share/postgresql/ \
 && ln -sv ../postgresql.conf.sample /usr/share/postgresql/$PG_MAJOR/ \
 && sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample \
 && mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql

ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
ENV PGDATA /var/lib/postgresql/data
RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
VOLUME /var/lib/postgresql/data

COPY postgres_start.sh /opt/bin/postgres_start.sh
COPY postgres_stop.sh /opt/bin/postgres_stop.sh
RUN chmod 500 /opt/bin/postgres_start.sh /opt/bin/postgres_stop.sh
