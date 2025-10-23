// SPDX-License-Identifier: NQDU
pragma solidity 0.8.29;

import {BOPCustomer} from "./BOPCore/BOPCustomer.sol";

library BOPUtils{
    /**
     * @dev Performs an acceptance check for the provided `operator` by calling {BOPCustomer::withdrawalReceiver}
     * on the `to` address. The `operator` is generally the address that initiated the token transfer (i.e. `msg.sender`).
     *
     * The acceptance call is executed whether the receiver is an EOA or a Smart Contract to ensure the latest feature
     * implemented by the Bank Of People - Inovative Future Global Release is running correctly.
     */

    function checkOnWithdrawalReceiver(
        uint256 _amount,
        address _receiver
    ) internal returns(bool){
        return (BOPCustomer(_receiver).withdrawalReceiver(_amount,_receiver) == 0x5c1573fd);
    }
}