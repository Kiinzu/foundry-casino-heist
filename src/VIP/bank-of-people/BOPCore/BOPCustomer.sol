// SPDX-License-Identifier: NQDU
pragma solidity 0.8.29;

/**
 * @title BOPCustomer Validator
 * @dev A Validator for checking destinated Receiver of Customer's Balance.
 */
interface BOPCustomer {

    function withdrawalReceiver(
        uint256 _amount,
        address _receiver
    ) external returns(bytes4);

}