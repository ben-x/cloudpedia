#!/bin/bash -x

# Usage: setup-nginx-on-ubuntu.sh {DOMAIN_NAME} {APP_PORT}

apt update -y
apt install nginx -y

mkdir /var/www/web-app

cat <<EOF > /var/www/web-app/index.html
<!doctype html>
<html>
<head>
    <meta charset="utf-8">
    <title>Hello, Cloudpedia</title>
</head>
<body>
    <h1>Hey, Guys!</h1>
    <p>You've successfully setup this app on nginx</p>
</body>
</html>
EOF

cat <<EOF > /etc/nginx/sites-available/web-app.conf
server {
   listen ${APP_PORT};
   listen [::]:${APP_PORT};

   server_name ${DOMAIN_NAME};

   root /var/www/web-app;
   index index.html;

   location / {
           try_files $uri $uri/ =404;
   }
}
EOF

ln -s /etc/nginx/sites-available/web-app.conf /etc/nginx/sites-enabled/

systemctl start nginx
