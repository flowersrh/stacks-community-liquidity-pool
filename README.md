# Stacks Community Liquidity Pool Smart Contract

## Overview

The **Stacks Community Liquidity Pool** is a Clarity smart contract built for the Stacks blockchain that enables users to deposit STX into a shared pool for collective use—such as yield farming, community funding, or protocol liquidity support. This contract helps bootstrap decentralized ecosystems by allowing communities to pool resources in a transparent and trustless manner.

## Features

- 💧 **Liquidity Pooling**: Users can deposit and withdraw STX from a common liquidity vault.
- 📊 **Share Tracking**: Accurately tracks each user's share in the pool for fair reward distribution.
- 💸 **Reward Distribution**: Supports proportional distribution of earnings or incentives to liquidity providers.
- 🔐 **On-Chain Transparency**: Every deposit, withdrawal, and balance is recorded and publicly auditable.
- 👥 **Community-Driven**: Ideal for DAOs, grant funds, and ecosystem bootstrapping efforts.

## Core Functions

- `deposit`: Allows users to contribute STX to the pool and receive share units.
- `withdraw`: Enables users to redeem their share of the pool's STX balance.
- `distribute-reward`: Distributes additional rewards proportionally across participants.
- `get-user-share`: Returns a user's current share in the pool.
- `get-total-pool-balance`: Returns the total balance of STX in the pool.

## Use Cases

- DAO-managed treasury pools
- Community grant and incentive funding
- Protocol-level liquidity support
- Shared yield vaults or farming rewards

## Development & Testing

Developed using [Clarinet](https://docs.stacks.co/docs/clarity/clarinet/overview/), the official development framework for Clarity smart contracts.

### Run Tests

```bash
clarinet test
