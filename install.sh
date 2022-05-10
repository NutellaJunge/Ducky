mkdir /snirt
cd /snirt

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

echo FRONTEND_ADDRESSE=snirt.staticalt.de\
FRONTEND_PORT=443\
NODE_PORT=8888\
IS_EXTERNAL_NODE=true > .env

echo [Unit]\
Description=Snirt Service\
After=docker.service\
Requires=docker.service\
\
[Service]\
TimeoutStartSec=0\
Restart=always\
ExecStartPre=-/usr/bin/docker exec %n stop\
ExecStartPre=-/usr/bin/docker rm %n\
ExecStartPre=/usr/bin/docker login -u paulo5 -p a8Hk@L_~4m_8Zcb\
ExecStartPre=/usr/bin/docker image tag paulo5/snirt:node SnirtNode\
ExecStartPre=/usr/bin/docker image prune -f\
ExecStart=/usr/bin/docker run --name SnirtNode --env-file /snirt/.env -p 8888:8888 SnirtNode\
\
[Install]\
WantedBy=default.target > /etc/systemd/system/Snirt.service

systemctl enable Snirt

