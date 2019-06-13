class Taller1Schema < GraphQL::Schema
  mutation(Types::MutationType)
  query(Types::QueryType)
end
