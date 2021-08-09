# nginx

Configures [nginx](https://tracker.debian.org/pkg/nginx) on the target host. The purpose of this role is not to expose every single parameter to Ansible, but to provision hosts efficiently and consistently. Edit included Jinja templates if you must.


## Requirements

Ansible ≥2.10


## Role Variables

| Variable            | Description                    | Default     |
|---------------------|--------------------------------|-------------|
| ngx_cert_email      | E-mail to use for LetsEncrypt. | ''          |
| ngx_endpoints       | Lists of domains to provision. | []          |
| ngx_flavour         | `full` or `light` package?     | extras      |
| ngx_provision_https | Request & install HTTPS certs? | True        |
| ngx_resolver        | Resolver to use for stapling.  | '127.0.0.1' |


## Dependencies

Tested on a remote that is already provisioned with the [base role](../base/).


## License

Apache-2.0


## Author Information
Andrew Savchenko\
https://savchenko.net
