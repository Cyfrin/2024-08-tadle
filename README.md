# Tadle Protocol



### Prize Pool

- Total Pool - $30,000
- H/M -  $25,000
- Low - $2,750
- Community Judging - $2,250

- Starts: August 05, 2024 Noon UTC
- Ends: August 12, 2024 Noon UTC

- nSLOC: 1229

[//]: # (contest-details-open)

## About the Project


Tadle is a cutting-edge pre-market infrastructure designed to unlock illiquid assets in the crypto pre-market.

Our first product, the Points Marketplace, empowers projects to unlock the liquidity and value of points systems before conducting the Token Generation Event (TGE). By facilitating seamless trading and providing a secure, trustless environment, Tadle ensures that your community can engage with your tokens and points dynamically and efficiently.

- [Documentation](https://tadle.gitbook.io/tadle)
- [Website](https://tadle.com)
- [Twitter](https://x.com/tadle_com)
- [GitHub](https://github.com/tadle-com/market-evm)


## Actors

```
Maker
- Create buy offer
- Create sell offer
- Cancel your offer
- Abort your offer

Taker
- Place taker orders
- Relist stocks as new offers

Sell Offer Maker
- Deliver tokens during settlement

General User
- Fetch balances info
- Withdraw funds from your balances

Admin (Trust)
- Create a marketplace
- Take a marketplace offline
- Initialize system parameters, like WETH contract address, referral commission rate, etc.
- Set up collateral token list, like ETH, USDC, LINK, ankrETH, etc.
- Set `TGE` parameters for settlement, like token contract address, TGE time, etc.
- Grant privileges for users’ commission rates
- Pause all the markets

```

[//]: # (contest-details-close)

[//]: # (scope-open)

## Scope (contracts)

```js
src
├── core
│   ├── CapitalPool.sol
│   ├── DeliveryPlace.sol
│   ├── PreMarkets.sol
│   ├── SystemConfig.sol
│   └── TokenManager.sol
├── factory
│   ├── ITadleFactory.sol
│   └── TadleFactory.sol
├── interfaces
│   ├── ICapitalPool.sol
│   ├── IDeliveryPlace.sol
│   ├── IPerMarkets.sol
│   ├── ISystemConfig.sol
│   └── ITokenManager.sol
├── libraries
│   ├── MarketPlaceLibraries.sol
│   └── OfferLibraries.sol
└── storage
    ├── CapitalPoolStorage.sol
    ├── DeliveryPlaceStorage.sol
    ├── OfferStatus.sol
    ├── PerMarketsStorage.sol
    ├── SystemConfigStorage.sol
    └── TokenManagerStorage.sol
```

## Compatibilities

```
Compatibilities:
  Blockchains:
      - Ethereum/Any EVM
  Tokens:
      - ETH
      - WETH
      - ERC20 (any token that follows the ERC20 standard)
```

[//]: # (scope-close)

[//]: # (getting-started-open)

## Setup

Prerequisites:

```bash
forge install OpenZeppelin/openzeppelin-contracts
```

Build:

```bash
forge build
```

Tests:

```bash
forge test -vvv
```

[//]: # (getting-started-close)

[//]: # (known-issues-open)

## Known Issues

No known issues reported.

**Additional Known Issues, as detected by LightChaser, can be found [here](https://github.com/Cyfrin/2024-08-tadle/issues/1).**

[//]: # (known-issues-close)
