# GitHowTo harjutused

See repository sisaldab GitHowTo harjutuste käigus tehtud töid. Projekti eesmärk oli õppida Git'i põhilist kasutamist, branch'idega töötamist ning muudatuste salvestamist ja GitHubi saatmist.

## Mida ma õppisin

Harjutuste käigus õppisin:

- kuidas kontrollida repository olekut;
- kuidas lisada faile staging area'sse;
- kuidas teha commit'e;
- kuidas vaadata commit'ide ajalugu;
- kuidas luua uusi branch'e;
- kuidas branch'ide vahel liikuda;
- kuidas branch'e omavahel ühendada;
- kuidas muudatusi GitHubi push'ida;
- kuidas GitHubist muudatusi pull'ida.

## Kasutatud Git käsud

Repository oleku kontrollimiseks kasutasin käsku `git status`.

Failide lisamiseks kasutasin:

```bash
git add failinimi
```

Commit'i tegemiseks kasutasin:

```bash
git commit -m "Muudatuse kirjeldus"
```

Branch'idega töötamisel kasutasin näiteks:

```bash
git branch
git switch style
git merge style
```

Commit'ide ajaloo vaatamiseks kasutasin:

```bash
git log
```

Muudatuste GitHubi saatmiseks kasutasin:

```bash
git push
```

GitHubist muudatuste allalaadimiseks kasutasin:

```bash
git pull
```

## Git'i põhitöövoog

Tavaline Git'i töövoog näeb välja selline:

```bash
git status
git add .
git commit -m "Muudatuste kirjeldus"
git push
```

Kõigepealt teen failides muudatused. Seejärel kontrollin käsuga `git status`, millised failid on muutunud.

Pärast seda lisan vajalikud failid staging area'sse käsuga `git add`.

Seejärel teen commit'i, et muudatused salvestada.

Lõpuks kasutan `git push` käsku, et saata muudatused GitHubi.

Kui GitHubis on tehtud uusi muudatusi, kasutan nende allalaadimiseks käsku `git pull`.

### Harjutuste edenemine

- [x] Repository kasutamine
- [x] Failide lisamine
- [x] Commit'ide tegemine
- [x] Branch'ide loomine
- [x] Branch'ide vahetamine
- [x] Merge kasutamine
- [x] Push kasutamine
- [x] Pull kasutamine

Lisainfot Git'i kohta leiab [Git'i ametlikust dokumentatsioonist](https://git-scm.com/doc).
