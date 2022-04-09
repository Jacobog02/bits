# Creating a snapshot

# Initiating GCP virtual machine with goodies

The purpose of this document is to outline how we establish virtual machine from scratch. You shouldn’t have to do this unless you want to create a new snapshot. Most likely, you’ll want to just extend an existing snapshot. Talk to Caleb before you proceed with this.

Jacob 3/1/22: I am documenting how I modified this approach to substantiate a new snapshot image for the satpathy lab. 

# Setting up a new Virtual Machine - from scratch

Here, we are going to walk through creating a virtual machine with requisite packages installed for perfoming common single-cell analyses.

## Create virtual machine

First, to create the new instance, navigate to [https://console.cloud.google.com/compute/instancesAdd](https://console.cloud.google.com/compute/instancesAdd)

Jacob 3/16/22: Caleb recommended that the instance be processed with minimal cores and gross amounts of RAM (64GB x 8 cores) and 16GB memory.

We generally recommend keeping Debian 10 on the machine with 32Gb x 4 cores and 250 Gb of disk memory (unless you have other ideas in mind). You should also click the `Allow HTTP traffic` and `Allow HTTPS traffic` check boxes.

## Modify settings on the virtual machine

After the virtual machine is created, click on it and “edit” it. Under Network tags, type in `open8787` and `open8888` to allow for these ports (that will host Rstudio and Jupyter) to be exposed on the remote machine. Save these changes by going back.

## Update OS attributes on the machine

Again, assuming that you setup a Debian 10 operating system, you will utilize the `apt` package manager. For the downstream elements to flow without hiccups, run the following:

```
sudo apt-get update
sudo apt -y install gdebi-core wget libcurl4-openssl-dev libssl-dev libxml2-dev dirmngr software-properties-common apt-transport-https --install-recommends
```

# Installing R

Now that we have our basic OS established, we are ready to install `R`. Here are a few notes (following along from [this tutorial](https://cran.r-project.org/bin/linux/debian/) with a few modifications).

JG 3/22/22: Lets use a newer version of R. With the latest ensembl release we need at least R 4.1+ in order to analyze 10X data with ensembl data.

First, we need to expose our `apt` package manager to the most recent version of R that is available (at the time of writing, this is `v4.0.x`). Do it this way:

```
## Updated 3/22/22
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7'
#sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF'
```

Next, we need to

```
sudo vi /etc/apt/sources.list
```

You are now in `vim` editing this `/etc/apt/sources.list` file. Press `i` to start editing and add this line to the top.

```
deb http://cloud.r-project.org/bin/linux/debian buster-cran40/
```

Now quit vim (`ESC` + `:wq` + `ENTER`)

Now, update the `apt` manger and install the appropriate version of R

```
sudo apt update
sudo apt install -t buster-cran40 r-base
```

If you did this correctly,

```
R --version
```

yields 
JG UPDATED

```
R version 4.1.3 (2022-03-10) -- "One Push-Up"
...
```

## Install Rstudio server

First, it may be worth verifying that you are using the right linux distro / https://www.rstudio.com/products/rstudio/download-server/ and that the version of Rstudio hasn’t been significantly updated. 

JG 3/22/22: It has we are in the future!  


```
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
sudo gdebi rstudio-server-1.4.1106-amd64.deb
```

If it works you should see

```
sudo rstudio-server version
```
```
2022.02.0+443 (Prairie Trillium) for Ubuntu Bionic
```

## Install R packages

To install packages, globally, we are going to open the `site-library` folder for global editing. Most folks advise against this as anyone on the machine can overwrite any installations. 

JG: We accept this because we are sudo-ers on our own gcloud compute instance. 

```
sudo chmod 777 -R /usr/local/lib/R/site-library
```

Next, we can install `R` packages. Before doing so, we will most certainly need a few more environment dependencies:

## JG 3/24/22: I added libsqlite3-dev which was kind of spur of the moment we can choose other sqlite systems but let's try this one. 

```
sudo apt install -y libgsl-dev libhdf5-dev libcairo2-dev libxt-doc libxt-dev libsqlite3-dev
```

Then, open an `R` environment and start installing packages

```
install.packages(c("Seurat", "Signac","data.table", "tidyverse", "BiocManager", "Cairo", "devtools", "IRkernel","ggpubr"))
BiocManager::install(c("ComplexHeatmap", "rhdf5","EnsDb.Hsapiens.v86"))
devtools::install_github(c("caleblareau/BuenColors", "mojaveazure/seurat-disk"))
```

# Install Python and jupyter notebook

First, we need a few additional OS dependencies, so let’s grab those:

```
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
```

We’re going to install a global python binary for all users. [This tutorial](https://linuxize.com/post/how-to-install-python-3-8-on-debian-10/) summarizes the installation details but uses an older version. So, first, verify current version of python for installation[here](https://www.python.org/downloads/source/). We’re going to install it in `/home/` for the heck of it.

JG: I have a bin directory where I am keeping rstudio and other goodies. Note everything uses sudo bc we want a root install so everyone has access to the same python binaries on this instance. 

```
cd /home/bin
sudo curl -O https://www.python.org/ftp/python/3.9.4/Python-3.9.4.tar.xz
sudo tar -xf Python-3.9.4.tar.xz
cd Python-3.9.4
sudo ./configure --enable-optimizations
sudo make -j 16
sudo make install
```

Now verify the install:

```
python3 --version
```

Assuming that this all looks goood, we can go ahead and install requisite python packages of interest:

```
sudo -H pip3 install matplotlib seaborn pandas numpy scipy scikit-learn phenograph scanpy jupyter jupyterlab wheel
```

## Expose R to jupyter

In case we want to utilize R from our jupyter session, we can do this relatively easily from this link: [https://dzone.com/articles/using-r-on-jupyternbspnotebook](https://dzone.com/articles/using-r-on-jupyternbspnotebook). Note: at first google glance, `conda` tries really hard to do this for you, which is not optimal. There's an easy way to add this by typing the following two commands into a bash session:

```
sudo chmod -R 777 /usr/local/share/jupyter/kernels/
R -e "IRkernel::installspec(user = FALSE)"
```

Now, we can create `R` notebooks that route to the root install (including packages) in jupyter:

![Creating%20a%20snapshot%20fbc9b580e89b47d7bf57da471a00e4bb/R-jupyter.png](Creating%20a%20snapshot%20fbc9b580e89b47d7bf57da471a00e4bb/R-jupyter.png)

# Misc other details for bookkeeping

It seems like we have to add users to the VM to get Rstudio to work. This seems silly, but is worth doing:

```
sudo apt-get install pamtester
sudo pamtester --verbose rstudio caleb authenticate
```
