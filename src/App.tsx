// Last sync: 2025-02-10
import { ConnectButton } from '@rainbow-me/rainbowkit';
import { useAccount, useBalance } from 'wagmi';
import { Providers } from './providers';

function AppContent() {
  const { address, isConnected } = useAccount();
  const { data: balance } = useBalance({
    address: address,
  });

  return (
    <main className="min-h-screen bg-gradient-to-br from-blue-50 via-white to-purple-50 dark:from-gray-900 dark:via-gray-800 dark:to-gray-900">
      <div className="container mx-auto px-4 py-16">
        <div className="max-w-4xl mx-auto">
          {/* Header */}
          <div className="text-center mb-12">
            <h1 className="text-5xl font-bold text-gray-900 dark:text-white mb-4">
              Web3 Connection Demo
            </h1>
            <p className="text-xl text-gray-600 dark:text-gray-300">
              Connect your wallet using RainbowKit v2
            </p>
          </div>

          {/* Connect Button Card */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-8 mb-8 border border-gray-200 dark:border-gray-700">
            <div className="flex flex-col items-center justify-center space-y-6">
              <div className="w-full flex justify-center">
                <ConnectButton />
              </div>
              
              {isConnected && (
                <div className="w-full mt-8 space-y-4">
                  <div className="bg-gradient-to-r from-blue-50 to-purple-50 dark:from-gray-700 dark:to-gray-700 rounded-lg p-6 border border-gray-200 dark:border-gray-600">
                    <h2 className="text-lg font-semibold text-gray-900 dark:text-white mb-4">
                      Connection Details
                    </h2>
                    <div className="space-y-3">
                      <div>
                        <p className="text-sm text-gray-600 dark:text-gray-400">Address</p>
                        <p className="text-sm font-mono text-gray-900 dark:text-white break-all">
                          {address}
                        </p>
                      </div>
                      {balance && (
                        <div>
                          <p className="text-sm text-gray-600 dark:text-gray-400">Balance</p>
                          <p className="text-lg font-semibold text-gray-900 dark:text-white">
                            {parseFloat(balance.formatted).toFixed(4)} {balance.symbol}
                          </p>
                        </div>
                      )}
                    </div>
                  </div>
                </div>
              )}
            </div>
          </div>

          {/* Info Section */}
          <div className="bg-white dark:bg-gray-800 rounded-2xl shadow-xl p-8 border border-gray-200 dark:border-gray-700">
            <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
              Features
            </h2>
            <ul className="space-y-3 text-gray-600 dark:text-gray-300">
              <li className="flex items-start">
                <span className="text-green-500 mr-2">✓</span>
                <span>RainbowKit v2 integration</span>
              </li>
              <li className="flex items-start">
                <span className="text-green-500 mr-2">✓</span>
                <span>Multiple wallet support (MetaMask, WalletConnect, Coinbase, etc.)</span>
              </li>
              <li className="flex items-start">
                <span className="text-green-500 mr-2">✓</span>
                <span>Multi-chain support (Ethereum, Polygon, Optimism, Arbitrum, Base)</span>
              </li>
              <li className="flex items-start">
                <span className="text-green-500 mr-2">✓</span>
                <span>Modern, responsive UI with dark mode support</span>
              </li>
              <li className="flex items-start">
                <span className="text-green-500 mr-2">✓</span>
                <span>Built with Vite + React + TypeScript</span>
              </li>
            </ul>
          </div>
        </div>

          {/* Footer */}
          <div className="text-center mt-8">
            <p className="text-xs text-gray-400 dark:text-gray-500">
              Build 2026-03-10 — Served via IPFS
            </p>
          </div>
      </div>
    </main>
  );
}

function App() {
  return (
    <Providers>
      <AppContent />
    </Providers>
  );
}

export default App;

