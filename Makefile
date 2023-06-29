define _script
crontab <<'EOF'
0 */2 * * *  /usr/bin/echo -n "[$(date)] " >> /home/rex/ddns.log; /home/rex/Projects/nuc-config/ddns.sh >> /home/rex/ddns.log
EOF
endef
export script = $(value _script)

all:; @eval "$$script"
