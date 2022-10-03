#!/bin/sh 
: "   t s s l  V2.01   J.R. Cordy   Rev 3 March 1983"
: "Run the Turing S/SL Processor."
: "Usage:  tssl [-t] [-+] [-e] [-l] [-u] file.ssl "
: "S/SL processor toggles: "
: "	-t :  produce Turing tables "
: "	-+ :  produce Turing Plus tables "
: "	-e :  produce Euclid tables (the present default) "
: "	-l :  produce a listing of the source program with table coordinates "
: "	-u :  summarize processor resource usage "
options=""
suffix="e"
while true
do
	case $1 in
	-*)	options=$options`expr "$1" : "-\(.*\)"`
		case $1 in
		-t*|-+*)
			suffix="t" ;;
		*)	;;
		esac
		shift ;;
	*)	break ;;
	esac
done
i=`basename $1 .ssl`
/usr/local/lib/tplus/ssl.x $i.ssl $i.def.$suffix $i.sst.$suffix $i.lst $options
