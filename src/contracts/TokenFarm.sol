pragma solidity ^0.5.0;

import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
    string public name = "Dapp Token Farm";
    DappToken public dappToken;
    DaiToken public daiToken;
    address public owner;

    address[] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    constructor(DappToken _dappToken, DaiToken _daiToken) public {
        dappToken = _dappToken;
        daiToken = _daiToken;
        owner = msg.sender;
    }

    // 1. Stakes Tokens (Deposit)
    function stakeTokens(uint _amount) public {
        // Require amount greater than 0
        require(_amount > 0, "amount annot be 0");

        // Transfer Mock Dai tokens to this contract for staking
        daiToken.transferFrom(msg.sender, address(this), _amount);

        // Update Staking Balance
        stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

        // Add user to Stakers array only if they haven't staked already
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);
        }

        // Update Staking status
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;
    }

    // 2. Unstaking tokens (Withdraw)


    // 3. Issuing tokens
    function issueTokens() public {
        // Only owner can call this function
        require(msg.sender == owner, "caller must be the owner");

        // Issue tokens to all stakers
        for (uint i=0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            
            if(balance> 0) {
                dappToken.transfer(recipient, balance);
            }
        }
    }
}