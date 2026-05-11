import { gql } from 'apollo-server-express';

export const typeDefs = gql`
  type Query {
    health: String!
    verifyInventory(hubId: String!, skus: [String!]!): FulfillmentVerification!
  }

  type Mutation {
    processPayment(userId: String!, amount: Float!): PaymentResponse!
  }

  type FulfillmentVerification {
    isFulfillable: Boolean!
    hubId: String!
    overallPoF: Float!
    items: [InventoryItem!]!
    errors: [String!]
  }

  type InventoryItem {
    sku: String!
    quantity: Int!
    probabilityOfFulfillment: Float!
  }

  type PaymentResponse {
    success: Boolean!
    transactionId: String
    method: String!
  }
`;
