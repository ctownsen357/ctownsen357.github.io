+++
Description = ""
Tags = [
  "code",
  "bash",
  "ssh",
]
date = "2016-10-31T21:11:01-04:00"
title = "port forwarding"
Categories = [
  "code",
  "bash",
  "ssh",
]
menu = "main"

+++

```{bash}
ssh -NL 3389:internal.network.ip.address:3389 user@public.ip.address
```

In this example I'm forwarding an RDP connection to a machine on some internal network IP address through a public facing SSH server.  I've found this sort of tunelling through SSH to be invaluable and I've used it for everything from accessing Windows servers over RDP where the only external access was a key protected SSH server to forwarding http/https traffic to remote APIs for testing and debugging.

