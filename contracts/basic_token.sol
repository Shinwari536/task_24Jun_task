//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "./interfaces/IFactoryContract.sol";

import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract ERC20Token is ERC20Upgradeable, Ownable, Pausable {
    // string private tokenName;
    // string private tokenSymbol;

    IFactoryContract private iFactory;

    modifier NotPauseAllContracts() {
        require(
            !iFactory.getPauseAllStatus(),
            "AllPauseable: All contracts are paused."
        );
        _;
    }


    function initialize(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _recipient,
        address _factoryAddress
    ) public initializer {
        iFactory = IFactoryContract(_factoryAddress);
        __ERC20_init(_name, _symbol);
        _mint(_recipient, _initialSupply);
    }


    function _msgSender() internal view virtual override(ContextUpgradeable, Context) returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual override(ContextUpgradeable, Context) returns (bytes calldata) {
        return msg.data;
    }

    // function __ERC20_init(
    //     string memory _name,
    //     string memory _symbol,
    //     uint256 _initialSupply,
    //     address _recipient
    // ) internal {
    //     tokenName = _name;
    //     tokenSymbol = _symbol;
    //     _mint(_recipient, _initialSupply);
    // }

    // function name() public view virtual override returns (string memory) {
    //     return tokenName;
    // }

    // function symbol() public view virtual override returns (string memory) {
    //     return tokenSymbol;
    // }

    function mintToken(address _recipient, uint256 _tokenToMint)
        external
        onlyOwner
        NotPauseAllContracts
        whenNotPaused
    {
        _mint(_recipient, _tokenToMint);
    }

    function puaseContract() public onlyOwner {
        _pause();
    }

    function unPuaseContract() public onlyOwner {
        _unpause();
    }
}
