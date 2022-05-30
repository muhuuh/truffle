pragma solidity ^0.6.0;

import "./ItemManager.sol";
contract Item {
    uint public priceInWei;
    uint public pricePaid;
    uint public index;
    
    ItemManager ParentContract;
    
    constructor(ItemManager _parentContract, uint _index, uint _priceInWei) public {
        priceInWei = _priceInWei;
        index = _index;
        ParentContract = _parentContract;
    }
    
    receive() external payable {
        require(pricePaid == 0, "Already Paid");
        require(priceInWei == msg.value, "Not exact amount");
        (bool success, ) = address (ParentContract).call.value(msg.value)(abi.encodeWithSignature("triggerPayement(uint256)", index));
        require(success, "The transaction wasn't successful, Cancel");
        pricePaid += msg.value;
    }
    
    fallback() external{
        
    }
}