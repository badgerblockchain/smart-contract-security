pragma solidity 0.8.11;

contract Reentrant {

    // balances will return the amount of eth currently*  
    // owned by this contract that a given address has sent it
    mapping(address => uint256) private _balances;

    function withdraw(uint256 amount) external {

        uint256 balance = _balances[msg.sender];

        require(balance > 0);

        payable(msg.sender).call{value: amount}("");

        _balances[msg.sender] = 0;
        
    }

    // receive is a special function in solidity, like constructor, 
    // that doesn't need to be denoted as a function first

    // this is becasue when sending eth to this contract,
    // even if a function isnt targeted, this will be exectued

    function pay() external payable {
        _balances[msg.sender] += msg.value;
    }

}