 #!/usr/bin/env bash
sudo gem install bundler
cd /vagrant
bundle install
puma -p 4000 -d --control tcp://0.0.0.0:9292 --control-token admin