#!/usr/bin/env bash

sudo apt-get -y update
sudo apt-get -y upgrade
sudo apt-get -y install r-base git libcurl4-openssl-dev libssl-dev libxml2-dev
sudo su - \
        -c "R -e \"install.packages(c('shiny', 'data.table', 'plotly', 'rmarkdown'), repos='https://cran.rstudio.com/')\""
sudo apt-get install gdebi-core
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
sudo gdebi shiny-server-1.5.9.923-amd64.deb
