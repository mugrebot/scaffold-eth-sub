pragma solidity >=0.8.0 <0.9.6;
//SPDX-License-Identifier: MIT

//errors
//minimum subscription tier is 1
//make a revert error instead of require


import "@openzeppelin/contracts/access/Ownable.sol";


error NoEtherSent( uint256 value, uint256 min );



contract YourContract is Ownable {

//set the owner of the contract to 0x30fA487ee1b335b5f76aF590f2452d83BaAA71fC
    constructor() {
        transferOwnership(0x30fA487ee1b335b5f76aF590f2452d83BaAA71fC);
    }

    struct Subscription {
        uint256 tier;
        uint256 expiration;
    }

    mapping(address => Subscription) public subscriptions;

    uint256 min = 0.05 ether;


    uint256 public tier1Price = .05 ether;
    uint256 public tier2Price = .25 ether;
    uint256 public tier3Price = .45 ether;

    uint256 public tier1Duration = 30 days;
    uint256 public tier2Duration = 180 days;
    uint256 public tier3Duration = 365 days;

    function subscribe(uint256 _tier) public payable {
        require(_tier == 1 || _tier == 2 || _tier == 3, "Invalid tier");
        require(
            msg.value == tier1Price && _tier == 1 ||
            msg.value == tier2Price && _tier == 2 ||
            msg.value == tier3Price && _tier == 3,
            "Invalid price"
        );

        subscriptions[msg.sender] = Subscription(_tier, block.timestamp + (
            _tier == 1 ? tier1Duration :
            _tier == 2 ? tier2Duration :
            tier3Duration
        ));
    }


    //payable receive function that will allow the user to pay the subscription fee and will give them the subscription tier they paid for
    //reverts if not enough ether sent, returns any extra ether sent
    receive() external payable {
        require(msg.value > 0, "No ether sent");
        if (msg.value >= tier3Price) {
            subscriptions[msg.sender] = Subscription(3, block.timestamp+(tier3Duration));
            payable(msg.sender).transfer(msg.value-(tier3Price));
        } else if (msg.value >= tier2Price) {
            subscriptions[msg.sender] = Subscription(2, block.timestamp+(tier2Duration));
            payable(msg.sender).transfer(msg.value-(tier2Price));
        } else if (msg.value >= tier1Price) {
            subscriptions[msg.sender] = Subscription(3, block.timestamp+(tier1Duration));
            payable(msg.sender).transfer(msg.value-(tier1Price));
        } else {
            revert NoEtherSent(msg.value, min);
        }
    }



    function isSubscribed(address _user) public view returns (bool) {
        return subscriptions[_user].expiration > block.timestamp;
    }


    function withdraw() public onlyOwner {
        payable(msg.sender).transfer(address(this).balance);
    }

    function setTier1Price(uint256 _price) public onlyOwner {
        tier1Price = _price;
    }

    function setTier2Price(uint256 _price) public onlyOwner {
        tier2Price = _price;
    }

    function setTier3Price(uint256 _price) public onlyOwner {
        tier3Price = _price;
    }

    function setTier1Duration(uint256 _duration) public onlyOwner {
        tier1Duration = _duration;
    }

    function setTier2Duration(uint256 _duration) public onlyOwner {
        tier2Duration = _duration;
    }

    function setTier3Duration(uint256 _duration) public onlyOwner {
        tier3Duration = _duration;
    }
}



