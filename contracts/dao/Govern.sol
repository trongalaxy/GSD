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
import "./Setters.sol";
import "./Permission.sol";
import "./Upgradeable.sol";
import "../external/Require.sol";
import "../external/Decimal.sol";
import "../Constants.sol";

contract Govern is Setters, Permission, Upgradeable {
    bytes32 private constant FILE = "Govern";
    event Commit(address indexed account, address indexed candidate);
    function commit(address candidate) external {
        Require.that(
            _state.owner == msg.sender,
            FILE,
            "Not owner"
        );

        upgradeTo(candidate);

        emit Commit(msg.sender, candidate);
    }
}
