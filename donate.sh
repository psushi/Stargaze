#!/bin/bash
source .env;
export fUSDCx=0xaA1EA30cEe569fA70B8561c0F52F10Da249Aecb5;
export fUSDC=0xa794c9ee519fd31bbce643e8d8138f735e97d1db;
export user=0xD0074F4E6490ae3f888d1d4f7E3E43326bD3f0f5;
export stargazer_contract=0x2084DC12810Ad13e7606f5248EC5E05a390A8Dfd;


echo "Donating to the Foundry opensource project...";
echo "Converting 20 USDC to USDCx ✅";
cast send $fUSDC "approve(address,uint256)" $fUSDCx $(cast --to-wei 20) --rpc-url $optimism_rpc --private-key $alice_pk > output.txt; 
cast send $fUSDCx "upgrade(uint256)" $(cast --to-wei 20) --rpc-url $optimism_rpc --private-key $alice_pk > output.txt;
echo "Successfully wrapped USDC to USDCx ✅ ";
echo "SuperFluid funtionality enabled ✅"
echo "Current USDCx balance of user: $(cast call $fUSDCx "balanceOf(address)(uint256)" $user --rpc-url $optimism_rpc)" 
cast send $fUSDCx "approve(address,uint256)" $stargazer_contract $(cast --to-wei 20) --rpc-url $optimism_rpc --private-key $alice_pk > output.txt; 
cast send $stargazer_contract "donate(string,uint256)" "foundry" $(cast --to-wei 20) --rpc-url $optimism_rpc --private-key $alice_pk > output.txt;
echo "Donated 20 USDC to the Foundry opensource project, thank you! 💜";