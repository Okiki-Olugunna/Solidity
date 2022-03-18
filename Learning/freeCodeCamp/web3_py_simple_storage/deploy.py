from solcx import compile_standard, install_solc
import json
from web3 import Web3
import os
from dotenv import load_dotenv

load_dotenv()

install_solc("0.6.0")

with open("./SimpleStorage.sol", "r") as file:
    simple_storage_file = file.read()
    # print(simple_storage_file)


# Compile soldiity contract
compiled_sol = compile_standard(
    {
        "language": "Solidity",
        "sources": {"SimpleStorage.sol": {"content": simple_storage_file}},
        "settings": {
            "outputSelection": {
                "*": {"*": ["abi", "metadata", "evm.bytecode", "evm.sourceMap"]}
            }
        },
    },
    solc_version="0.6.0",
)

with open("compiled_code.json", "w") as file:
    json.dump(compiled_sol, file)


# Getting bytcode
bytecode = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["evm"][
    "bytecode"
]["object"]

# Getting ABI
abi = compiled_sol["contracts"]["SimpleStorage.sol"]["SimpleStorage"]["abi"]
# print(abi) - checking the code

# connecting to the blockchain
w3 = Web3(
    Web3.HTTPProvider("https://kovan.infura.io/v3/f655d5cb8d5548e79014be05a4ee9cbd")
)
chain_id = 42  # 1337 - Ganache  # netid 5777
my_address = "0x207A3Ceef5cB47E4CCAFd34FFe3E2858Db6334fC"
private_key = os.getenv("PRIVATE_KEY")


# Creating the contract in python
SimpleStorage = w3.eth.contract(abi=abi, bytecode=bytecode)
# print(SimpleStorage)
# getting latest transaction
nonce = w3.eth.getTransactionCount(my_address)
# print(nonce)

# Creating a transaction
transaction = SimpleStorage.constructor().buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce,
    }
)
# print(transaction)

# Signing the transaction
signed_txn = w3.eth.account.sign_transaction(transaction, private_key=private_key)
# print(signed_txn)

# Sending the signed transaction
print("Deploying contract...")
tx_hash = w3.eth.send_raw_transaction(signed_txn.rawTransaction)
tx_receipt = w3.eth.wait_for_transaction_receipt(tx_hash)
print("Contract is deployed.")


# Working with the contract
# Need: Contract Address & Contract ABI
simple_storage = w3.eth.contract(address=tx_receipt.contractAddress, abi=abi)

# calling a function - doesn't make a state change
# however transactions _do_ create a state change
# this is the initial value of the favourite number in the SimpleStorage contract
print(f"Initial stored value: {simple_storage.functions.retrieve().call()}")

# create transaction
store_transaction = simple_storage.functions.store(15).buildTransaction(
    {
        "chainId": chain_id,
        "gasPrice": w3.eth.gas_price,
        "from": my_address,
        "nonce": nonce + 1,  # a nonce can only be used once per transaction
    }
)

# sign the transaction
signed_store_tx = w3.eth.account.sign_transaction(
    store_transaction, private_key=private_key
)

# send the transaction
send_store_tx = w3.eth.send_raw_transaction(signed_store_tx.rawTransaction)
# wait for transaction to finish
print("Updating stored value...")
tx_receipt = w3.eth.wait_for_transaction_receipt(send_store_tx)

print(f"Updated stored value: {simple_storage.functions.retrieve().call()}")
