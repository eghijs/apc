#!/bin/sh
IFS=","
XENHOSTNAME="s-xs-2"
XENHOST="10.1.8.1"
XENUSER="root"
XENPWD="illusion"

for VM in `xe vm-list is-control-domain=false power-state=running params=uuid --minimal`
do
	echo "Shutting down " $VM
	xe vm-shutdown vm=$VM
	if [ $? -eq 0 ]; then
		echo $VM "Desligado com sucesso..."
	else
		echo "O desligamento falhou, Forçando o desligamento" $VM
		xe vm-shutdown vm=$VM force=true
	fi
done
xe host-disable host=$XENHOSTNAME
xe host-shutdown host=$XENHOSTNAME
