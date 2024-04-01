## Why was SafeERC20 Developed

SafeERC20 is a series of wrappers around ERC20 operations that throw on failure.

#### Return Values

ERC20 transfer, tranferFrom and approve functions are supposed to return a boolean upon succeeding.
However, they sometimes may not.
SafeERC20 has wrappers that throw on failure.
SafeERC20 supports tokens that return no value and instead revert or throw on failure. Non reverting calls are assumed to be successful.

#### Wrapper Functions

    safeTransfer(token, to, value)

    safeTransferFrom(token, from, to, value)

    safeApprove(token, spender, value)

    safeIncreaseAllowance(token, spender, value)

    safeDecreaseAllowance(token, spender, value)

##### When to use SafeERC20

SafeERC20 is crucial when contract logic strictly depends on the success of token transfers or approvals, offering enhanced error handling and security.
It is best to use when you are dealing with a wide array of ERC20 tokens that may not adhere to the token standard.
