# Overview

EXP installation consists of setting up the following components:

1. Packages / Dependencies
2. Ruby interpreter
3. System user account
4. Database configuration
5. Upstart scripts
6. EXP application
7. Nginx web server
8. EXP administrator account
9. Logrotate
10. IPWrangler (for TCP/UDP redirections)
11. Redirus worker (for smart HTTP(s) redirections)

## 1. Packages / Dependencies

Install the required packages (reqired to compile Ruby and native extensions
to Ruby gems):

```
sudo apt-get update

sudo apt-get install -y build-essential zlib1g-dev libyaml-dev libssl-dev libgdbm-dev libreadline-dev libncurses5-dev libffi-dev openssh-server redis-server curl wget checkinstall libxml2-dev libxslt-dev libcurl4-openssl-dev libicu-dev logrotate
```

Make sure you have the right version of Git installed

```
# Install Git
sudo apt-get install -y git-core

# Make sure Git is version 1.7.10 or higher, for example 1.7.12 or 2.0.0
git --version
```

If the Git version installed by the system is too old, remove it and compile
from source.

```
# Remove packaged Git
sudo apt-get remove git-core

# Install dependencies
sudo apt-get install -y libcurl4-openssl-dev libexpat1-dev gettext libz-dev libssl-dev build-essential

# Download and compile from source
cd /tmp
curl --progress https://www.kernel.org/pub/software/scm/git/git-2.0.0.tar.gz | tar xz
cd git-2.0.0/
make prefix=/usr/local all

# Install
sudo make install
```

Note: In order to receive e-mail notifications, make sure to install a mail server.

```
sudo apt-get install -y postfix
```

## 2. Ruby

