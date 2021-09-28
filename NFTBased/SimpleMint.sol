// SPDX-License-Identifier: GPL-3.0

// @Author: nemo

pragma solidity^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract SimpleMinter is ERC721Enumerable, Ownable {
    using Strings for uint256;
    string baseURI; // pointer for our nft image location
    string baseExtension;
    uint256 price = 0.05 ether; // price of nft
    uint256 maxMintAmount= 20; // max per tx
    uint256 maxPerWallet = 10; // max per wallet
    uint256 maxSupply = 10000; // total amount of nfts we have
    constructor( // just a simple constructor
        string memory _baseURI,  
        string memory _symbol, 
        string memory _name)
        ERC721(_name, _symbol) {
            setBaseURI(_baseURI);
        }
    
    function setBaseURI(string memory _givenBaseURI) public onlyOwner {
        baseURI = _givenBaseURI; // set our baseURI to x 
    }

    function _baseURI() internal override virtual view returns(string memory) {
        return baseURI; // retrieve our baseURI
    }

    function mint(uint256 _amnt) public payable {
        uint256 alreadyMinted = totalSupply(); // see how many have already been minted
        require(alreadyMinted + _amnt <= maxSupply, "We cannot supply this amount"); // check we have enough to mint 
        require(_amnt > 0, "Must mint at least one"); // check user doesnt try mint less than 1
        require(_amnt <= maxMintAmount, "You cannot mint this amount in one transaction"); // amnt per tx
        require(balanceOf(msg.sender) + _amnt <= maxPerWallet, "You are not allowed this many in one wallet");
        require(msg.value >= price, "User did not send enough ether with this tx"); // check they are paying enough
        for (uint256 i = 1; i <= _amnt;i++) {
            _safeMint(msg.sender, alreadyMinted + i); // mint the user there nft
        }
    }

    function tokenURI(uint256 tokenID) public view virtual override returns(string memory) {
        require(_exists(tokenID), "This token does not exist");
        string memory currBaseURI = _baseURI();
        return bytes(currBaseURI).length > 0 ? string(abi.encodePacked(currBaseURI, tokenID.toString(), baseExtension)):""; // for opensea and other places to find the data of our nft
    }
}