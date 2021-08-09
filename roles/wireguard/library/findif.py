#!/usr/bin/python3

# Apache License 2.0
# Forked from:
#   - https://github.com/larsks/stackoverflow-example-45659201/commit/a131584a4a77acf2778ff27b9193d6813602a098

from ansible.module_utils.basic import AnsibleModule
import os
import netaddr
import subprocess


def list_interfaces():
    '''
    Get a list of available network interfaces by looking at
    the contents of /sys/class/net.
    '''
    for name in os.listdir('/sys/class/net'):
        path = os.path.join('/sys/class/net', name)
        if not os.path.isdir(path):
            continue
        yield name


def get_addresses_for(name):
    '''
    Call "ip addr show <iface>" for the given interface name, and then
    parse ipv4 addresses out of the result.
    '''
    out = subprocess.check_output(['ip', 'addr', 'show', name])
    addresses = []
    for line in out.splitlines():
        line = line.strip().decode('utf-8').split()
        if line[0] == 'inet':
            addresses.append(line[1].split('/')[0])
    return addresses


def main():
    module = AnsibleModule(argument_spec=dict(address=dict(required=True, type='str')))

    address = module.params['address']

    if not netaddr.valid_ipv4(address):
        module.fail_json(msg='%s is not a valid ip address' % address)

    results = {}
    for iface in list_interfaces():
        for ip in get_addresses_for(iface):
            results[ip] = iface
    try:
        results = results[address]
        mod_changed = True
    except:
        results = None
        mod_changed = False

    module.exit_json(changed=mod_changed,
                     interface=results)


if __name__ == '__main__':
    main()