You can use ruby installed by ruby version managers such as [RVM](http://rvm.io/)
or [rbenv](https://github.com/sstephenson/rbenv), or install it globally
from sources. The following manual presents global installation.

Remove old Ruby 1.8, if present:

```
sudo apt-get remove ruby1.8
```

Download Ruby and compile it:

```
mkdir /tmp/ruby && cd /tmp/ruby
curl --progress ftp://ftp.ruby-lang.org/pub/ruby/2.1/ruby-2.1.2.tar.gz | tar xz
cd ruby-2.1.2
./configure --disable-install-rdoc
make
sudo make install
```

Install the Bundler and Foreman Gems:

```
sudo gem install bundler --no-ri --no-rdoc
sudo gem install foreman --no-ri --no-rdoc
```

## 3. System User

Create an `exp` user for EXP:

```
sudo adduser --gecos 'EXP' exp
```

## 4. Database setup

Install PostgreSQL database.

```
# Install the database packages
sudo apt-get install -y postgresql-9.3 postgresql-client libpq-dev

# Log in to PostgreSQL
sudo -u postgres psql -d template1

# Create a user for EXP
template1=# CREATE USER exp CREATEDB;

# Create the EXP production database & grant all privileges to user exp
template1=# CREATE DATABASE exp_production OWNER exp;

# Quit the database session
template1=# \q

# Try connecting to the new database with the new user
sudo -u exp -H psql -d exp_production
```

## 5. Upstart

Upstart is used to manage the EXP and Redirus worker lifecycle
(`start`/`stop`/`restart`).

Replace `/etc/dbus-1/system.d/Upstart.conf` with the content presented below
to allow any user to invoke all upstart methods (this step is not needed when
using Ubuntu 14.04):

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE busconfig PUBLIC
  "-//freedesktop//DTD D-BUS Bus Configuration 1.0//EN"
  "http://www.freedesktop.org/standards/dbus/1.0/busconfig.dtd">

<busconfig>
  <!-- Only the root user can own the Upstart name -->
  <policy user="root">
    <allow own="com.ubuntu.Upstart" />
  </policy>

  <!-- Allow any user to invoke all of the methods on Upstart, its jobs
       or their instances, and to get and set properties - since Upstart
       isolates commands by user. -->
  <policy context="default">
    <allow send_destination="com.ubuntu.Upstart"
       send_interface="org.freedesktop.DBus.Introspectable" />
    <allow send_destination="com.ubuntu.Upstart"
       send_interface="org.freedesktop.DBus.Properties" />
    <allow send_destination="com.ubuntu.Upstart"
       send_interface="com.ubuntu.Upstart0_6" />
    <allow send_destination="com.ubuntu.Upstart"
       send_interface="com.ubuntu.Upstart0_6.Job" />
    <allow send_destination="com.ubuntu.Upstart"
       send_interface="com.ubuntu.Upstart0_6.Instance" />
  </policy>
</busconfig>
```

Add the following to `/home/exp/.bash_profile`:

```
if [ ! -f /var/run/user/$(id -u)/upstart/sessions/*.session ]
then
    /sbin/init --user --confdir ${HOME}/.init &
fi

if [ -f /var/run/user/$(id -u)/upstart/sessions/*.session ]
then
   export $(cat /var/run/user/$(id -u)/upstart/sessions/*.session)
fi
```

Change the owner of this file:

```
sudo chown exp:exp /home/exp/.bash_profile
```


More information can be found in the [Upstart Cookbook](http://upstart.ubuntu.com/cookbook/), particularly in the following sections:

* [user job](http://upstart.ubuntu.com/cookbook/#user-job)
* [enabling user job](http://upstart.ubuntu.com/cookbook/#enabling)
* [session job](http://upstart.ubuntu.com/cookbook/#session-job)
* [session init](http://upstart.ubuntu.com/cookbook/#session-init)

## 6. EXP

We use Git `hooks` to automatically deploy new releases of EXP.

Prepare a clean git repository:

```
# We'll install EXP into the home directory of the user "exp"
cd /home/exp

# Create the EXP home directory
sudo -u exp -H mkdir current

# Init empty git repository...
sudo -u exp -H git init /home/exp/current

# ...and enable pushing to this repository.
cd /home/exp/current
sudo -u exp -H git config receive.denyCurrentBranch ignore
```

Install the post hook which will be triggered every time new code is pushed into the
repository

```
# Download post-receive hook...
sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/doc/install/support/git/post-receive -O /home/exp/current/.git/hooks/post-receive

# ...and make it executable
sudo -u exp -H chmod +x /home/exp/current/.git/hooks/*
```

Install modified templates for foreman upstart script generation. If you are
using a ruby version management tool than please uncomment the appropriate
line in `/home/exp/upstart-templates/process.conf.erb`

```
# Create directory for upstart templates
sudo -u exp -H mkdir /home/exp/upstart-templates

# Download templates
sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/doc/install//support/upstart/master.conf.erb -O /home/exp/upstart-templates/master.conf.erb

sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/doc/install//support/upstart/process.conf.erb -O /home/exp/upstart-templates/process.conf.erb

sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/doc/install//support/upstart/process_master.conf.erb -O /home/exp/upstart-templates/process_master.conf.erb

# Create directory for generated upstart scripts
sudo -u exp -H mkdir /home/exp/.init
```

Create EXP configuration files

```
sudo -u exp -H mkdir /home/exp/current/config
sudo -u exp -H mkdir /home/exp/current/config/initializers

# Download required configuration files
sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/config/air.yml.example -O /home/exp/current/config/air.yml

sudo -u exp -H wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/config/puma.rb.example -O /home/exp/current/config/puma.rb

# Customize configuration files
sudo -u exp -H editor /home/exp/current/config/air.yml
sudo -u exp -H editor /home/exp/current/config/puma.rb
```

Clone EXP code locally (e.g. on your laptop):

```
git clone https://github.com/ismop/exp.git
```

Generate two random secrets locally:

```
cd air
rake secret
rake secret
```
Expose generated secrets as environmental variables on your server

```
# Open bash profile...
sudo -u exp -H editor /home/exp/.bash_profile

# ...and add two secrets
export SECRET_KEY_BASE=<first_generated_secret>
export DEVISE_SECRET_KEY_BASE=<second_generated_secret>
```

Install nodejs for compiling java script files

```
sudo apt-get install -y nodejs
```

Add EXP remote to your local EXP copy

```
cd cloned_exp_path
git remote add production exp@production.server.ip:current
```

Push exp code into production

```
git push production master
```

As a result, code from the `master` branch will be pushed into the remote server and
the `post-receive` hook will be invoked. It will:
- update remote code to requested version
- install all required dependencies (gems)
- perform database migration
- regenerate upstart scripts
- restart the application.

## Nginx

```
# Install nginx
sudo apt-get install -y nginx-light

# Download EXP nginx configuration file
sudo wget --no-check-certificate https://raw.githubusercontent.com/ismop/exp/master/doc/install/support/nginx/exp -O /etc/nginx/sites-available/exp

# customize nginx configuration file
sudo editor /etc/nginx/sites-available/exp

# ...enable it...
sudo ln -s /etc/nginx/sites-available/exp /etc/nginx/sites-enabled/exp

# ...and restart nginx
sudo service nginx restart
```

As a conclusion EXP should be up and running under the selected URL.

## 7. EXP administrator

```
sudo su - exp
cd /home/exp/current
bundle exec rake db:seed
exit
```

## 8. Logrotate

```
sudo cp /home/exp/current/doc/install/support/logrotate/exp /etc/logrotate.d/exp
```

If needed, create additional logrotate configurations for Redirus workers and IPWrangler.

## 9. IPWrangler

Documentation is available [here](https://gitlab.dev.cyfronet.pl/atmosphere/ipt_wr/blob/master/README.md).

## 10. Redirus worker

Installation documentation is available [here](https://github.com/dice-cyfronet/redirus/blob/master/README.md).
