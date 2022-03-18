from brownie import accounts, SimpleStorage, network, config


def deploy_simple_storage():
    account = get_account()  # accounts[0] is a local ganache
    # print(account)
    # account = accounts.load("freecodecamp-account") # - metamask  dev account
    # print(account)
    # account = accounts.add(config["wallets"]["from_key"]) # better way, however will need to import config
    # print(account)
    simple_storage = SimpleStorage.deploy({"from": account})
    # print(simple_storage)
    stored_value = simple_storage.retrieve()
    print(f"This is the initial stored value: {stored_value}")
    transaction = simple_storage.store(15, {"from": account})
    print("Updating the stored value...")
    transaction.wait(1)  # waiting for 1 block
    updated_stored_value = simple_storage.retrieve()
    print(f"This is the new value: {updated_stored_value}")


def get_account():
    if network.show_active() == "development":
        return accounts[0]
    else:
        return accounts.add(config["wallets"]["from_key"])


def main():
    deploy_simple_storage()
