pragma solidity >=0.8.0 <0.9.0;
//SPDX-License-Identifier: MIT
//create a contract that will interact with the contract packages/hardhat/contracts/YourContract.sol and allow the user to call the contract if the isSubscribed function returns true



import "./YourContract.sol";

contract SubInteraction {
    YourContract yourContract;

    constructor(address payable _yourContract) {
        yourContract = YourContract(_yourContract);
    }

    //create an interact function that returns a secret message saying "the password is 1234" if the user is subscribed and reverts if the user is not subscribed
    function interact(address beans) public view returns (string memory) {
        require(yourContract.isSubscribed(beans) == true, "Not subscribed");
        string memory message = "the password is 1234";
        return message;
}

    //returns the contract address of YourContract
    function getYourContract() public view returns (address) {
        return address(yourContract);
    }



}



