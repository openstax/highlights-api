# OpenStax Highlights API

[![Build Status](https://travis-ci.com/openstax/open-search.svg?branch=master)](https://travis-ci.com/openstax/highlights-api)

The API interface to highlights within OpenStax

## Dependencies

This app creates, updates, and deletes highlights from Postgres

## Configuration

## Setup

```
$> bundle install
```

## Swagger, Clients, and Bindings

The Highlights API is documented in the code using Swagger.  Swagger JSON can be accessed at `/api/v0/swagger`.

### Autogenerating bindings

Within the baseline, we use Swagger-generated Ruby code to serve as bindings for request and response data.  Calling
`rake openstax_swagger:generate_model_bindings[X]` will create version X request and response model bindings in `app/bindings/api/vX`.
See the documentation at https://github.com/openstax/swagger-rails for more information.

### Autogenerating clients

A rake script is provided to generate client libraries.  Call
`rake openstax_swagger:generate_client[X,lang]` to generate the major version X client for the given language, e.g.
`rake openstax_swagger:generate_client[0,ruby]` will generate the Ruby client for the latest version 0 API.  This
will generate code in the baseline, so if you don't want it committed move it elsewhere.

### Generating files with the Swagger JSON

Run `rake write_swagger_json` to write Swagger JSON files to `tmp/swagger` for each major API version.

## Tests

Run the tests with `rspec` or `rake`.

## to back up the database manually
open an ssh tunnel to the rds instance through the dmz and an api server
```
ssh -L 5432:localhost:9999 -t yourbastionuser@bastion2.cnx.org sudo -u rundeck ssh -L 9999:rds-dns-goes-here:5432 ubuntu@api-ec2-isntance-dns-or-ip -i ~rundeck/.ssh/openstax-sandbox-kp.pem
```
then do pg_dump
```
pg_dump -h localhost -U highlights -O highlights > highlights.sql
```

then close your ssh tunnel and open a new one to your target environment (same command, different hosts)

then restore 
```
psql -h localhost -U highlights -f highlights.sql 
```

## Contributing

See [CONTRIBUTING.md](./CONTRIBUTING.md)
