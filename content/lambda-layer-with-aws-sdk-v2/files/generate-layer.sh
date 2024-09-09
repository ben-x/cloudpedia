#!/bin/sh

echo \
'
{
  "name": "aws-sdk-v2",
  "version": "1.0.0",
  "description": "A module containing aws-sdk v2",
  "dependencies": {
    "aws-sdk": "^2.1691.0"
  }
}
' >> package.json

npm install
mkdir nodejs
mv node_modules nodejs
zip -rqm aws-sdk-v2.zip nodejs
rm package.json package-lock.json
