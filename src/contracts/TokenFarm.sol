pragma solidity ^0.5.0;
import "./DappToken.sol";
import "./DaiToken.sol";

contract TokenFarm {
//all code goes here...the public identifier enables the variable to be accessed from outside the contract

	string public name = "Dapp Token Farm";
	address public owner;
	DappToken public dappToken;
	DaiToken public daiToken;

	address[] public stakers;
	mapping(address => uint) public stakingBalance;
	mapping(address => bool) public hasStaked;
	mapping(address => bool) public isStaking;



constructor(DappToken _dappToken, DaiToken _daiToken) public {
	dappToken = _dappToken;
	daiToken = _daiToken;
	owner = msg.sender;
	}
	// 1. Stake Tokens (Deposit)
	function stakeTokens(uint _amount) public {
		// Require amount greater than 0
		require(_amount > 0, "amount cannot be zero");

		// Transfer Mock Dai tokens to this contract for staking
		daiToken.transferFrom(msg.sender, address(this), _amount);

		// Update Staking Balance
		stakingBalance[msg.sender] = stakingBalance[msg.sender] + _amount;

		// Add user to stakers array *only if they have not staked already
		if(!hasStaked[msg.sender]) {
        	stakers.push(msg.sender);
         }
         //Update Staking Status
         isStaking[msg.sender] = true;
         hasStaked[msg.sender] = true;
		
	}	

	// 2. Unstaking Tokens (Withdraw)
	function unstakeTokens() public {
		// Fetch staking balance
		uint balance = stakingBalance[msg.sender];

		// Require amount greater than zero
		require(balance > 0, "staking balance cannot be 0");

		// Transfer Mock Dai tokens to this contract for staking
		daiToken.transfer(msg.sender,balance);

		// Reset staking balance
		stakingBalance[msg.sender] = 0;

		// Update staking status
		isStaking[msg.sender] = false;

	}

	// 3. Issuing Tokens
	function issueTokens() public {
		// Only the owner can call this function
		require(msg.sender == owner, "caller must be the owner");
		// Issue tokens to all stakers
		//require(msg.sender == owner, "caller must be the owner  ")
		for (uint i=0; i<stakers.length; i++) {
		address recipient = stakers[i];
		uint balance = stakingBalance[recipient];
		if(balance > 0) {
			dappToken.transfer(recipient, balance);
		}
	}
	
}
} 