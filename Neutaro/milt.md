## Consensus Key Rotation (Emergency)

*(priv_validator_key.json is lost, overwritten, or truncated)*

### This applies **ONLY IF**

* `priv_validator_key.json` was:

  * overwritten
  * partially saved
  * truncated
  * lost
* Or you are unsure if it’s valid

> **This was the situation in the incident discussed.**

---

### Why rotation is required

* A corrupted signing key is **cryptographically unsafe**
* Tendermint cannot guarantee correct signing
* Attempting to “fix” or reuse it risks **double-sign slashing**
* The key **cannot be repaired**

---

## ✅ Correct Fix: Rotate Consensus Key On-Chain

### 1. Permanently stop the old node

```bash
sudo systemctl stop Neutaro
sudo systemctl disable Neutaro
```

⚠️ **Never start it again**

---

### 2. Prepare a new node (fresh machine or clean install)

https://github.com/Neutaro/Neutaro/blob/main/Instructions/NeutaroInstallation.md

```bash
Neutaro init <NEW_MONIKER> --chain-id Neutaro-1
```

Configure `config.toml` and `app.toml`, then sync fully:

```bash
sudo systemctl start Neutaro
```

Wait until:

```bash
Neutaro status | jq '.sync_info.catching_up'
# must be false
```

---

### 3. Extract the new consensus public key

```bash
Neutaro tendermint show-validator
```

Example output:

```json
{"@type":"/cosmos.crypto.ed25519.PubKey","key":"BASE64KEY=="}
```

Save this as `NEW_PUBKEY`.

---

### 4. Identify validator wallet & valoper

```bash
Neutaro keys list
WALLET=<your_wallet_name>
VALOPER=$(Neutaro keys show $WALLET --bech val -a)
```

Confirm validator exists:

```bash
Neutaro q staking validator $VALOPER -o json
```

---

### 5. Rotate consensus key on-chain

```bash
Neutaro tx staking rotate-cons-pubkey "$VALOPER" '<NEW_PUBKEY>' \
  --from $WALLET \
  --chain-id Neutaro-1 \
  --gas auto \
  --gas-adjustment 1.3 \
  --fees 1000uneutaro
```

Wait for confirmation.

---

### 6. Verify rotation

```bash
Neutaro q staking validator $VALOPER -o json | jq '.consensus_pubkey'
Neutaro tendermint show-validator
```

**They must match exactly.**

---

### 7. Start signing again

```bash
sudo systemctl enable Neutaro
sudo systemctl restart Neutaro
```

Monitor:

```bash
Neutaro status | jq '.validator_info'
```

---

## 🚫 Absolute Warnings

* ❌ Never reuse a truncated `priv_validator_key.json`
* ❌ Never bring the old node online after rotation
* ❌ Never run two nodes with the same validator identity
* ❌ Never rotate keys unless the original key is lost or unsafe

---

## Quick Decision Table (printable)

| Situation                        | Correct Action           |
| -------------------------------- | ------------------------ |
| AppHash mismatch, keys untouched | Rebuild state only       |
| Node stuck at height             | State sync / resync      |
| priv key overwritten / truncated | **Rotate consensus key** |
| Lost priv_validator_key.json     | **Rotate consensus key** |
| Double-sign risk                 | **Rotate consensus key** |

---

## Final takeaway (one sentence)

> **State problems → rebuild state.
> Key problems → rotate keys.
> Never mix the two.**

