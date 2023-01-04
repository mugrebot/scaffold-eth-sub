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



//start writing the contract

contract YourContract {
    //create a struct that will hold the subscription tier information

    address private owner;

    struct SubscriptionTier {
        uint256 subscriptionFee;
        uint256 subscriptionDuration;
    }
    
    //create a struct that will hold the user information
    struct User {
        address userAddress;
        uint256 subscriptionTier;
        uint256 subscriptionExpiration;
    }
    
    //create a mapping that will hold the subscription tier information
    mapping(uint256 => SubscriptionTier) public subscriptionTiers;
    
    //create a mapping that will hold the user information
    mapping(address => User) public users;
    
    //create an event that will be emitted when a user pays for a subscription
    event UserSubscribed(address userAddress, uint256 subscriptionTier, uint256 subscriptionExpiration);
    
    //create an event that will be emitted when the owner withdraws the funds from the contract
    event FundsWithdrawn(address owner, uint256 amount);
    
    //create an event that will be emitted when the owner changes the subscription fee for a tier
    event SubscriptionFeeChanged(uint256 subscriptionTier, uint256 subscriptionFee);
    
    //create an event that will be emitted when the owner changes the subscription duration for a tier
    event SubscriptionDurationChanged(uint256 subscriptionTier, uint256 subscriptionDuration);
    
    //create a constructor that will initialize the subscription tiers
    constructor() {
        owner=0x72d5fCC549C7454F2017Fe8ad19EdD800aB7EB92;
        subscriptionTiers[1] = SubscriptionTier(.05 ether, 30 days);
        subscriptionTiers[2] = SubscriptionTier(.25 ether, 180 days);
        subscriptionTiers[3] = SubscriptionTier(.45 ether, 365 days);
    }
    
    //create a function that will allow the user to pay the subscription fee and will give them the subscription tier they paid for
    function subscribe(uint256 subscriptionTier) public payable {
        require(msg.value == subscriptionTiers[subscriptionTier].subscriptionFee, "You must pay the correct subscription fee");
        require(subscriptionTier >= 1 && subscriptionTier <= 3, "You must choose a valid subscription tier");
        
 
        users[msg.sender].subscriptionExpiration += subscriptionTiers[subscriptionTier].subscriptionDuration;
        
        users[msg.sender].userAddress = msg.sender;
        users[msg.sender].subscriptionTier = subscriptionTier;

        
        emit UserSubscribed(msg.sender, subscriptionTier, users[msg.sender].subscriptionExpiration);
    }
    
    //create a read only function that will allow anyone to check a user's subscription status
    function checkSubscriptionStatus(address userAddress) public view returns(uint256) {

            return users[userAddress].subscriptionExpiration;
        
    }

    //create a read onlyfunction that returns a boolean value if the user is subscribed or not

    function isSubscribed(address userAddress) public view returns(bool) {
        if(users[userAddress].subscriptionExpiration > 0) {
            return true;
        } else {
            return false;
        }
    }
    
    //create a function that will allow the owner to withdraw the funds from the contract
    function withdrawFunds() public {
        require(msg.sender == owner, "You must be the owner to withdraw the funds");
        
        uint256 balance = address(this).balance;
        payable(msg.sender).transfer(balance);
        
        emit FundsWithdrawn(msg.sender, balance);
    }
    
    //create a function that will allow the owner to change the subscription fee for each tier
    function changeSubscriptionFee(uint256 subscriptionTier, uint256 subscriptionFee) public {
        require(msg.sender == owner, "You must be the owner to change the subscription fee");
        require(subscriptionTier >= 1 && subscriptionTier <= 3, "You must choose a valid subscription tier");
        
        subscriptionTiers[subscriptionTier].subscriptionFee = subscriptionFee;
        
        emit SubscriptionFeeChanged(subscriptionTier, subscriptionFee);
    }
    
    //create a function that will allow the owner to change the subscription duration for each tier
    function changeSubscriptionDuration(uint256 subscriptionTier, uint256 subscriptionDuration) public {
        require(msg.sender == owner, "You must be the owner to change the subscription duration");
        require(subscriptionTier >= 1 && subscriptionTier <= 3, "You must choose a valid subscription tier");
        
        subscriptionTiers[subscriptionTier].subscriptionDuration = subscriptionDuration;
        
        emit SubscriptionDurationChanged(subscriptionTier, subscriptionDuration);
    }
}

//end writing the contract


