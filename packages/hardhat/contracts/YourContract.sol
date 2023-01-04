pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT

//write a smart contract that will give three subscription tiers to users who pay a certain amount of ether
//the first tier will be equal to 5 usd and will be for 1 month subscription, the second tier will be equal to 25 usd and will be for 6 months subscription, and the third tier will be equal to 15 usd and will be for 6 months subscription
//the third tier will be equal to 45 usd and will be for 12 months subscription
//the contract will have a function that will allow the user to pay the subscription fee and will give them the subscription tier they paid for
//the contract will have a read only function that will allow anyone to check a user's subscription status
//the contract will have a function that will allow the owner to withdraw the funds from the contract
//the contract will have a function that will allow the owner to change the subscription fee for each tier
//the contract will have a function that will allow the owner to change the subscription duration for each tier



import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";


contract YourContract is Ownable {
    using SafeMath for uint256;

//set the owner of the contract to 0x30fA487ee1b335b5f76aF590f2452d83BaAA71fC
    constructor() {
        transferOwnership(0x30fA487ee1b335b5f76aF590f2452d83BaAA71fC);
    }

    struct Subscription {
        uint256 tier;
        uint256 expiration;
    }

    mapping(address => Subscription) public subscriptions;

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

        subscriptions[msg.sender] = Subscription(_tier, block.timestamp.add(
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
            subscriptions[msg.sender] = Subscription(3, block.timestamp.add(tier3Duration));
            payable(msg.sender).transfer(msg.value.sub(tier3Price));
        } else if (msg.value >= tier2Price) {
            subscriptions[msg.sender] = Subscription(2, block.timestamp.add(tier2Duration));
            payable(msg.sender).transfer(msg.value.sub(tier2Price));
        } else if (msg.value >= tier1Price) {
            subscriptions[msg.sender] = Subscription(3, block.timestamp.add(tier1Duration));
            payable(msg.sender).transfer(msg.value.sub(tier1Price));
        } else {
            revert("Not enough ether sent");
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



