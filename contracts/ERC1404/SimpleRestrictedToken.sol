pragma solidity ^0.5.15;
import "./ERC1404.sol";

/// @title Extendable reference implementation for the ERC-1404 token
/// @dev Inherit from this contract to implement your own ERC-1404 token
contract SimpleRestrictedToken is ERC1404 {
    uint8 public constant SUCCESS_CODE = 0;
    string public constant SUCCESS_MESSAGE = "SUCCESS";

    modifier notRestricted (address from, address to, uint256 value) {
        uint8 restrictionCode = detectTransferRestriction(from, to, value);
        require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
        _;
    }
    
    function detectTransferRestriction (address /* from */, address /* to */, uint256 /* value */)
        public
        view
        returns (uint8 restrictionCode)
    {
        restrictionCode = SUCCESS_CODE;
    }
        
    function messageForTransferRestriction (uint8 restrictionCode)
        public
        view
        returns (string memory message)
    {
        if (restrictionCode == SUCCESS_CODE) {
            message = SUCCESS_MESSAGE;
        }
    }
    
    function transfer (address to, uint256 value)
        public
        notRestricted(msg.sender, to, value)
        returns (bool success)
    {
        success = super.transfer(to, value);
    }

    function transferBatch (address[] memory destinations, uint256[] memory values)
        public
    {
        require(destinations.length == values.length);

        for (uint i = 0; i < destinations.length; i++) {
            address to = destinations[i];
            uint256 value = values[i];
            uint8 restrictionCode = detectTransferRestriction(msg.sender, to, value);
            require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
            super.transfer(to, value);
        }
    }

    function transferFrom (address from, address to, uint256 value)
        public
        notRestricted(from, to, value)
        returns (bool success)
    {
        success = super.transferFrom(from, to, value);
    }

    function transferFromBatch (address from, address[] memory destinations, uint256[] memory values)
        public
    {
        require(destinations.length == values.length);

        for (uint i = 0; i < destinations.length; i++) {
            address to = destinations[i];
            uint256 value = values[i];
            uint8 restrictionCode = detectTransferRestriction(from, to, value);
            require(restrictionCode == SUCCESS_CODE, messageForTransferRestriction(restrictionCode));
            super.transferFrom(from, to, value);
        }
    }
}
