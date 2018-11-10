+++
title = 'Use Gpg Signing for Github'
date = 2018-07-28T20:39:40+08:00
draft = true
description = ""
+++

A few days ago, I notiecd that when creating a new file or delete that on Github,  on the right-hand side, the commits will display a "Verified" sign. Just look like following:

![](https://blog-d0zingcat.oss-cn-hangzhou.aliyuncs.com/gpg-sign.png) 

Looks really cool, isn't it? So, I've tried to make this thing appear on every commit(especially on local pc/laptop, using git client) I've submit, but not soon I've encountered a lot and a lot troubles(when your os is OS X). Here is an instruction of how to turn this feature on(which means signing commits with G(nu)PG). 
?

So, let me guide you how to make this "Verified" sign come out.

- install [brew](https://brew.sh/) if not

`/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"`

- install gpg and pinentry

`brew update && brew install gpg && brew install pinentry-mac && echo "pinentry-program /usr/local/bin/pinentry-mac" > ~/.gnupg/gpg-agent.conf && killall gpg-agent`

- use `echo "test" | gpg --clearsign` to test of gpg is installed correctly.


- generate gpg key and import into Github(just use the new key for gpg sign by ignoring any existed gpg key)

`gpg --default-new-key-algo rsa4096 --gen-key`

> When asked to enter your email address, ensure that you enter the verified email address for your GitHub account.

Now, the terminal displays like following:
```
-----BEGIN PGP PUBLIC KEY BLOCK-----

mQINBFtUemQBEADE2tGSTjXyd6zqx6WIRlB+EosPBV5WPgLUCSFiHgPLpjY59Kek
0WwdBX+ippgAfFNfdiYWJLs0oddd8zV/aU70ZMSUErCS9oyWem/HEpLO383
CcSrvN2YMWuAviBcsrbbUY6uWBRbeHqyNWir19nFOBURXEk9JomHefI3JYcxv6xA
wZPz2mEEn+HfneoqAb9oFq5IKqMkteFQ5uBTgUfG5V7QXjxr2qbjDg8i3wARAQAB
tCBMZWUgVGFuZyA8ZDB6aW5nY2F0QG91dGxvb2suY29tPokCTgQTAQgAOBYhBBHd
N/0HszSZ2DAZ4VoovvfEXbLFBQJbVHpkAhsDBQsJCAcCBhUKCQgLAgQWAgMBAh4B
AheAAAoJEFoovvfEXbLFsssT2oEi5RgpO8hwCkRSQTVSCIgUSH
TBkEh+Sewy6/DgALbv+KHkox/oG44BAnI4/9jxK/p2HUNE1rP2VnWw50kZyOcGcA
d1nt63jLqxyURq+7h6MHrw0D81L3U72/4KHnK5JcBSpOYrDOpkb+LQVqD1hYKpoD
oMvd57qZECuiXHKLe82YlL8FaWhILoaG6jjEn90w8n4VZmvOyI39FaBgALTL4nH0
DwO8uQINBFtUemQBEAC1RGuRYJiwTv//9wThSiMKRO0xZUUWI/kQaDqYSExnaRSV
x51bp7fD5EEJCE8w8o6oLQhvPrpRPsssurUSeAOwfOHMRhUaU1XyR4O2OW
yu3pIsW1/2la18XMbBIKo3Z4wLFL+XWznB3wHsYtHcJQFqUVetF85DB7ILAvsQAR
AQABiQI2BBgBCAAgFiEEEd03/QezNJnYMBnhWii+98RdssUFAltUemQCGwwACgkQ
Wii+98RdssVugg/+KFtx74+ip/IPV/bvssssL7JfFJO0QzOUc=
=BGUu
-----END PGP PUBLIC KEY BLOCK-----
```

Copy your GPG key, beginning with -----BEGIN PGP PUBLIC KEY BLOCK----- and ending with -----END PGP PUBLIC KEY BLOCK----- and paste into Github-Settings-SSH and GPG keys-new GPG key.

- set up local git client 


    gpg --list-secret-keys --keyid-format SHORT | grep ^sec

when the command entered, the terminal displays like following:

    sec   rsa4096/3AA5C343 2018-07-22 [SC]

Which is need to denote, the keyid format should be SHORT instead of LONG, and this step is different from Github official instruction. You should copy '3AA5C343' this part and we will use this key:

`git config --global user.signingkey 3AA5C343 && git config --global gpg.program $(which gpg)`


- test if git know how to sign your commit

    `mkdir test && cd test && git init && touch a && git add . && git commit -S -m "test" && cd .. && rm -rf test`

if no error shows, that means you are safe now and from now on you can use `-S` argument to order git to sign with Gpg. In addition, to sign all commits by default in any local repository on your computer, run `git config --global commit.gpgsign true`.

*Ref:* 

- [Signing commits with GPG](https://help.github.com/articles/signing-commits-with-gpg/)
- [gpg failed to sign the data fatal: failed to write commit object [Git 2.10.0]](https://stackoverflow.com/questions/39494631/gpg-failed-to-sign-the-data-fatal-failed-to-write-commit-object-git-2-10-0/39626266)
- [GPG and git on macOS](https://gist.github.com/danieleggert/b029d44d4a54b328c0bac65d46ba4c65)
- [Generating a new GPG key](https://help.github.com/articles/generating-a-new-gpg-key/)
- [Telling Git about your GPG key](https://help.github.com/articles/telling-git-about-your-gpg-key/)
- [The git error: “gpg failed to sign the data”](https://ducfilan.wordpress.com/2017/03/10/the-git-error-gpg-failed-to-sign-the-data/comment-page-1/)
- [Signing Commits in Git](https://nathanielhoag.com/blog/2016/09/05/signing-commits-in-git/)


