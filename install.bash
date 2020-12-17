#!/bin/bash

GOINFRE=/goinfre/$USER
BREW_PATH=$GOINFRE/.brew
BREW_OLD=$HOME/.brew
BREW_EXEC=$BREW_PATH/bin/brew
if [ ! -d $BREW_PATH ]; then
	if [ -d $BREW_OLD ]; then
		rm -rf $BREW_OLD
	if
	git clone https://github.com/Homebrew/brew $BREW_PATH
fi

DOCKER_PATH=$GOINFRE/.docker
DOCKER_OLD=$HOME/.docker

if [ ! -d $DOCKER_PATH ]; then
	if [ -d $DOCKER_OLD ]; then
		rm -rf $DOCKER_OLD
	if
	$BREW_EXEC install docker docker-machine
fi

KUBE_PATH=$GOINFRE/.kube
KUBE_OLD=$HOME/.kube

if [ ! -d $KUBE_PATH]; then
	if [ -d $KUBE_OLD]; then
		rm -rf $KUBE_OLD
	fi
	mkdir $KUBE_PATH
	cd $HOME
	ln -s $KUBE_PATH .
	cd -	
fi
