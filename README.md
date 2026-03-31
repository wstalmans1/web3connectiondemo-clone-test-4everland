# Web3 Connection Demo with RainbowKit v2

A simple, modern webpage with Web3 wallet connection using RainbowKit v2, wagmi, Vite, and React.

## Live Demo

The frontend is available at: [https://web3connectiondemo.eth.limo](https://web3connectiondemo.eth.limo)

## Features

- 🔗 **RainbowKit v2** - Beautiful wallet connection UI
- 🦊 **Multiple Wallets** - Support for MetaMask, WalletConnect, Coinbase Wallet, and more
- 🌐 **Multi-Chain** - Ethereum, Sepolia, Polygon, Optimism, Arbitrum, and Base
- 🎨 **Modern UI** - Clean, responsive design with dark mode support
- ⚡ **Vite** - Fast build tool and dev server
- ⚛️ **React 18** - Latest React with TypeScript

## Getting Started

### Prerequisites

- Node.js 18+ 
- pnpm (recommended) or npm/yarn

### Installation

1. Install dependencies:
```bash
pnpm install
```

2. Get a WalletConnect Project ID:
   - Visit [WalletConnect Cloud](https://cloud.walletconnect.com/)
   - Sign up for a free account
   - Create a new project and copy your Project ID

3. Create a `.env` file in the root directory:
```bash
VITE_WALLETCONNECT_PROJECT_ID=your_project_id_here
```

### Running the Development Server

```bash
pnpm dev
```

Open [http://localhost:5173](http://localhost:5173) in your browser to see the result.

### Building for Production

```bash
pnpm build
pnpm preview
```

## Project Structure

```
├── src/
│   ├── App.tsx          # Main app component
│   ├── main.tsx         # Entry point
│   ├── providers.tsx    # RainbowKit and wagmi providers
│   └── index.css        # Global styles
├── index.html           # HTML template
├── vite.config.ts       # Vite configuration
└── package.json         # Dependencies
```

## Technologies Used

- [Vite](https://vitejs.dev/) - Next generation frontend tooling
- [React](https://react.dev/) - UI library
- [TypeScript](https://www.typescriptlang.org/) - Type safety
- [RainbowKit v2](https://rainbowkit.com/) - Wallet connection UI
- [wagmi](https://wagmi.sh/) - React Hooks for Ethereum
- [viem](https://viem.sh/) - TypeScript Ethereum library
- [Tailwind CSS](https://tailwindcss.com/) - Styling

## License

MIT

