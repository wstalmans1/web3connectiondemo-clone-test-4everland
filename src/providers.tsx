import '@rainbow-me/rainbowkit/styles.css';
import { RainbowKitProvider, connectorsForWallets } from '@rainbow-me/rainbowkit';
import { injectedWallet, walletConnectWallet } from '@rainbow-me/rainbowkit/wallets';
import { WagmiProvider, createConfig, http } from 'wagmi';
import { mainnet, polygon, optimism, arbitrum, base, sepolia } from 'wagmi/chains';
import { QueryClientProvider, QueryClient } from '@tanstack/react-query';
import { ReactNode } from 'react';

const projectId = import.meta.env.VITE_WALLETCONNECT_PROJECT_ID || '';

const connectors = connectorsForWallets(
  [{ groupName: 'Wallets', wallets: [injectedWallet, walletConnectWallet] }],
  { appName: 'Web3 Connection Demo', projectId },
);

const config = createConfig({
  chains: [mainnet, sepolia, polygon, optimism, arbitrum, base],
  connectors,
  transports: {
    [mainnet.id]:  http(import.meta.env.VITE_RPC_MAINNET  || undefined),
    [sepolia.id]:  http(import.meta.env.VITE_RPC_SEPOLIA  || undefined),
    [polygon.id]:  http(import.meta.env.VITE_RPC_POLYGON  || undefined),
    [optimism.id]: http(import.meta.env.VITE_RPC_OPTIMISM || undefined),
    [arbitrum.id]: http(import.meta.env.VITE_RPC_ARBITRUM || undefined),
    [base.id]:     http(import.meta.env.VITE_RPC_BASE     || undefined),
  },
});

const queryClient = new QueryClient();

export function Providers({ children }: { children: ReactNode }) {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <RainbowKitProvider>
          {children}
        </RainbowKitProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
}

