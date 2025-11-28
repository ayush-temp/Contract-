// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title TrackChain
 * @dev A simple supply-tracking smart contract that records product creation 
 *      and ownership transfers on-chain.
 */
contract TrackChain {

    struct Product {
        uint256 id;
        string name;
        address currentOwner;
        uint256 timestamp;
    }

    uint256 private nextId = 1;
    mapping(uint256 => Product) public products;

    event ProductCreated(uint256 indexed id, string name, address indexed creator);
    event OwnershipTransferred(uint256 indexed id, address indexed from, address indexed to);

    /**
     * @notice Create a new product entry on-chain.
     * @param _name The name of the product.
     */
    function createProduct(string memory _name) external {
        products[nextId] = Product({
            id: nextId,
            name: _name,
            currentOwner: msg.sender,
            timestamp: block.timestamp
        });

        emit ProductCreated(nextId, _name, msg.sender);
        nextId++;
    }

    /**
     * @notice Transfer ownership of a product to another address.
     * @param _id The product ID.
     * @param _newOwner The address receiving ownership.
     */
    function transferOwnership(uint256 _id, address _newOwner) external {
        require(products[_id].id != 0, "Product does not exist");
        require(products[_id].currentOwner == msg.sender, "Not product owner");
        require(_newOwner != address(0), "Invalid new owner");

        address previousOwner = products[_id].currentOwner;
        products[_id].currentOwner = _newOwner;

        emit OwnershipTransferred(_id, previousOwner, _newOwner);
    }

    /**
     * @notice Get details of a stored product.
     * @param _id The product ID.
     * @return Product struct with full metadata.
     */
    function getProduct(uint256 _id) external view returns (Product memory) {
        require(products[_id].id != 0, "Product does not exist");
        return products[_id];
    }
}
