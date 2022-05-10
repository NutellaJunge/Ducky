mkdir /snirt
cd /snirt

curl -fsSL https://get.docker.com -o get-docker.sh
sh get-docker.sh

(cat << EOF
FRONTEND_ADDRESSE=snirt.staticalt.de
FRONTEND_PORT=443
NODE_PORT=8888
IS_EXTERNAL_NODE=true
EOF
) > .env

(cat << EOF
[Unit]
Description=Snirt Service
After=docker.service
Requires=docker.service

[Service]
User=root
TimeoutStartSec=0
Restart=always
ExecStop=/usr/bin/docker exec snirt_node kill -s SIGINT 1
ExecStartPre=/usr/bin/docker login -u paulo5 -p a8Hk@L_~4m_8Zcb
ExecStartPre=/usr/bin/docker image pull paulo5/snirt:node
ExecStartPre=/usr/bin/docker image tag paulo5/snirt:node snirt_node
ExecStartPre=/usr/bin/docker image prune -f
ExecStart=/usr/bin/docker run --rm --name snirt_node --env-file /snirt/.env -p 8888:8888 snirt_node

[Install]
WantedBy=default.target
EOF
) > /etc/systemd/system/Snirt.service

systemctl daemon-reload
systemctl enable Snirt
systemctl start Snirt
