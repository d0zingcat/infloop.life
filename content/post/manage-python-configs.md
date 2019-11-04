---
title: "Manage python project configurations"
date: 2019-05-03T11:02:09+08:00
draft: false
---

When working on a python project I've been thinking how to manage the configurations in an elegant way, just like the 'maven-way'(use a placeholder and replace them when packaging). Here are some points I care about:

1. separate development and production configs
2. easy to use, no need to include third party packages
3. safe, will not be committed to git repo by mistake
4. out-of-box, no need to modify the code to run on production or development environment

As I have such requirements, after researching I finally choose this way to handle it.

The structure looks like:

![](https://files.d0zingcat.xyz/blog/posts/manage-python-configs/config-module.png)

*base_config.py*

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

class Config(object):
    _DEBUG = False
    _PROD = False

    def __getitem__(self, key):
        return self.__getattribute__(key)
        
   	common_1 = '1'
    common_2 = '2'
    common_3 = '3'
    common_4 = '4'
    common_5 = '5'
```

*config_dev.py*

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

from .base_config import Config

class DevelopmentConfig(Config):
    _DEBUG = True
    
    customized_1 = '1111'
    customized_2 = 'two'
    
```

*config_prod.py*

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-

from .base_config import Config

class ProductionConfig(Config):
    _PROD = True
    
    customized_1 = 'oneoneone'
    customized_2 = '2'
```

*config.py*

```python
#!/usr/bin/env python
# -*- coding:utf-8 -*-
import os

from .config_dev import DevelopmentConfig
from .config_prod import ProductionConfig

mappings = {
    'development': DevelopmentConfig,
    'production': ProductionConfig,
    'default': DevelopmentConfig
}

MY_ENV = os.environ.get('MY_ENV', 'default').lower()
config = mappings[MY_ENV]()
```

*__init__.py*

this file is only to declare: the costconfig is a module

*from other file*

```python
from costconfig.config import config as Config
```

In the files you need to use config you just need to import it.

As you can see, the config file is key point. When entering the main scope, it will try to get environment 'MY_ENV'('default' by default and will use dev config) and get related config class according to this env variable, by which we can easily export an environment 'MY_ENV' to production on the server then the program will use production config. In this way, we can just run the same code without modifying even one line of the codes on server or on local development environment, just modify the configs and everything works fine.

In addition, there are still three steps you have to take.

1. add this filename into .gitignore, for me is: `*config/*_prod.*` to ignore the production config, in this case we will never have to worry about commit the production config to git repo(e.g. Github)
2. export MY_ENV on server, for me is add `export MY_ENV=production` to the end of ~/.bshrc
3. if you use a crontab to execute your script, you will find the program fails. That's because the crontab env is not safe like your bash, namely it will not execute your ~/.bashrc file first before executing. So, you have to declare in the crontab, just use `crontab -e` to edit the crontab and add `MY_ENV=production` at the first line.



Reference: 

[Better Cron env and shell control with the SHELL variable](https://raymii.org/s/tutorials/Better_cron_env_and_shell_control_with_the_SHELL_variale.html)

[Timesaving crontab Tips](https://krisjordan.com/blog/2013/11/04/timesaving-crontab-tips)

[Linux Environment Variables](https://codeburst.io/linux-environment-variables-53cea0245dc9)

[Scheduling Cron Jobs with Crontab](https://linuxize.com/post/scheduling-cron-jobs-with-crontab/)

[how-can-i-run-a-cron-command-with-existing-environmental-variables](https://unix.stackexchange.com/questions/27289/how-can-i-run-a-cron-command-with-existing-environmental-variables)

[where-can-i-set-environment-variables-that-crontab-will-use](https://stackoverflow.com/questions/2229825/where-can-i-set-environment-variables-that-crontab-will-use)

