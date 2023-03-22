#!/bin/bash

useragent="Mozilla/5.0 (Windows NT 10.0; rv:102.0) Gecko/20100101 Firefox/102.0"
referer="https://www.heavent-expo.com"

##############

rndstr=`tr -dc "a-z0-9" < /dev/urandom | head -c16`
thedate=`date +%F`

red="\\e[1;91m"
green="\\e[1;92m"
orange="\\e[1;93m"
blue="\\e[1;94m"
purple="\\e[1;95m"
cyan="\\e[1;96m"
end="\\e[0;0m"

##############

echo -e "$blue""\n[+] Check results folder""$end"

if [ ! -d results/ ]; then
	mkdir results/
fi

##############

echo -e "$blue""\n[+] Extract all expos""$end"

allexpos=`curl -L -s -A "$useragent" -e "$referer" "https://visitor.weyou-group.com/" | grep 'https://visitor.weyou-group.com/' | cut -d'"' -f2`

echo "$allexpos" > /tmp/weyou_$rndstr.txt

echo -e "$blue""\n[+] Guess vip for each expo""$end"

i=1
while IFS='' read -r line || [[ -n "$line" ]]; do
	
	echo -e "$purple""\nExpo $i: $line""$end"
	
	isvip=false
	
	for vipcode in vip vipbrut4 bavip vipparrainage vipt vipm vipshort vipmfelu vipnet vipmfafrc;
	do
		echo -e "$cyan""VIP Code: $vipcode""$end"
		
		testvip=`curl -L -s -A "$useragent" -e "$referer" "$line?source=$vipcode" | grep -A1 'wysiwyg-inscription text-16' | grep 'VIP'`
		
		if [ "$testvip" != "" ]; then
			isvip=true
			
			echo -e "$green""VIP: OK""$end"
		else
			echo -e "$orange""VIP: KO""$end"
		fi
		
		if ($isvip); then
			echo "$line?source=$vipcode" >> results/$thedate-$rndstr.txt
			break
		fi
	done
	
	let i=i+1
done < /tmp/weyou_$rndstr.txt

##############

echo -e "$blue""\n[+] Clean & exit""$end"

if [ -e /tmp/weyou_$rndstr.txt ]; then
	rm /tmp/weyou_$rndstr.txt
fi

exit 0
