pragma solidity^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
contract Token is ERC20{
    address public admin;
    constructor() ERC20("NEMO TOKEN", "NEMO") {
        _mint(msg.sender, 10000 ether);
        admin = msg.sender;
    }

    function mint(address to, uint256 amnt) external {
        require(msg.sender == admin, "Only admins can do this");
        _mint(to, amnt);
    }

    function burn(uint256 amnt) external {
        _burn(msg.sender, amnt);
    }

    function changeAdmin(address newAdmin) external {
        require(msg.sender == admin, "Only the admin can do this");
        admin = newAdmin;
    }
}
