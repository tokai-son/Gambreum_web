pragma solidity ^0.4.24;

import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract GambreumTip is StandardToken, Ownable {
	string public name = "GambreumToken";
	string public symbol = "GTIP";
	uint public decimals = 18;

	event TokenPublish(uint value);

	/*
	function publishToken(uint value) public onlyOwner {
		if(totalSupply() == 0) {
			totalSupply_ = value;
			balances[msg.sender] = value;
			emit TokenPublish(value);
		} else if (totalSupply() > 0) {
			totalSupply_ += value;
			balances[msg.sender] += value;
		}
	}
	*/

}
