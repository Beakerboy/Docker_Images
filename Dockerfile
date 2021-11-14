FROM mcr.microsoft.com/mssql/server:2017-latest-ubuntu

RUN set -eux; \
	curl -fSL "wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll"; \
	mv RegEx.dll /var/opt/mssql/data/; \
