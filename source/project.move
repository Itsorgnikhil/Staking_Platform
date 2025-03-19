module MyModule::StakingPlatform {

    use aptos_framework::signer;
    use aptos_framework::coin;
    use aptos_framework::aptos_coin::AptosCoin;

    /// Struct representing a staking pool.
    struct StakingPool has store, key {
        total_staked: u64,
    }

    /// Function to create a new staking pool.
    public fun create_pool(owner: &signer) {
        let pool = StakingPool {
            total_staked: 0,
        };
        move_to(owner, pool);
    }

    /// Function for users to stake tokens into the pool.
    public fun stake_tokens(staker: &signer, pool_owner: address, amount: u64) acquires StakingPool {
        let pool = borrow_global_mut<StakingPool>(pool_owner);

        // Transfer the staked amount from the user to the pool owner
        let stake = coin::withdraw<AptosCoin>(staker, amount);
        coin::deposit<AptosCoin>(pool_owner, stake);

        // Update the total staked amount
        pool.total_staked = pool.total_staked + amount;
    }
} 
