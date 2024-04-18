## How does ERC721A save gas?

### 1. Removing Storage Redundancies

ERC721a removes redundant storage of each tokens's metadata. It also guarantees all tokenIDs start at 0 and are incremented sequentially rather than being any arbitrary value.

### 2. Updating the owner's balance once per batch mint request

If minting multiple NFTs with a regular ERC721 contract, it changes the value of the balance only once. A regular ERC721 contract would change the balance separately for each mint. For example with 721: Alice mint token IDs 5-8: balance would be 5,6,7,8. With 721A: balance would be 5,8.

### 3. Updating the owner data once per batch mint request

Setting an owner for the tokens is done only for the first in the batch mint. The remaining are not changed and the ownerOf function checks only the lowestToken and assumes the others also belong to that owner

## Where does ERC721A add cost

It adds cost to the transfer functions later on which must now set the owner of the nft tokens. This is not so bad however as the mint can be done for cheap and later on when the gas prices are lower, they can be transferred or sold.

| Transaction Type    | ERC721     | ERC721A    |
| ------------------- | ---------- | ---------- |
| Batch Mint 5 Tokens | 155949 gas | 63748 gas  |
| Transfer 5 Tokens   | 226655 gas | 334450 gas |
