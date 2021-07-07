require "inspec/resources/opa"

module Inspec::Resources
  class OpaCli < Opa
    name "opa_cli"
    supports platform: "unix"
    supports platform: "windows"

    # 1 Query: should we name them as policy_file adn data_file instead of @policy and @data?
    attr_reader :allow

    def initialize(opts = {})
      @policy = opts[:policy] || nil
      @data = opts[:data] || nil
      @query = opts[:query] || nil
      fail_resource "policy and data are the mandatory for executing OPA." if @policy.nil? && @data.nil?
      @content = load_result
      super(@content)
    end

    # 2 Note to discuss with Clinton we can't have something like allow and deny defined as properties as User
    # can use any variable

    # 5 if we have to support property allow then we have to check verify that the allow is used in the policy file

    # 3 opa command executes as ./opa. We need to make the standardise code so that it will work for any system

    # solution: add the path in the PATH varaible for both Windows and Linux


    # 4 opa command expects the policy file and the data should be present on the system on which opa is running


    def allow
      @content["result"][0]["expressions"][0]["value"] if @content["result"][0]["expressions"][0]["text"].include?("allow")
    end

    def to_s
      "OPA cli"
    end

    private

    def load_result
      raise Inspec::Exceptions::ResourceFailed, "#{resource_exception_message}" if resource_failed?

      result = inspec.command("opa eval -i '#{@data}' -d '#{@policy}' '#{@query}'")
      if result.exit_status == 0
        result.stdout.gsub("\n", "")
      else
        error = result.stdout + "\n" + result.stderr
        raise Inspec::Exceptions::ResourceFailed, "Error while executing OPA query: #{error}"
      end
    end
  end
end
