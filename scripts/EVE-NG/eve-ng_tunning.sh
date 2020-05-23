

# para que solo muestre las plantillas cargadas 
cp /opt/unetlab/html/includes/config.php.distribution /opt/unetlab/html/includes/config.php

# teclado en español
for file in `find /opt/unetlab/html/templates/ -type f -iname \???*.yml`
do
  sed -i 's/=kvm /=kvm -k es /g' $file
done

#IOL con 256MB andan...
for file in `find /opt/unetlab/html/templates/ -type f -iname iol.yml`
do
  sed -i 's/ram: 1024/ram: 256/g' $file
done

# igual que los linux.. 512MB sobra ! 
for file in `find /opt/unetlab/html/templates/ -type f -iname linux.yml`
do
  sed -i 's/ram: 2048/ram: 512/g' $file
done

#------ install megadl
apt-get update && apt-get -y install build-essential libglib2.0-dev libssl-dev libcurl4-openssl-dev libgirepository1.0-dev -y 

cd /usr/local/src
wget https://megatools.megous.com/builds/megatools-1.10.3.tar.gz
tar -zxvf megatools-1.10.3.tar.gz
cd megatools-1.10.3
make clean
./configure --disable-docs
make
make install

