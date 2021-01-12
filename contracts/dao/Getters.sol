/*
    Copyright 2020 Empty Set Squad <emptysetsquad@protonmail.com>

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
*/

pragma solidity ^0.5.17;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/math/SafeMath.sol";
import "./State.sol";
import "../Constants.sol";

contract Getters is State {
    using SafeMath for uint256;
    using Decimal for Decimal.D256;

    bytes32 private constant IMPLEMENTATION_SLOT = 0x360894a13ba1a3210667c828492db98dca3e2076cc3735a920a3ca505d382bbc;

    /**
     * ERC20 Interface
     */

    function name() public view returns (string memory) {
        return "Galaxy Set Dollar Stake";
    }

    function symbol() public view returns (string memory) {
        return "GSDS";
    }

    function decimals() public view returns (uint8) {
        return 18;
    }

    function balanceOf(address account) public view returns (uint256) {
        return _state.accounts[account].balance;
    }

    function totalSupply() public view returns (uint256) {
        return _state.balance.supply;
    }

    function allowance(address owner, address spender) external view returns (uint256) {
        return 0;
    }

    /**
     * Global
     */

    function dollar() public view returns (IDollar) {
        return _state.provider.dollar;
    }

    function oracle() public view returns (IOracle) {
        return _state.provider.oracle;
    }

    function pool() public view returns (address) {
        return _state.provider.pool;
    }

    function totalBonded() public view returns (uint256) {
        return _state.balance.bonded;
    }

    function totalStaged() public view returns (uint256) {
        return _state.balance.staged;
    }

    function totalDebt() public view returns (uint256) {
        return _state.balance.debt;
    }

    function totalRedeemable() public view returns (uint256) {
        return _state.balance.redeemable;
    }

    function totalCoupons() public view returns (uint256) {
        return _state.balance.coupons;
    }

    function totalNet() public view returns (uint256) {
        return dollar().totalSupply().sub(totalDebt()).sub(9000 * 1e18);
    }

    /**
     * Account
     */

    function balanceOfStaged(address account) public view returns (uint256) {
        return _state.accounts[account].staged;
    }

    function balanceOfBonded(address account) public view returns (uint256) {
        uint256 totalSupply = totalSupply();
        if (totalSupply == 0) {
            return 0;
        }
        return totalBonded().mul(balanceOf(account)).div(totalSupply);
    }

    function balanceOfCoupons(address account, uint256 epoch) public view returns (uint256) {
        if (outstandingCoupons(epoch) == 0) {
            return 0;
        }
        return _state.accounts[account].coupons[epoch];
    }

    function statusOf(address account) public view returns (Account.Status) {
        if (_state.accounts[account].lockedUntil > epoch()) {
            return Account.Status.Locked;
        }

        return epoch() >= _state.accounts[account].fluidUntil ? Account.Status.Frozen : Account.Status.Fluid;
    }

    function allowanceCoupons(address owner, address spender) public view returns (uint256) {
        return _state.accounts[owner].couponAllowances[spender];
    }

    /**
     * Epoch
     */

    function epoch() public view returns (uint256) {
        return _state.epoch.current;
    }

    function epochStart() public view returns (uint256) {
        return _state.epoch.start;
    }

    function epochPeriod() public view returns (uint256) {
        return _state.epoch.period;
    }

    function epochTime() public view returns (uint256) {
        uint256 epochStart = epochStart();

        if (block.timestamp < epochStart) {
            return 0;
        }

        uint256 bootstrappingPeriod = epochPeriod().div(Constants.getBootstrappingSpeedupFactor());
        uint256 bootstrappingTotal = Constants.getBootstrappingPeriod().mul(bootstrappingPeriod);

        if (block.timestamp < epochStart.add(bootstrappingTotal)) {
            return block.timestamp.sub(epochStart).div(bootstrappingPeriod).add(1);
        }

        return block.timestamp
            .sub(epochStart.add(bootstrappingTotal))
            .div(_state.epoch.period)
            .add(1)
            .add(Constants.getBootstrappingPeriod());
    }

    function outstandingCoupons(uint256 epoch) public view returns (uint256) {
        return _state.epochs[epoch].coupons.outstanding;
    }

    function couponsExpiration(uint256 epoch) public view returns (uint256) {
        return _state.epochs[epoch].coupons.expiration;
    }

    function expiringCoupons(uint256 epoch) public view returns (uint256) {
        return _state.epochs[epoch].coupons.expiring.length;
    }

    function expiringCouponsAtIndex(uint256 epoch, uint256 i) public view returns (uint256) {
        return _state.epochs[epoch].coupons.expiring[i];
    }

    function totalBondedAt(uint256 epoch) public view returns (uint256) {
        return _state.epochs[epoch].bonded;
    }

    function bootstrappingAt(uint256 epoch) public view returns (bool) {
        return epoch <= Constants.getBootstrappingPeriod();
    }

    function fluidUntil(address account) public view returns (uint256) {
        return _state.accounts[account].fluidUntil;
    }

    function lockedUntil(address account) public view returns (uint256) {
        return _state.accounts[account].lockedUntil;
    }

    /**
     * Governance
     */
    function isInitialized(address candidate) public view returns (bool) {
        return _state.candidates[candidate].initialized;
    }

    function implementation() public view returns (address impl) {
        bytes32 slot = IMPLEMENTATION_SLOT;
        assembly {
            impl := sload(slot)
        }
    }
}
