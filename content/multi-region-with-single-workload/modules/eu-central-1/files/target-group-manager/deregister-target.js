import { ElasticLoadBalancingV2Client, DeregisterTargetsCommand } from '@aws-sdk/client-elastic-load-balancing-v2';

const elasticLoadBalancingV2Client = new ElasticLoadBalancingV2Client();

async function deregisterTarget (event) {
  const targetGroupArns = JSON.parse(process.env.TARGET_GROUP_ARNS);
  const { detail } = event;

  for (const targetGroupArn of targetGroupArns) {
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
        console.error(`Unable to detach ${detail.ipAddress} from target groups`)
        throw error;
      }
    }
  }
}

export { deregisterTarget };
