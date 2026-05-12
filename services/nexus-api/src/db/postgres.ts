import { Pool } from 'pg';

let pgPool: Pool;

export async function initializePostgres() {
  pgPool = new Pool({
    connectionString: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/verve_nexus'
  });

  try {
    // Test connection
    const client = await pgPool.connect();
    client.release();
    console.log('Connected to PostgreSQL');

    // Ensure schema exists (P3-T02 schema)
    await pgPool.query(`
      CREATE TABLE IF NOT EXISTS inventory (
        hub_id VARCHAR(50) NOT NULL,
        sku VARCHAR(100) NOT NULL,
        quantity INTEGER NOT NULL DEFAULT 0,
        last_updated TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
        PRIMARY KEY (hub_id, sku)
      );
    `);
  } catch (err) {
    console.error(`Failed to connect to PostgreSQL: ${err}`);
  }
}

export function getPgPool(): Pool {
  return pgPool;
}
