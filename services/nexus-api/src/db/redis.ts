import { createClient, RedisClientType } from 'redis';

let redisClient: RedisClientType | null = null;

export async function initializeRedis() {
  const url = process.env.REDIS_URL || 'redis://localhost:6379';
  redisClient = createClient({ url });

  redisClient.on('error', (err) => console.log('Redis Client Error', err));

  try {
    await redisClient.connect();
    console.log(`Connected to Redis at ${url}`);
  } catch (err) {
    console.error(`Failed to connect to Redis (continuing without cache for dev): ${err}`);
  }
}

export function getRedisClient(): RedisClientType | null {
  return redisClient?.isOpen ? redisClient : null;
}
