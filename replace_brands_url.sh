#!/bin/bash

set -u

directories="
/usr/local/lib/python3.13/site-packages/hass_frontend/
/usr/local/lib/python3.13/site-packages/insteon_frontend/
/usr/local/lib/python3.13/site-packages/knx_frontend/
/usr/local/lib/python3.13/site-packages/lcn_frontend/
"

apk add --no-cache brotli

# replace the brands.home-assistant.io URL in all frontend files
# recompress all js.gz and js.br assets
for frontend_dir in $directories; do
	echo $frontend_dir
	cd $frontend_dir
	for i in $(find . -iname "*.js.gz"); do
		if zcat $i | grep -q "brands.home-assistant.io"; then
			echo "fixing file $i"
			zcat $i | sed 's/https:\/\/brands.home-assistant.io/\/frontend_latest\/brands/g' >"$i.copy"
			gzip -9 "$i.copy"
			mv "$i.copy.gz" "$i"
		fi
	done
	for i in $(find . -iname "*.js"); do
		if grep -q "brands.home-assistant.io" "$i"; then
			echo "fixing file $i"
			cat $i | sed 's/https:\/\/brands.home-assistant.io/\/frontend_latest\/brands/g' >"$i.copy"
			mv "$i.copy" "$i"
			if [[ -f "$i.br" ]]; then
				rm "$i.br" || true
				brotli -9k "$i"
			fi
		fi
	done
done

# replace the brands.home-assistant.io URL in all .py files
for i in $(find /usr/src/homeassistant -iname "*.py"); do
	if grep -q "brands.home-assistant.io" "$i"; then
		sed -i 's/https:\/\/brands.home-assistant.io/\/frontend_latest\/brands/g' $i
	fi
done

apk del brotli
