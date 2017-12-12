SHELL = /bin/bash
ROOT_MOM = $(shell dcos config show core.dcos_url)

cleanroot:
	@echo Cleaning up root
	dcos marathon app remove /marathon-lb

cleandevmom:
	@echo Cleaning up devmom
	dcos marathon app stop --force /dev/dev-user-marathon
	dcos marathon app remove /dev/dev-user-marathon
	dcos package uninstall marathon-lb --app-id=/dev-marathon-lb

devmom:
	@echo Launching dev mom
	dcos marathon app add ./dev-mom/marathon-mom.json
	@echo Launching dev marathon-lb
	dcos marathon app add ./dev-mom/marathon-lb.json

devmomapps:
	dcos config set marathon.url $(ROOT_MOM)/service/dev-marathon-user
	dcos marathon app add ./dev-mom/apps/tracer-external.json
	dcos config set marathon.url $(ROOT_MOM)

base:
	@echo Launching root marathon-lb
	dcos marathon app add ./base/marathon-lb.json
#	dcos config unset marathon.url

list:
	dcos marathon app list

all:
	$(MAKE) devmom
	$(MAKE) root
