pragma solidity ^0.6.0;

import "./Ownable.sol";
import "./Item.sol";


contract ItemManager is Ownable {
    
    enum SupplyChainState{Created, Paid, Delivered}
    
    struct S_Item {
        Item _item;
        string _id;
        uint _price;
        ItemManager.SupplyChainState _state;
    }
    
    event SupplyChainStep(uint _ItemIndex, uint _step, address _itemAddress);
    
    mapping(uint => S_Item) public items;
    uint itemIndex;

    function createItem(string memory _id, uint _price) public onlyOwner{
        Item item = new Item(this, _price, itemIndex);
        items[itemIndex]._item = item;
        items[itemIndex]._id = _id;
        items[itemIndex]._price = _price;
        items[itemIndex]._state = SupplyChainState.Created;
        emit SupplyChainStep(itemIndex, uint(items[itemIndex]._state), address(item));
        itemIndex ++;
    }    
    
    function triggerPayement(uint _itemIndex) public payable {
        require(msg.value == items[_itemIndex]._price, "Not correct amount");
        require(items[_itemIndex]._state == SupplyChainState.Created, "already paid");
        
        items[_itemIndex]._state = SupplyChainState.Paid;
        
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
    }
    
    function triggerDelivery(uint _itemIndex) public onlyOwner{
        require(items[_itemIndex]._state == SupplyChainState.Paid, "already delivered");
        
        items[_itemIndex]._state = SupplyChainState.Delivered;
        
        emit SupplyChainStep(_itemIndex, uint(items[_itemIndex]._state), address(items[_itemIndex]._item));
        
    }
}