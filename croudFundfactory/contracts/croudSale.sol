// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/extensions/draft-ERC20Permit.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@openzeppelin/contracts/utils/math/Math.sol";
import "@openzeppelin/contracts/interfaces/IERC4626.sol";
import "./dividendPayingToken.sol";

contract croudSale is IERC20, DividendPayingToken {
    using SafeERC20 for IERC20;
    IERC20 stable;
    uint256 maxFund;
    uint256 endTime;
    address benificiary;

    constructor(
        ERC20 _stableCoin,
        uint256 _maxFund,
        uint256 _endTime,
        address _benificiary,
        string memory _name
    ) DividendPayingToken(_name, _name) {
        stable = _stableCoin;
        maxFund = _maxFund;
        endTime = _endTime;
        benificiary = _benificiary;
    }

    function fund(uint256 amount) external {
        require(isActive(), "This round is over");
        stable.safeTransferFrom(msg.sender, address(this), amount);
        _mint(msg.sender, amount);
    }

    function isActive() public view returns (bool) {
        if (
            block.timestamp < endTime ||
            maxFund < stable.balanceOf(address(this))
        ) {
            return true;
        }
        return false;
    }

    function refund() external {
        uint256 tokensToRefund = balanceOf(msg.sender);
        _burn(msg.sender, tokensToRefund);
        stable.safeTransferFrom(address(this), msg.sender, tokensToRefund);
    }

    function finalizeFund() public {
        require(msg.sender == benificiary, "No authorized");
        require(maxFund >= stable.balanceOf(address(this)), "Cap not meet");
        stable.safeTransferFrom(
            address(this),
            benificiary,
            stable.balanceOf(address(this))
        );
    }
}
