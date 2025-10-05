use cardano/assets.{AssetName, PolicyId, flatten}
use cardano/transaction.{Transaction}

// Token name
const mock_jpyc_token_name: AssetName = "mockJPYC"

// Redeemer type - made public
pub type MockJPYCRedeemer {
  Mint { amount: Int }
  Burn { amount: Int }
}

validator mock_jpyc_policy {
  mint(redeemer: MockJPYCRedeemer, policy_id: PolicyId, tx: Transaction) {
    // Flatten minted/burned assets
    let minted = tx.mint |> flatten
    when redeemer is {
      Mint { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_jpyc_token_name, amount)]
        minted == expected
      }
      Burn { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_jpyc_token_name, -amount)]
        minted == expected
      }
    }
  }

  else(_) {
    fail
  }
}
