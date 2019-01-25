#!/bin/bash
case "$1" in
    display|dis|disp|show)
	#状态显示 各服务状态或日志 配置文件等
		case "$2" in
		fw|firewall|iptables)
			case "$3" in
			nat|filter|mangle|raw)
				iptables -t $3 -nvL --line-number > /tmp/ipt.$3.temp
				less -c -M -Q /tmp/ipt.$3.temp
			;;
			all)
				echo "Table : filter" > /tmp/ipt.all.temp
				iptables -t filter -nvL --line-number >> /tmp/ipt.all.temp
				echo "" >> /tmp/ipt.all.temp
				echo "Table : nat" >> /tmp/ipt.all.temp
				iptables -t nat -nvL --line-number >> /tmp/ipt.all.temp
				echo "" >> /tmp/ipt.all.temp
				echo "Table : mangle" >> /tmp/ipt.all.temp
				iptables -t mangle -nvL --line-number >> /tmp/ipt.all.temp
				echo "" >> /tmp/ipt.all.temp
				echo "Table : raw" >> /tmp/ipt.all.temp
				iptables -t raw -nvL --line-number >> /tmp/ipt.all.temp
				less -c -M -Q /tmp/ipt.all.temp
			;;
			help)
			echo "help"
			echo ""
			echo "<nat|filter|mangle|raw> Display selected table"
			echo "<all>                   Display all tables"
			;;
			*)
			if [ "$3" = "" ]
			then
				iptables -nvL --line-number >  /tmp/ipt.filter.temp
				less -c -M -Q /tmp/ipt.filter.temp
			else
			echo "Unknown table: $3"
			fi
			;;
			esac
		;;
		fw6|firewall6|ip6tables)
			case "$3" in
			nat|filter|mangle|raw)
				ip6tables -t $3 -nvL --line-number > /tmp/ip6t.$3.temp
				less -c -M -Q /tmp/ip6t.$3.temp
			;;
			all)
				echo "Table : filter" > /tmp/ip6t.all.temp
				ip6tables -t filter -nvL --line-number >> /tmp/ip6t.all.temp
				echo "" >> /tmp/ip6t.all.temp
				echo "Table : nat" >> /tmp/ip6t.all.temp
				ip6tables -t nat -nvL --line-number >> /tmp/ip6t.all.temp
				echo "" >> /tmp/ip6t.all.temp
				echo "Table : mangle" >> /tmp/ip6t.all.temp
				ip6tables -t mangle -nvL --line-number >> /tmp/ip6t.all.temp
				echo "" >> /tmp/ip6t.all.temp
				echo "Table : raw" >> /tmp/ip6t.all.temp
				ip6tables -t raw -nvL --line-number >> /tmp/ip6t.all.temp
				less -c -M -Q /tmp/ip6t.all.temp
			;;
			help)
			echo "help"
			echo ""
			echo "<nat|filter|mangle|raw> Display selected table"
			echo "<all>                   Display all tables"
			;;
			*)
			if [ "$3" = "" ]
			then
				ip6tables -nvL --line-number >  /tmp/ip6t.filter.temp
				less -c -M -Q /tmp/ip6t.filter.temp
			else
			echo "Unknown table: $3"
			fi
			;;
			esac
		;;
		route)
			case "$3" in
			4|inet|inet4|ip|ipv4)
				route -n -4 > /tmp/route.temp
				less -c -M -Q /tmp/route.temp
			;;
			6|inet6|ip6|ipv6)
			route -n -6 > /tmp/route.temp
			less -c -M -Q /tmp/route.temp
			;;
			all)
			route -n -4 > /tmp/route.temp
			route -n -6 >> /tmp/route.temp
			less -c -M -Q /tmp/route.temp
			;;
			help)
			echo "help"
			echo ""
			echo "<4|inet|inet4|ip|ipv4>  Display routing table (IPv4)"
			echo "<6|inet6|ip6|ipv6>      Display routing table (IPv6)"
			echo "<all>                   Display routing table (IPv4+IPv6)"
			;;
			*)
			if [ "$3" = "" ]
			then
				route -n -4 > /tmp/route.temp
				less -c -M -Q /tmp/route.temp
			else
			echo "Command error, use help for help"
			fi
			;;
			esac
		;;
		br|brd|bridge)
			brctl show > /tmp/bridge.temp
			less -c -M -Q /tmp/bridge.temp
		;;
		ip|if|interface|ifconfig)
			ip addr > /tmp/interface.temp
			less -c -M -Q /tmp/interface.temp
		;;
		dhcp|dhcpd)
			less -c -M -Q /root/log/dhcpd.leases
		;;
		dhcpv6|dhcp6|dhcpd6|dhcpdv6)
			less -c -M -Q /root/log/dhcpd6.leases
		;;
		ra|radvd)
			less -c -M -Q /var/log/radvd.log
		;;
		syslog|systemlog|log)
			less -c -M -Q /root/log/messages
		;;
		config|conf)
		#配置文件查看
		case "$3" in
			fw|firewall|iptables)
				less -c -M -Q /root/iptables/iptables
			;;
			fw6|firewall6|ip6tables)
			    less -c -M -Q /root/iptables/ip6tables
			;;
			dhcp)
				less -c -M -Q /root/dhcp/dhcpd.conf
			;;
			dhcpv6|dhcp6)
			    less -c -M -Q /root/dhcp/dhcpd6.conf
			;;
			ra|radvd)
				less -c -M -Q /root/radvd/radvd.conf
			;;
			dnsmasq)
				less -c -M -Q /root/dnsmasq/dnsmasq.conf 
			;;
			help)
			echo "help
			
