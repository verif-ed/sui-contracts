module verif_ed::verif_ed {
 use std::string::String;
 use sui::table::{Self, Table};

  public struct VerifDir has key, store {
    id: UID, 
    table: Table<u64, Test>, 
    test_count: u64
  }

  public struct Test has store {
    candidates: Table<address, Status>,
    candidate_count: u64
  }

  // public struct AdminCap has key, store {
  //   id: UID
  // }

  public struct Status has store {
    test_id: u64, 
    name: String, 
    date_timestamp: u64, 
    tries: u64, 
    certificate_id: u64
  }

  // public struct Certificate has key {
  //   id: UID, 
  //   name: String,
  //   test_id: u64,
  // }

  fun init(ctx: &mut TxContext) {
    let new_dir = VerifDir {
      id: object::new(ctx),
      table: table::new(ctx),
      test_count: 0
    };
    transfer::share_object(new_dir);

    // transfer::transfer(
    //   AdminCap {
    //     id: object::new(ctx)
    //   }, 
    //   ctx.sender()
    // )
  }

  public entry fun add_test(test_dir: &mut VerifDir, ctx: &mut TxContext) {
    let new_test = Test {
      candidates: table::new(ctx),
      candidate_count: 0
    };

    table::add(
      &mut test_dir.table, 
      test_dir.test_count,
      new_test
    );

    test_dir.test_count = test_dir.test_count + 1;
  }

  public entry fun join_test(test_dir: &mut VerifDir, test_id: u64, name: String,certificate_id: u64, date_timestamp: u64, ctx: &mut TxContext) {
    let status = Status {
      name,
      date_timestamp,
      test_id,
      tries: 0, 
      certificate_id
    };

    let test = table::borrow_mut(
      &mut test_dir.table,
      test_id
    );

    table::add(
      &mut test.candidates, 
      ctx.sender(),
      status
    );

    test.candidate_count = test.candidate_count + 1;
  }
}
