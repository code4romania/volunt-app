[![Travis build](https://travis-ci.org/code4romania/volunt-app.svg?branch=master)](https://travis-ci.org/code4romania/volunt-app)
[![Code Climate](https://codeclimate.com/github/code4romania/volunt-app/badges/gpa.svg)](https://codeclimate.com/github/code4romania/volunt-app)

# Gestiunea voluntarilor si proiectelor Code4Romania
Un sistem de gestiune a voluntarilor si proiectelor Code4Romania disponibil la http://comunitate.code4.ro/


## Development

- Instalează Vagrant și VirtualBox
- Instalează Ansible
- Clonează proiectul:
```bash
git clone https://github.com/code4romania/volunt-app ~/dev/volunt-app
```
- Creează setup-ul:
```bash
cd ~/dev/volunt-app
vagrant up
```

- Poți accesa aplicația în browser la adresa `http://localhost:8000` (Vagrant
se ocupă de port forwarding de la 8000 la 3000)

- Ca să încarci baza de date cu niște date dummy, trebuie să intri în VM:
```bash
vagrant ssh
cd /vagrant
bundle exec rake db:seed
```
- La fel și ca să rulezi teste:
```bash
vagrant ssh
cd /vagrant
rspec
```

**Made with :heart: by [GovITHub](http://ithub.gov.ro)**
