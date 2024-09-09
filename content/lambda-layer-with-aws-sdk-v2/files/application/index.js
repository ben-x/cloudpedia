import AWS from 'aws-sdk';

const s3Client = new AWS.S3({ region: "ca-west-1"});

async function handler (event) {
  console.log('new event', event);
  const bucketName = process.env.S3_BUCKET_NAME

  return new Promise((resolve, reject) => {
    s3Client.getObject({
      Bucket: bucketName,
      Key: 'static-file.pdf'
    }, (err, data) => {
      if (err) {
        console.error(err.message);
        return reject(err);
      }

      if (!data) {
        return reject('No data found');
      }

      const objectData = data.Body.toString('utf-8');
      resolve(objectData);
    });
  });
}

export { handler }
