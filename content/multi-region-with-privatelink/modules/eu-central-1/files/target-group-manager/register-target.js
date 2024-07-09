import { ElasticLoadBalancingV2Client, RegisterTargetsCommand } from '@aws-sdk/client-elastic-load-balancing-v2';

const elasticLoadBalancingV2Client = new ElasticLoadBalancingV2Client();

async function registerTarget (event) {
  const targetGroupArn = process.env.TARGET_GROUP_ARN;
  const { detail } = event;

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

export { registerTarget };
