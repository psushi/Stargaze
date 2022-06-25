// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./SuperfluidTester.sol";
import "../src/Stargazer.sol";

import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

import {IInstantDistributionAgreementV1} from "@superfluid-finance/interfaces/agreements/IInstantDistributionAgreementV1.sol";

import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";

import {ISuperfluid} from "@superfluid-finance/interfaces/superfluid/ISuperfluid.sol";

contract StargazerTest is Test {
    struct Repo {
        uint32 superfluidIndex;
        address admin;
        ISuperToken impactToken;
    }
    using IDAv1Library for IDAv1Library.InitData;

    IDAv1Library.InitData internal idaV1Lib;
    address constant alice = address(0xbabe);
    address constant bob = address(0xb0b);
    address constant charlie = address(0xbcc);
    address constant whale =
        address(0xBDFE7973931C8A187bEDdaD34641339b8Fe06794);
    Stargazer stargazer;

    // Optimism-kovan addresses
    ISuperfluid host =
        ISuperfluid(address(0x74b57883f8ce9F2BD330286E884CfD8BB24AC4ED));
    IInstantDistributionAgreementV1 ida =
        IInstantDistributionAgreementV1(
            address(0x98E5E5d915Bf79ceeF02c72D1bf8f5b26f0bcBaA)
        );

    constructor() {
        idaV1Lib = IDAv1Library.InitData(host, ida);
    }

    function setUp() public {
        stargazer = new Stargazer();
        stargazer.initiateRepo(alice, "foundry");
    }

    function testCreateIndex() public {
        (, address admin, ISuperToken impactToken) = stargazer.nameToRepo(
            "foundry"
        );
        assert(admin == alice);
        emit log_address(address(impactToken));
    }

    function testUpdateUnits() public {
        hoax(alice);
        stargazer.updateUnits("foundry", bob, 20);
        uint256 units = stargazer.getImpactScore("foundry", bob);
        assertEq(units, 20);
    }

    function testFailUpdateUnits() public {
        stargazer.updateUnits("foundry", bob, 20);
    }

    function testDonation() public {
        (
            uint32 superfluidIndex,
            address admin,
            ISuperToken impactToken
        ) = stargazer.nameToRepo("foundry");

        hoax(alice);
        stargazer.updateUnits("foundry", bob, 20);

        hoax(alice);
        stargazer.updateUnits("foundry", charlie, 40);

        hoax(bob);
        host.callAgreement(
            ida,
            abi.encodeCall(
                ida.approveSubscription,
                (
                    impactToken,
                    address(stargazer),
                    superfluidIndex,
                    new bytes(0) // ctx placeholder
                )
            ),
            new bytes(0)
        );
        hoax(charlie);
        host.callAgreement(
            ida,
            abi.encodeCall(
                ida.approveSubscription,
                (
                    impactToken,
                    address(stargazer),
                    superfluidIndex,
                    new bytes(0) // ctx placeholder
                )
            ),
            new bytes(0)
        );

        hoax(whale);
        impactToken.approve(address(stargazer), 30 ether);

        hoax(whale);
        stargazer.donate("foundry", 30 ether);

        uint256 bobBalance = impactToken.balanceOf(bob);
        uint256 charlieBalance = impactToken.balanceOf(charlie);

        assertEq(bobBalance, 10 ether);
        assertEq(charlieBalance, 20 ether);
    }
}
