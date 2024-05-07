#!/bin/bash
# Function to generate certificates
generate_maincert() {
    read -p "What is the name of your new CA authority? " main_name
    nebula-cert ca -name "$main_name" -encrypt -duration 8760h
}

# Function to generate client certificates
generate_clientcert() {
    read -p "What is the client name, reminder you need at least one lighthouse: " client_name
    read -p "What is the IP of the client, sample 10.10.0.1/24: " client_ip
    read -p "what groups should be associated to this client" client_groups
    nebula-cert sign -name "$client_name" -ip "$client_ip" --groups "$client_groups"
}

# Check if CA authority certificates exist
if [ ! -f "ca.crt" ] || [ ! -f "ca.key" ]; then
    echo "CA authority certificates not found."
    generate_maincert
else
    echo "Found ca.cert or ca.key"
    read -p "Would you like to generate a new CA authority? (yes/no) " renew_choice

    if [ "$renew_choice" = "yes" ]; then
        rm -f ca.crt ca.key
        echo "Generating Certificates"
        generate_maincert
    fi
fi

# Loop for generating client certificates
while true; do
    generate_clientcert
    read -p "Want to generate another client? (yes/no): " gen_choice
    if [ "$gen_choice" != "yes" ]; then
        break
    fi
done

echo "We are done"
