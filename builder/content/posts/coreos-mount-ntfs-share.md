+++
Categories = [
  "Development",
  "Docker",
  "CoreOS",
]
menu = "main"
date = "2016-11-01T14:12:12-04:00"
title = "CoreOS Mount NTFS Share"
Description = ""
Tags = [
  "Development",
  "Docker",
  "CoreOS",
]

+++

I had the need to mount an NTFS share for an application that was connecting to a SQL Server database and required that a share be mapped.  While testing from my CentOS 7 desktop, creating the share was trivial.  Not so much once I transitioned over to a CoreOS machine where I was to deploy for user testing.  

**Note:** I map /opt/bin from the host to a folder in the container.  I store custom binaries and scripts in /opt/bin on CoreOS as it is in the path and persists even after CoreOS updates to the latest version.  I've also changed the example from a Fedora container to CentOS as CentOS already has items installed that the example I link to installed in addition to the dev tools and libraries. 

This is how I got around that problem:

```{bash}
docker run -t -i -v /opt/bin:/host_tmp centos /bin/bash
yum groupinstall -y "Development Tools" "Development Libraries"

curl https://download.samba.org/pub/linux-cifs/cifs-utils/cifs-utils-6.3.tar.bz2 | bunzip2 -c - | tar -xvf -
cd cifs-utils-6.3/
./configure && make
cp mount.cifs /host_tmp/
exit

sudo mkdir /media/foo
sudo mount.cifs "//1.1.1.1/ntfs_share" -o username=winuser,domain=mydomain.com,rw,dir_mode=0775,noperm /media/foo/ 
```

Originally [found here](https://gist.github.com/pantelis/540a19262cacc841fb0a).
