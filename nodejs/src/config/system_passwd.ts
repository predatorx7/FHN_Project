import { v4 as uuidv4 } from 'uuid';

/// System worker uses this value to authenticate with this server.
/// Therefore, right now we can only run worker on the same server process.
export const _SYSTEM_PASSWORD = uuidv4();
