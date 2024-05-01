#!/bin/bash

# Script for setting up a Ruby on Rails development environment with PostgreSQL, MySQL, Sublime Text, NVM, and Elasticsearch

# Define passwords for PostgreSQL and MySQL
POSTGRES_PASSWORD="your_postgres_password"
MYSQL_PASSWORD="your_mysql_password"

# Define Ruby and Rails versions
RUBY_VERSION="3.0.0"
RAILS_VERSION="6.1.0"

# Define Elasticsearch version
ELASTICSEARCH_VERSION="7.x"

# Update package manager
echo "Updating package manager..."
sudo apt update

# Install essential dependencies
echo "Installing essential dependencies..."
sudo apt install -y curl git

# Install RVM (Ruby Version Manager)
echo "Installing RVM..."
\curl -sSL https://get.rvm.io | bash -s stable

# Load RVM into the current shell session
source ~/.rvm/scripts/rvm

# Install Ruby
echo "Installing Ruby (version $RUBY_VERSION)..."
rvm install $RUBY_VERSION

# Set default Ruby version
echo "Setting default Ruby version to $RUBY_VERSION..."
rvm use $RUBY_VERSION --default

# Install Rails gem
echo "Installing Rails gem (version $RAILS_VERSION)..."
gem install rails -v $RAILS_VERSION

# Install Node Version Manager (NVM)
echo "Installing Node Version Manager (NVM)..."
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash

# Load NVM into the current shell session
source ~/.bashrc

# Install the latest LTS version of Node.js
echo "Installing the latest LTS version of Node.js..."
nvm install --lts

# Set the latest LTS version of Node.js as the default version
echo "Setting the latest LTS version of Node.js as the default version..."
nvm alias default 'lts/*'

# Install PostgreSQL
echo "Installing PostgreSQL..."
sudo apt install -y postgresql postgresql-contrib libpq-dev

# Start and enable PostgreSQL
echo "Starting and enabling PostgreSQL..."
sudo systemctl start postgresql
sudo systemctl enable postgresql

# Set password for PostgreSQL user 'postgres'
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD '$POSTGRES_PASSWORD';"

# Install MySQL
echo "Installing MySQL..."
sudo apt install -y mysql-server mysql-client libmysqlclient-dev

# Secure MySQL installation (optional)
echo "Securing MySQL installation..."
sudo mysql_secure_installation <<< "n
y
y
y
y"

# Set password for MySQL root user
sudo mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '$MYSQL_PASSWORD';"

# Start and enable MySQL
echo "Starting and enabling MySQL..."
sudo systemctl start mysql
sudo systemctl enable mysql

# Install Elasticsearch
echo "Installing Elasticsearch..."
sudo apt install -y openjdk-11-jre
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
sudo sh -c 'echo "deb https://artifacts.elastic.co/packages/$ELASTICSEARCH_VERSION/apt stable main" > /etc/apt/sources.list.d/elastic-$ELASTICSEARCH_VERSION.list'
sudo apt update
sudo apt install -y elasticsearch

# Start and enable Elasticsearch
echo "Starting and enabling Elasticsearch..."
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch

# Install Sublime Text
echo "Installing Sublime Text..."
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | sudo apt-key add -
sudo apt-get install apt-transport-https
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list
sudo apt-get update
sudo apt-get install sublime-text

echo "Setup complete!"
