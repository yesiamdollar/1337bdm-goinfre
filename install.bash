#!/bin/bash

GOINFRE=/goinfre/$USER
BREW_PATH=$GOINFRE/.brew
BREW_OLD=$HOME/.brew
BREW_EXEC=$BREW_PATH/bin/brew

if [ ! -d $BREW_PATH ]; then
	if [ -d $BREW_OLD ]; then
		rm -rf $BREW_OLD
	fi
	git clone https://github.com/Homebrew/brew $BREW_PATH
fi

DOCKER_PATH=$GOINFRE/.docker
DOCKER_OLD=$HOME/.docker

if [ ! -d $DOCKER_PATH ]; then
	if [ -d $DOCKER_OLD ]; then
		rm -rf $DOCKER_OLD
	fi
	$BREW_EXEC install docker docker-machine
fi

KUBE_PATH=$GOINFRE/.kube
KUBE_OLD=$HOME/.kube

if [ ! -d $KUBE_PATH ]; then
	if [ -d $KUBE_OLD ]; then
		rm -rf $KUBE_OLD
	fi
	mkdir $KUBE_PATH
	cd $HOME
	ln -s $KUBE_PATH .
	cd -	
fi

ZSHRC_FILE=$HOME/.zshrc
READ_ZSHRC=$ZSHRC_FILE

if [ ! -f $ZSHRC_FILE ]; then
	READ_ZSHRC=$PWD/zshrc	
fi

IFS=$'\n' read -d '' -r -a lines < $READ_ZSHRC

if [ -f $ZSHRC_FILE ]; then 
		rm -rf $ZSHRC_FILE & touch $ZSHRC_FILE
else
		touch $ZSHRC_FILE
fi
for i in "${lines[@]}"; do 
	if [[ "$i" == *"brew"*  ]]; then
		echo 'export PATH=$HOME/goinfre/.brew/bin:$PATH' >> $ZSHRC_FILE
	else
		echo $i >> $ZSHRC_FILE
	fi
done

if [[ ! "${lines[@]}" =~ "Code" ]] && [[ ! "${lines[@]}" =~ "code"  ]]; then
	echo 'export PATH="$PATH:/Applications/Visual Studio Code.app/Contents/Resources/app/bin"' >> $ZSHRC_FILE
fi

if [[ ! "${lines[@]}" =~ "MINIKUBE_HOME" ]]; then
	echo 'export MINIKUBE_HOME=$HOME/goinfre/.minikube' >> $ZSHRC_FILE
fi

if [[ ! "${lines[@]}" =~ "MACHINE_STORAGE_PATH" ]]; then
	echo 'export MACHINE_STORAGE_PATH=$HOME/goinfre/.docker' >> $ZSHRC_FILE
fi


NASM_EXEC=/usr/bin/nasm

$NASM_EXEC 2> nasm_check

IFS=$'\n' read -d '' -r -a C_NASM < nasm_check

if [[ "${C_NASM[@]}" =~ "error" ]];then
	$BREW_EXEC install nasm
fi

$BREW_EXEC cleanup
source ~/.zshrc
