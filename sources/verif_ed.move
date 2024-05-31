module verif_ed::verif_ed {

  use sui::coin::{Self, Coin};
  use sui::balance;
  use sui::sui::SUI;
  
  /// The `VerifPool` struct represents a quizzer pool that holds a balance of SUI tokens.
  //VerifPool object which is the main pool in the sui_lotto and carries all the information 
  //about the sui deposits
  public struct  has key, store {
    /// Unique identifier for the quizzer pool.
    id: UID, 
    /// Balance of SUI tokens held in the quizzer pool.
    suiBalance: balance::Balance<SUI>
  }

  public fun create_lotto(ctx: &mut TxContext) {
    let object = VerifPool {
      id: object::new(ctx),
      suiBalance: balance::zero()
    };
    transfer::share_object(object);
  }

  public entry fun participate_lotto(coinToDeposit: Coin<SUI>, object: &mut VerifPool) {
    let balanceToAdd = coin::into_balance(coinToDeposit);
    balance::join(&mut object.suiBalance, balanceToAdd);
  }

public fun send_to_winner(amountToWithdraw: u64, object: &mut VerifPool, ctx: &mut TxContext): Coin<SUI> {
    let balanceToWithdraw = balance::split(&mut object.suiBalance, amountToWithdraw);
    coin::from_balance(balanceToWithdraw, ctx)
  }


}