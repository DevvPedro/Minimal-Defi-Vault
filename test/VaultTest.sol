// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.6;

import "forge-std/Test.sol";
import "../src/Vault.sol";
import "./mocks/TestToken.sol";

contract ContractTest is Test {
    Vault public vault;
    TestToken public test;
    function setUp() public {
        vault = new Vault(test);
       
    }
   //Test for zero input
     function testNonZero() public {
        vm.expectRevert(abi.encodeWithSignature("Vault_NonZero()"));
        uint amount = 0;
        vault.withdraw(amount);

    }
   //Test for 0 input
    function testNonZero_() public {
        vm.expectRevert(abi.encodeWithSignature("Vault_NonZero()"));
        uint amount = 0;
        vault.deposit(amount);
    }




    
}
