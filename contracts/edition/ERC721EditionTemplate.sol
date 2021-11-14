// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

/// @title: 
/// @author: manifold.xyz

import "@openzeppelin/contracts/proxy/Proxy.sol";
import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/utils/StorageSlot.sol";

contract ERC721EditionTemplate is Proxy {
    
    constructor(address editionImplementation, address creator) payable {
        assert(_IMPLEMENTATION_SLOT == bytes32(uint256(keccak256("eip1967.proxy.implementation")) - 1));

        StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value = editionImplementation;

        // Insert your uri data here
        string[] memory uriParts = new string[](10);
        uriParts[0] = 'data:application/json;utf8,{"name":"Template Edition #';
        uriParts[1] = '<EDITION>';
        uriParts[2] = '/';
        uriParts[3] = '<TOTAL>';
        uriParts[4] = ', "description":"Template Description",';
        uriParts[5] = '"attributes":[{"display_type":"number","trait_type":"Edition","value":';
        uriParts[6] = '<EDITION>';
        uriParts[7] = ',"max_value":';
        uriParts[8] = '<TOTAL>';
        uriParts[9] = '}]}';

        Address.functionDelegateCall(
            editionImplementation,
            abi.encodeWithSignature("initialize(address,string[])", creator, uriParts)
        );
    }
        
    /**
     * @dev Storage slot with the address of the current implementation.
     * This is the keccak-256 hash of "eip1967.proxy.implementation" subtracted by 1, and is
     * validated in the constructor.
     */
    bytes32 internal constant _IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * @dev Returns the current implementation address.
     */
     function implementation() public view returns (address) {
        return _implementation();
    }

    function _implementation() internal override view returns (address) {
        return StorageSlot.getAddressSlot(_IMPLEMENTATION_SLOT).value;
    }    

}