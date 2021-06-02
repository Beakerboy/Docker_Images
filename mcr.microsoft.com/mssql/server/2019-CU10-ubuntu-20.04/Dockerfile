FROM mcr.microsoft.com/mssql/server:2019-CU10-ubuntu-20.04
RUN set -eux; \
        wget https://github.com/Beakerboy/drupal-sqlsrv-regex/releases/download/1.0/RegEx.dll; \
	list="$(ls -al)" && echo $list; \
	list="$(ls -al /var)" && echo $list; \
	list="$(ls -al /var/opt/)" && echo $list; \
	list="$(ls -al /var/opt/mssql/)" && echo $list; \
	list="$(ls -al /var/opt/mssql/data/)" && echo $list; \
	sudo mv RegEx.dll /var/opt/mssql/data/; \
