[![Build Status](https://travis-ci.org/code4romania/volunt-app.svg?branch=master)](https://travis-ci.org/code4romania/volunt-app)
[![Code Climate](https://codeclimate.com/github/code4romania/volunt-app/badges/gpa.svg)](https://codeclimate.com/github/code4romania/volunt-app)

# Volunt-App

Un sistem de gestiune a voluntarilor si proiectelor Code4Romania disponibil la 
[https://comunitate.code4.ro/]()


## Development

În acest moment, sunt două metode prin care se poți să rulezi aplicația:

1. Automat, folosind fie [Vagrant][vagrant] sau [Docker][docker]
2. Manual, când trebuie să rezolvi tu toate dependințele (Ruby, gem-uri, 
   Postgres, nginx, etc)

[vagrant]: https://www.vagrantup.com/
[docker]: https://www.docker.com/

Dintre cele două metode, recomandăm cu tărie prima variantă deoarece vor crea o
mașină virtuală care se apropie cât mai mult de mediul de producție. Dezavantajul
acestei metode este faptul că totul se petrece într-o mașină virtuală, ceea ce
implică un necesar de resurse semnificativ mai ridicat decât dacă totul e
instalat manual, excepția notabilă fiind cazul în care folosești Linux și optezi
pentru Docker.

Indiferent de opțiunea aleasă, primul pas e să clonezi local repository-ul de
git

```bash
git clone https://github.com/code4romania/volunt-app ~/dev/volunt-app

cd ~/dev/volunt-app
```

### Vagrant

Vagrant este o aplicație dezvoltată de Hashicorp care simplifică semnificativ
configurarea și management-ul mașinilor virtuale. La finalul instrucțiunilor vei
putea să te loghezi într-o mașină virtuală configurată foarte similar cu cele
din producție.

Înainte de toate, ai nevoie de următoarele aplicații instalate:

* Vagrant pentru [sistemul tău de operare](https://www.vagrantup.com/downloads.html)
* [VirtualBox](https://www.virtualbox.org/wiki/Downloads) 
* [Ansible](https://www.ansible.com/)

Dacă folosești Windows și ai versiunea Pro, e recomandat să folosești Hyper-V în
loc de VirtualBox. Pentru mai multe detalii, vezi 
[documentația provider-ului de Hyper-V din Vagrant][hyperv].

[hyperv]: https://www.vagrantup.com/docs/hyperv/

Când toate aplicațiile sunt instalate, tot ce trebuie să faci e să pornești
Vagrant și totul va fi configurat automat (în special prima rulare va dura mai
mult, e perfect normal):

```bash
cd ~/dev/volunt-app
vagrant up
```

În acest moment, te poți conecta la mașina virtuală și să faci setările
inițiale:

```bash
vagrant ssh

bundle install
cp .env.local .env

bundle exec rake db:setup
```

Apoi poți porni aplicația:

```bash
bundle exec rails s -p 3000
```

__ATENȚIE__: chiar dacă ai configurat în fișierul `.env` ca aplicația să ruleze pe
portul 3000, Vagrant va expune portul 8000 lcoal. Deci în loc să deschizi
`http://localhost:3000` în browser, vei folosi `http://localhost:8000`.


### Docker

Spre diferență de Vagrant, care doar oferă un layer de abstractizare peste
un provider de mașini virtuale (cum e VirtualBox, de exemplu), Docker a fost 
conceput pentru a permite definirea unor „containere”. Cum toți marii provideri
de SaaS ([Amazon EC2][aws], [Microsoft Azure][azure], 
[Google Cloud Engine][google-ce]) sau PaaS ([Heroku][heroku]) oferă suport
pentru configurarea instanțelor oferite prin Docker, există posibilitatea de a
avea un mediu de dezvoltare local identic cu cel de producție.

[aws]: https://aws.amazon.com/ecs/
[azure]: https://azure.microsoft.com/en-us/services/container-service/
[google-ce]: https://cloud.google.com/compute/docs/instance-groups/deploying-docker-containers
[heroku]: https://devcenter.heroku.com/articles/container-registry-and-runtime

Docker folosește fie hypervisor-ul nativ cu care vine sistemul de operare 
(Hyper-V pentru Windows, Hyperkit pentru macOS), fie (aproape) nativ pe Linux,
ceea ce permite un pic mai puțină flexibilitate decât Vagrant (de exemplu, 
Docker nu funcționează pe mașini cu Windows non-Pro deoarece nu se poate instala
Hyper-V).

Primul pas e să instalezi [Docker CE pentru sistemul tău de operare][docker-ce],
apoi trebuie să adaugi un fișier local numit `docker-compose.override.yml` care
poate conține o serie de setări locale pentru sistemul tău (fișierul e adăugat
în `.gitignore` deci nu va putea fi commit-uit din greșeală). Recomandarea ar fi
să ai următorul conținut:

[docker-ce]: https://store.docker.com/search?offering=community&type=edition

```yaml
version: '3'

services:

  db:
    environment:
      POSTGRES_USER: ${VOLUNTARI_DATABASE_DEVELOPMENT_USER}
      POSTGRES_PASSWORD: ${VOLUNTARI_DATABASE_DEVELOPMENT_PASSWORD}
      POSTGRES_DB: voluntari_development

  app:
    env_file: .env
    build:
      context: .
      args:
        bundler_opts: ''
    volumes:
      # The volume must be identical to the application home in Dockerfile
      - .:/opt/voluntapp
```

În acest moment, poți să construiești container-ul:

```bash
docker-compose build
```

Apoi poți face setările finale: 

```bash
cp .env.local .env
# Editează fișierul .env astfel încât valoarea lui VOLUNTARI_DATABASE_HOST
# sa fie db nu localhost 
docker-compose run app rake db:setup
```

Pentru a porni container-ul, folosești `docker-compose up` și va porni automat
două containere: unul cu aplicația și celălalt cu baza de date.

De acum încolo, pentru a rula comenzi în interiorul container-ului va trebui să
înlocuiești `bundle exec` cu `docker-compose run app`. De exemplu, pentru a 
migra baza de date:

```bash
docker-compose run app rake db:migrate
```

În general, e o idee bună să faci niște aliasuri pentru `docker-compose run app`
și `docker-compose up` deoarece le vei rula destul de frecvent.


### Manual

Aplicația folosește:

* ultima versiune stabilă de Ruby (vezi `.ruby-version`)
* baza de date este Postgres, versiunea 9.5 sau mai nouă
* `.env.local` conține environment variables necesare

Unele gem-uri vor avea nevoie de anumite librării, care depinde de la un sistem
de operare la altul. 


## Teste

Testele sunt scrise folosind RSpec și suita de teste se poate rula folosind:

```bash
bundle exec rspec
```


* Generate Diagrams

We use **railroady** gem for generating diagrams. For more information please 
contact [RailRoady](https://github.com/preston/railroady).


```
bundle exec rake diagram:all
railroady -M | neato -Tjpeg > models.jpeg
railroady -C | neato -Tjpeg > controllers.jpeg
```

Diagrams with extension **svg** can be opened via browser.

**Made with :heart: by [GovITHub](http://ithub.gov.ro) and [Code 4 Romania](https://code4.ro)**