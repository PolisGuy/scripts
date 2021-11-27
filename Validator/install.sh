$name="put your validator name here"
sudo yum update
cd /usr/local/src
git clone https://github.com/polischain/polis-chains
cd polis-chains
sudo yum install -y nodejs
sudo yum install -y npm
sudo amazon-linux-extras install docker
sudo service docker start
sudo usermod -a -G docker ec2-user
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
./run.sh generate
#Get the address from the passwords directory.
NAME="%name" ./run.sh sparta validator %address
