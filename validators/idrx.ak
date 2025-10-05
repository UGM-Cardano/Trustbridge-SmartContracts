use cardano/assets.{AssetName, PolicyId, flatten}
use cardano/transaction.{Transaction}

// Backend authority public key hash
//const backend_authority: ByteArray =
//#"f4c9f9c4252d86702c2f4c2e49e6648c7cffe3c8f2b6b7d779788f50"

// Token name
const mock_idrx_token_name: AssetName = "mockIDRX"

// Redeemer type - made public
pub type MockIDRXRedeemer {
  Mint { amount: Int }
  Burn { amount: Int }
}

validator mock_idrx_policy {
  mint(redeemer: MockIDRXRedeemer, policy_id: PolicyId, tx: Transaction) {
    // Check signature
    //let is_signed = list.has(tx.extra_signatories)
    // Flatten minted/burned assets
    let minted = tx.mint |> flatten
    when redeemer is {
      Mint { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_idrx_token_name, amount)]
        minted == expected
      }
      Burn { amount } -> {
        expect amount > 0
        let expected = [(policy_id, mock_idrx_token_name, -amount)]
        minted == expected
      }
    }
  }

  else(_) {
    fail
  }
}
