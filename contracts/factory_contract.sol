//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./basic_token.sol";
import "./basic_nft.sol";
import "./owners_registry.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TokenFactory is Ownable, OwnersRegistry {
    address public superAddress;

    ERC20Token[] deployedERC20Tokens;
    NftToken[] deployedNftTokens;

    // Creation Events
    event NftCreated(address nftAddress, address ownerAddress);
    event ERC20Created(address erc20Address, address ownerAddress);

    // Puase Events
    event ContractPaused(address erc20Address, uint256 timeStamp);
    event AllContractsPaused(address owner, uint256 timeStamp);

    // UnPause Events
    // event ContractUnPaused(address erc20Address, uint256 timeStamp);
    // event AllContractsUnPaused(address owner, uint256 timeStamp);


    constructor(address _address) {
        superAddress = _address;
    }

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) public {
        address clonedTokenAddress = Clones.clone(superAddress);
        ERC20Token token = ERC20Token(clonedTokenAddress);
        token.initialize(_name, _symbol, _initialSupply, msg.sender);
        deployedERC20Tokens.push(token);
        // set deployer of this contract
        setERC20TokenOwner(clonedTokenAddress, msg.sender);

        emit ERC20Created(clonedTokenAddress, msg.sender);
    }

    function createNFT(string memory _name, string memory _symbol) public {
        address clonedNftAddress = Clones.clone(superAddress);
        NftToken nft = NftToken(clonedNftAddress);
        nft.initialize(_name, _symbol);
        deployedNftTokens.push(nft);
        // get deployer of this contract
        setNFTTokenOwner(clonedNftAddress, msg.sender);

        emit NftCreated(clonedNftAddress, msg.sender);
    }

    function pauseNFTContract(address _contractAddress) external onlyOwner {
        NftToken nftToken = NftToken(_contractAddress);
        nftToken.puaseContract();

        emit ContractPaused(_contractAddress, block.timestamp);
    }

    function pauseERC20Contract(address _contractAddress) public onlyOwner {
        ERC20Token erc20Token = ERC20Token(_contractAddress);
        erc20Token.puaseContract();

        emit ContractPaused(_contractAddress, block.timestamp);
    }

    function pauseAllContracts() external onlyOwner {
        if (deployedNftTokens.length == deployedERC20Tokens.length) {
            // Pause both tokens
            for (uint256 index = 0; index < deployedNftTokens.length; index++) {
                // Pause NFT Tokens
                deployedNftTokens[index].puaseContract();

                // PausERc20 Token
                deployedERC20Tokens[index].puaseContract();
            }
        } else {
            // Pause only NftToken
            for (uint256 index = 0; index < deployedNftTokens.length; index++) {
                deployedNftTokens[index].puaseContract();
            }

            // Pause only ERc20Token
            for (uint256 index = 0; index < deployedERC20Tokens.length; index++) {
                deployedERC20Tokens[index].puaseContract();
            }
        }

        emit AllContractsPaused(msg.sender, block.timestamp);
    }


}
