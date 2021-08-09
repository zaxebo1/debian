# Wireguard

Configures Wireguard on the target machine and provisions arbitrary number of clients. This role uses "server" and "client" terminology which does make sense in many-to-one type of setup, but is absent in Wireguard's dictionary where everyone is a "peer".

Role was made for and tested extensively on ipv4 setup. ipv6 is unsupported.


## Logic

1. `wg_server_ip` and `wg_server_subnet` are an optional pair of variables and must be set together.

    If neither is present, target host will act as a transparent gateway. It will route packets between other peers, but won't be directly accessible from a Wireguard subnet.

1. Neither `wg_clients` nor `wg_endpoints` are required and both are completely independent from each other. Former provisions peers that are connecting _to the target host_. Latter is for peers with which target host will attempt to connect. Role can be run:

    1. With both defined, target host will accept connections from `wg_clients` and attempt to connect with `wg_endpoints`.
    1. With only `wg_clients`, target host will act as a VPN-server and route packets from clients within `AllowedIPs` in each `[Peer]` section.
    1. With only `wg_endpoints`, target host will connect to each server defined in all `[Peer]` sections.
    1. If neither is defined, target host can still be provisioned and Wireguard interface can be optionally brought-up, however it won't accept any connections until valid peers are added to its config.

1. In any case, routing and firewall rules are set automatically.

## Requirements

- Ansible ≥2.10
- Python ≥3.7
- `python3-netifaces` and `python3-netaddr`, versions shipped with Debian are preferred.


## Role Variables

| Variable         | Description                                          | Default |
|------------------|------------------------------------------------------|---------|
| wg_autostart     | Autostart WG service?                                | True    |
| wg_clients       | List of clients that will connect to the target host | {}      |
| wg_endpoints     | List of endpoints target host will connect to        | {}      |
| wg_forward       | Forward between clients?                             | False   |
| wg_iface         | Interface name                                       | wg0     |
| wg_overwrite     | Overwrite existing config?                           | False   |
| wg_peerkey       | Server's private key, optional                       | -       |
| wg_port          | Server port                                          | 51820   |
| wg_server_ip     | Server's IP that is exposed to clients, optional     | -       |
| wg_server_subnet | Server's subnet                                      | -       |
| wg_ssh           | Allow incoming tcp/22 from WG subnet?                | False   |
| wg_start         | Start WG at the end of play?                         | True    |
| wg_systemd       | Enable systemd unit on startup?                      | True    |


### wg_clients

Format is as following, `keepalive` is disabled if set to zero.

```yaml
wg_clients:
  - { name: 'MyClient',
      pubkey: '...xxxxxxx=',
      psk: '...xxxxxxx=',
      ip: '1.1.1.1',
      keepalive: '25' }
```


### wg_endpoints

Similar to the `wg_clients`:

```yaml
wg_endpoints:
  - { name: 'MyEndpoint',
      pubkey: '...xxxxxxx=',
      psk: '...xxxxxxx=',
      endpoint: '10.0.0.1:1234',
      keepalive: '25',
      allowedips: '10.0.0.0/24' }
```

Please note that `allowedips` currently supports a single element only.


### wg_server_subnet

Should be in CIDR notation, e.g. `192.168.1.0/24`.


## Dependencies

Tested on the machine that is already provisioned with the [base role](../base/).\
Likely to complain about missing packages if executed against an untouched installation.


## License

Apache-2.0


## Author Information

Andrew Savchenko\
https://savchenko.net
