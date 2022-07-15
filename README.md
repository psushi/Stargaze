# Stargaze ✨
A simple, seamless way to support your favorite opensource project. Built at the ETH NYC hackathon. <br>
We ♥️ open-source and Gitcoin and wanted to build a framework using the best qualities of both.

Won 1st place for Optimism (most optimistic hack) and Superfluid (best project) at [ETH NYC 2022](https://nyc.ethglobal.co). <br>
Submission link: [ethglobal/stargaze](https://ethglobal.com/showcase/stargaze-igmkq)


# tldr
An extremely simple way to:
- Distribute funds between contributors of an open-source project. 
- Fund your favorite open-source project from the command line! (UI coming soon, haven't slept in 30 hours). 

# What and Why
Stargaze was made to preserve the way open source teams work while enabling a new way of rewarding contributors retroactively. 

Today, open source projects are based on voluntary contributions from a passionate group of people. While these contributors do not seek financial gain for their contributions, the donations made to these projects rarely reach many of the downstream developers and contributors that have created and maintain them.

We aim to solve that problem. With Stargaze, contributors submit pull requests as they normally would. Moderators, responsible for merging code, audit it, tag it and value it. When a merge takes place, an on-chain attestation is issued. 

Stargaze currently integrates with SuperFluid to instantly distribute funds to contributors when donations to projects are made by supporters. In this current implementation, Stargaze uses a basic metric to value contributions and calculate an impact score representing a contributor’s share of the total value created. He or she receives donations proportionately to his or her share.

Stargaze has no UI and can be integrated with just a couple of lines of code. Open source project workflows are untouched and take place through Github as they would normally.

Funds are *instantly* distributed to *all* contributors of the project, in a fair and transaparent manner. 


# How

- Contributors open a PR and share their wallet address in the slightly modified PR template. 
- When a PR is merged, a github workflow is run, using metrics like user defined `PR labels` (priority, difficulty, etc), `addtions`, `deletions` etc, a score is calculated and then updated on-chain on the `Stargazer` contract. 
- How the score is calculated is entirely upto the maintainers. It's publicly visible in the workflow yaml file.
- When someone funds the project it is *instanly distributed* among *all* contributors proportional to their contributions captured on-chain using SuperFluid IDA. Boom.
- Contributors can track all their earnings and on-chain shares in their personal [SuperFluid dashboard](https://app.superfluid.finance/dashboard). 
<img width="1512" alt="Screenshot 2022-06-26 at 8 25 29 AM" src="https://user-images.githubusercontent.com/22870103/175814123-6a93dd82-2926-447c-881c-e77a0e2c7680.png">





What's beautiful about Stargaze is that *almost nothing* is added to the usual open-source work cycle. 

- Make a one-time smart contract interaction to initiate your repo.
- Add a ~15 line workflow to your github repo.
- Make a tiny change to your pull request template. 
- That's it. Now you're using the Stargaze framework. People can now donate to your project and the funds will be distributed among all contributors proportional to their contributions. 
- 
This Stargaze contract repo also uses the Stargaze framework! Checkout the workflow `stargazer.yml` to see a simple implementation (just using additions for calculating scores). Hope it's clear how powerful it would be to use a sophisticated metric. 

# Fund your favorite project from the command line
It's as simple as ```sh donate.sh "foundry" 500```. Donate script is shared in the repo, users familiar with `Foundry` should have no trouble setting their donation up.


