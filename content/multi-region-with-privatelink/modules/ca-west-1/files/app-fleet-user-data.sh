#!/bin/bash -x

# Usage: app-fleet-user-data.sh {APP_PORT}

apt update -y

cd ~
curl -sL https://deb.nodesource.com/setup_20.x -o /tmp/nodesource_setup.sh

bash /tmp/nodesource_setup.sh

apt install nodejs -y
node -v
npm -v

mkdir /var/web-app

cat <<EOF > /var/web-app/package.json
{
  "name": "fastify-app",
  "version": "1.0.0",
  "description": "A demo fastify application",
  "main": "index.js",
  "dependencies": {
    "fastify": "^4.26.2"
  }
}
EOF

cat <<EOF > /var/web-app/index.js
const fastify = require('fastify')({ logger: true })

fastify.get('/', function handler (request, reply) {
  reply.send({ msg: "Hello! You've successfully set up a fastify server." });
})

fastify.listen({ port: ${APP_PORT}, host: '0.0.0.0' }, (err) => {
  if (err) {
    fastify.log.error(err)
    process.exit(1)
  }

  console.log('Server running');
})
EOF

cd /var/web-app/

npm install

node index.js
