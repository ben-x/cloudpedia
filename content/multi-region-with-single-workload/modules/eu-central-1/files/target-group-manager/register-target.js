import { ElasticLoadBalancingV2Client, RegisterTargetsCommand } from '@aws-sdk/client-elastic-load-balancing-v2';

const elasticLoadBalancingV2Client = new ElasticLoadBalancingV2Client();

console.log('arns', process.env.TARGET_GROUP_ARNS);

async function registerTarget (event) {
  const targetGroupArns = JSON.parse(process.env.TARGET_GROUP_ARNS);
  const { detail } = event;

  for (const targetGroupArn of targetGroupArns) {
    const registerTargetsCommand = new RegisterTargetsCommand({
      TargetGroupArn: targetGroupArn,
      Targets: [{
        Id: detail.ipAddress,
        Port: detail.port,
        AvailabilityZone: detail.availabilityZone
      }]
    });

    await elasticLoadBalancingV2Client.send(registerTargetsCommand);
  }
}

export { registerTarget };
