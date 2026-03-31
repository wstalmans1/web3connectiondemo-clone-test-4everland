import { createWalletClient, createPublicClient, http } from 'viem';
import { privateKeyToAccount } from 'viem/accounts';
import { mainnet } from 'viem/chains';
import { namehash, normalize } from 'viem/ens';
import { encode } from '@ensdomains/content-hash';

const ENS_NAME = process.env.ENS_NAME;
const IPFS_CID = process.env.IPFS_CID;
const PRIVATE_KEY = process.env.ENS_MANAGER_PRIVATE_KEY;
const RPC_URL = process.env.RPC_URL;

if (!ENS_NAME || !IPFS_CID || !PRIVATE_KEY || !RPC_URL) {
  console.error('Required environment variables: ENS_NAME, IPFS_CID, ENS_MANAGER_PRIVATE_KEY, RPC_URL');
  process.exit(1);
}

const ENS_REGISTRY = '0x00000000000C2E074eC69A0dFb2997BA6C7d2e1e';

const registryAbi = [
  {
    name: 'resolver',
    type: 'function',
    stateMutability: 'view',
    inputs: [{ name: 'node', type: 'bytes32' }],
    outputs: [{ name: '', type: 'address' }],
  },
];

const resolverAbi = [
  {
    name: 'setContenthash',
    type: 'function',
    stateMutability: 'nonpayable',
    inputs: [
      { name: 'node', type: 'bytes32' },
      { name: 'hash', type: 'bytes' },
    ],
    outputs: [],
  },
];

async function updateENS() {
  const account = privateKeyToAccount(PRIVATE_KEY.startsWith('0x') ? PRIVATE_KEY : `0x${PRIVATE_KEY}`);

  const publicClient = createPublicClient({
    chain: mainnet,
    transport: http(RPC_URL),
  });

  const walletClient = createWalletClient({
    account,
    chain: mainnet,
    transport: http(RPC_URL),
  });

  const node = namehash(normalize(ENS_NAME));

  const resolverAddress = await publicClient.readContract({
    address: ENS_REGISTRY,
    abi: registryAbi,
    functionName: 'resolver',
    args: [node],
  });

  if (!resolverAddress || resolverAddress === '0x0000000000000000000000000000000000000000') {
    console.error(`No resolver found for ${ENS_NAME}`);
    process.exit(1);
  }

  const encoded = '0x' + encode('ipfs', IPFS_CID);

  console.log(`Updating ENS contenthash for ${ENS_NAME}`);
  console.log(`  Node: ${node}`);
  console.log(`  Resolver: ${resolverAddress}`);
  console.log(`  CID: ${IPFS_CID}`);
  console.log(`  Encoded: ${encoded}`);
  console.log(`  Account: ${account.address}`);

  const hash = await walletClient.writeContract({
    address: resolverAddress,
    abi: resolverAbi,
    functionName: 'setContenthash',
    args: [node, encoded],
  });

  console.log(`Transaction submitted: ${hash}`);
  console.log(`Waiting for confirmation...`);

  const receipt = await publicClient.waitForTransactionReceipt({ hash });
  console.log(`Confirmed in block ${receipt.blockNumber}`);
  console.log(`ENS contenthash updated successfully!`);
}

updateENS();