<fw|firewall|iptables>          Display iptables config (IPv4)
<fw6|firewall6|ip6tables>       Display iptables config (IPv6)
<dhcp|dhcpd>                    Display DHCP config (IPv4)
<dhcpv6|dhcp6|dhcpd6|dhcpdv6>   Display DHCP config (IPv6)
<ra|radvd>                      Display radvd config
<dnsmasq>                       Display dnsmasq config"
			;;
			*)
			echo "Command error, use help for help"
			;;
			esac
			;;
		tra|traffic|iftop)
		if [ "$3" = "" ]
			then
				echo " Must specify an interface"
			else
			iftop -nNP -i ${3}
			fi
		;;
		help)
			echo "help
			
<fw|firewall|iptables>          Display iptables rules (IPv4)
<fw6|firewall6|ip6tables>       Display iptables rules (IPv6)
<route>                         Display routing table
<br|brd|bridge>                 Display bridge interface
<ip|if|interface|ifconfig>      Display IP MAC and other interface info
<dhcp|dhcpd>                    Display dhcp assignment info (IPv4)
<dhcpv6|dhcp6|dhcpd6|dhcpdv6>   Display dhcp assignment info (IPv6)
<ra|radvd>                      Display radvd log
<syslog|systemlog|log>          Display system log
<config|conf>                   Display config file
<tra|traffic|iftop>             Display real time traffic"
		;;
		*)
		echo "Command error, use help for help"
		;;
		esac
    ;;
	
	
	
	config|conf)
	#配置修改
	case "$2" in
		fw|firewall|iptables)
		 vi /root/iptables/iptables
		;;
		fw6|firewall6|ip6tables)
		  vi /root/iptables/ip6tables
		;;
		dhcp|dhcpd)
		  vi /root/dhcp/dhcpd.conf
		;;
		dhcpv6|dhcp6|dhcpd6|dhcpdv6)
		  vi /root/dhcp/dhcpd6.conf
		;;
		ra|radvd)
		  vi /root/radvd/radvd.conf
		;;
		dnsmasq)
		  vi /root/dnsmasq/dnsmasq.conf 
		;;
		if|interface)
		  if [ "$3" = "" ]
			then
				echo " Must specify an interface"
			else
			vi /root/network-scripts/ifcfg-${3}
			fi
		;;
		route)
		  if [ "$3" = "" ]
			then
				echo " Must specify an interface"
			else
			vi /root/network-scripts/route-${3}
			fi
		;;
		help)
		echo "help
		
