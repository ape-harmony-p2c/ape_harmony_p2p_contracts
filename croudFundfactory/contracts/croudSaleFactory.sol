// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./croudSale.sol";

contract croudSaleFactory {
    croudSale public deployedCroudSale;
    mapping(address => address[]) public ownedCroudSales;
    ERC20 PROTOCOL_STABLE;
    constructor(address _stable){
        PROTOCOL_STABLE = ERC20(_stable);
    }


    event DeployedSale(address deployedAddresss);
    function deployCroudSale(
        uint256 _maxFund,
        uint256 _endTime,
        address _benificiary,
        string memory _name
    )  external{
        //deploy croudsale
        deployedCroudSale = new croudSale(
            PROTOCOL_STABLE,
            _maxFund,
            _endTime,
            _benificiary,
            _name
        );
        //store croudsale address
        ownedCroudSales[_benificiary].push(address(deployedCroudSale));
        emit DeployedSale(address(deployedCroudSale));
    }
}
