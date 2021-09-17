pragma solidity ^0.5.15;

import "@openzeppelin/contracts/token/ERC20/ERC20Detailed.sol";
import "./managed-whitelist/ManagedWhitelist.sol";
import "./ERC1404/MessagedERC1404.sol";

contract xxCoin is ERC20Detailed, ManagedWhitelist, MessagedERC1404 {
    uint8 public SEND_NOT_ALLOWED_CODE;
    uint8 public RECEIVE_NOT_ALLOWED_CODE;
    string public constant SEND_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_SENDING_ACCOUNT_NOT_WHITELISTED";
    string public constant RECEIVE_NOT_ALLOWED_ERROR = "ILLEGAL_TRANSFER_RECEIVING_ACCOUNT_NOT_WHITELISTED";

    constructor (address initialAccount, uint256 initialBalance)
        ERC20Detailed("xxCoin", "xx", 0)
        public
    {
        SEND_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(SEND_NOT_ALLOWED_ERROR);
        RECEIVE_NOT_ALLOWED_CODE = messagesAndCodes.autoAddMessage(RECEIVE_NOT_ALLOWED_ERROR);
        addToBothSendAndReceiveAllowed(initialAccount);
        _mint(initialAccount, initialBalance);
    }

    function detectTransferRestriction (address from, address to, uint /* value */)
        public
        view
        returns (uint8 restrictionCode)
    {
        if (!sendAllowed[from]) {
            restrictionCode = SEND_NOT_ALLOWED_CODE; // sender address not whitelisted
        } else if (!receiveAllowed[to]) {
            restrictionCode = RECEIVE_NOT_ALLOWED_CODE; // receiver address not whitelisted
        } else {
            restrictionCode = SUCCESS_CODE; // successful transfer (required)
        }
    }
}
