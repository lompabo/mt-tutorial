---
title: AI4EU Tutoral Teplate (Python)
author: Michele Lombardi <michele.lombardi2@unibo.it>
---

# A Template for AI4EU Tutorials

This is a simple template and how-to guide for preparing tutorials on AI topics presented via Jupyter notebooks (and published on github), so that they can be accessed in three different ways:

* As static pages on github
* As interactive notebooks running on a remote machine (via Binder)
* As interactive notebooks running on your local machine (via repo2jupyter)

The main tool used to deliver tutorials is [Jupyter](https://jupyter.org/), a system using web technologies to display text and run code interactively. In a nutshell, Jupyter will dsplay a web page contaning both text cells (written in [Markdown](https://en.wikipedia.org/wiki/Markdown)) and code cells. "Running" text cells in will display the markdown source as nicely formatted HTML, while running code cells will actually execute the code they contain. While originally developed for Python, Jupyter now supports also R and Julia code.

A full overview of Jupyter is outside the scope of this guide, which will focus instead in how to access and prepare a tutorial, and how to publish it on the AI4EU platform.

# Accessing a Tutorial Template

## Using github as a Viewer

The most basic approach for accessing a tutorial is simply to use github, which allows one to visualized markdown files (such as this `README.md`) and Jupyter notebooks (such as `Example notebook.ipynb`) as nicely formatted web pages. This is enough to view the text and code content of a tutoria, but it does not enable executing the code and checking the results.

## Using Binder

[Binder](https://mybinder.org/) is a system that enables running repositories containing Jupyter notebooks in automatically created Docker containers, runninng on a remote machine. Accessing a tutorial in this way is actually very simple, since it involve just clicking a link such as this one:

[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/lompabo/ai4eu-tutorial-python/HEAD)

When you click the link, the Binder system will spawn a Docker container running a Jupyter server, configure an environment for the tutorial, and allow you to run it as if on a local machine. This means you can execute code, as well as displaying the tutorial content. It's an extremely convenient way to make tutorials accessible.

## Local Execution

More advanced use cases may benefit from running everything on a local machine. In an effort to improve portability and to avoid messing up wit local environment we will rely on [Docker]((https://www.docker.com/)) for local execution and on the [repo2docker](https://repo2docker.readthedocs.io/) tool to automate the process of configuring and launching containters.

Doing this will require to:

* Install Docker, by following the [online instructions](https://docs.docker.com/get-docker/).
* Install repo2docker, by following the [online instructions](https://repo2docker.readthedocs.io/en/latest/install.html)
* Cloning the repository with the tutorial, in this case via the command:
```sh
git clone https://github.com/lompabo/ai4eu-tutorial-python.git
```
* Running the repo2jupyter tool to build a Docker configuration file and spawn a container locally:
```sh
jupyter-repo2docker .
```

The first execution of this process will be fairly long, since Docker will need to download a base image for the container (think of a virtual machine disk) and then some boilerplate confguration steps will need to be perfofmed (e.g. installing jupyter in the container). Subsequent runs will be much faster.

The process will end with a message such as this one:
```sh
To access the notebook, open this file in a browser:
    file:///home/lompa/.local/share/jupyter/runtime/nbserver-1-open.html
Or copy and paste this URL:
    http://127.0.0.1:39281/?token=0cd92163797c3b3abe67c2b0aea57939867477d6068708a2
```
Copying one of the two addresses in a file browser file provide access to the Jupyter server running in the spawned container.

# Preparing a Tutorial



## Running a Tutorial

Running a tutorial requires to:

* Install [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/install/) (the two tools ship together on Windows and OSX)
* Open a terminal in the tutorial main folder (the one containing the `Dockerfile`)
* Executing the command:

```sh
docker-compose up
```

This will:

* Download a base image for the virtualize environment (just the first time)
* Configure the container as specified in the `Dockerfile`
* Run the Jupyter notebook server inside the container

If everything goes well, you should see on the terminal a message similar to:

```sh
Attaching to tutorial-template_jupyter_1
jupyter_1  | [I 12:53:12.467 NotebookApp] Writing notebook server cookie secret to /root/.local/share/jupyter/runtime/notebook_cookie_secret
jupyter_1  | [I 12:53:12.678 NotebookApp] [jupyter_nbextensions_configurator] enabled 0.4.1
jupyter_1  | [I 12:53:12.680 NotebookApp] Serving notebooks from local directory: /app/notebooks
jupyter_1  | [I 12:53:12.680 NotebookApp] Jupyter Notebook 6.2.0 is running at:
jupyter_1  | [I 12:53:12.680 NotebookApp] http://d806a2f6c7af:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  | [I 12:53:12.680 NotebookApp]  or http://127.0.0.1:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  | [I 12:53:12.680 NotebookApp] Use Control-C to stop this server and shut down all kernels (twice to skip confirmation).
jupyter_1  | [C 12:53:12.683 NotebookApp] 
jupyter_1  |     
jupyter_1  |     To access the notebook, open this file in a browser:
jupyter_1  |         file:///root/.local/share/jupyter/runtime/nbserver-1-open.html
jupyter_1  |     Or copy and paste one of these URLs:
jupyter_1  |         http://d806a2f6c7af:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
jupyter_1  |      or http://127.0.0.1:8888/?token=22aa406c8640afae5480eb35bd4f89409b63f2708d3c47c9
```

Copying the last link (the one starting with `http://127.0.0.1:8888`) on the address bar of a browser will allow you to access the tutorial.

Once you are done, pressing CTRL+C on the terminal will close the Docker container.

## Setting Up the Template

Setting up the template requires to:

1. Configuring the container
2. Filling the container with content (Jupyter notebooks, datasets, images, etc.)

The container follows a basic files structure:

* The `data` is meant to contain datasets
* The `notebooks` folders should contain the jupyter notebooks
  - Images, fonts, and any media resource used by the notebooks should go in `notebooks/assets`
  - Custom Python modules (e.g. used for lengthy code, plotting functions, or other components that are used often or across notebooks) should go in the `notebooks/util` folder
* The main folder contains also a `Dockerfile` and a file `docker-compose.yml`

Most of the container setup is controlled by the Dockerfile. The basic version provided here installs `pip`, `jupyter`, and the Jupyter contributed extensions.

```
# Base image specification
FROM python:3

# Update the package list (this is a Ubuntu-based machine)
RUN apt-get update -y && apt-get install zip -y

# Install pip
RUN pip install --upgrade pip

# Install a couple of Python packages
RUN pip install jupyter jupyter_contrib_nbextensions 

# Install jupyter contriobuted extensions (e.g. spellcheck)
RUN jupyter contrib nbextension install --system

# Copy raw data
COPY ./data /app/data

# During development, the notebooks folder will be overriden by a volume
COPY ./notebooks /app/notebooks

# Move to the notebook folder
WORKDIR /app/notebooks

# Start the jupyter server in the container
CMD ["jupyter", "notebook", "--port=8888", "--no-browser", \
     "--ip=0.0.0.0", "--allow-root"]
```

For more detail, have a look at the [Dockerfile reference](https://docs.docker.com/engine/reference/builder/).

The `docker-compose.yml` file contains configuration instructions for docker compose, which simplifies manageing Docker containers. In this case, it enables us to use simple commands to start the tutorial. The file content is:

```
version: '2.0'
services:
  jupyter:
    build: .
    ports:
    - "8888:8888"
    volumes:
    - ./notebooks:/app/notebooks
```

Here we are specifying that port 8888 on the host is mapped to port 8888 of the container, where the Jupyter server will be listening.

We are also using a _shared volume_ for the `notebooks` folder. This allows us to make modifications to the content of that folder (and in particular to any custom Python modules) and see that reflected in the container file system, even while that is running. Note that the same is not done for the data folder (which is just copied when the container starts): if you desire the same behavior in this case, too, you need to add a second line in the "volume" section in `docker-compose.yml`.

Once the setup is done, content can be added as you would usually do in a Jupyter notebook. Following the proposed folder structure is not mandatory, but it is encouraged to maximize compatibility.

# Publishing the Tutorial

Publishing a tutorial is done in three steps:

1. Publishing static web pages for each notebook
2. Publishing a compressed archive with the content of the (populated) tutorial
3. Registering a new "Tutorial" node on the AI4EU CMS, which will contain meta-information about the tutorial and pointers to the compressed archive and the static web pages.

Static, self-contained, web pages can be easily obtained from the notebooks via the use of the `nbconvert` tool, and in particular of the command:

```sh
jupyter nbconvert --to html_embed --template basic --HTMLExporter.anchor_link_text='' "the_notebook_file.ipynb"
```

This will export the notebook as an HTML page, including all linked resources, so that no external file are necessary. Note this can be result in a pretty large file if images or plots are used in the container. The main benefit is that copy-pasting the source is enough to publish the whole notebook.

AND HERE THE CLEAR GUIDE STOPS: THE NEXT STEPS ARE STILL IN A PROVISIONAL STATE
