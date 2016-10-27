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
git clone https://github.com/gov-ithub/volunt-app.git
cd volunt-app
set VOLUNTARI_DATABASE_HOST=<host postgresql>
set VOLUNTARI_DATABSE_PORT=<port postgresql>
set VOLUNTARI_DATABASE_DEVELOPMENT_USER=<postgresql user>
set VOLUNTARI_DATABASE_DEVELOPMENT_PASSWORD=<postgresql pwd>
set VOLUNTARI_EMAIL_DEVELOPMENT_TO=<an email to receive all emails from dev env>
bundle install
rake db:migrate
rails server
```
Evident, `set`-urile se pot muta in `~/.bash_profile`. Rails serveste aplicatia pe portul 3000. Mailurile trimise din aplicatie au host configurat din `config/domains.yml` si `config/email.yml`, daca vrei sa verifici link-urile din aplicatie trebuie sa ai control pe un domeniu DNS si sa modifici config ca link-urile sa fie valide.

**Made with :heart: by [GovITHub](http://ithub.gov.ro)**
