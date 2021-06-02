FROM mcr.microsoft.com/mssql/server:2019-CU10-ubuntu-20.04
USER root
RUN set -eux; \
        wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll; \
	ls -al /var
	ls -al /var/opt
	cd /
	find -name mssql
	mv RegEx.dll /var/opt/mssql/data/;
