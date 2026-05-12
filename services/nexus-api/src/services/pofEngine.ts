import { getRedisClient } from '../db/redis';
import { getPgPool } from '../db/postgres';

interface PoFResult {
  sku: string;
  quantity: number;
  probabilityOfFulfillment: number;
}

export async function calculatePoF(hubId: string, sku: string): Promise<PoFResult> {
  const redis = getRedisClient();
  const pg = getPgPool();

  let redisQty = 0;
  let pgQty = 0;

  if (redis) {
    const cached = await redis.get(`hub:${hubId}:sku:${sku}`);
    if (cached) redisQty = parseInt(cached, 10);
  }

  try {
    const res = await pg.query('SELECT quantity FROM inventory WHERE hub_id = $1 AND sku = $2', [hubId, sku]);
    if (res.rows.length > 0) {
      pgQty = res.rows[0].quantity;
    }
  } catch (err) {
    console.error("DB Query error", err);
  }

  // Use redis as primary if available, otherwise DB
  let actualQty = redis ? redisQty : pgQty;

  // Drift calculation
  let drift = 0;
  if (redisQty !== pgQty && pgQty > 0) {
    drift = Math.abs(redisQty - pgQty) / pgQty;
  }

  // Base PoF logic
  let pof = 0.98;
  if (actualQty <= 0) pof = 0.0;
  else if (actualQty < 5) pof = 0.85;

  // Desync capping (P3-T03 requirement)
  if (drift > 0.15) {
    pof = Math.min(pof, 0.80);
    console.warn(`[Desync Detected] Hub ${hubId} SKU ${sku} Drift ${drift}. Capping PoF to ${pof}.`);
  }

  return {
    sku,
    quantity: actualQty,
    probabilityOfFulfillment: pof
  };
}
