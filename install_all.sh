#!/usr/bin/env bash
./updates.sh
./imagemagick.sh
./ossec.sh
./pdftk.sh
./snowflake_install.sh
./yarn.sh

sudo yum clean metadata