<fw|firewall|iptables>          Edit iptables config 
<fw6|firewall6|ip6tables>       Edit ip6tables config
<dhcp|dhcpd>                    Edit DHCP config  (IPv4)
<dhcpv6|dhcp6|dhcpd6|dhcpdv6>   Edit DHCP config (IPv6)
<ra|radvd>                      Edit radvd config
<dnsmasq>                       Edit dnsmasq config
<if|interface> [if name]        Edit network interface config
<route> [if name]               Edit interface static route"
		;;
		*)
		echo "Command error, use help for help"
		;;
	esac
	;;
	
	
	
	
	status|stat)
	#服务状态
	case "$2" in
		fw|firewall|iptables)
		 systemctl status iptables
		;;
		fw6|firewall6|ip6tables)
		  systemctl status ip6tables
		;;
		dhcp|dhcpd)
		  systemctl status dhcpd
		;;
		ra|radvd)
		  systemctl status radvd
		;;
		dnsmasq)
		  systemctl status dnsmasq 
		;;
		net|network)
		  systemctl status network
		;;
		nm|networkmanager|NetworkManager)
		  systemctl status NetworkManager
		;;
		help)
		  echo "help
		  
Sevice                  Sevice name in command

iptables                fw|firewall|iptables
ip6tables               fw6|firewall6|ip6tables
dhcpd                   dhcp|dhcpd
radvd                   ra|radvd
dnsmasq                 dnsmasq
network	                network
NetworkManager          nm|networkmanager|NetworkManager"
		;;
		*)
		  if [ "$2" = "" ]
			then
				echo "Must specify a service, use help for help"
			else
			echo "Invalid Service, use help for help"
			fi
		;;
	esac
	;;
	
	start|stop|restart|enable|disable)
	case "$2" in
		fw|firewall|iptables)
		 systemctl $1 iptables
		;;
		fw6|firewall6|ip6tables)
		  systemctl $1 ip6tables
		;;
		dhcp|dhcpd)
		  systemctl $1 dhcpd
		;;
		ra|radvd)
		  systemctl $1 radvd
		;;
		dnsmasq)
		  systemctl $1 dnsmasq 
		;;
		net|network)
		  systemctl $1 network
		;;
		nm|networkmanager|NetworkManager)
		  systemctl $1 NetworkManager
		;;
		help)
		echo "help
		
Sevice                  Sevice name in command

iptables                fw|firewall|iptables
ip6tables               fw6|firewall6|ip6tables
dhcpd                   dhcp|dhcpd
radvd                   ra|radvd
dnsmasq                 dnsmasq
network	                network
NetworkManager          nm|networkmanager|NetworkManager"
		;;
		*)
		   if [ "$2" = "" ]
			then
				echo "Must specify a service, use help for help"
			else
			echo "Invalid Service, use help for help"
			fi
		;;
	esac
	;;
	
	fw|firewall|iptables)
	case "$2" in
		save|s|sa)
		 service iptables save
		;;
		reload|restore|rl|r)
		  iptables-restore /root/iptables/iptables
		;;
		help)
		echo "help
		
<save|s|sa>              Save config
<reload|restore|rl|r>    Reload config
"
		;;
		*)
		  echo "Command error, use help for help"
		;;
	esac
	;;
	fw6|firewall6|ip6tables)
	case "$2" in
		save|s|sa)
		 service ip6tables save
		;;
		reload|restore|rl|r)
		  ip6tables-restore /root/iptables/ip6tables
		;;
		help)
		echo "help
		
<save|s|sa>              Save config
<reload|restore|rl|r>    Reload config"
		;;
		*)
		  echo "Command error, use help for help"
		;;
	esac
	;;
	nmtui|uiconfig)
		nmtui
	;;
    help)
	echo "help
	
<display|dis|disp|show>              Display network status,firewall rules and service logs
<config|conf>                        Edit config
<status|stat>                        Show service status
<start|stop|restart|enable|disable>  To start/stop/restart/enable/disable service
<nmtui|uiconfig>                     Config interfaces with NetworkManager TUI
<fw|firewall|iptables>               Save/reload IPv4 firewall rules
<fw6|firewall6|ip6tables>            Save/reload IPv6 firewall rules

admin@ghzgqx.com CentOS Router/Firewall Control Script 20190124"
	;;
	help2)
	less -c -M -Q /etc/info.txt
	;;
    *)
	echo "Command error, use help for help"
	;;
	
	
	
	
esac


