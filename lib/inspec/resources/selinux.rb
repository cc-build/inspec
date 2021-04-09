require "inspec/resources/command"

module Inspec::Resources
  class Selinux < Inspec.resource(1)
    name "selinux"

    supports platform: "unix"

    desc "Use selinux Inspec resource to test state/mode of the selinux policy."

    example <<~EXAMPLE
      describe selinux do
        it { should be_disabled }
        it { should be_permissive }
        it { should be_enabled }
      end
    EXAMPLE

    def initialize(selinux_path = "/etc/selinux/config")
      return skip_resource "The 'selinux' resource does not support Windows." if inspec.os.windows?

      @path = selinux_path
      cmd = inspec.command("sestatus")
      if cmd.exit_status != 0
        return skip_resource "#{cmd.stdout}"
      end
      result = cmd.stdout.delete(" ").gsub(/\n/, ",").gsub(/\r/,"").downcase
      @data = Hash[result.scan /([^:]+):([^,]+)[,$]/]
    end

    def installed?
      inspec.file(@path).exist?
    end

    def disabled?
      @data["selinuxstatus"] == 'disabled'
    end

    def enabled?
      @data["selinuxstatus"] == 'enabled'
    end

    def enforcing?
      @data["currentmode"] == 'enforcing'
    end

    def permissive?
      @data["currentmode"] == 'permissive'
    end

    def to_s
      "SELinux"
    end
  end
end