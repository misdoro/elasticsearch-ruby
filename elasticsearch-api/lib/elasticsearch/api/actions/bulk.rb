# Licensed to Elasticsearch B.V under one or more agreements.
# Elasticsearch B.V licenses this file to you under the Apache 2.0 License.
# See the LICENSE file in the project root for more information

module Elasticsearch
  module API
    module Actions
      # Allows to perform multiple index/update/delete operations in a single request.
      #
      # @option arguments [String] :index Default index for items which don't provide one
      # @option arguments [String] :type Default document type for items which don't provide one
      # @option arguments [String] :wait_for_active_shards Sets the number of shard copies that must be active before proceeding with the bulk operation. Defaults to 1, meaning the primary shard only. Set to `all` for all shard copies, otherwise set to any non-negative value less than or equal to the total number of copies for the shard (number of replicas + 1)
      # @option arguments [String] :refresh If `true` then refresh the affected shards to make this operation visible to search, if `wait_for` then wait for a refresh to make this operation visible to search, if `false` (the default) then do nothing with refreshes.
      #   (options: true,false,wait_for)

      # @option arguments [String] :routing Specific routing value
      # @option arguments [Time] :timeout Explicit operation timeout
      # @option arguments [String] :type Default document type for items which don't provide one
      # @option arguments [List] :_source True or false to return the _source field or not, or default list of fields to return, can be overridden on each sub-request
      # @option arguments [List] :_source_excludes Default list of fields to exclude from the returned _source field, can be overridden on each sub-request
      # @option arguments [List] :_source_includes Default list of fields to extract and return from the _source field, can be overridden on each sub-request
      # @option arguments [String] :pipeline The pipeline id to preprocess incoming documents with
      # @option arguments [Hash] :headers Custom HTTP headers
      # @option arguments [Hash] :body The operation definition and data (action-data pairs), separated by newlines (*Required*)
      #
      # @see https://www.elastic.co/guide/en/elasticsearch/reference/master/docs-bulk.html
      #
      def bulk(arguments = {})
        raise ArgumentError, "Required argument 'body' missing" unless arguments[:body]

        headers = arguments.delete(:headers) || {}

        arguments = arguments.clone

        _index = arguments.delete(:index)

        _type = arguments.delete(:type)

        method = Elasticsearch::API::HTTP_POST
        path   = if _index && _type
                   "#{Utils.__listify(_index)}/#{Utils.__listify(_type)}/_bulk"
                 elsif _index
                   "#{Utils.__listify(_index)}/_bulk"
                 else
                   "_bulk"
  end
        params = Utils.__validate_and_extract_params arguments, ParamsRegistry.get(__method__)

        body = arguments[:body]
        if body.is_a? Array
          payload = Elasticsearch::API::Utils.__bulkify(body)
        else
          payload = body
      end

        headers.merge!("Content-Type" => "application/x-ndjson")
        perform_request(method, path, params, payload, headers).body
      end

      # Register this action with its valid params when the module is loaded.
      #
      # @since 6.2.0
      ParamsRegistry.register(:bulk, [
        :wait_for_active_shards,
        :refresh,
        :routing,
        :timeout,
        :type,
        :_source,
        :_source_excludes,
        :_source_includes,
        :pipeline
      ].freeze)
    end
    end
end
