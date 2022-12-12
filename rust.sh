#!/bin/bash
echo "installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
echo ".  '/home/$username/.cargo/env'" >> "/home/$username/.profile" || exit
source "/home/$username/.profile" || exit
