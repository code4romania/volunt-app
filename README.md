[![Travis build](https://travis-ci.org/gov-ithub/volunt-app.svg?branch=master)](https://travis-ci.org/gov-ithub/volunt-app)
[![Code Climate](https://codeclimate.com/github/gov-ithub/volunt-app/badges/gpa.svg)](https://codeclimate.com/github/gov-ithub/volunt-app)

# Gestiunea voluntarilor si proiectelor Gov IT Hub
Un sistem de gestiune a voluntarilor si proiectelor Gov IT Hub.

Cind aplicatia este folosita de un bursier sau coordinator:
- Inregistrarea voluntarilor, completarea de profil (locatie, contact, skills, tags)
- Cautare voluntari dupa locatie, skils, taguri
- Inregistrarea proiectelor Gov IT Hub
- Managementul alocarii de voluntari per proiect, incarcare etc
- Inregistrera progresului pe proiecte, integrare cu GitHub/JIRA
- Pozitii disponibile in proiect (openings, jobs)
- Mass mailing pentru comunitate, voluntari, contributori la proiecte

Cind aplicatia este folosita de un voluntar:
- Signup, aplicare
- Editare profil personal
- Acces lista de proiecte, informatii publice in proiect
- Acces lista de pozitii, cautare dupa skills/atribute
- Aplicare la pozitii (disponibilitate de a lucra la un proiect)

## Install

Applicatia se conecteaza la o baza de PostgreSQL.

```
psql
CREATE ROLE voluntapp;
ALTER ROLE voluntapp WITH LOGIN;
```

```
createdb voluntari_development --host=localhost --port=5432 --owner=voluntapp
createdb voluntari_test --host=localhost --port=5432 --owner=voluntapp
```

```
git clone https://github.com/gov-ithub/volunt-app.git
cd volunt-app
bundle install
cp config/.env.sample .env
rails db:setup
rails server
rspec # will run all tests in spec/
```

**Made with :heart: by [GovITHub](http://ithub.gov.ro)**
