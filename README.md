Work in progress for the next major version

## Basic usage

## Configuration
Many aspect of the programs can be configured by a configuration file. A sample is provided.

    cp /usr/share/doc/ucaresystem/ucaresystem.conf.sample /etc/ucaresystem.conf
    sudo $EDITOR etc/ucaresystem.conf

## Timeshift backups
If `timeshift` is installed, there is an option 
to enable automatic snapshots in the config file.
It is recommended to install and enable timeshift in `btrfs` filesystems. 
  
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