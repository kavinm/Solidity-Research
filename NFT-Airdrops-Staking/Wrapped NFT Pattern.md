## Wrapped NFT Pattern

The wrapped NFT contract (OZ implementation: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/extensions/ERC721Wrapper.sol) allows a contract to take in an ERC721 and mint a corresponding NFT with the same tokenID.

Depositing the wrapped NFT in the contract and then using the new NFT prevents the royalties from going to the original creator.
This was suggested to be used to create a new Pudgy Penguins collection in which old users would deposit into the wrapper and get new wrapped PPs (haha PP).

#### Use cases

- Liquidity provisioning: Users can wrap an NFT, have it be held in the wrapper contract and still trade the wrapped NFT.
- Staking contract: The wrapper contract can act as a staking contract which holds the original NFT and gives out rewards to the user.
