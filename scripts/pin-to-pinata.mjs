import fs from 'fs';
import path from 'path';
import { Readable } from 'stream';

const PINATA_JWT = process.env.PINATA_JWT;
const DIST_DIR = path.resolve('dist');
const PIN_NAME = process.env.PIN_NAME || `web3connectiondemo.eth - ${new Date().toISOString()}`;

if (!PINATA_JWT) {
  console.error('PINATA_JWT environment variable is required');
  process.exit(1);
}

function getAllFiles(dir, baseDir = dir) {
  const entries = fs.readdirSync(dir, { withFileTypes: true });
  const files = [];
  for (const entry of entries) {
    const fullPath = path.join(dir, entry.name);
    if (entry.isDirectory()) {
      files.push(...getAllFiles(fullPath, baseDir));
    } else {
      files.push({
        absPath: fullPath,
        relPath: path.relative(baseDir, fullPath),
      });
    }
  }
  return files;
}

async function pin() {
  const files = getAllFiles(DIST_DIR);
  const formData = new FormData();

  for (const file of files) {
    const content = fs.readFileSync(file.absPath);
    const blob = new Blob([content]);
    formData.append('file', blob, `dist/${file.relPath}`);
  }

  formData.append('pinataOptions', JSON.stringify({ cidVersion: 1 }));
  formData.append('pinataMetadata', JSON.stringify({ name: PIN_NAME }));

  console.log(`Uploading ${files.length} files from dist/ to Pinata...`);

  const response = await fetch('https://api.pinata.cloud/pinning/pinFileToIPFS', {
    method: 'POST',
    headers: { Authorization: `Bearer ${PINATA_JWT}` },
    body: formData,
  });

  if (!response.ok) {
    const text = await response.text();
    console.error(`Pinata upload failed (${response.status}): ${text}`);
    process.exit(1);
  }

  const result = await response.json();
  const cid = result.IpfsHash;

  console.log(`Pinned successfully!`);
  console.log(`CID: ${cid}`);
  console.log(`Gateway: https://gateway.pinata.cloud/ipfs/${cid}`);

  if (process.env.GITHUB_OUTPUT) {
    fs.appendFileSync(process.env.GITHUB_OUTPUT, `cid=${cid}\n`);
  }
}

pin();
