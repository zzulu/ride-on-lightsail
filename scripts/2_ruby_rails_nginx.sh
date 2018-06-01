#!/bin/bash
set -e

# ./2.sh [project_name]
cd ~

# Install ruby
echo '>> Install ruby'
if [ -e ~/$1/.ruby-version ]; then
  rv="$(cat ~/$1/.ruby-version)"
else
  rv="2.3.6"
fi

if hash ruby 2>/dev/null; then
  echo 'Ruby already installed'
else
  rbenv install -v $rv
  rbenv global $rv
  ruby -v
fi

# Install Bundler
echo '>> Install Bundler'
gem install bundler

# Run 'bundle install'
echo '>> Run bundle install'
cd ~/$1 && bundle install --without development test

# Install passenger & nginx
echo '>> Install Passenger & Nginx'
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
sudo apt-get install -y apt-transport-https ca-certificates
sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger xenial main > /etc/apt/sources.list.d/passenger.list'
sudo apt-get update && sudo apt-get install -y nginx-extras passenger
sudo service nginx start

# Configure Passenger & Nginx
echo '>> Configure Passenger & Nginx'
sudo sed -i -e '/passenger_ruby/c\passenger_ruby /home/ubuntu/.rbenv/shims/ruby;' /etc/nginx/passenger.conf
sudo sed -i -e 's/\# include \/etc\/nginx\/passenger/include \/etc\/nginx\/passenger/g' /etc/nginx/nginx.conf
sudo sed -i -e "s/root \/var\/www\/html;/root \/home\/ubuntu\/$1\/public; passenger_enabled on; rails_env production;/g" -e '/index.nginx-debian.html/d' -e '/try_files/d' -e '/server_name _;/a\        error_page  500 502 503 504  \/50x.html; location = \/50x.html { root html; }' /etc/nginx/sites-enabled/default
sudo service nginx restart

# Assets precompile & restart
echo '>> Assets precompile & restart'
cd ~/$1 && bundle exec rake db:migrate RAILS_ENV=production && bundle exec rake db:seed RAILS_ENV=production && bundle exec rake assets:precompile RAILS_ENV=production && touch tmp/restart.txt
