FROM mcr.microsoft.com/mssql/server:2019-CU10-ubuntu-20.04
RUN set -eux; \
        wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll; \
	#curl -fSL "https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll"; \
	mv RegEx.dll /var/opt/mssql/data/; \
