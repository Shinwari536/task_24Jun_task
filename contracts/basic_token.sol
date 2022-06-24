//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";

contract ERC20Token is ERC20, Ownable, Initializable, Pausable {
    string private tokenName;
    string private tokenSymbol;

    constructor() ERC20("", "") {}

    function initialize(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _recipient
    ) public initializer {
        __ERC20_init(_name, _symbol, _initialSupply, _recipient);
    }

    function __ERC20_init(
        string memory _name,
        string memory _symbol,
        uint256 _initialSupply,
        address _recipient
    ) internal {
        tokenName = _name;
        tokenSymbol = _symbol;
        _mint(_recipient, _initialSupply);
    }

    function name() public view virtual override returns (string memory) {
        return tokenName;
    }

    function symbol() public view virtual override returns (string memory) {
        return tokenSymbol;
    }

    function mintToken(address _recipient, uint256 _tokenToMint)
        external
        onlyOwner
        whenNotPaused
    {
        _mint(_recipient, _tokenToMint);
    }

    function puaseContract() public onlyOwner{
        _pause();
    }

    function unPuaseContract() public onlyOwner{
        _unpause();
    }
}
