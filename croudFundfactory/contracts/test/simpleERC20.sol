// SPDX-License-Identifier: MIT

pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract simpleERC20 is ERC20, Ownable {

    uint256 limitMintPublic = 11000 ether;
    uint256 maxTotalSupply = 1000000000 ether;

    constructor() ERC20("SimpleToken", "ST"){
    }

    function mintOwner(address to, uint256 amount) external onlyOwner {
        require(totalSupply() <= maxTotalSupply, "Can't exceed max total supply");
        _mint(to, amount);
    }

    function mintPublic(address to, uint256 amount) public {
        require(amount <= limitMintPublic, "Can't mint more than 11K");
        require(totalSupply() <= maxTotalSupply, "Can't exceed max total supply");
        _mint(to, amount);
    }
}