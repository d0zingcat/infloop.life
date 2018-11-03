+++
title = 'Upgrade Git on Mac'
date = 2018-07-28T08:54:04+08:00
draft = true
tags = ["tags"]
description = "Desc"

# For twitter cards, see https://github.com/mtn/cocoa-eh-hugo-theme/wiki/Twitter-cards
meta_img = "/images/image.jpg"

# For hacker news and lobsters builtin links, see github.com/mtn/cocoa-eh-hugo-theme/wiki/Social-Links
hacker_news_id = ""
lobsters_id = ""
+++

Recently, I've tried to use GnuPG signing my commits, but some wierd phenomemon appear. To eliminate other factors that affect the problem, I've tried to upgrade my Git release on Mac OS X.

1. check git version and back up original git version

    $ git --version
    git version 2.10.1 (Apple Git-78)
    $ sudo mv /usr/bin/git /usr/bin/git-apple

2. Update homebrew(already installed supposed)

    $ brew update && brew upgrade

If you've not heard [Homebrew](https://brew.sh/) or not installed before, install brew firstly.

    $ /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

3. Install Git with Homebrew

    $ brew install git

4. (if not linked) Fix symblic link
    $ brew link --force git

If symbolic link is already linked, this won't cause any harm.

5.  Close Terminal and reopen then check version

    $ git --version

And you shall see...

    git version 2.18.0


Nice! We are safe now! And next time you just need to...

    $ brew update && brew upgrade

And this script will automatically upgrade all the softwares installed by brew.



*Ref*:

[How to upgrade Git (Mac OSX)](https://medium.com/@katopz/how-to-upgrade-git-ff00ea12be18)

