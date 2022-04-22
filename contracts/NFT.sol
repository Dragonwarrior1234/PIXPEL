/**
 *Submitted for verification at testnet.snowtrace.io on 2022-01-21
*/

// SPDX-License-Identifier: MIT
// OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/math/SafeMath.sol";

contract PixpelNFT is ReentrancyGuard, ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Burnable, Ownable {
    using SafeMath for uint256;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string private baseTokenURI;

    mapping(address => bool) public addressForRegister;
    mapping(uint256 => NFTInfo) public NFTInfoForAddress;

    modifier onlyRegister() {
        require(
            addressForRegister[msg.sender],
            "Can only be called by register"
        );
        _;
    }
    
    constructor(string memory _baseURI) ERC721("PixpelNFT", "PIXPNT") {
    }
    receive() external payable {}

    function _baseURI() 
        internal 
        view 
        override 
        returns(string memory) 
    {
        return baseTokenURI;
    }
    
    function setBaseURI(string memory _newuri) 
        external 
        onlyOwner 
        returns(bool)
    {
        baseTokenURI = _newuri;
    }

    function mintNFT() 
        pubilc 
        onlyRegister
    {
        uint256 _newTokenId = _tokenIds.current();
        _safeMint(_to, _newTokenId);
        _tokenIdCounter.increment();
    }

    function tokensOfOwner(address _owner)
        external
        view
        returns (uint256[] memory)
    {
        uint256 tokenCount = balanceOf(_owner);
        uint256[] memory tokensIds = new uint256[](tokenCount);
        for (uint256 i = 0; i < tokenCount; i++) {
            tokensIds[i] = tokenOfOwnerByIndex(_owner, i);
        }

        return tokensIds;
    }

    function _totalSupply() 
        internal 
        view 
        returns (uint) 
    {
        return _tokenIds.current();
    }

    function withdrawAll() 
        public 
        payable 
        onlyOwner 
    {
        uint256 balance = address(this).balance;
        require(balance > 0);
        _widthdraw(msg.sender, address(this).balance);
    }

    function _widthdraw(
        address _address, 
        uint256 _amount
    ) private 
    {
        (bool success, ) = _address.call{value: _amount}("");
        require(success, "Transfer failed.");
    }

    function tokenURI(uint256 tokenId) 
        public 
        view 
        virtual 
        override 
        returns (string memory) 
    {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString(),".json")) : "";
    }

    function isRegister()
        public 
        view
        returns(bool)
    {
        return addressForRegister(msg.sender);
    }

    function registerAddress(address _register) 
        public
        onlyOwner
    {
        addressForRegister[_register] = true;
    }

    function unregisterAddress(address _unregister)
        public
        onlyOwner
    {
        addressForRegister[_register] = false;
    }
}