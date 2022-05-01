#!/usr/bin/env bash
./tools.sh
./imagemagick.sh
./ossec.sh
./pdftk.sh
if [ $(uname -m) = "x86_64" ]; then ./snowflake_install.sh ; fi
./yarn.sh

sudo yum clean metadata