# RakuDist

Test Raku modules against different OS, Rakudo versions

# Run tests via API

Warning: it's not implimented yet

`curl -d '' http://repo.westus.cloudapp.azure.com/rakudist/api/$module_name`

where `module_name` is a one of the following:

* a name of a Raku module 
* a name of a folder in `modules/` directory 

This allow to invoke tests both for:

* Raku modules ( default test scenarios )
* Folder in `modules/` directory ( custom test scenarios  )

Examples:

```
POST `rakudist/api/Chart::Gnuplot # default test scenario, module Chart::Gnuplot`
POST `rakudist/api/red-with-pg` # custom test scenario, modules/rest-with-pg 
```

# Runs tests manually

Install Sparrowdo

`zef install --/test Sparrowdo`

Pull docker images

`docker pull debian`

Run container

`container_name='debian-rakudist' && docker run -d -t --rm --name $container_name debian`

Run tests

Cd to module dir

`cd modules/red`

Run sparrowdo

`sparrowdo --bootstrap --no_sudo --docker=$container_name --repo=http://repo.westus.cloudapp.azure.com`

# Example report

```
[melezhik@localhost kind]$ sparrowdo  --no_sudo --docker=debian-rakudist --repo=http://repo.westus.cloudapp.azure.com
16:50:02 01/09/2020 [repository] index updated from http://repo.westus.cloudapp.azure.com/api/v1/index
16:50:07 01/09/2020 [create user kind] uid=1006(kind) gid=1006(kind) groups=1006(kind)
16:50:07 01/09/2020 [create user kind] user kind created
[task check] stdout match <created> True
16:50:11 01/09/2020 [create directory /data/test/kind] directory path: /data/test/kind
16:50:11 01/09/2020 [create directory /data/test/kind] directory owner: <kind>
16:50:11 01/09/2020 [create directory /data/test/kind] directory group: <kind>
16:50:11 01/09/2020 [create directory /data/test/kind] directory access rights: drwxr-xr-x
[task check] stdout match <owner: <kind>> True
[task check] stdout match <group: <kind>> True
16:50:15 01/09/2020 [bash: git checkout https://github.com/Kaiepi/p6-Kind.git] /data/test/kind
16:50:15 01/09/2020 [bash: git checkout https://github.com/Kaiepi/p6-Kind.git] stderr: Cloning into '.'...
16:50:17 01/09/2020 [bash: last commit] commit c08acf1e4a52491a3b09e19e129efc3092cef745
16:50:17 01/09/2020 [bash: last commit] Author: Ben Davies <kaiepi@outlook.com>
16:50:17 01/09/2020 [bash: last commit] Date:   Tue Dec 24 16:28:29 2019 -0400
16:50:17 01/09/2020 [bash: last commit]
16:50:17 01/09/2020 [bash: last commit]     Release v0.1.0
16:50:17 01/09/2020 [bash: last commit]
16:50:17 01/09/2020 [bash: last commit] M       CHANGELOG
16:50:17 01/09/2020 [bash: last commit] M       META6.json
16:50:17 01/09/2020 [bash: last commit] M       lib/Kind.pm6
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] total 32
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind  191 Jan  9 16:50 CHANGELOG
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind 8902 Jan  9 16:50 LICENSE
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind  408 Jan  9 16:50 META6.json
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind 3230 Jan  9 16:50 README.md
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind 3337 Jan  9 16:50 README.pod6
16:50:19 01/09/2020 [bash: cd /data/test/kind && ls -l] -rw-r--r--. 1 kind kind  114 Jan  9 16:50 dist.ini
16:50:20 01/09/2020 [bash: cd /data/test/kind && ls -l] drwxr-xr-x. 2 kind kind   22 Jan  9 16:50 lib
16:50:20 01/09/2020 [bash: cd /data/test/kind && ls -l] drwxr-xr-x. 2 kind kind   23 Jan  9 16:50 t
16:50:24 01/09/2020 [bash: Install module dependencies] stderr: All candidates are currently installed
16:50:24 01/09/2020 [bash: Install module dependencies] <empty stdout>
16:50:27 01/09/2020 [bash: zef test] ===> Testing: Kind:ver<0.1.0>
16:50:29 01/09/2020 [bash: zef test] [Kind] t/01-kind.t .. ok
16:50:29 01/09/2020 [bash: zef test] [Kind] All tests successful.
16:50:29 01/09/2020 [bash: zef test] [Kind] Files=1, Tests=3,  2 wallclock secs ( 0.02 usr  0.00 sys +  2.68 cusr  0.21 csys =  2.91 CPU)
16:50:29 01/09/2020 [bash: zef test] [Kind] Result: PASS
16:50:29 01/09/2020 [bash: zef test] ===> Testing [OK] for Kind:ver<0.1.0>
```

# Available reports

Reports available in `reports/` directory

For example:

* [red debian](https://github.com/melezhik/RakuDist/blob/master/reports/red-debian.txt)
* [red debian with Postgresql](https://github.com/melezhik/RakuDist/blob/master/reports/red-with-pg-debian.txt)
* [cro alpine](https://github.com/melezhik/RakuDist/blob/master/reports/cro-apline.txt)

# Adding new modules

* Create a new folder in `modules/` directory
* Write high-level scenario preparing configuration/environment for your module
* See `modules/red` as an example


# See also

* [Sparrow6](https://github.com/melezhik/Sparrow6)
* [Sparrow6 DSL](https://github.com/melezhik/Sparrow6/blob/master/documentation/dsl.md)
* [Sparrowdo](https://github.com/melezhik/sparrowdo)

# Thanks to

God, because "For the Lord gives wisdom; from his mouth come knowledge and understanding.", Proverbs 2:6

# Author

Alexey Melezhik

