#!/usr/bin/env ts-node

import { Client } from 'pg';

async function seedDatabase() {
  const connectionString = process.env.DATABASE_URL || 'postgres://verve:verve@localhost:5432/nexus';
  const client = new Client({ connectionString });

  try {
    await client.connect();
    console.log('[Seed] Connected to Nexus PostgreSQL DB.');

    // Ensure table exists for testing script
    await client.query(`
      CREATE TABLE IF NOT EXISTS orders (
        id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
        user_id UUID NOT NULL,
        status VARCHAR(50) NOT NULL,
        total_amount DECIMAL(10, 2) NOT NULL,
        created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
      );
    `);
    console.log('[Seed] Database schema verified.');

    console.log('[Seed] Generating 50 closed-beta provisioning events...');
    
    let successStates = 0;
    let edgeCases = 0;

    for (let i = 0; i < 50; i++) {
      // Generate diverse data
      const userId = `a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a1${Math.floor(Math.random() * 10)}`;
      const amount = (Math.random() * 15000 + 1000).toFixed(2);
      
      // Simulate success vs edge cases (80% success rate)
      const isSuccess = Math.random() < 0.8;
      const status = isSuccess ? 'DELIVERED' : (Math.random() > 0.5 ? 'CANCELLED_GRIDLOCK' : 'RETURNED_COLD_HOLD');

      if (isSuccess) successStates++;
      else edgeCases++;

      await client.query(`
        INSERT INTO orders (user_id, status, total_amount) 
        VALUES ($1, $2, $3)
      `, [userId, status, amount]);
    }

    console.log(`[Seed] Successfully seeded 50 orders.`);
    console.log(`[Seed] Summary: ${successStates} successful deliveries, ${edgeCases} edge case events.`);

  } catch (error) {
    console.error('[Seed] Error seeding database:', error);
  } finally {
    await client.end();
    console.log('[Seed] Database connection closed.');
  }
}

seedDatabase();
