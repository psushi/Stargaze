// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";
import {ISuperfluidToken} from "@superfluid-finance/interfaces/superfluid/ISuperfluidToken.sol";

import {SuperToken} from "@superfluid-finance/superfluid/SuperToken.sol";

import {IInstantDistributionAgreementV1} from "@superfluid-finance/interfaces/agreements/IInstantDistributionAgreementV1.sol";

import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
// import {Superfluid, InstantDistributionAgreementV1, SuperTokenFactory, SuperfluidFrameworkDeployer} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {ISuperfluid} from "@superfluid-finance/interfaces/superfluid/ISuperfluid.sol";

error Stargazer__initiateRepo__AlreadyExists();
error Stargazer__donate__RepoNotFound();
error Stargazer__donate__InsufficientAllowance();
error Stargazer__updateUnits__UNAUTHORIZED();

contract Stargazer {
    ///////////////////////////////////////////////////////////////////////////////
    // SuperFluid stuff
    ///////////////////////////////////////////////////////////////////////////////
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal idaV1Lib;

    ISuperToken public USDCx =
        ISuperToken(address(0xaA1EA30cEe569fA70B8561c0F52F10Da249Aecb5));

    uint32 public repoCount = 0;

    ///////////////////////////////////////////////////////////////////////////////
    // Repo struct
    ///////////////////////////////////////////////////////////////////////////////
    struct Repo {
        uint32 superfluidIndex;
        address admin;
        ISuperToken impactToken;
    }

    ///////////////////////////////////////////////////////////////////////////////
    // Stargazer Access
    ///////////////////////////////////////////////////////////////////////////////

    // Optimism-kovan addresses
    ISuperfluid host =
        ISuperfluid(address(0x74b57883f8ce9F2BD330286E884CfD8BB24AC4ED));
    IInstantDistributionAgreementV1 ida =
        IInstantDistributionAgreementV1(
            address(0x98E5E5d915Bf79ceeF02c72D1bf8f5b26f0bcBaA)
        );

    mapping(string => Repo) public nameToRepo;

    constructor() {
        idaV1Lib = IDAv1Library.InitData(host, ida);
    }

    function initiateRepo(address admin, string calldata name) external AlreadyExists {

        repoCount += 1;

        nameToRepo[name] = Repo({
            superfluidIndex: repoCount,
            admin: admin,
            impactToken: USDCx
        });

        idaV1Lib.createIndex(USDCx, repoCount);
    }
    modifier AlreadyExists {
        if (address(nameToRepo[name].impactToken) != address(0)) {
            revert Stargazer__initiateRepo__AlreadyExists();
        }
        _;
    }

    function donate(string calldata repoName, uint256 amount) external payable RepoNotFound InsufficientAllowance {

        // instead of 'amount' it's flowRate
        // instead of transferFrom it's createFlowWithOperation

        repo.impactToken.transferFrom(msg.sender, address(this), amount);

        idaV1Lib.distribute(repo.impactToken, repo.superfluidIndex, amount);
    }
    modifier RepoNotFound {
        if (address(nameToRepo[repoName].impactToken) == address(0)) {
            revert Stargazer__donate__RepoNotFound();
        }
        _;
    }
    modifier InsufficientAllowance {
        if (repo.impactToken.allowance(msg.sender, address(this)) != amount) {
            revert Stargazer__donate__InsufficientAllowance();
        }
        _;
    }

    function updateUnits(
        string calldata repoName,
        address subscriber,
        uint128 amount
    ) external {
        Repo storage repo = nameToRepo[repoName];
        if (msg.sender != nameToRepo[repoName].admin) {revert Stargazer__updateUnits__UNAUTHORIZED();
        ISuperToken superToken = ISuperToken(repo.impactToken);
        // Get current units msg.sender holds
        (, , uint256 currentUnitsHeld, ) = idaV1Lib.getSubscription(
            superToken,
            address(this),
            repo.superfluidIndex,
            subscriber
        );

        // Update to current amount + points amount
        idaV1Lib.updateSubscriptionUnits(
            superToken,
            repo.superfluidIndex,
            subscriber,
            uint128(currentUnitsHeld + amount)
        );
    }

    function getImpactScore(string calldata repoName, address subscriber)
        external
        view
        returns (uint256)
    {
        Repo storage repo = nameToRepo[repoName];
        ISuperToken superToken = ISuperToken(repo.impactToken);
        (, , uint256 currentUnitsHeld, ) = idaV1Lib.getSubscription(
            superToken,
            address(this),
            repo.superfluidIndex,
            subscriber
        );
        return currentUnitsHeld;
    }

    function approveSubscription(string calldata repoName) external {
        Repo storage repo = nameToRepo[repoName];

        idaV1Lib.approveSubscription(
            repo.impactToken,
            address(this),
            repo.superfluidIndex
        );
    }
}