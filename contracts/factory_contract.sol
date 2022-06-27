//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "./basic_token.sol";
// import "./basic_nft.sol";
import "./owners_registry.sol";
import {Clones} from "@openzeppelin/contracts/proxy/Clones.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";

contract TokenFactory is Ownable, OwnersRegistry {
    address public superNftTokenAddress;
    address public superERC20TokenAddress;

    bool private pauseAllStatus;


    ERC20Token[] deployedERC20Tokens;
    // NftToken[] deployedNftTokens;

    // Creation Events
    event NftCreated(address nftAddress, address ownerAddress);
    event ERC20Created(address erc20Address, address ownerAddress);

    // Puase Events
    event ContractPaused(address erc20Address, uint256 timeStamp);
    event AllContractsPaused(address owner, uint256 timeStamp);

    // UnPause Events
    // event ContractUnPaused(address erc20Address, uint256 timeStamp);
    // event AllContractsUnPaused(address owner, uint256 timeStamp);


    constructor(address _nftaddress, address _erc20address) {
        pauseAllStatus = true;
        superNftTokenAddress = _nftaddress;
        superERC20TokenAddress = _erc20address;
    }

    function setPauseAllStatus(bool _status) public onlyOwner {
        pauseAllStatus = _status;
    }

    function getPauseAllStatus() external view  returns(bool){
        return pauseAllStatus;
    }

    function createToken(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply
    ) public {
        address clonedTokenAddress = Clones.clone(superERC20TokenAddress);
        ERC20Token token = ERC20Token(clonedTokenAddress);
        token.initialize(_name, _symbol, _initialSupply, msg.sender, address(this));
        deployedERC20Tokens.push(token);
        // set deployer of this contract
        setERC20TokenOwner(clonedTokenAddress, msg.sender);

        emit ERC20Created(clonedTokenAddress, msg.sender);
    }

    // function createNFT(string memory _name, string memory _symbol) public {
    //     address clonedNftAddress = Clones.clone(superNftTokenAddress);
    //     NftToken nft = NftToken(clonedNftAddress);
    //     nft.initialize(_name, _symbol, address(this));
    //     deployedNftTokens.push(nft);
    //     // get deployer of this contract
    //     setNFTTokenOwner(clonedNftAddress, msg.sender);

    //     emit NftCreated(clonedNftAddress, msg.sender);
    // }

    // function pauseNFTContract(address _contractAddress) external onlyOwner {
    //     // NftToken nftToken = NftToken(_contractAddress);
    //     nftToken.puaseContract();

    //     emit ContractPaused(_contractAddress, block.timestamp);
    // }

    function pauseERC20Contract(address _contractAddress) public onlyOwner {
        ERC20Token erc20Token = ERC20Token(_contractAddress);
        erc20Token.puaseContract();

        emit ContractPaused(_contractAddress, block.timestamp);
    }

}
