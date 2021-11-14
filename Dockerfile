FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

RUN set -eux; \
	wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll; \
        mkdir /var/opt/mssql/data; \
	mv RegEx.dll /var/opt/mssql/data/; \
