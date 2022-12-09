# Creating a snapshot

# Initiating GCP virtual machine with goodies

The purpose of this document is to outline how we establish virtual machine from scratch. You shouldn’t have to do this unless you want to create a new snapshot. Most likely, you’ll want to just extend an existing snapshot. Talk to Caleb before you proceed with this.

Jacob 3/1/22: I am documenting how I modified this approach to substantiate a new snapshot image for the satpathy lab. 

# Major Software Organization Update

JG 10/8/22: 

Running into issues with different python needs, different R packages that conflict (Seurat bridge vs Seurat imaging) Thus there is a need to try to put every analytics environment into its own little package environment with conda. But conda is a hot mess and that sounds hard we are sudo-ers... 

The way I will overcome this is that we will have a standard python base venv in order to just fix that isolated ArchR MACS2 issue. Basically I think MACS2 and R is freaking out bc I `sudo pip install STUFF` and so its throwing a proper fit. I will record how users can copy the base environment for their first time setup, then be shown how to install stuff and if they had a new analysis project to make a new copy of their environment. 


ALL SHARED FUNCTIONS AND LIBRAIRES SHOULD BE PLACED IN THE /usr/local/share/satpathylab_bin directory

Here is where I thought of using this directory structure: https://stackoverflow.com/questions/9506281/sharing-python-virtualenv-environments


Think about using this wrapper to manage venvs: https://virtualenvwrapper.readthedocs.io/en/latest/


```
sudo mkdir -p satpathy_bin
sudo mkdir -p satpathy_bin/rstudio ## rstudio path
```

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

# Jacob Helpful Tools

I am installing these standard on all satpathy lab VMs to make life easier for when I jump in and help do stuff... also using these tools helps you see what is actually  happening in a computer~~~

* tmux: session manager, lets you open a shell run whatever command/script and see if its working then detatch. Your laptop could then explode and whatever computation/script happening on the VM will still finish non-the-wiser. 
* htop:  resource monitor, lets you literally visually see how many cores and the performance of the machine. Helpful for debuging parallel functions. can use htop -u jacob_stanford_edu to see the traffic for one user ;) 
* parallel: gnu parallal, best thing since sliced bread it lets you run any code thrown across the available cores writting output or returning values to use in your bash script. Make sure your script doesn task for parallel cores then youre in the shadow realm. TLDR: lets your run random stuff as if it was an 8 machine cluster job doing 8 things at once. 
* watch: watch a command: its already installed but play around with it very helpful to see if your stuff if working. try `watch -n 1 ls -lh ` and use `ctrl + c` to leave.  

```
sudo apt install -y tmux htop parallel 
```

# Installing R

## DEBAIN WAY (JG Dec 8  2022: METHOD FAILING ) 


### Updates/Headaches

JG 12/8/22: Ran into issues following this script. Turns out GCP has updated to debian 11 bullseye (yay?)

```
jacobog_stanford_edu@jacob-base-setup2:~$ sudo apt install -t buster-cran40 r-base
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Some packages could not be installed. This may mean that you have
requested an impossible situation or if you are using the unstable
distribution that some required packages have not yet been created
or been moved out of Incoming.
The following information may help to resolve the situation:

The following packages have unmet dependencies:
 r-base-core : Depends: libicu63 (>= 63.1-1~) but it is not installable
               Depends: libreadline7 (>= 6.0) but it is not installable
               Recommends: r-base-dev but it is not going to be installed
E: Unable to correct problems, you have held broken packages.
```




## Start

