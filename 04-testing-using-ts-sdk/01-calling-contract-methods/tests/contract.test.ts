import { launchTestNode, TestAssetId } from 'fuels/test-utils';

import { describe, test, expect } from 'vitest';

import { CallingContractsFactory } from '../abi_types';

describe('Calling contract methods', () => {
  test('Call non-payable method', async () => {
    using testNode = await launchTestNode({
      contractsConfigs: [
        {
          factory: CallingContractsFactory,
        },
      ],
    });

    const {
      contracts: [contract],
    } = testNode;

    const { waitForResult: nonPayableCallWaitForResult } = await contract.functions.non_payable_call().call();
    const { value: callInfo } = await nonPayableCallWaitForResult();

    console.log(callInfo);

    expect(callInfo.caller_is_external).toBe(true);
    expect(callInfo.amount.toNumber()).toBe(0);
    expect(callInfo.asset_id.bits).toBe('0x0000000000000000000000000000000000000000000000000000000000000000');
  });

  test('Call payable method', async () => {
    using testNode = await launchTestNode({
      walletsConfig: {
        count: 2,
        assets: [TestAssetId.A, TestAssetId.B],
        coinsPerAsset: 1,
        amountPerCoin: 10_000,
      },
      contractsConfigs: [
        {
          factory: CallingContractsFactory,
          walletIndex: 0,
        },
      ],
    });

    const {
      wallets: [_deployerWallet, userWallet],
      contracts: [contract],
    } = testNode;

    contract.account = userWallet;

    const { waitForResult: payableCallWaitForResult } = await contract
      .functions
      .payable_call()
      .callParams({
        forward: [4422, TestAssetId.A.value],
      })
      .call();
    const { value: callInfo } = await payableCallWaitForResult();

    console.log(callInfo);

    expect(callInfo.caller_is_external).toBe(true);
    expect(callInfo.caller.Address?.bits.toUpperCase()).toBe(userWallet.address.toString().toUpperCase());
    expect(callInfo.amount.toNumber()).toBe(4422);
    expect(callInfo.asset_id.bits).toBe(TestAssetId.A.value);

    expect((await userWallet.getCoins(TestAssetId.A.value)).coins[0].amount.toNumber()).toBe(10_000 - 4422);
    expect((await userWallet.getCoins(TestAssetId.B.value)).coins[0].amount.toNumber()).toBe(10_000);
  });
});
