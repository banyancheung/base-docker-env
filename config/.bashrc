# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
        . /etc/bashrc
fi

# User specific aliases and functions
PATH=$PATH:$HOME/bin:$HOME/php/bin:$HOME/nginx/sbin:$HOME/memcached/bin
export PATH

alias logn="tail -F /home/worker/data/nginx/logs/* /home/worker/data/nginx/logs/*"
alias logp="tail -F /home/worker/data/php/log/*"
alias logr="tail -F /home/worker/data/www/runtime/*/*.log"