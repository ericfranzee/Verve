import './tracing';
import express from 'express';
import { ApolloServer } from 'apollo-server-express';
import { typeDefs } from './schema/typeDefs';
import { resolvers } from './resolvers';
import { initializeRedis } from './db/redis';
import { initializePostgres } from './db/postgres';

async function startServer() {
  const app = express();

  // Initialize Databases
  await initializeRedis();
  await initializePostgres();

  const server = new ApolloServer({
    typeDefs,
    resolvers,
    context: ({ req }) => {
      // Add context (e.g., auth, db clients)
      return { req };
    }
  });

  await server.start();
  server.applyMiddleware({ app: app as any });

  const PORT = process.env.PORT || 4000;
  app.listen(PORT, () => {
    console.log(`🚀 Nexus API ready at http://localhost:${PORT}${server.graphqlPath}`);
  });
}

startServer().catch(console.error);
