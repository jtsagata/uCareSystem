[![Build Status](https://travis-ci.org/jtsagata/uCareSystem.svg?branch=master)](https://travis-ci.org/jtsagata/uCareSystem)

Work in progress for the next major version. Move away!!

## Modes of operation
There is 3 modes of operation

* maintain: Basic system maintainace
  - Updates the list of available packages
  - Downloads and installs the available updates
  - do all clean actions
 * clean: Reclaim some disk space
   - Removes obsolete packages
   - Removes orphan packets, and old kernels
   - Deletes package configuration files from packages that have been uninstalled by you
   - Cleans the cache of the downloaded packages
* upgrade: 
  - Update to next amiable release (Ubuntu)
  - Update to development release (Ubuntu)
  - Update to next available release if EOL (Ubuntu)
  - Update to last stable version (Debian)

The program reports the expected date of new distribution release, or how old is your release in some cases. 

## Command line options
If no options is specified the program runs in `maintain` mode

```text
Usage:
  sudo ucaresystem [options]
  ucaresystem --help|--version

MODES
   -m, --maintain
      Do normal maintenance jobs. The default action id no option is given.
   -c, --clean
      reclaim some disk space
   -u type, --upgrade=type
          Upgrade ...

OTHER OPTIONS
  -n, --dyrun
    Show only the commands, but do not modify the system
  -y, --yes
    Don't ask for confirmation
  -h, --help
    Display this help text
  -v, --version
    Display program version and exits
  -s, --skip
    Do not show the welcome header_text, and do not pause.
  -w, --wait
    Press ENTER to end the program. For the "gui" version

RUNNERS
  --cli
    Run the cli version
  --xterm
    Run the xterm version
   --dialog
    Run the dialog version
  --gtk
    (maybe some day)  
```
    
See [man page](https://jtsagata.github.io/uCareSystem/man/ucaresystem.8.html) for more info



## Supported distributions
TODO: Debian, Ubuntu, Others, WSL

## Configuration
Many aspect of the programs can be configured by a configuration file. A sample is provided.

    cp /usr/share/doc/ucaresystem/ucaresystem.conf.sample /etc/ucaresystem.conf
    sudo $EDITOR etc/ucaresystem.conf

## Timeshift backups
With **timeshift** a snapshoot of the OS can be created before maintain and cleanup actions.
The default setting is `ENABLE_TIMESHIFT=auto` which enables timeshift if timeshift is installed 
and operates in `btrfs` mode. We recommend to install and enable timeshift. 

To enable timeshift in `rsync` mode set the option `ENABLE_TIMESHIFT=yes`  
  
## Topgrade integration

## Cleanup kernels
When you do an `apt autoremove` kernels and headers will be cleaned except 
- the currently booted version
- the kernel version we've been called for
- the latest kernel version (as determined by debian version number)
- the second-latest kernel version
 
This is controlled by the file `/etc/kernel/postinst.d/apt-auto-removal`. 
Thus the `clean` actions will do the same.

If you need better control the tool `remove-old-kernels` is provided. 
This is based the old  `purge-old-kernels` from byopu, extended to remove headers also.

## Unattended upgrades
TODO: cron job  