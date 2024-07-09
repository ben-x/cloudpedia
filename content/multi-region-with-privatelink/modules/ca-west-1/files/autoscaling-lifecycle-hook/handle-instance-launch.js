import { getInstanceIpAddress, publishEvent, completeLifecycleAction } from './utils.js';

async function handleInstanceLaunch(event) {
  const port = process.env.APP_PORT;
  const availabilityZone = process.env.AVAILABILITY_ZONE || 'all';
  const { detail } = event;

  if(!detail.EC2InstanceId) {
    throw new Error('Details contains no instance ID');
  }

  const ipAddress = await getInstanceIpAddress(detail.EC2InstanceId);

  await publishEvent('INSTANCE_IS_LAUNCHING', {
    instanceId: detail.EC2InstanceId,
    ipAddress,
    port,
    availabilityZone
  });

  await completeLifecycleAction({
    asgName: detail.AutoScalingGroupName,
    instanceId: detail.EC2InstanceId,
    lifecycleHookName: detail.LifecycleHookName,
    lifecycleActionToken: detail.LifecycleActionToken
  });
}

export { handleInstanceLaunch };