Now that we have our basic OS established, we are ready to install `R`. Here are a few notes (following along from [this tutorial](https://cran.r-project.org/bin/linux/debian/) with a few modifications).

JG 3/22/22: Lets use a newer version of R. With the latest ensembl release we need at least R 4.1+ in order to analyze 10X data with ensembl data.

First, we need to expose our `apt` package manager to the most recent version of R that is available (at the time of writing, this is `v4.0.x`). Do it this way:

```
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key '95C0FAF38DB3CCAD0C080A7BDC78B2DDEABC47B7' ## Updated 3/22/22 : still valid 12/7/22 
#sudo apt-key adv --keyserver keys.gnupg.net --recv-key 'E19F5F87128899B192B1A2C2AD5F960A256A04AF' ## OLD 2021
```

Next, we need to

```
sudo vi /etc/apt/sources.list
```

You are now in `vim` editing this `/etc/apt/sources.list` file. Press `i` to start editing and add this line to the top.

```
deb http://cloud.r-project.org/bin/linux/debian bullseye-cran40/ ## Debian 11 
#deb http://cloud.r-project.org/bin/linux/debian buster-cran40/ ## Debian 10 Pre dec 2022
```

Now quit vim (`ESC` + `:wq` + `ENTER`)

Now, update the `apt` manger and install the appropriate version of R

```
sudo apt update
#sudo apt install -t buster-cran40 r-base r-cran-nlme ## This was for debian 10
sudo apt install -t r-base ## This is for debian 11
```

If you did this correctly,

```
R --version
```

yields 
JG UPDATED

```
#R version 4.2.2 (2022-10-31) -- "Innocent and Trusting"
#R version 4.1.3 (2022-03-10) -- "One Push-Up" 
```



## R

## Install Rstudio server

First, it may be worth verifying that you are using the right linux distro / https://www.rstudio.com/products/rstudio/download-server/ and that the version of Rstudio hasn’t been significantly updated. 

JG 3/22/22: It has we are in the future!  

JG 8/8/22: Jeez that last guy is in the past, theres a 07 2022 release now! 


```{ Depreciated Command}
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-1.4.1106-amd64.deb
sudo gdebi rstudio-server-1.4.1106-amd64.deb
```

```
cd /usr/local/share/satpathy_bin/rstudio
sudo apt-get install gdebi-core
wget https://download2.rstudio.org/server/bionic/amd64/rstudio-server-2022.07.2-576-amd64.deb
sudo gdebi rstudio-server-2022.07.2-576-amd64.deb

```


If it works you should see

```
sudo rstudio-server version
```
```
2022.07.2+576 (Spotted Wakerobin) for Ubuntu Bionic ## As of Dec 2022
#2022.02.0+443 (Prairie Trillium) for Ubuntu Bionic
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

sudo apt install -y libharfbuzz-dev libfribidi-dev ## Needed for devtools & ArchR
sudo apt install -y libfreetype6-dev libpng-dev libtiff5-dev libjpeg-dev ## For devtools more? 
```

Then, open an `R` environment and start installing packages

```
install.packages(c("Seurat", "Signac","data.table", "tidyverse", "BiocManager", "Cairo", "devtools", "IRkernel","ggpubr"))
BiocManager::install(c("ComplexHeatmap", "rhdf5","EnsDb.Hsapiens.v86"))
devtools::install_github(c("caleblareau/BuenColors", "mojaveazure/seurat-disk"))
```

ArchR Install Instructions

I have suffered doing this enough times heres how I install on the VM.
Note it takes a significant amount of time to install the specific package preferences. 
I may not make it apart of the standard environment but I could install the neccesary packages if someone wants to actually install..


```
###INSTRUCTIONS HERE WHEN YOU ACTUALLY INSTALL ON THE FRESH VM
```


# Install Python and jupyter notebook

First, we need a few additional OS dependencies, so let’s grab those:

```
sudo apt install -y build-essential zlib1g-dev libncurses5-dev libgdbm-dev libnss3-dev libssl-dev libsqlite3-dev libreadline-dev libffi-dev curl libbz2-dev
```

We’re going to install a global python binary for all users. [This tutorial](https://linuxize.com/post/how-to-install-python-3-8-on-debian-10/) summarizes the installation details but uses an older version. So, first, verify current version of python for installation[here](https://www.python.org/downloads/source/). We’re going to install it in `/home/` for the heck of it.

JG: I have a bin directory where I am keeping rstudio and other goodies. Note everything uses sudo bc we want a root install so everyone has access to the same python binaries on this instance. 

```
mkdir -p satpathy_bin/python ## assume you are in /usr/local/share/
cd satpathy_bin/python
#cd /home/bin
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
