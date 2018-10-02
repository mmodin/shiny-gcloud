# How to install a Shiny server on a Google (GCP) Compute Engine

## 1. Set up a virtual machine (Compute Engine) in Google Cloud
For testing I went with with the n1-standard-1 (1 vCPU, 3.75 GB memory) with a 10 GB standard persistent disk running Debian GNU/Linux 9 (stretch). I initially tested the f1-micro	(1 shared vCPU and 0.60 GB memory) VM but I ended up running out of memory during the installation locking up the entire machine.

## 2. Installing R & Shiny
[Rstudio](https://www.rstudio.com/products/shiny/download-server/) has a detailed guide on how to install and configure a Shiny server. I would also recommend checking out the [Admininistrator's guide](http://docs.rstudio.com/shiny-server/).

I put all the necessary dependencies and installation steps in [`startup.sh`](https://github.com/mmodin/shiny-gcloud/blob/master/setup.sh) that can just be executed. The steps are as follows:

1. SSH into the VM using your local machine. I simply used Google's in-browser "Active Cloud Shell".
2. Update and upgrade system packages.
```shell
sudo apt-get -y update
sudo apt-get -y upgrade
```
3. Install R and dependencies. Note that if you only plan on using base R without packages you will only need to intall R. I added git for version control and libssl/libcurl for the plotly R-package.
```shell
sudo apt-get -y install r-base git libcurl4-openssl-dev libssl-dev libxml2-dev
```
4. Install R-packages. The only package you actually need is `shiny`. The demo example that comes with the Shiny server installation requires `rmarkdown`. I personally use `data.table` for tables and `plotly` for graphing both of which have many dependencies that will have to be installed - this will most likely take a few minutes to finish.

```shell
sudo su - \
        -c "R -e \"install.packages(c('shiny', 'data.table', 'plotly', 'rmarkdown'), repos='https://cran.rstudio.com/')\""
```
5. Install `gdebi-core` to be able to install local debian packages.
```shell
sudo apt-get install gdebi-core
```
6. Download and install shiny server.
```
wget https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-1.5.9.923-amd64.deb
sudo gdebi shiny-server-1.5.9.923-amd64.deb
```
5. Ensure that the server is up and running
```shell
sudo systemctl status shiny-server
```

## 3. Configure the firewall to allow inbound traffic.
Depending on your use case you might want to configure the firewall to allow traffic. Shiny runs on port 3838 by default which will have to be added to the firewall. You can edit the default port by editing the shiny configuration file `/etc/shiny-server/shiny-server.conf`
