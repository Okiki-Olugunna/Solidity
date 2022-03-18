from brownie import accounts, SimpleStorage, config


def read_contract():
    # -1 always gets the most recent deployment #0 is the first deployment we make
    simple_storage = SimpleStorage[-1]
    # ABI & Address
    print(simple_storage.retrieve())


def main():
    read_contract()
