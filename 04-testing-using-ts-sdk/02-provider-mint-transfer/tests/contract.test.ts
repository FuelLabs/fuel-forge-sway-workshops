import { launchTestNode } from 'fuels/test-utils';

import { describe, test, expect } from 'vitest';

import { MintAndTransferFactory } from '../abi_types';
import { getMintedAssetId, Wallet, ZeroBytes32 } from 'fuels';

describe('Minting and transferring', () => {
  test('Test minting and transferring default asset', async () => {
    using testNode = await launchTestNode({
      contractsConfigs: [
        MintAndTransferFactory
      ]
    });

    const {
      contracts: [contract],
      provider,
    } = testNode;

    const default_asset_id = getMintedAssetId(contract.id.b256Address, ZeroBytes32);

    const initial_balance = await contract.getBalance(default_asset_id);
    expect(initial_balance.toNumber()).toBe(0);

    const { waitForResult: mint_default_asset } = await contract.functions.mint_default_asset(10_000).call();
    await mint_default_asset();

    const new_balance = await contract.getBalance(default_asset_id);
    expect(new_balance.toNumber()).toBe(10_000);

    const userWallet = Wallet.generate({ provider });

    const user_initial_balance = await userWallet.getBalance(default_asset_id);
    expect(user_initial_balance.toNumber()).toBe(0);

    const user_identity = { Address: { bits: userWallet.address.b256Address } };
    const { waitForResult: transfer_default_asset_to } = await contract.functions.transfer_default_asset_to(user_identity, 4422).call();
    await transfer_default_asset_to();

    const user_new_balance = await userWallet.getBalance(default_asset_id);
    expect(user_new_balance.toNumber()).toBe(4422);

    const latest_balance = await contract.getBalance(default_asset_id);
    expect(latest_balance.toNumber()).toBe(10_000 - 4422);
  });
});
