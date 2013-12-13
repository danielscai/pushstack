#!/bin/bash

reset_refs(){
	pwd_module=`pwd`
	git_path=$1
	cd $git_path
	git_remote_path=`git remote -v | grep push | awk '{print \$2}'`
	cd $pwd_module
	git remote rm origin 
	git remote add origin $git_remote_path
	git fetch 
}

main(){
	git_path=`git remote -v | grep push | awk '{print \$2}'`
	
	if [[ $git_path =~ ^/ ]];then
		reset_refs $git_path
	fi
}

main $@
