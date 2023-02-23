// eslint-disable-next-line @typescript-eslint/no-var-requires
const crypto = require('crypto');
export const ALGORITHM = 'aes-256-cbc';
export const INIT_VECTOR = crypto.randomBytes(16);
export const SECURITY_KEY = crypto.randomBytes(32);
