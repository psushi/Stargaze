#!/bin/bash

# A small script to make a donation to your favorite opensource project using stargazer.

# adding $optimism_rpc and $private_key env variables.
source .env;

# addresses of the contract's used. fUSDC and fUSDCx are the testnet versions of USDC and USDCx 
# used by SuperFluid for testing purposes.  
export fUSDCx=0xaA1EA30cEe569fA70B8561c0F52F10Da249Aecb5;
export fUSDC=0xa794c9ee519fd31bbce643e8d8138f735e97d1db;

# Address corresponding to the private_key (your wallet address)
export user=0xD0074F4E6490ae3f888d1d4f7E3E43326bD3f0f5;

# Address of the stargazer contract.
export stargazer_contract=0x$284DC12810Ad13e7606f5248EC5E05a390A8Dfd;


echo "Donating to the $1 opensource project...";

echo "Getting some testnet USDC 💵";
cast send $fUSDC "mint(address,uint256)" $user $(cast --to-wei $2) --private-key $private_key --rpc-url $optimism_rpc > /dev/null;
echo "Current USDC balance of user: $(cast call $fUSDC "balanceOf(address)(uint256)" $user --rpc-url $optimism_rpc | cast --from-wei)";

echo "Converting $2 USDC to USDCx ✅";

# Contract interactions to convert fUSDC to fUSDCx
cast send $fUSDC "approve(address,uint256)" $fUSDCx $(cast --to-wei $2) --rpc-url $optimism_rpc --private-key $private_key > /dev/null; 
cast send $fUSDCx "upgrade(uint256)" $(cast --to-wei $2) --rpc-url $optimism_rpc --private-key $private_key > /dev/null;

echo "Successfully wrapped USDC to USDCx ✅ ";
echo "SuperFluid funtionality enabled ✅"
echo "Current USDCx balance of user: $(cast call $fUSDCx "balanceOf(address)(uint256)" $user --rpc-url $optimism_rpc | cast --from-wei)" 


# Donating fUSDCx that will be instantly distributed to all contributors! 
cast send $fUSDCx "approve(address,uint256)" $stargazer_contract $(cast --to-wei $2) --rpc-url $optimism_rpc --private-key $private_key > /dev/null; 
cast send $stargazer_contract "donate(string,uint256)" $1 $(cast --to-wei $2) --rpc-url $optimism_rpc --private-key $private_key > /dev/null;
echo "Distributing $2 USDC to all contributors of $1 open-source repository! Thank you! 💜";