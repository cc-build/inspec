+++
title = "mongodb_session resource"
draft = false
gh_repo = "inspec"
platform = "os"

[menu]
  [menu.inspec]
    title = "mongodb_session"
    identifier = "inspec/resources/os/mongodb_session.md mongodb_session resource"
    parent = "inspec/resources/os"
+++

Use the `mongodb_session` Chef InSpec audit resource to run MongoDB command run against MongoDB Database.

## Availability

### Installation

This resource is distributed along with Chef InSpec itself. You can use it automatically.

## Syntax

A `mongodb_session` resource block declares the user, password and the command to be run.

  describe mongodb_session(user: "username", password: "password", command: {}) do
    its("params") { should match(/expected-result/) }
  end

where

- `mongodb_session` declares a user and password, connecting locally, with permission to run the query
- `command` contains the query to be run
- `its("params") { should eq(/expected-result/) }` compares the results of the query against the expected result in the test

### Optional Parameters

`mongodb_session` InSpec resource accepts `user`, `password`, `host`, `port`, `auth_source`, `auth_mech`, `ssl`, `ssl_cert`, `ssl_ca_cert`, `auth_mech_properties`.

In Particular:

#### `database`

Defaults to 'admin'

#### `host`

Defaults to `127.0.0.1`

#### `port`

Defaults to `27017`

#### `auth_mech`

Defaults to `:scram`

#### `auth_source`

Defaults to given database name.

### MongodDB query reference docs

This resource is using mongo ruby driver to fetch the data.
[MongoDB Ruby Driver authentication](https://docs.mongodb.com/ruby-driver/master/tutorials/ruby-driver-authentication/)

## Examples

The following examples show how to use this Chef InSpec audit resource.

### Test the roles information using rolesInfo command of MongoDB

    describe mongodb_session(user: "foo", password: "bar", command: { rolesInfo: "dbAdmin" }).params["roles"].first do
      its(["role"]) { should eq "dbAdmin" }
    end

### Test the port on which MongoDB listens

    describe mongodb_session(user: "foo", password: "bar", command: { usersInfo: "ian" }).params["users"].first["roles"].first do
      its(["role"]) { should eq "readWrite" }
    end


## Matchers

For a full list of available matchers, please visit our [matchers page](/inspec/matchers/).

### params

The `params` contains all the query data.
