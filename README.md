# weekly-reports

This is a bundling of utilities meant to automate the creation of weekly reports. The requirements for the generation are rather
specific.

The generator reads out a list of svn repositories, looks for commits made in the last week by a specific 
author and generates markdown files from the commit messages.

The other half of the project is [Jekyll](http://jekyllrb.com/) for displaying those reports. So the second half of the generation process is converting those
reports into Jekyll blog posts. The Jekyll blog currently only supports one commit author, as I haven't worked out a sensible structure
for that yet. 

# Getting started

To get the report generation running, you'll only need Ruby installed then simply put the data you need into the *config.yaml* and run 
the 
```
    weekly.rb
```
script in the */generator* folder.
The reports can be found in /{username}/{weekXX}/{project}. When no commits are found for the given week, no files will be created.

To get Jekyll up it is easiest to use the supplied VagrantFile. Simply install [Vagrant](https://www.vagrantup.com/downloads.html) and [Virtualbox](https://www.virtualbox.org/wiki/Downloads) and run

```
    vagrant up
```
in the root directory. The Vagrant box comes with port forwarding and automatically starts up the Jekyll server. The server is 
available under *localhost:9000*. For some reason the Jekyll autorebuild feature doesn't seem to work within the Vagrant VM so after changes you have to ssh into the machine (```vagrant ssh```) and cd into */vagrant/weekly-reports* and run ```jekyll build```.
