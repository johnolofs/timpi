# 🪙 Neutaro

[Neutaro](https://github.com/Neutaro/Neutaro) is the Cosmos-SDK chain that powers Timpi governance and rewards. Run a node to:

* secure the network
* delegate or stake **NTMPI**
* vote on governance proposals (including ethical & operational decisions for Timpi search)
* (optionally) become a validator

> [!IMPORTANT]
> **Read the security guide first:** [Neutaro Security Guide](https://github.com/Neutaro/Neutaro/blob/main/Security%20Guide.md).

---

## 📥 Pick your platform

| Platform | Guide | Notes |
| --- | --- | --- |
| Linux server (x86_64) | [validator.md](validator.md) | Cosmovisor + State Sync (recommended), full validator setup |
| Raspberry Pi 4 / 5 (8 GB) | [raspberry-pi.md](raspberry-pi.md) | ARM64 build, snapshot-based sync |

---

## 🔌 Required port

Neutaro needs **TCP 26656** open to inbound peers.

```bash
sudo ufw allow 26656/tcp
sudo ufw reload
```

Forward the same port on your router to the node's LAN IP.

---

## 🪙 Token units & participation

```text
1 NTMPI = 1,000,000 uneutaro
```

Ways to participate:

* Hold NTMPI
* Delegate to an existing validator
* Run a full node
* Become a validator (after your node is fully synced)

### Delegate to a validator (optional)

```bash
Neutaro tx staking delegate <VALIDATOR_ADDRESS> 1000000uneutaro \
  --from YOUR_WALLET \
  --chain-id Neutaro-1
```

---

## 🆘 Support & resources

* [Neutaro/Neutaro](https://github.com/Neutaro/Neutaro) — main repository
* [Security Guide](https://github.com/Neutaro/Neutaro/blob/main/Security%20Guide.md)
* [Timpi Discord](https://discord.com/channels/946982023245992006)
