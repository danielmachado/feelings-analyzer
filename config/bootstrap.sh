#!/usr/bin/env bash

apt-get update
apt-get install -y ruby
apt-get install -y rubygems
apt-get install -y redis-server
apt-get install -y git
apt-get install -y curl
# introducimos estos comandos a mano luego, reiniciamos la máquina
#curl -#L https://get.rvm.io | bash -s stable --autolibs=3 --ruby
#echo "source $HOME/.rvm/scripts/rvm" >> ~/.bash_profile
echo "you should restart your vagrant machine (vagrant halt, vagrant up)"
# url del repositorio
#git clone repo.url
# usamos rvm para gestionar las versiones de Ruby
#rvm use 2.0.0
# ejecutamos para instalar bundle y gestionar dependencias
#gem install bundle
#bundle install