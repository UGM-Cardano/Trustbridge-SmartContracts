use cardano/assets.{AssetName, PolicyId, flatten}
use cardano/transaction.{Transaction}

// mockUSDC token name
const mock_usdc_token_name: AssetName = "mockUSDC"

pub type MockUSDCRedeemer {
  Mint { amount: Int }
  Burn { amount: Int }
}

validator mock_usdc_policy {
  mint(redeemer: MockUSDCRedeemer, policy_id: PolicyId, tx: Transaction) {
    // Flatten minted/burned assets
    let minted = tx.mint |> flatten
    when redeemer is {
      Mint { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_usdc_token_name, amount)]
        minted == expected
      }
      Burn { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_usdc_token_name, -amount)]
        minted == expected
      }
    }
  }

  else(_) {
    fail
  }
}
