// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {console2} from "lib/forge-std/src/console2.sol";
import {ERC404} from "../src/ERC404.sol";
import {OriginalERC404} from "../src/OriginalERC404.sol";

contract ERC404Mock is ERC404 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalNativeSupply, address _owner)
        ERC404(_name, _symbol, _decimals, _totalNativeSupply, _owner)
    {
        balanceOf[_owner] = 10000 * 10 ** 18;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {}

    function _spendAllowance(address, address, uint256) internal virtual override {}
}

contract OriginalERC404Mock is OriginalERC404 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalNativeSupply, address _owner)
        OriginalERC404(_name, _symbol, _decimals, _totalNativeSupply, _owner)
    {
        balanceOf[_owner] = 10000 * 10 ** 18;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {}

    //function _spendAllowance(address, address, uint256) internal virtual {}
}

contract ERC404GasComparisonTest is Test {
    ERC404Mock public erc404;
    OriginalERC404Mock public og404;
    address public alice = address(0x01);
    address public bob = address(0x02);

    function setUp() public {
        erc404 = new ERC404Mock("Newer 404", "n404", 18, 10_000, address(this));
        og404 = new OriginalERC404Mock("Original 404", "og404", 18, 10_000, address(this));
        erc404.setWhitelist(erc404.owner(), true);
        og404.setWhitelist(erc404.owner(), true);
    }

    function testTransferGasUsage(uint256 x) public {
        vm.assume(x > 1 ether && x < 1_000 ether);
        console2.logUint(og404.balanceOf(og404.owner()));
        vm.startPrank(erc404.owner());
        erc404.transfer(alice, x);
        og404.transfer(alice, x);
        vm.stopPrank();

        vm.startPrank(alice);
        erc404.transfer(bob, x);
        og404.transfer(bob, x);
        vm.stopPrank();
    }
}
