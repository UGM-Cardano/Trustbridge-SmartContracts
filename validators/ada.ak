use cardano/assets.{AssetName, PolicyId, flatten}
use cardano/transaction.{Transaction}

// mockADA token name
const mock_ada_token_name: AssetName = "mockADA"

pub type MockADARedeemer {
  Mint { amount: Int }
  Burn { amount: Int }
}

validator mock_ada_policy {
  mint(redeemer: MockADARedeemer, policy_id: PolicyId, tx: Transaction) {
    // Flatten minted/burned assets
    let minted = tx.mint |> flatten
    when redeemer is {
      Mint { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_ada_token_name, amount)]
        minted == expected
      }
      Burn { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_ada_token_name, -amount)]
        minted == expected
      }
    }
  }

  else(_) {
    fail
  }
}
