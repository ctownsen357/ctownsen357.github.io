+++
Description = ""
Tags = [
  "Development",
  "Docker",
  "GlusterFS",
]
Categories = [
  "Development",
  "Docker",
  "GlusterFS",
]
menu = "main"
date = "2016-11-08T16:28:48-05:00"
title = "GlusterFS & Docker"

+++

I've recently started exploring [GlusterFS](https://www.gluster.org/) in Docker containers to use as persistent storage for the Dockerized services and applications I've been working on.  If this is performant enough then for my purposes it will close the gap for me to really treat the data center as one giant computer.  Getting started was pretty straight forward.

**Note:** This is a quick example.  Make sure you read up on security, changing the default password, and review the original Dockerfile.  I'll be experimenting with running this out on AWS soon and should be able to further tighten up my example.

### Get the latest Gluster container:
[Get the latest container:](https://github.com/gluster/gluster-containers) 
```{bash}
docker pull gluster/gluster-centos
```

### Make the persistent data folders on each host:
```{bash} 
sudo mkdir -p /gluster/logs && sudo mkdir /gluster/data && sudo mkdir /gluster/config && /gluster/mnt
```

### Start a GlusterFS container on each host:
```{bash}
docker run -d \
   --name gluster \
   --privileged \
   --net=host \
   -v /gluster/data:/gluster \
   -v /gluster/logs:/var/log/glusterfs \
   -v /gluster/config:/var/lib/glusterd \
   -v /gluster/mnt:/gluster/mnt \
   gluster/gluster-centos
```

### Probe the hosts in the cluster:
For each container on each host you'll want to execute this to get them aware of the other peers.  If running out on AWS these steps could be orchestrated through the init system on the hosts so you don't have to log into each machine.
```{bash}
gluster peer probe 1.1.1.1
```

### Now create your volume and start it:
```{bash}
gluster volume create media replica 3 transport tcp 172.30.0.185:/gluster/data  172.30.0.186:/gluster/data 172.30.0.30:/
gluster volume start media
```

In this example I'm replicating across each of three servers but depending on your needs you could: distributed striped, distributed, replicated, distributed striped replicated, ... know what and why.

### Mount the volume
The docs made a big deal out of mounting the volume.  I suspect if you were doing anything other than replicating that would become very important.

You'll want to do this on each host, using its internal ip:
```{bash}
mount -t glusterfs 172.30.0.186:/media /gluster/mnt
```


From one of the hosts testing with a write statement to the volume:
```{bash}
echo "testing, 1,2,3..." >> /gluster/mnt/test.txt
```

And from another host you should be able to read/write to the same document.  One could then launch containers on any host with a mount to /gluster/mnt to store data.  Then it would have access to the data no matter which node it was launched on. 


