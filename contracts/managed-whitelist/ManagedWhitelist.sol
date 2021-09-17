pragma solidity ^0.5.15;
import "../ownership/Managed.sol";

contract ManagedWhitelist is Managed {
    mapping (address => bool) public sendAllowed;
    mapping (address => bool) public receiveAllowed;

    modifier onlySendAllowed {
        require(sendAllowed[msg.sender], "Sender is not whitelisted");
        _;
    }

    modifier onlyReceiveAllowed {
        require(receiveAllowed[msg.sender], "Recipient is not whitelisted");
        _;
    }

    function addToSendAllowed (address operator) public onlyManagerOrOwner {
        sendAllowed[operator] = true;
    }

    function addToSendAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            sendAllowed[operator[i]] = true;
        }
    }

    function addToReceiveAllowed (address operator) public onlyManagerOrOwner {
        receiveAllowed[operator] = true;
    }

    function addToReceiveAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            receiveAllowed[operator[i]] = true;
        }
    }

    function addToBothSendAndReceiveAllowed (address operator) public onlyManagerOrOwner {
        addToSendAllowed(operator);
        addToReceiveAllowed(operator);
    }

    function addToBothSendAndReceiveAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            sendAllowed[operator[i]] = true;
            receiveAllowed[operator[i]] = true;
        }
    }

    function removeFromSendAllowed (address operator) public onlyManagerOrOwner {
        sendAllowed[operator] = false;
    }

    function removeFromSendAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            sendAllowed[operator[i]] = false;
        }
    }

    function removeFromReceiveAllowed (address operator) public onlyManagerOrOwner {
        receiveAllowed[operator] = false;
    }

    function removeFromReceiveAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            receiveAllowed[operator[i]] = false;
        }
    }

    function removeFromBothSendAndReceiveAllowed (address operator) public onlyManagerOrOwner {
        removeFromSendAllowed(operator);
        removeFromReceiveAllowed(operator);
    }

    function removeFromBothSendAndReceiveAllowedBatch (address[] memory operator) public onlyManagerOrOwner {
        for (uint i = 0; i < operator.length; i++) {
            sendAllowed[operator[i]] = false;
            receiveAllowed[operator[i]] = false;
        }
    }
}
