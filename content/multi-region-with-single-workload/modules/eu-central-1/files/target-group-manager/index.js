import { registerTarget } from './register-target.js';
import { deregisterTarget } from './deregister-target.js';

async function handler (event) {
  console.log(`new event`, event);

  if (event['detail-type'] === 'INSTANCE_IS_LAUNCHING') {
    await registerTarget(event);
  } else if (event['detail-type'] === 'INSTANCE_IS_TERMINATING') {
    await deregisterTarget(event);
  } else {
    throw new Error('Event not recognized!');
  }
}

export { handler };
