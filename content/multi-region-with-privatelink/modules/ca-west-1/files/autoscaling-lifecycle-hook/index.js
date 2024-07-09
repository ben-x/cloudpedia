import { handleInstanceLaunch } from './handle-instance-launch.js';
import { handleInstanceTermination } from './handle-instance-termination.js';

async function handler (event) {
  console.log(`new event`, event);

  if (event['detail-type'] === 'EC2 Instance-launch Lifecycle Action') {
    await handleInstanceLaunch(event);
  } else if (event['detail-type'] === 'EC2 Instance-terminate Lifecycle Action') {
    await handleInstanceTermination(event);
  } else {
    throw new Error('Event not recognized!');
  }
}

export { handler }
