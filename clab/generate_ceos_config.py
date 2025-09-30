import random
import yaml
import os
import argparse

# script arguments
parser = argparse.ArgumentParser(description='Generates random MAC addresses for cEOS containers')
parser.add_argument("-r", "--clab_topo", type=str, help="Path to container lab topology file (input)", nargs='*', required=True)
parser.add_argument("-w", "--write_dir", type=str,help="Path to output directory", nargs='*', required=True)
args = parser.parse_args()

# Generates a configuration file for cEOS containers
def write_ceos_config_file(clab_file_path:str, config_dir_path:str):
    if isinstance(clab_file_path,str) and isinstance(config_dir_path,str):
        with open(file=clab_file_path, mode='r', encoding='utf-8') as file:
            clab_topo = yaml.safe_load(file)
        
        if isinstance(clab_topo, dict):
            if 'topology' in clab_topo and 'nodes' in clab_topo['topology']:
                    for node, data in clab_topo['topology']['nodes'].items():
                        node_kind = str()
                        if 'kind' in data:
                            if data['kind'] == 'arista_ceos':
                                node_kind = data['kind']
                        elif 'group' in data:
                            if data['group']:
                                if 'groups' in clab_topo['topology']:
                                    if clab_topo['topology']['groups'][data['group']]['kind'] == 'arista_ceos':
                                        node_kind = clab_topo['topology']['groups'][data['group']]['kind']
                        # generate serial number and mac address for ceos nodes
                        if node_kind == 'arista_ceos':
                            ceos_config = os.path.join(config_dir_path,f'{node}-ceos-config')
                            serial_num = os.path.join(config_dir_path,f'{node}-system_mac_address')
                            mac = generate_random_mac_address()
                            serial = generate_random_serial_number()
                            with open(ceos_config,'w') as file:
                                file.write(f"SERIALNUMBER={serial}")
                            
                            with open(serial_num,'w') as file:
                                file.write(f"{mac}")
                    return 0

def generate_random_serial_number():
    """Generate a random 11 characters alpha numeric serial number.
    """
    # Generate 11 random alpha characters
    alpha = [random.choice('ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789') for _ in range(11)]

    # Format the alpha characters
    serial = ''.join(alpha)
    
    return serial

def generate_random_mac_address():
    """Generate a random MAC address.
    
    Note: The second digit is set to be an even number to create a unicast
    and universally administered MAC address.
    """
    # Generate 11 random hexadecimal digits
    digits = [random.choice('0123456789ABCDEF') for _ in range(11)]
    
    # Add an even hexadecimal digit for the second character
    second_digit = random.choice('02468ACE')
    digits.insert(1, second_digit)

    # Format the digits into a valid MAC address format
    mac_address = ':'.join(''.join(digits[i:i+2]) for i in range(0, 12, 2))
    
    return mac_address

# Generate a random MAC address
random_mac_address = generate_random_mac_address()

if __name__ == "__main__":
    if args.clab_topo and args.write_dir:
        write_ceos_config_file(clab_file_path=args.clab_topo[0], config_dir_path=args.write_dir[0])

