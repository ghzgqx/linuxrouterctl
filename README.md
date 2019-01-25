# linuxrouterctl
自用备份之用linux机当nat路由器的常用操作控制脚本

用到的服务：

DHCP/DHCPv6：dhcpd

RA/SLAAC:radvd

DNS转发:dnsmasq

IPv4 NAT和防火墙:iptables

IPv6 NAT和防火墙:ip6tables

虽然IPv6可以不需要NAT 但是为了DDNS的时候能解析到同一个IP和端口映射什么的 依然保留了ip6tables的nat链

代码很丑 很蠢 可能还有bug 但是能用就行了 

# 使用本脚本之前
建立一堆符号链接 把文件结构差不多改成这样

```
/root
 ├── [ctl]
 │   ├── nat     //IPv4 nat (MASQUERADE/PORT FORWARD) control
 │   ├── nat6    //IPv6 nat (MASQUERADE/PORT FORWARD) control
 │   └── r       //Router control
 ├── [dhcp] -> /etc/dhcp/
 │   ├── [dhclient.d]
 │   ├── [dhclient-exit-hooks.d]
 │   ├── dhcpd6.conf
 │   ├── dhcpd6.leases -> /var/lib/dhcpd/dhcpd6.leases
 │   ├── dhcpd.conf
 │   ├── dhcpd.leases -> /var/lib/dhcpd/dhcpd.leases
 │   └── [scripts]
 ├── [dnsmasq]
 │   ├── dnsmasq.conf -> /etc/dnsmasq.conf
 │   └── [dnsmasq.d] -> /etc/dnsmasq.d
 ├── [iptables]
 │   ├── ip6tables -> /etc/sysconfig/ip6tables
 │   └── iptables -> /etc/sysconfig/iptables
 ├── [log]
 │   ├── dhcpd6.leases -> /var/lib/dhcpd/dhcpd6.leases
 │   ├── dhcpd.leases -> /etc/dhcp/dhcpd.leases
 │   └── messages -> /var/log/messages
 ├── [network-scripts]-> /etc/sysconfig/network-scripts/
 ├── [radvd]
 │   └── radvd.conf -> /etc/radvd.conf
 └── [sysconfig] -> /etc/sysconfig/

```

然后把ctl文件夹下的三个控制脚本用ln -s 链接到/usr/bin 下 作为系统命令

如果和现有命令有文件名冲突 自己改名

# 各脚本作用

r:

用作路由器时的主要控制脚本 查询/修改配置文件和防火墙规则 查询DHCP分配地址 查询/启动/停止主要系统服务

nat/nat6：

快速对指定局域网网段添加iptables的masquerade 实现上网

快速添加、删除端口映射规则

# r.sh

r.sh
```	
<display|dis|disp|show>              Display network status,firewall rules and service logs
<config|conf>                        Edit config
<status|stat>                        Show service status
<start|stop|restart|enable|disable>  To start/stop/restart/enable/disable service
<nmtui|uiconfig>                     Config interfaces with NetworkManager TUI
<fw|firewall|iptables>               Save/reload IPv4 firewall rules
<fw6|firewall6|ip6tables>            Save/reload IPv6 firewall rules
```

r.sh display
 ```
<fw|firewall|iptables>          Display iptables config (IPv4)
<fw6|firewall6|ip6tables>       Display iptables config (IPv6)
<dhcp|dhcpd>                    Display DHCP config (IPv4)
<dhcpv6|dhcp6|dhcpd6|dhcpdv6>   Display DHCP config (IPv6)
<ra|radvd>                      Display radvd config
<dnsmasq>                       Display dnsmasq config"
 ```
 
 r.sh display fw 或 r.sh display fw6 
 ```
<nat|filter|mangle|raw> Display selected table
<all>                   Display all tables
 ```
 
 
 r.sh display route
 ```
 <4|inet|inet4|ip|ipv4>  Display routing table (IPv4)
 <6|inet6|ip6|ipv6>      Display routing table (IPv6)
 <all>                   Display routing table (IPv4+IPv6)
 ```
 
 r.sh config
 ```
<fw|firewall|iptables>          Edit iptables config 
<fw6|firewall6|ip6tables>       Edit ip6tables config
<dhcp|dhcpd>                    Edit DHCP config  (IPv4)
<dhcpv6|dhcp6|dhcpd6|dhcpdv6>   Edit DHCP config (IPv6)
<ra|radvd>                      Edit radvd config
<dnsmasq>                       Edit dnsmasq config
<if|interface> [if name]        Edit network interface config
<route> [if name]               Edit interface static route
 ```
 
 r.sh status/start/stop/restart/enable/disable
 
```
Available services

Sevice                  Sevice name in command

iptables                fw|firewall|iptables
ip6tables               fw6|firewall6|ip6tables
dhcpd                   dhcp|dhcpd
radvd                   ra|radvd
dnsmasq                 dnsmasq
network	                network
NetworkManager          nm|networkmanager|NetworkManager
```

r.sh fw 或 r.sh fw6
```
<save|s|sa>              Save config
<reload|restore|rl|r>    Reload config"
```

# nat.sh 和nat6.sh
IPv4/IPv6 Lan->Wan转发规则(为避免特殊情况在此支持NAT66 性能很低 尽量不要用) 及 端口映射规则 快速生成脚本

仅适用于一个LAN只对应一个WAN的情况 需要负载均衡请自己写规则

IPv4 nat
```
nat add <pf|port|portforward> [PROTOCOL] [LAN IP] [LAN PORT] [WAN INTERFACE] [WAN PORT]
nat add <masq|masquerade> [LAN IP]/[CIDR MASK] [WAN INTERFACE]
nat del <pf|port|portforward> [PROTOCOL] [LAN IP] [LAN PORT] [WAN INTERFACE] [WAN PORT]
nat del <masq|masquerade> [LAN IP]/[CIDR MASK] [WAN INTERFACE]

```

IPv6 NAT(不到万不得已不要用NAT66 masquerade 端口映射效率还行)
```
nat6 add <pf|port|portforward> [PROTOCOL] [LAN IP] [LAN PORT] [WAN INTERFACE] [WAN PORT]
nat6 add <masq|masquerade> [LAN IP]/[CIDR MASK] [WAN INTERFACE]
nat6 del <pf|port|portforward> [PROTOCOL] [LAN IP] [LAN PORT] [WAN INTERFACE] [WAN PORT]
nat6 del <masq|masquerade> [LAN IP]/[CIDR MASK] [WAN INTERFACE]

```



# 关于
admin@ghzgqx.com 
2019.1

版权没有 盗版不究 随便用随便改 如果有BUG别找我反馈自己修 需要加啥功能也别找我 自己改
