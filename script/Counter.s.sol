// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "forge-std/Script.sol";
import "../src/AvatarCollection.sol";
import "../src/CrossProtocolNFTMapping.sol"

contract DeployAvatarCollection is Script {
    function run() external {
        vm.startBroadcast();
        
        CrossProtocolNFTMapping mapper = new CrossProtocolNFTMapping();
        AvatarCollection avatar = new AvatarCollection("AVAZON", "AVA", 0x17FE961Ba4A15EB9B69b5a46E08789D27BA5ea30);
        
        vm.stopBroadcast();
    }
}
