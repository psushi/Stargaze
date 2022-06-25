// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ISuperfluid, ISuperfluidToken} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";

import {SuperfluidToken} from "@superfluid-finance/ethereum-contracts/contracts/superfluid/SuperfluidToken.sol";

import {IInstantDistributionAgreementV1} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/agreements/IInstantDistributionAgreementV1.sol";

import {IDAv1Library} from "@superfluid-finance/ethereum-contracts/contracts/apps/IDAv1Library.sol";

contract Stargazer {
    ///////////////////////////////////////////////////////////////////////////////
    // SuperFluid stuff
    ///////////////////////////////////////////////////////////////////////////////
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal _idav1Lib;

    address public constant USDCx = 0xaA1EA30cEe569fA70B8561c0F52F10Da249Aecb5;

    uint256 public repoCount = 0;

    ///////////////////////////////////////////////////////////////////////////////
    // Repo struct
    ///////////////////////////////////////////////////////////////////////////////
    struct Repo {
        uint256 superfluidIndex;
        address admin;
        address superTokenAddress;
    }
    ///////////////////////////////////////////////////////////////////////////////

    ///////////////////////////////////////////////////////////////////////////////
    // Stargazer Access control
    ///////////////////////////////////////////////////////////////////////////////

    mapping(string => Repo) public nameToRepo;

    // constructor(
    //     address admin,
    //     ISuperfluid _host,
    //     IInstantDistributionAgreement _ida // ISuperfluidToken _token
    // ) {
    //     _ADMIN = admin;
    //     token = _token;
    //     _idav1Lib = IDAv1Library.InitData(_host, _ida);
    //     _idav1Lib.createIndex(ISuperfluidToken(), _INDEX_ID);
    // }

    function initiateRepo(address admin, string calldata name) external {
        require(nameToIndex[name] != 0, "ALREADY_EXISTS");
        repoCount += 1;
        nameToRepo[name] = new Repo({
            superfluidIndex: repoCount,
            admin: admin,
            superTokenAddress: USDCx
        });
    }

    function donate(string calldata repoName, uint256 amount) external payable {
        require(nameToRepo[repoName] != 0, "REPO_NOT_FOUND");
        Repo repo = nameToRepo[repoName];
        ISuperfluidToken token = ISuperfluidToken(repo.superTokenAddress);

        // token.allowance(msg.sender, );
    }

    function distribute() internal {
        require(_canAirdrop(), "can not air drop yet");
        _idav1Lib.distribute(token, _INDEX_ID, AIRDROP_AMOUNT);
    }

    function updateUnits(address subscriber, uint128 units) external {
        require(msg.sender == _ADMIN, "unathorized");
        _idav1Lib.updateSubscriptionUnits(token, _INDEX_ID, subscriber, units);
    }
}
