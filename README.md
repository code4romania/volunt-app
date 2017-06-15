[![Travis build](https://travis-ci.org/code4romania/volunt-app.svg?branch=master)](https://travis-ci.org/code4romania/volunt-app)
[![Code Climate](https://codeclimate.com/github/code4romania/volunt-app/badges/gpa.svg)](https://codeclimate.com/github/code4romania/volunt-app)

# Gestiunea voluntarilor si proiectelor Code4Romania
Un sistem de gestiune a voluntarilor si proiectelor Code4Romania disponibil la http://comunitate.code4.ro/


## Development

There are 2 ways defined for running app in development mode.Either you can try to setup it 
locally or you can try do it via an integrated environment ( vagrant).
Start by cloning the project to your machine:
```bash
git clone https://github.com/code4romania/volunt-app ~/dev/volunt-app
```

### Local environment 

#### Prerequisites

* Ruby 
* Postgres
* PgAdmin3 (psql client, in case you are not very familiar with psql console)

#### Steps


Following will bring up the necessary gems into your system and create database and
corresponding tables. 

```bash 
bundle install
bundle exec rake db:create
bundle exec rake db:migrate
bundle exec rake db:seed
```

Start the application with 

```bash 
source config/.env.sample
bundle exec rails s
```
 You can access the app via browser at `http://localhost:3000` and you can find the logs under
  `/logs/development.log`
  
  For login you can use an *admin user* ( credentials are: admin@example.com, pass) or
  *normal user*: (credentials are: user@example.com, pass).  


### Vagrant environment 

#### Prerequisites

* Vagrant
* VirtualBox
* Ansible

#### Steps 
* Setup 
```bash
cd ~/dev/volunt-app
vagrant up
```
* Accessing the app  
  You can access the app via browser at `http://localhost:8000` ( Vagrant will take over the port forwarding from 8000 to 3000)

* Accessing the DB by entering the VM
```bash
vagrant ssh
cd /vagrant
bundle exec rake db:seed
```
* Running tests
```bash
vagrant ssh
cd /vagrant
rspec
```
* Troubleshooting 

In case app does not start try restarting puma:
```bash
sudo service puma-manager restart
```


**Made with :heart: by [GovITHub](http://ithub.gov.ro)**
