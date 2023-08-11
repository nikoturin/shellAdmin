SOME POINTS TO INSTALL AT Stream CentOs 8
    
1.-    Simulate pkg losted and control traffic or high or low latency.
    
    1.- check commands tc and iperf3.
    2.- sync time and check timezone correctly.
    3.- systemclt status chrony
    4.- timedatectl set-timezone "America/Mexico_City"

    Will be necesary to install at Stream Centos8
    - yum install -y  kernel-modules-extra 
    - timedatectl set-timezone "America/Mexico_City"
    - dnf -y install iperf3

2.- If not exists ifconfig cmd, launch ip command: " ip a show enp0s3 && ip a list enp0s3 && ip a show dev enp0s3 "
3.- The way to simulate high latency or low latency will be using tc and iperf3 commands

      Client:
    - tc qdisc add dev enp0s8 root netem 200ms
    - iperf3 -c <client or host> f K     

      Server:
    - iperf3 -s (port default 5201)

Note: if we need to restart the configure or parameters added, execute next command: tc qdisc del dev enp0s8 root.
Above points are to make a test the new configure, after we can do any install about http or mq protocol.
