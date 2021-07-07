# opa_api : opa need to be run as server using
# opa run --server command and it need as policy file to be loaded using same command
# `opa run --server ./example.rego`
# curl localhost:8181/v1/data/example/allow -d @v1-data-input.json -H 'Content-Type: application/json'

# two parameters needs to be there
# api url
# data-binary ( this accepts input.json )
# curl -X POST localhost:8181/v1/data/example/violation -d @v1-data-input.json -H 'Content-Type: application/json'
# curl -X POST localhost:8181/v1/data/example/allow -d @v1-data-input.json -H 'Content-Type: application/json'

require "inspec/resources/opa"

module Inspec::Resources
  class OpaApi < Opa
    name "opa_api"
    supports platform: "unix"
    supports platform: "windows"

    attr_reader :allow

    def initialize(opts={})
      @url = opts[:url]
      @data = opts[:data]
      fail_resource "policy and data are the mandatory for executing OPA." if @url.nil? && @data.nil?
      @content = load_result
      super(@content)
    end

    def allow
      @content["result"]
    end

    def to_s
      "OPA api"
    end

    private

    def load_result
      raise Inspec::Exceptions::ResourceFailed, "#{resource_exception_message}" if resource_failed?

      result = inspec.command("curl -X POST #{@url} -d @#{@data} -H 'Content-Type: application/json'")
      if result.exit_status == 0
        result.stdout.gsub("\n", "")
      else
        error = result.stdout + "\n" + result.stderr
        raise Inspec::Exceptions::ResourceFailed, "Error while executing OPA query: #{error}"
      end
    end
  end
end
