import { EC2Client, DescribeInstancesCommand } from '@aws-sdk/client-ec2';
import { CloudWatchEventsClient, PutEventsCommand } from '@aws-sdk/client-cloudwatch-events';
import { AutoScalingClient, CompleteLifecycleActionCommand } from '@aws-sdk/client-auto-scaling';

const client = new EC2Client();
const autoScalingClient = new AutoScalingClient();

export async function getInstanceIpAddress(instanceId) {
  const describeInstancesCommand = new DescribeInstancesCommand({
    InstanceIds: [instanceId]
  });

  const response = await client.send(describeInstancesCommand);
  const instance = response.Reservations[0].Instances[0];

  return instance.PrivateIpAddress;
}

export async function publishEvent(type, data) {
  const eventsClient = new CloudWatchEventsClient({ region: process.env.TARGET_EVENT_BUS_REGION });

  const putEventsCommand = new PutEventsCommand({
    Entries: [{
      DetailType: type,
      Detail: JSON.stringify(data),
      EventBusName: process.env.TARGET_EVENT_BUS_ARN,
      Source: 'cloudpedia'
    }]
  })

  const { FailedEntryCount } = await eventsClient.send(putEventsCommand);

  if (FailedEntryCount > 0) {
    console.error(`Failed to publish ${type} event`, data);
    throw new Error('Failed to publish event');
  }
}

export async function
completeLifecycleAction({asgName, instanceId, lifecycleHookName, lifecycleActionToken}) {
  const completeLifecycleActionCommand = new CompleteLifecycleActionCommand({
    AutoScalingGroupName: asgName,
    InstanceId: instanceId,
    LifecycleHookName: lifecycleHookName,
    LifecycleActionResult: 'CONTINUE',
    LifecycleActionToken: lifecycleActionToken
  });

  await autoScalingClient.send(completeLifecycleActionCommand);
}

export async function sleep(ms) {
  return new Promise((resolve) => setTimeout(resolve, ms));
}
