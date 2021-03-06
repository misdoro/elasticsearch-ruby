# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module XPack
    module API
      module MachineLearning
        module Actions
          # Deletes an existing data frame analytics job.
          #
          # @option arguments [String] :id The ID of the data frame analytics to delete
          # @option arguments [Boolean] :force True if the job should be forcefully deleted
          # @option arguments [Hash] :headers Custom HTTP headers
          #
          # @see https://www.elastic.co/guide/en/elasticsearch/reference/current/delete-dfanalytics.html
          #
          def delete_data_frame_analytics(arguments = {})
            raise ArgumentError, "Required argument 'id' missing" unless arguments[:id]

            headers = arguments.delete(:headers) || {}

            arguments = arguments.clone

            _id = arguments.delete(:id)

            method = Elasticsearch::API::HTTP_DELETE
            path   = "_ml/data_frame/analytics/#{Elasticsearch::API::Utils.__listify(_id)}"
            params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

            body = nil
            perform_request(method, path, params, body, headers).body
          end

          # Register this action with its valid params when the module is loaded.
          #
          # @since 6.2.0
          ParamsRegistry.register(:delete_data_frame_analytics, [
            :force
          ].freeze)
      end
    end
    end
  end
end
