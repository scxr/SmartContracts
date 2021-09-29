// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract GameContract is ERC721, Ownable {
    uint counter;
    uint256 price = 0.05 ether;
    mapping(uint => uint256) locations;
    struct Character {
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }
    
    event newCharacter(address indexed owner, uint256 id, uint256 dna);
    
    Character[] public Characters;
    
    constructor(
        string memory _name,
        string memory _symbol
    ) ERC721(_name, _symbol){
        // initialise the ERC721 token
    }
    
    // helpers
    
    function genRandomNum(uint256 _modulus) internal view returns(uint256) {
        uint256 randomNum = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender)));
        return randomNum % _modulus;
    }

    function createCharacter(string memory _name) internal {
        uint8 rand = uint8(genRandomNum(100));
        uint256 randomDna = genRandomNum(10**16);
        Character memory newCharacterObj = Character( _name, counter, randomDna, 1, rand);
        Characters.push(newCharacterObj);
        _safeMint(msg.sender, counter);
        
        emit newCharacter(msg.sender, counter, randomDna);
        counter++;
    }
    
    function createRandomCharacter(string memory name) public payable {
        //require(msg.value >= price, "User did not send enough eth");
        createCharacter(name);
    }
    
    function makeSuperCharacterObj(string memory _name) internal view returns(Character memory){
        uint256 randomDna = genRandomNum(10**16);
        Character memory newCharacterObj = Character(_name, counter, randomDna, 1, 95);
        return newCharacterObj;
    }
    
    
    function getCharacters() public view returns(Character[] memory) {
        return Characters;
    }
    
    function changePrice(uint256 newPrice) external  onlyOwner() {
        price = newPrice;
    }
    
    function withdraw() external payable onlyOwner() {
        require(payable(msg.sender).send(address(this).balance));
    }

    
    
    event foundCharacter(uint256 id, uint256 dna);
    function getOwnerCharacters(address _check) public view returns (Character[] memory) {
        
        Character[] memory result = new Character[](balanceOf(_check));
        uint256 cnt = 0;
        
        for (uint256 i = 0; i < Characters.length; i++) {
            if (ownerOf(i) == _check) {
                Character memory Character = Characters[i];
                if (Character.dna != 0){
                    //emit foundCharacter(Character.id, Character.dna);
                    result[cnt] = Characters[i];
                    cnt++;
                } else {
                    
                }
                

            }
        }  
        if (cnt==0) {
            return new Character[](0);
        }
        return result;
    }

    function upgradeLevel(uint256 CharacterId) public {
        require(ownerOf(CharacterId) == msg.sender, "User does not own this Character");
        Character storage CharacterGiven = Characters[CharacterId];
        CharacterGiven.level++;
        Characters[CharacterId] = CharacterGiven;
    }

    function makeSuper() public payable {
        require(getOwnerCharacters(msg.sender).length >= 2, "User does not have at least 2 Characters");
        require(msg.value >= 0.2 ether, "User did not pay enough");
        Character[] memory usersCharacters = getOwnerCharacters(msg.sender);
        burn(usersCharacters[0].id);
        burn(usersCharacters[1].id);
        Character memory newSuper = makeSuperCharacterObj(usersCharacters[0].name);
        Characters.push(newSuper);
        emit newCharacter(msg.sender, counter, newSuper.dna);
        _safeMint(msg.sender, counter);
        counter++;

    }

    function burn(uint256 CharacterId) public {
        require(ownerOf(CharacterId) == msg.sender, "User does not own this Character");
        Characters[CharacterId].dna = 0;
    }
    
    function getLocation(uint256 CharacterId) public view returns(uint) {
        Character storage CharacterObj = Characters[CharacterId];
        return locations[CharacterObj.dna];
    }
    
    function getAllCharacters() public view returns(Character[] memory) {
        return Characters;
    }
}