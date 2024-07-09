import { ElasticLoadBalancingV2Client, DeregisterTargetsCommand } from '@aws-sdk/client-elastic-load-balancing-v2';

const elasticLoadBalancingV2Client = new ElasticLoadBalancingV2Client();

async function deregisterTarget (event) {
  const targetGroupArn = process.env.TARGET_GROUP_ARN;
  const { detail } = event;

  const deregisterTargetsCommand = new DeregisterTargetsCommand({
    TargetGroupArn: targetGroupArn,
    Targets: [{ Id: detail.ipAddress }]
  });

  try {
    await elasticLoadBalancingV2Client.send(deregisterTargetsCommand);
  } catch (error) {
    if (error.name === 'InvalidTargetException') {
      console.error(`Target: ${detail.ipAddress} does not exist.`);
    } else {
      throw error;
    }
  }
}

export { deregisterTarget };
