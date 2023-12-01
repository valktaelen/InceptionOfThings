# P1

## Setup

Launch the project with:

```
vagrant up
```

You can verify that everything is setup with `vagrant status`:

```bash
vagrant status
...

Current machine states:

aartigesS                   running (virtualbox)
aartigesSW                  running (virtualbox)
```

You can ssh in a VM with `vagrant ssh`:

```bash
vagrant ssh aartigesS
aartigesS:~$ 
```

or 

```bash
vagrant ssh aartigesSW
aartigesSW:~$ 
```

### Check k3s is correctly setup

```bash
vagrant ssh aartigesS
aartigesS:~$ kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION        INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
aartigessw   Ready    <none>                 72s    v1.25.6+k3s1   192.168.56.111   <none>        Alpine Linux v3.17   5.15.81-0-virt   containerd://1.6.15-k3s1
aartigess    Ready    control-plane,master   2m6s   v1.25.6+k3s1   192.168.56.110   <none>        Alpine Linux v3.17   5.15.81-0-virt   containerd://1.6.15-k3s1
aartigesS:~$ ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 08:00:27:AC:EF:16  
          inet addr:192.168.56.110  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:feac:ef16/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:931 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1197 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:148314 (144.8 KiB)  TX bytes:810817 (791.8 KiB)
```

```bash
vagrant ssh aartigesS
aartigesS:~$ kubectl get nodes -o wide
NAME       STATUS   ROLES                  AGE    VERSION        INTERNAL-IP      EXTERNAL-IP   OS-IMAGE             KERNEL-VERSION   CONTAINER-RUNTIME
aartigessw   Ready    <none>                 72s    v1.25.6+k3s1   192.168.56.111   <none>        Alpine Linux v3.17   5.15.81-0-virt   containerd://1.6.15-k3s1
aartigess    Ready    control-plane,master   2m6s   v1.25.6+k3s1   192.168.56.110   <none>        Alpine Linux v3.17   5.15.81-0-virt   containerd://1.6.15-k3s1
aartigesS:~$ ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 08:00:27:AC:EF:16  
          inet addr:192.168.56.110  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:feac:ef16/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:931 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1197 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:148314 (144.8 KiB)  TX bytes:810817 (791.8 KiB)
```

```bash
vagrant ssh aartigesSW
aartigesSW:~$ ifconfig eth1
eth1      Link encap:Ethernet  HWaddr 08:00:27:85:47:D9  
          inet addr:192.168.56.111  Bcast:0.0.0.0  Mask:255.255.255.0
          inet6 addr: fe80::a00:27ff:fe85:47d9/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1247 errors:0 dropped:0 overruns:0 frame:0
          TX packets:1011 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:1000 
          RX bytes:835870 (816.2 KiB)  TX bytes:159157 (155.4 KiB)

```
