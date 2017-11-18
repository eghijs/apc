#!/bin/sh
IFS=","
XENHOSTNAME=""
XENHOST=""
XENUSER="root"
XENPWD=""

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
