### How does OpenSea keep track of NFT Ownership?

Many NFTS don't use enumerable, which means there is no efficient way to check what NFTs a user owns in a collection.
Without enumerable, a user would have to balanceOf on an address and then loop through all tokenIDs and check ownerOf for each until they reach the balanceOf amount.

Events can be used instead to index and keep track of NFTs.

##### event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);

An NFT Marketplace can check the to address for a series of NFT collections and filter out all NFTS owned by a certain address.

Something like:
NFTContract.filters.Transfer(null, userAddress, null);
would return all transfers to the address and we can then update owners of nft contracts and the tokenIDs.

If I didn't want to actually scan the blockchain for all events, I could use the filter events and then use OwnerOf those tokenIDs to just verify that the user still owns those tokens.
