import { getInstanceIpAddress, publishEvent, completeLifecycleAction, sleep } from './utils.js';

async function handleInstanceTermination(event) {
  const { detail } = event;

  if(!detail.EC2InstanceId) {
    throw new Error('Details contains no instance ID');
  }

  const ipAddress = await getInstanceIpAddress(detail.EC2InstanceId);

  await publishEvent('INSTANCE_IS_TERMINATING', {
    instanceId: detail.EC2InstanceId,
    ipAddress
  });

  // An additional delay of 10 seconds is added to give enough time for the event to propagate.
  const delay = (process.env.DEREGISTRATION_DELAY_SECONDS + 10) * 1000;
  await sleep(delay);

  await completeLifecycleAction({
    asgName: detail.AutoScalingGroupName,
    instanceId: detail.EC2InstanceId,
    lifecycleHookName: detail.LifecycleHookName,
    lifecycleActionToken: detail.LifecycleActionToken
  });
}

export { handleInstanceTermination };
