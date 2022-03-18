# importing the smart contract & the account we'll use to test
from brownie import accounts, SimpleStorage


def test_deploy():
    # Testing is separated into 3 categories: Arrange, Act, Assert
    # Arrange
    account = accounts[0]  # geting our account so we can make contracts
    # Act
    simple_storage = SimpleStorage.deploy({"from": account})  # deploying the contract
    starting_value = simple_storage.retrieve()  # calling the retrieve function
    expected = 0
    # Assert
    assert starting_value == expected


def test_updating_storage():
    # Arrange
    account = accounts[0]
    simple_storage = SimpleStorage.deploy({"from": account})  # deploying the contract

    # Act
    expected = 15
    simple_storage.store(expected, {"from": account})

    # Assert
    assert expected == simple_storage.retrieve()
