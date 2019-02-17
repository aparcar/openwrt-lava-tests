# job templates


The template will be parsed using the **create-job.py** script to generate
a yaml file which can be given to lava.

The **create-job.py** will fill metadata as well as image url and job name into the job.

## Template variables

The template can use the following variables. Those variables will be (string) replaced
by create-job.py.

Valid template variables:

* `IMAGE_URL` - will be replaced by a https:// url to an OpenWrt image
