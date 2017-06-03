# encoding: UTF-8
require "docker_helper"

describe "Operating system" do
  subject do
    os
  end
  it "is Alpine Linux 3.6" do
    expect(subject[:family]).to eq("alpine")
    expect(subject[:release]).to match(/^3\.6\./)
  end
end

describe "Packages" do
  [
    "bash",
    "curl",
    "jq",
    "libressl",
    "lighttpd",
    "lighttpd-mod_auth",
  ].each do |package|
    context package do
      it "is installed" do
        expect(package(package)).to be_installed
      end
    end
  end
end

describe "Docker entrypoint file" do
  context "/docker-entrypoint.sh" do
    it "has set permissions" do
      expect(file("/docker-entrypoint.sh")).to exist
      expect(file("/docker-entrypoint.sh")).to be_executable
    end
  end
  [
    "/docker-entrypoint.d/30-environment-certs.sh",
    "/docker-entrypoint.d/40-server-certs.sh",
  ].each do |file|
    context file do
      it "exists" do
        expect(file(file)).to exist
        expect(file(file)).to be_readable
      end
    end
  end
end
