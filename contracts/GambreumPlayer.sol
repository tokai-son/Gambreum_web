pragma solidity ^0.4.24;

import "./GambreumTip.sol";
import "../node_modules/zeppelin-solidity/contracts/token/ERC20/StandardToken.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract GambreumPlayer is GambreumTip {

	struct PlayerInfo {
		string username;
		uint winrate;
		bool locked;
	}

	event PlayerCreated(string username);

	mapping (address => PlayerInfo) public addressToPlayerInfo;
	mapping (address => uint) public addressToBalance;

	/*
	constructor() public {
	}
	*/

	function createPlayer(string _name) public {
		emit PlayerCreated(_name);
		require(keccak256(_name) != keccak256("username"));
		string memory player_name = addressToPlayerInfo[msg.sender].username;
		require(bytes(player_name).length == 0);
		addressToPlayerInfo[msg.sender] = PlayerInfo(_name, 0, false);
		balances[msg.sender] += 100; //初期配布分の100GTIP
	}

	function viewPlayerInfo() public view returns (string username, uint winrate, bool locked) {
		//return addressToPlayerInfo[msg.sender];
		PlayerInfo memory player_info = addressToPlayerInfo[msg.sender];
		return (player_info.username, player_info.winrate, player_info.locked);
	}

	function publishTokenToPlayer(uint value, address to) public onlyOwner {
		balances[to] += value;
	}

	function returnToken(uint value, address player_address) public onlyOwner {
		balances[player_address] -= value;
	}
}
