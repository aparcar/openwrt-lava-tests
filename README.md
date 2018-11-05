# Thsi repository contains lava related files

* boards - a simple text based database containing for every board type 2 files
* jobs - contains valid jobs, ready to submit via lava
* job-templates - contains templates which are used by jenkins
* tests - contains the actual tests, which gets executed within the lava jobs

## boards

To support the CI, every board which is tested automatic (via jenkins) needs
an '$DEVICETYPE.sysupgrade' file and a '$DEVICETYPE.initramfs'
