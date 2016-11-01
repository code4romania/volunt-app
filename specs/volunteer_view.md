# Volunteer View

## Roadmap

Este necesar ca volunt-app sa poata sa fie folosit si de catre voluntari si comunitatea extinsa Gov IT Hub, nu numai de catre bursieri. Memberii comunitatii trebuie sa fie autentificati si autorizati de catre volunt-app si aplicatia trebuie sa afiseze un menu de navigare specific pentru nevoile membrilor comunitatii. Voluntarii pot folosi volunt-app pentru:

 [ ] a-si vedea si modifica profilul. Acesta contine datele personale ale voluntarului (nume, email, telefon, poza, URL-uri relevante pentru profil)
 [ ] editeaza skill-urile declarate in profil
 [ ] sa vada profilurile bursierilor Gov IT Hub, dara fara date personale (Eg. fara email-uri in afara celor @ithub.gov.ro)
 [ ] vede lista de proiecte Gov IT Hub
 [ ] sa vada datele public despre progresul proiectelor (status reports)
 [ ] vede lista de nevoi a proiectelor
 [ ] cauta proiecte dupa skill-urile cerute
 [ ] aplica la proiecte ca disponibil
 [ ] propune noi proiecte

Odata acceptata ca colaborator intr-un proiect, voluntarii trebuie sa:
  
 [ ] sa vada ceilalti voluntari care contribuie la proiect
 [ ] sa vada task-uri ale proiectului si status_reports private
 [ ] sa raporteze progres in task-urile proiectelor

## Vizualizare si editare profile propriu voluntar

Pentru inceput este necesar sa implementam primele doua puncte (vedere/editare profil si skill-uri voluntar). Pasi necesari:

 [ ] adaugarea de autorizare pentru login in aplicatei. In acest moment aplicatia are doar un nivel de autorizare (`authorization_required` in controller-ele private). Este necesar sa se poata specifica mai multe nivele, in functie de rolul user-ului logat (comunitatea extinsa, voluntar, bursier). [`cancan`](https://github.com/ryanb/cancan) posibil sa mearga, de studiat. Anumite actiuni pot fir permise pentru user-ul curent (de eg. un user poate sa-si vada si sa-si editeze profilul proriu, dar nu poate vedea alte profile. Un voluntar poate sa vada profilurile celorlati participanti la proiectele la care participa, dar nu le poate edita)
 [ ] declarare de rol pentru login. `User` nu contine rol/tip. Ma gindesc ca nu este nevoie, pentru ca avem informatia in `Profile` si profilul unui user poate fi rezolvat din email (user === email).
 [ ] un layout diferit in aplicatie pentru voluntari vs. bursieri. Chiar daca controller-ele auorizeaza user-ul, nu e un user-experience bun daca aplicattion layout (si implicit navbar-ul) ramine cel de la bursieri.
 [ ] la login user-ul trebuie directionat la pagina de profil propiu.

## Signup
 
 [ ] Curent un login este permis daca exista `User`, dar nu exista posibilitatea de a aduga useri (nu exista sign-up). Este necesar flow de sign-up, pentru ca doritorii sa poata sa aplice ca voluntari la Gov IT Hub.
 [ ] Nu exista enforcement la email verification. Flow-ul trebuie sa fie Signup -> Verify -> Profile. La login user-ul trebuie blocat intr-o pagina de 'pending verification' pina link-ul din email (validation_token) este validata, abia apoi permisa navigarea mai departe (profil). Acesta trebuie enforced pe toate controllel-le 'private'. Asta creeaza problem cu user-ii care nu primesc mail-ul de validare, dar daca nu se face enforcement intreaga infrastructura de user-profile se duce de ripa pentru ca este bazata pe email === identity
 
## Email storage

In acest moment modul cum se tin emailurile in `Profile` este broken (as in really broken). Exista un cimp `email`, string indexat, si exista `contacts` care este jsonb si `TagsConcern` marcheaza emailurile din el ca `email:`, `email1:`, `email2:`. `Profile.for_email` cauta in `email` si in `contacts`, folosing PsotgreSQL json operators, ca sa gaseasca profilul corespunzator unui email (folosit de eg. pentru a afisa profilul propriu in ruta `/me`, si folosit si in taskurile de import (`lib/tasks/*.rake`). Citeva probleme:

 [ ] cautarea `Profile.for_email` este ineficienta (scan). Un [`gin`](https://www.postgresql.org/docs/9.1/static/textsearch-indexes.html) index ar ajuta, dar nu asta este ce este nevoie.
 [ ] emailurile nu sunt validate. In afara de problema de comunicare (trimiterea de newsletter fara verificare), exista o problema de autorizare. User-ul x poate adauga adresa de email foo@example.com in profilul sau. Apoi, cind foo@example.com se logheaza in volunt-app, este directionat spre profilul lui X, pentru ca identificarea profilui se face pe baza oricarui email declarat in profil. 

Trebuie sa pastram posibilitatea de a adauga mai multe email-uri per profile. Ma gindesc o tabele `emails` si has_many: in profil. Fiecare email trebuie validat separat si doar cele validate pot fi folosite in volunt-app. NB. tabela `users` este in principiu un overlap significant cu o tabela `emails` (e deja index uniq pentru `user.email`). 
