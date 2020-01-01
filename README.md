# RakuDist

Test Raku modules against different OS, Rakudo versions

# Automatic tests

I am working on tests get run automatically and reports get published to a public domain,
so far module authors could run tests manually.

# Runs tests manually

Install Sparrowdo

`zef install --/test Sparrowdo`

Pull docker images

`docker pull debian`

Run container

`docker run -t --rm --name $container-name debian`

Run tests

`sparrowdo --bootstrap --no_sudo --docker=$container-name --repo=http://repo.westus.cloudapp.azure.com/ --sparrowfile=modules/red/sparrowfile`

# Example report

```
[melezhik@localhost red]$ sparrowdo --docker=debian --no_sudo --repo=http://repo.westus.cloudapp.azure.com 
22:59:06 01/01/2020 [repository] index updated from http://repo.westus.cloudapp.azure.com/api/v1/index
22:59:10 01/01/2020 [create user red] Don't change user home as managehome set to 'no' OR homedir not set
22:59:10 01/01/2020 [create user red] user red - nothing changed
22:59:10 01/01/2020 [create user red] uid=1000(red) gid=1000(red) groups=1000(red)
22:59:13 01/01/2020 [create directory /data/test/red] directory path: /data/test/red
22:59:13 01/01/2020 [create directory /data/test/red] directory owner: <red>
22:59:13 01/01/2020 [create directory /data/test/red] directory group: <red>
22:59:13 01/01/2020 [create directory /data/test/red] directory access rights: drwxr-xr-x
[task check] stdout match <owner: <red>> True
[task check] stdout match <group: <red>> True
22:59:16 01/01/2020 [bash: git checkout https://github.com/FCO/Red.git] /data/test/red
22:59:16 01/01/2020 [bash: git checkout https://github.com/FCO/Red.git] Already up to date.
22:59:18 01/01/2020 [bash: last commit] commit fc47058f080722cca2c2872e3f03082bd09ca5da
22:59:18 01/01/2020 [bash: last commit] Author: Fernando Correa de Oliveira <fernandocorrea@gmail.com>
22:59:18 01/01/2020 [bash: last commit] Date:   Tue Dec 31 22:21:27 2019 +0000
22:59:18 01/01/2020 [bash: last commit] 
22:59:18 01/01/2020 [bash: last commit]     0.1.3
22:59:18 01/01/2020 [bash: last commit] 
22:59:18 01/01/2020 [bash: last commit] M Changes
22:59:18 01/01/2020 [bash: last commit] M META6.json
22:59:18 01/01/2020 [bash: last commit] M README.md
22:59:18 01/01/2020 [bash: last commit] M lib/Red.pm6
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] total 68
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   592 Jan  1 22:31 CONTRIBUTING.md
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red  2526 Jan  1 22:31 Changes
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   384 Jan  1 22:31 Dockerfile
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   332 Jan  1 22:31 Dockerfile-no-config
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   427 Jan  1 22:31 Dockerfile-no-run
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red  8902 Jan  1 22:31 LICENSE
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red  5955 Jan  1 22:31 META6.json
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   123 Jan  1 22:31 Makefile
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red 10509 Jan  1 22:31 README.md
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   482 Jan  1 22:31 Red.iml
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red     0 Jan  1 22:47 a.db
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red     0 Jan  1 22:47 b.db
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 2 red red    17 Jan  1 22:31 bin
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] -rw-r--r--. 1 red red   100 Jan  1 22:31 dist.ini
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 4 red red    83 Jan  1 22:31 docs
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 8 red red    82 Jan  1 22:31 examples
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 7 red red    85 Jan  1 22:45 lib
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 3 red red  4096 Jan  1 22:31 t
22:59:19 01/01/2020 [bash: cd /data/test/red && ls -l] drwxr-xr-x. 2 red red    27 Jan  1 22:31 tools
22:59:23 01/01/2020 [bash: zef install Test::META] stderr: All candidates are currently installed
22:59:23 01/01/2020 [bash: zef install Test::META] No reason to proceed. Use --force-install to continue anyway
22:59:26 01/01/2020 [bash: zef install /data/test/red] stderr: All candidates are currently installed
22:59:26 01/01/2020 [bash: zef install /data/test/red] <empty stdout>
22:59:28 01/01/2020 [bash: zef test] ===> Testing: Red:ver<0.1.3>:auth<Fernando Correa de Oliveira>:api<2>
23:01:06 01/01/2020 [bash: zef test] [Red] t/00-meta.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/01-basic.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/02-tdd.t ............................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/03-sqlite.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/04-blog.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/05-ticket.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/06-better-map.t ..................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/07-optimizer.t ...................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/08-best-tree.t ...................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/09-alternate-relation.t ............. ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/10-alternate-relation-modules.t ..... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/11-join.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/12-types.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/13-roles.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/14-result-seq-update.t .............. ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/15-union.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/16-result-seq-bool.t ................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/17-create-related-pars.t ............ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/18-pp.t ............................. ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/19-phasers.t ........................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/20-in-sql.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/21-new-with-id.t .................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/22-red-do.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/23-edit-id.t ........................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/24-metamodel-model.t ................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/25-grep-no-AND-OR.t ................. ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/26-is-rw.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/27-classify.t ....................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/28-LPW-2019.t ....................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/29-events.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/30-result-seq-pick.t ................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] Use of Nil in numeric context
23:01:06 01/01/2020 [bash: zef test] [Red]   in block  at /data/test/red/.precomp/902863C6FF81B0B9901E5C42393B9B7181A4AE04/F2/F2E53992C6FFEDC5DC3B09E6E9D69BBEB965D56B line 1
23:01:06 01/01/2020 [bash: zef test] [Red] t/31-update.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/32-join.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/33-join.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/34-join.t ........................... skipped: (no reason given)
23:01:06 01/01/2020 [bash: zef test] [Red] t/35-ast-generic.t .................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/35-create.t ......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/35-default-deflate.t ................ ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/36-json.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/37-equal.t .......................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/38-xmas.t ........................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/39-relationship-multiple-columns.t .. ok
23:01:06 01/01/2020 [bash: zef test] [Red] t/40-fallback.t ....................... ok
23:01:06 01/01/2020 [bash: zef test] [Red] All tests successful.
23:01:06 01/01/2020 [bash: zef test] [Red] Test Summary Report
23:01:06 01/01/2020 [bash: zef test] [Red] -------------------
23:01:06 01/01/2020 [bash: zef test] [Red] t/24-metamodel-model.t              (Wstat: 0 Tests: 65 Failed: 0)
23:01:06 01/01/2020 [bash: zef test] [Red]   TODO passed:   32
23:01:06 01/01/2020 [bash: zef test] [Red] Files=43, Tests=616, 98 wallclock secs ( 0.18 usr  0.05 sys + 137.29 cusr  5.27 csys = 142.79 CPU)
23:01:06 01/01/2020 [bash: zef test] [Red] Result: PASS
23:01:06 01/01/2020 [bash: zef test] ===> Testing [OK] for Red:ver<0.1.3>:auth<Fernando Correa de Oliveira>:api<2>
```

# Available reports

TBD

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

