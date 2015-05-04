sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y ruby1.9.3
sudo gem install -y jekyll
sudo apt-get install -y nodejs

cd /vagrant/weekly-reports
jekyll server --watch --detach

