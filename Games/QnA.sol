// SPDX-License-Identifier: GPL-3.0

// @Author: nemo

pragma solidity^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract QnA is Ownable {
    mapping(uint256 => bytes32) questionsAns;
    
    function addQuestion(uint256 qNumber, bytes32 answer) public onlyOwner{
        questionsAns[qNumber] = answer;
    }

    function removeQuestion(uint256 qNumber) public onlyOwner {
        questionsAns[qNumber] = "";
    }

    function editQuestion(uint256 qNumber, bytes32 answer) public onlyOwner{
        questionsAns[qNumber] = answer;
    }


    
    function ansQuestionString(string memory answer, uint256 qNumber) public view returns(bool) {
        require(questionsAns[qNumber] != "", "This answer is not set");
        bytes32 answerBytes = keccak256(abi.encodePacked(answer));
        return questionsAns[qNumber] == answerBytes;
    }
    
    function ansQuestionBytes(bytes32 answer, uint256 qNumber) public view returns(bool){
        require(questionsAns[qNumber] != "", "This answer is not set");
        return questionsAns[qNumber] == answer;
    }
    
    function getBytes(string memory toHash) public pure returns(bytes32) {
        return keccak256(abi.encodePacked(toHash));
    }
      
}