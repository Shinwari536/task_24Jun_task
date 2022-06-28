//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/security/PausableUpgradeable.sol";
import "./interfaces/IFactoryContract.sol";
import "@openzeppelin/contracts-upgradeable/token/ERC20/ERC20Upgradeable.sol";

contract ERC20Token is ERC20Upgradeable, OwnableUpgradeable, PausableUpgradeable {
    // string private tokenName;
    // string private tokenSymbol;

    IFactoryContract private iFactory;

    modifier NotPauseAllContracts() {
        require(
            iFactory.getPauseAllStatus() == true,
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
        _transferOwnership(_recipient);
        _mint(_recipient, _initialSupply);
    }

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

    function burnNft(address _account, uint256 _amount) public {
        _burn(_account, _amount);
    }
}
