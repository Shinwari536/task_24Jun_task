//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/proxy/utils/Initializable.sol";
import "./interfaces/IFactoryContract.sol";


contract NftToken is Initializable, ERC721URIStorage, Ownable, Pausable {
    using Counters for Counters.Counter;

    Counters.Counter private tokenIds;

    string private nftName;
    string private nftSymbol;

    IFactoryContract private iFactory;

    modifier NotPauseAllContracts{
        require(!iFactory.getPauseAllStatus(), "AllPauseable: All contracts are paused.");
        _;
    }
    constructor() ERC721("", "") {}

    function initialize(string memory _name, string memory _symbol, address _factoryAddress)
        public
        initializer
    {
        iFactory = IFactoryContract(_factoryAddress);
        __ERC721_init(_name, _symbol);
    }

    function __ERC721_init(string memory _name, string memory _symbol)
        internal
    {
        nftName = _name;
        nftSymbol = _symbol;
    }

    function name() public view virtual override returns (string memory) {
        return nftName;
    }

    function symbol() public view virtual override returns (string memory) {
        return nftSymbol;
    }

    function _mintNFT(address recipient, string memory _tokenURI)
        public
        onlyOwner
        NotPauseAllContracts
        whenNotPaused
        returns (uint256)
    {
        tokenIds.increment();
        _mint(recipient, tokenIds.current());
        _setTokenURI(tokenIds.current(), _tokenURI);
        return tokenIds.current();
    }

    function burnNft(uint256 tokenId) public onlyOwner {
        _burn(tokenId);
    }

    function puaseContract() public onlyOwner {
        _pause();
    }

    function unPuaseContract() public onlyOwner {
        _unpause();
    }
}
