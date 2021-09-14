// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

////////////////////////////////////
/// DO NOT USE IN PRODUCTION!!! ///
///////////////////////////////////

////////////////////////////
/// GENERAL INSTRUCTIONS ///
////////////////////////////

// 1. AT THE TOP OF EACH CONTRACT FILE, PLEASE LIST GITHUB LINKS TO ANY AND ALL REPOS YOU BORROW FROM THAT YOU DO NOT EXPLICITLY IMPORT FROM ETC.
// 2. PLEASE WRITE AS MUCH OR AS LITTLE CODE AS YOU THINK IS NEEDED TO COMPLETE THE TASK
// 3. LIBRARIES AND UTILITY CONTRACTS (SUCH AS THOSE FROM OPENZEPPELIN) ARE FAIR GAME

//////////////////////////////
/// CHALLENGE INSTRUCTIONS ///
//////////////////////////////

// 1. Fill in the contract's functions so that the unit tests pass in tests/Challenge.spec.ts
// 2. Please be overly explicit with your code comments
// 3. Since unit tests are prewritten, please do not rename functions or variables

// https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2Factory.sol
//

contract Challenge {
    uint256 public x;
    uint256 public y;
    uint256 public z;

    /// @dev delegate incrementX to the Incrementor contract below
    /// @param inc address to delegate increment call to
    function incrementX(address inc) external {
        // storage structure should be matched when delegatecall
        // Incrementor contract storage structure is same as Challenge contract
        // should call Incrementor.incrementY function to increase x
        // storage slot is not identified by the name of variable
        // but the type of variable and its declaration order
        (bool success, ) =
            inc.delegatecall(abi.encodeWithSignature("incrementY()"));
        require(success, "failed!");
    }

    /// @dev delegate incrementY to the Incrementor contract below
    /// @param inc address to delegate increment call to
    function incrementY(address inc) external {
        // same reason as in incrementX
        (bool success, ) =
            inc.delegatecall(abi.encodeWithSignature("incrementZ()"));
        require(success, "failed!");
    }

    /// @dev delegate incrementZ to the Incrementor contract below
    /// @param inc address to delegate increment call to
    function incrementZ(address inc) external {
        // same reason as in incrementX
        (bool success, ) =
            inc.delegatecall(abi.encodeWithSignature("incrementX()"));
        require(success, "failed!");
    }

    /// @dev determines if argument account is a contract or not
    /// @param account address to evaluate
    /// @return bool if account is contract or not
    function isContract(address account) external view returns (bool) {
        // NOTE: there is a securty issue here when this is called on contructor of contract
        // EXTCODESIZE returns 0 if it is called from the constructor of a contract
        uint32 size;
        assembly {
            size := extcodesize(account)
        }
        return (size > 0);
    }

    /// @dev converts address to uint256
    /// @param account address to convert
    /// @return uint256
    function addressToUint256(address account) external pure returns (uint256) {
        // from solidity v0.8, can no longer cast explicitly from address to uint256.
        return uint256(uint160(account));
    }

    /// @dev converts uint256 to address
    /// @param num uint256 number to convert
    /// @return address
    function uint256ToAddress(uint256 num) external pure returns (address) {
        // from solidity v0.8, can no longer cast explicitly from uint256 to address.
        return address(uint160(num));
    }

    /// @dev computes uniswapV2 pair address
    /// @param token0 address of first token in pair
    /// @param token1 address of second token in pair
    /// @return address of pair
    function getUniswapV2PairAddress(address token0, address token1)
        external
        pure
        returns (address)
    {
        // tokenA < tokenB, this condition is used to calculate to salt in UniswapV2Factory
        (address tokenA, address tokenB) =
            token0 < token1 ? (token0, token1) : (token1, token0);
        bytes32 salt = keccak256(abi.encodePacked(tokenA, tokenB));

        // UniswapV2Pair contract bytecode
        bytes32 bytecode =
            0x96e8ac4277198ff8b6f785478aa9a39f403cb768dd02cbee326c3e7da348845f;

        // NOTE: this is only valid when the contract is deployed using CREATE2
        bytes32 hashed =
            keccak256(
                abi.encodePacked(
                    bytes1(0xff),
                    0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f,
                    salt,
                    bytecode
                )
            );

        // NOTE: cast last 20 bytes of hash to address
        return address(uint160(uint256(hashed)));
    }
}
