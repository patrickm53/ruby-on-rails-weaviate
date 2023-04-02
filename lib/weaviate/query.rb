# frozen_string_literal: true

module Weaviate
  class Query < Base
    def get(
      class_name:,
      fields:,
      after: nil,
      limit: nil,
      offset: nil,
      sort: nil,
      where: nil,
      near_text: nil,
      near_vector: nil,
      near_object: nil
    )
      response = client.graphql.execute(
        get_query(
          class_name: class_name,
          fields: fields,
          sort: sort,
          where: where,
          near_text: near_text,
          near_vector: near_vector,
          near_object: near_object
        ),
        after: after,
        limit: limit,
        offset: offset
      )
      response.data.get.send(class_name.downcase)
    rescue Graphlient::Errors::ExecutionError => error
      raise Weaviate::Error.new(error.response.data.get.errors.messages.to_h)
    end

    def aggs(
      class_name:,
      fields: nil,
      object_limit: nil,
      near_text: nil,
      near_vector: nil,
      near_object: nil,
      group_by: nil
    )
      response = client.graphql.execute(
        aggs_query(
          class_name: class_name,
          fields: fields,
          near_text: near_text,
          near_vector: near_vector,
          near_object: near_object
        ),
        group_by: group_by,
        object_limit: object_limit
      )
      response.data.aggregate.send(class_name.downcase)
    rescue Graphlient::Errors::ExecutionError => error
      raise Weaviate::Error.new(error.response.data.aggregate.errors.messages.to_h)
    end

    private

    def get_query(
      class_name:,
      fields:,
      where: nil,
      near_text: nil,
      near_vector: nil,
      near_object: nil,
      sort: nil
    )
      client.graphql.parse <<~GRAPHQL
        query(
          $after: String,
          $limit: Int,
          $offset: Int,
        ) {
          Get {
            #{class_name}(
              after: $after,
              limit: $limit,
              offset: $offset,
              #{near_text.present? ? "nearText: #{near_text}" : ""},
              #{near_vector.present? ? "nearVector: #{near_vector}" : ""},
              #{near_object.present? ? "nearObject: #{near_object}" : ""},
              #{where.present? ? "where: #{where}" : ""},
              #{sort.present? ? "sort: #{sort}" : ""}
            ) {
              #{fields}
            }
          }
        }
      GRAPHQL
    end

    def aggs_query(
      class_name:,
      fields:,
      near_text: nil,
      near_vector: nil,
      near_object: nil
    )
      client.graphql.parse <<~GRAPHQL
        query(
          $group_by: [String],
          $object_limit: Int,
        ) {
          Aggregate {
            #{class_name}(
              objectLimit: $object_limit,
              groupBy: $group_by,
              #{near_text.present? ? "nearText: #{near_text}" : ""},
              #{near_vector.present? ? "nearVector: #{near_vector}" : ""},
              #{near_object.present? ? "nearObject: #{near_object}" : ""}
            ) {
              #{fields}
            }
          }
        }
      GRAPHQL
    end
  end
end
