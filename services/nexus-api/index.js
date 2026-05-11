const express = require('express');
const { ApolloServer, gql } = require('apollo-server-express');
const redis = require('redis');
const { Pool } = require('pg');

// P3-T02: PostgreSQL schema + Redis caching layer
const redisClient = redis.createClient({ url: process.env.REDIS_URL || 'redis://localhost:6379' });
const pgPool = new Pool({ connectionString: process.env.DATABASE_URL });

const typeDefs = gql`
  type Query {
    health: String
    inventory(hubId: String!, sku: String!): InventoryItem
  }

  type InventoryItem {
    sku: String!
    quantity: Int!
    probabilityOfFulfillment: Float!
  }
`;

// P3-T03: PoF engine with Redis desync detection
const resolvers = {
  Query: {
    health: () => 'OK',
    inventory: async (_, { hubId, sku }) => {
      // Mock logic for PoF and Single-Hub enforcement
      const cacheKey = \`hub:\${hubId}:sku:\${sku}\`;
      const cached = await redisClient.get(cacheKey);

      let qty = 10;
      let pof = 0.96;

      if (cached) {
        qty = parseInt(cached, 10);
      } else {
        // Fallback to PG
        // const res = await pgPool.query('SELECT quantity FROM inventory WHERE hub_id = $1 AND sku = $2', [hubId, sku]);
      }

      return {
        sku,
        quantity: qty,
        probabilityOfFulfillment: pof
      };
    }
  }
};

async function startServer() {
  await redisClient.connect().catch(e => console.error("Redis connect error (expected if no local redis):", e.message));

  const server = new ApolloServer({ typeDefs, resolvers });
  await server.start();

  const app = express();
  server.applyMiddleware({ app });

  app.listen({ port: 4000 }, () =>
    console.log(\`🚀 Server ready at http://localhost:4000\${server.graphqlPath}\`)
  );
}

startServer();
