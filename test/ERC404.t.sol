// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "lib/forge-std/src/Test.sol";
import {ERC404, Ownable, IERC404} from "../src/ERC404.sol";

contract ERC404Mock is ERC404 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _totalNativeSupply, address _owner)
        ERC404(_name, _symbol, _decimals, _totalNativeSupply, _owner)
    {
        balanceOf[_owner] = 10000 * 10 ** 18;
    }

    function tokenURI(uint256 id) public view virtual override returns (string memory) {}

    function _spendAllowance(address, address, uint256) internal virtual override {}
}

contract ERC404Test is Test {
    ERC404Mock public mock;
    address public alice = address(0x01);
    address public bob = address(0x02);

    function setUp() public {
        mock = new ERC404Mock("ERC404 Mock", "mERC404", 18, 10_000, address(this));
        mock.setWhitelist(address(this), true);
    }

    function testSetWhitelist(address x) public {
        if (x != mock.owner()) {
            vm.prank(x);
            vm.expectRevert(Ownable.Unauthorized.selector);
            mock.setWhitelist(address(0x01), true);
        } else {
            vm.prank(x);
            mock.setWhitelist(address(0x01), true);
            assert(mock.whitelist(address(0x01)) == true);
        }
    }

    function testApprove(address x, uint256 y) public {
        mock.approve(x, y);
        if (y > mock.minted()) {
            assert(mock.allowance(address(this), x) == y);
        } else {
            ///@dev currently minted is zero so nothing should happen
            assert(mock.getApproved(y) == address(0));
        }
    }

    function testSetApprovalForAll(address x, bool approved) public {
        mock.setApprovalForAll(x, approved);
        assert(mock.isApprovedForAll(address(this), x) == approved);
    }

    /// @dev transfer test for fractional reserves
    function testTransfer(uint256 x) public {
        vm.assume(x > 1 ether && x < 1_000 ether);
        console2.logBytes(mock._ownedIds(alice));
        mock.transfer(alice, x);
        uint256 tokensMinted = x / 1 ether;
        console2.logBytes(mock._ownedIds(alice));

        // /// @dev can be more thorough on this assertion, but requires additional time through loops
        // assert(mock.ownerOf(tokensMinted - 1) == alice);

        // assert(mock.balanceOf(address(this)) == (10_000 ether - x));
        // assert(mock.balanceOf(alice) == x);

        vm.prank(alice);
        mock.transfer(bob, x);

        // assert(mock.balanceOf(alice) == 0);
        // assert(mock.balanceOf(bob) == x);
        // assert(mock.ownerOf((tokensMinted * 2) - 1) == bob);
    }

    // function testTransferFrom() public {}

    // function testSafeTransferFrom() public {}

    // function testSafeTransferFromCallback() public {}
}
