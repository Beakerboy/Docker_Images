FROM mcr.microsoft.com/mssql/server:2019-CU10-ubuntu-20.04
RUN set -eux; \
        sudo wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll; \
	sudo mv RegEx.dll /var/opt/mssql/data/;
