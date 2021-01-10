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

import "./external/Decimal.sol";

library Constants {
    /* Chain */
    uint256 private constant CHAIN_ID = 128; // Mainnet

    /* Bootstrapping */
    uint256 private constant BOOTSTRAPPING_PERIOD = 2;
    uint256 private constant BOOTSTRAPPING_PRICE = 11e17; // 1.10 HUSD
    uint256 private constant BOOTSTRAPPING_SPEEDUP_FACTOR = 2; // 1 hours * 2 = 2h

    /* Oracle */
    address private constant HUSD = address(0x0298c2b32eaE4da002a15f36fdf7615BEa3DA047);
    uint256 private constant ORACLE_RESERVE_MINIMUM = 1e10; // 10,000 HUSD

    /* Bonding */
    uint256 private constant INITIAL_STAKE_MULTIPLE = 1e6; // 100 GSD -> 100M ESDS

    /* Epoch */
    uint256 private constant EPOCH_PERIOD = 7200; // 2 hour

    /* DAO */
    uint256 private constant ADVANCE_INCENTIVE = 1e20; // 100 GSD
    uint256 private constant DAO_EXIT_LOCKUP_EPOCHS = 36; // 36 epochs fluid 3days

    /* Pool */
    uint256 private constant POOL_EXIT_LOCKUP_EPOCHS = 18; // 18 epochs fluid 1.5 days

    /* Market */
    uint256 private constant COUPON_EXPIRATION = 360; //one month
    uint256 private constant DEBT_RATIO_CAP = 35e16; // 35%

    /* Regulator */
    uint256 private constant SUPPLY_CHANGE_LIMIT = 3e16; // 3%

    uint256 private constant COUPON_SUPPLY_CHANGE_LIMIT = 6e16; // 6%


    uint256 private constant ORACLE_POOL_RATIO = 40; // 40%


    /**
     * Getters
     */

    function getHUSD() internal pure returns (address) {
        return HUSD;
    }

    function getOracleReserveMinimum() internal pure returns (uint256) {
        return ORACLE_RESERVE_MINIMUM;
    }

    function getEpochPeriod() internal pure returns (uint256) {
        return EPOCH_PERIOD;
    }

    function getInitialStakeMultiple() internal pure returns (uint256) {
        return INITIAL_STAKE_MULTIPLE;
    }

    function getBootstrappingPeriod() internal pure returns (uint256) {
        return BOOTSTRAPPING_PERIOD;
    }

    function getBootstrappingPrice() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: BOOTSTRAPPING_PRICE});
    }

    function getBootstrappingSpeedupFactor() internal pure returns (uint256) {
        return BOOTSTRAPPING_SPEEDUP_FACTOR;
    }

    function getAdvanceIncentive() internal pure returns (uint256) {
        return ADVANCE_INCENTIVE;
    }

    function getCouponExpiration() internal pure returns (uint256) {
        return COUPON_EXPIRATION;
    }

    function getSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: SUPPLY_CHANGE_LIMIT});
    }

    function getCouponSupplyChangeLimit() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: COUPON_SUPPLY_CHANGE_LIMIT});
    }

    function getOraclePoolRatio() internal pure returns (uint256) {
        return ORACLE_POOL_RATIO;
    }

    function getChainId() internal pure returns (uint256) {
        return CHAIN_ID;
    }

    function getPoolExitLockupEpochs() internal pure returns (uint256) {
        return POOL_EXIT_LOCKUP_EPOCHS;
    }

     function getDAOExitLockupEpochs() internal pure returns (uint256) {
        return DAO_EXIT_LOCKUP_EPOCHS;
    }


    function getDebtRatioCap() internal pure returns (Decimal.D256 memory) {
        return Decimal.D256({value: DEBT_RATIO_CAP});
    }
}
