// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import {ERC404} from "./ERC404.sol";

contract ERC404Vault is ERC404 {

    constructor(string memory _name, string memory _symbol, uint8 _decimals) ERC404(_name, _symbol, _decimals) {}

    function tokenURI(uint256 id_) public view override returns (string memory) {}
}