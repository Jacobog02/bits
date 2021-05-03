# Getting going on a new virutal machine

This set of instructions should only be utilized once per virtual machine to get you going where you need to go. 

## 1) Boot up a virtual machine from a recent snapshot

First, navigate to [Snapshots](https://console.cloud.google.com/compute/snapshots?project=lareau-su-satpathylab) within the GCP console. Here, you are going to launch a new instance by extending one of the existing snapshots. 

We generally recommend keeping Debian 10 on the machine with 32Gb x 4 cores and 250 Gb of disk memory (unless you have other ideas in mind). You should also click the `Allow HTTP traffic` and `Allow HTTPS traffic` check boxes.

## 2) Modify settings on the virtual machine

After the virtual machine is created, click on it and "edit" it. Under Network tags, type in `open8787` and `open8888` to allow for these ports (that will host Rstudio and Jupyter) to be exposed on the remote machine. Save these changes by going back. 


## 3) Go ahead and change your password on this machine

Click on the `SSH` button to open a new terminal window directly from your browser. To change your password on this machine, type:

```
sudo passwd
```

you should see a prompt to change your password, which you should do:

```
New password: 
Retype new password: 
passwd: password updated successfully
```
This will be your password if you ever want to go `su`.

## 4) Create a new user to authenticate Rstudio

For reasons that aren't obvious to me, we need to establish an additional user account on the virtual machine to get Rstudio to operate correctly. Type the prompt below and add a password. Note: this will be your username/password for accessing `Rstudio` (served on port `8787`). 

```
sudo adduser cl-rstudio # change user name here
```


## 5) Configure jupyter notebook parameters

To enable using jupyter notebooks, let's set up a configuration to serve the notebook on port `8888`. Run the following:

```
jupyter notebook --generate-config
vi ~/.jupyter/jupyter_notebook_config.py
```

You are now in `vim` editing this `~/.jupyter/jupyter_notebook_config.py` file. 

```
c = get_config()
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
```
Now quit vim (`ESC` + `:wq:`)

## 6) Use resources!

Navigate back to the gcp console and discern the static external IP address of your new virtual machine. In your web browser, enter the following for Rstudio:

```
<ip_address>:8787
```

For jupyter, make sure that you've started a new server (`jupyter notebook`) in a shell for the machine, then navigate to the notebook like so:

```
<ip_address>:8888
```

## 7) Friendly reminder!

We are going to get billed by the hour-- remember to turn off your machine when you aren't using it! (it's only a few cents per hour, so don't sweat the small stuff like stopping for a break; just try to not let it run over multiple days without any use. )

<br>

