# Instructions for running solumns
#
# These instructions are given to you in a shell script format
# This makes it easier to distinguish the commands from the comments
#
# However I haven't tried this, so you might be better just reading this
# and typing into another terminal.
#
# First install rake, a build tool used by solumns
sudo apt-get install rake

# Then download and install racket, the programming language
# in which Solumns is written
# If this fails, then look at http://racket-lang.org/download/
wget -O install-racket.sh http://mirror.csclub.uwaterloo.ca/racket/racket-installers/5.1/racket/racket-5.1-bin-i386-linux-ubuntu-jaunty.sh

# Once you have installed the software needed to run it,
# then extract solumns.tar.gz
# You can do this with nautilus or with
#
# $ tar -xzf solumns.tar.gz
#
# Then to run it, you must cd into the directory in which it was
# extracted and run this:
# 
# $ rake test_hiscore
#
# Have fun!
