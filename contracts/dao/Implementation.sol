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
import "./Market.sol";
import "./Regulator.sol";
import "./Bonding.sol";
import "./Govern.sol";
import "../Constants.sol";

contract Implementation is State, Bonding, Market, Regulator, Govern {
    using SafeMath for uint256;

    event Advance(uint256 indexed epoch, uint256 block, uint256 timestamp);
    event Incentivization(address indexed account, uint256 amount);

    function initialize() initializer public {
        //uint256 epochPeriod = Constants.getEpochPeriod();
        //_state.epoch.current = 0;

        //2021-01-12 20:00:00 UTC+8
        //_state.epoch.start = 1610452800;
        //_state.epoch.start = (block.timestamp / epochPeriod + 1) * epochPeriod; // Round to the next UTC-0

        //_state.epoch.period = epochPeriod;

        //give 10000 gsd to owner
        //mintToAccount(msg.sender, 1e22);
    }

    function advance() external incentivized {
        Require.that(
            _state.owner == msg.sender,
            'impl',
            "Not owner"
        );
        Bonding.step();
        Regulator.step();
        Market.step();

        emit Advance(epoch(), block.number, block.timestamp);
    }

    modifier incentivized {
        uint256 incentive = Constants.getAdvanceIncentive();
        mintToAccount(msg.sender, incentive);
        emit Incentivization(msg.sender, incentive);

        _;
    }
}
