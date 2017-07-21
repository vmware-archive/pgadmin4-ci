# currently published as pivotaldata/pgadmin:gpdb-5

FROM pivotaldata/pgadmin:base-python-36-selenium-chrome

RUN apt-get update
RUN apt-get install -y git-core \
    gcc g++ \
    ccache \
    libreadline-dev \
    bison flex \
    zlib1g-dev \
    openssl libssl-dev \
    libpam-dev \
    libbz2-dev \
    python-dev \
    ssh \
    libapr1-dev \
    libcurl4-gnutls-dev \
    libevent-dev \
    libssl-dev libffi-dev python-dev \
    libxml2-dev libperl-dev ssh \
    net-tools iputils-ping

# explicitly set user/group IDs
RUN groupadd -r supergroup --gid=999 \
 && useradd -m -r -G supergroup,tty --uid=999 gpadmin

# grab gosu for easy step-down from root
ENV GOSU_VERSION 1.7
RUN set -x \
 && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
 && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
 && wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
 && export GNUPGHOME="$(mktemp -d)" \
 && gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
 && gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
 && rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
 && chmod +x /usr/local/bin/gosu \
 && gosu nobody true

RUN pip install lockfile \
    paramiko \
    setuptools \
    psutil

RUN mkdir gpdb_src \
 && chown gpadmin gpdb_src \
 && gosu gpadmin git clone https://github.com/fotomut/gpdb.git gpdb_src


#create ssh keys so you can do ssh localhost without a password
#ie ssh-keygen
#then cp ~/.ssh/id_rsa.pub authorized_keys


#Package libcurl4-dev is a virtual package provided by:
#libcurl4-openssl-dev 7.38.0-4+deb8u2
#libcurl4-nss-dev 7.38.0-4+deb8u2
#libcurl4-gnutls-dev 7.38.0-4+deb8u2

#apt-get install -y python-pip

#Note: debian8 required pip install --pre psutil

#sysctl.conf
#kernel.shmmax = 500000000
#kernel.shmmni = 4096
#kernel.shmall = 4000000000
#kernel.sem = 250 512000 100 2048
#kernel.sysrq = 1
#kernel.core_uses_pid = 1
#kernel.msgmnb = 65536
#kernel.msgmax = 65536
#kernel.msgmni = 2048
#net.ipv4.tcp_syncookies = 1
#net.ipv4.ip_forward = 0
#net.ipv4.conf.default.accept_source_route = 0
#net.ipv4.tcp_tw_recycle = 1
#net.ipv4.tcp_max_syn_backlog = 4096
#net.ipv4.conf.all.arp_filter = 1
#net.ipv4.ip_local_port_range = 1025 65535
#net.core.netdev_max_backlog = 10000
#net.core.rmem_max = 2097152
#net.core.wmem_max = 2097152
#vm.overcommit_memory = 2
#
#limits.conf
#* soft nofile 65536
#* hard nofile 65536
#* soft nproc 131072
#* hard nproc 131072

RUN cd gpdb_src && gosu gpadmin ./configure --disable-orca  --with-perl --with-python --with-libxml --prefix=/usr/local/gpdb
RUN cd gpdb_src && gosu gpadmin make
RUN cd gpdb_src && make install



RUN locale-gen "en_US.UTF-8" && dpkg-reconfigure locales

#RUN MAKE_TEST_COMMAND=foo TEST_OS=ubuntu /gpdb_src/concourse/scripts/ic_gpdb.bash
#
## Bring in greenplum environment into your running shell
#RUN source /usr/local/gpdb/greenplum_path.sh



COPY postgres_start.sh /opt/bin/postgres_start.sh
RUN chmod 500 /opt/bin/postgres_start.sh


#COPY initialize_gpdb.sh /opt/bin/initialize_gpdb.sh
#RUN chmod 500 /opt/bin/initialize_gpdb.sh






































#RUN set -ex; \
#	if ! command -v gpg > /dev/null; then \
#		apt-get update; \
#		apt-get install -y --no-install-recommends \
#			gnupg2 \
#			dirmngr \
#		; \
#		rm -rf /var/lib/apt/lists/*; \
#	fi
#
## explicitly set user/group IDs
#RUN groupadd -r postgres --gid=999 && useradd -m -r -g postgres --uid=999 postgres
#
## grab gosu for easy step-down from root
#ENV GOSU_VERSION 1.7
#RUN set -x \
#	&& apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
#	&& wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture)" \
#	&& wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$(dpkg --print-architecture).asc" \
#	&& export GNUPGHOME="$(mktemp -d)" \
#	&& gpg --keyserver ha.pool.sks-keyservers.net --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
#	&& gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu \
#	&& rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc \
#	&& chmod +x /usr/local/bin/gosu \
#	&& gosu nobody true
#
## make the "en_US.UTF-8" locale so postgres will be utf-8 enabled by default
#RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
#	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8
#ENV LANG en_US.utf8
#
#RUN mkdir /docker-entrypoint-initdb.d
#
#RUN set -ex; \
## pub   4096R/ACCC4CF8 2011-10-13 [expires: 2019-07-02]
##       Key fingerprint = B97B 0AFC AA1A 47F0 44F2  44A0 7FCC 7D46 ACCC 4CF8
## uid                  PostgreSQL Debian Repository
#	key='B97B0AFCAA1A47F044F244A07FCC7D46ACCC4CF8'; \
#	export GNUPGHOME="$(mktemp -d)"; \
#	gpg --keyserver ha.pool.sks-keyservers.net --recv-keys "$key"; \
#	gpg --export "$key" > /etc/apt/trusted.gpg.d/postgres.gpg; \
#	rm -rf "$GNUPGHOME"; \
#	apt-key list
#
#ENV PG_MAJOR 9.6
#ENV PG_VERSION 9.6.3-1.pgdg80+1
#
#RUN echo 'deb http://apt.postgresql.org/pub/repos/apt/ jessie-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list
#
#RUN apt-get update \
#	&& apt-get install -y postgresql-common \
#	&& sed -ri 's/#(create_main_cluster) .*$/\1 = false/' /etc/postgresql-common/createcluster.conf \
#	&& apt-get install -y \
#		postgresql-$PG_MAJOR=$PG_VERSION \
#		postgresql-contrib-$PG_MAJOR=$PG_VERSION \
#	&& rm -rf /var/lib/apt/lists/*
#
## make the sample config easier to munge (and "correct by default")
#RUN mv -v /usr/share/postgresql/$PG_MAJOR/postgresql.conf.sample /usr/share/postgresql/ \
#	&& ln -sv ../postgresql.conf.sample /usr/share/postgresql/$PG_MAJOR/ \
#	&& sed -ri "s!^#?(listen_addresses)\s*=\s*\S+.*!\1 = '*'!" /usr/share/postgresql/postgresql.conf.sample
#
#RUN mkdir -p /var/run/postgresql && chown -R postgres:postgres /var/run/postgresql && chmod 2777 /var/run/postgresql
#
#ENV PATH /usr/lib/postgresql/$PG_MAJOR/bin:$PATH
#ENV PGDATA /var/lib/postgresql/data
#RUN mkdir -p "$PGDATA" && chown -R postgres:postgres "$PGDATA" && chmod 777 "$PGDATA" # this 777 will be replaced by 700 at runtime (allows semi-arbitrary "--user" values)
#VOLUME /var/lib/postgresql/data
#

#COPY postgres_start.sh /opt/bin/postgres_start.sh
#COPY postgres_stop.sh /opt/bin/postgres_stop.sh
#RUN chmod 500 /opt/bin/postgres_start.sh /opt/bin/postgres_stop.sh