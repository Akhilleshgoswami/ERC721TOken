//ERC -  Ethereum Request for comment
// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

contract ERC721 {
    uint256 private totalsupply = 1000000000;
    mapping(address => uint256) private balance; // this will keep track of the number of token user have
    mapping(uint256 => address) private tokenOwners; // this will store the info of the owner of the token
    mapping(uint256 => bool) private tokenExits; // this will keep tarck if token is exits or not  on block chian
    mapping(address => mapping(address => uint256)) private allowed; // this will keep track the number of owner  of the token
    mapping(address => mapping(uint256 => uint256)) private ownerToekns;
uint256 l =1;
    // events


    event Approval(
        address indexed _owner,
        address indexed _approved,
        uint256 _tokenId
    );
    event Transfer(
        address indexed oldOwner,
        address indexed newOnwer,
        uint256 _tokenId
    );

    // ERC20 compatible functions
    //This function is used to define the name of the token to outsidecontracts and applications
    function name() public pure returns (string memory) {
        return "ERC721";
    }

    // The symbol() function helps with token identification, by creating its shorthand and symbol.
    // The function also provides compatibility with the ERC20 token standard.

    function symbol() public pure returns (string memory) {
        return "Black";
    }

    /**The totalSupply() function defines the total number of the tokens available in the contract and it also returns the total
 number of coins available on the blockchain. The supply does not have to be constant.*/

    function totalSupply() public view returns (uint256) {
        return totalsupply;
    }

    //This function is used to find the number of tokens that a given address owns.

    function balanceOf(address _owner) public view returns (uint256) {
        return balance[_owner];
    }

    //The purpose of this function is to return the address of the token owner

    function ownerOf(uint256 _tokenId) public view returns (address) {
        require(tokenExits[_tokenId]);

        return tokenOwners[_tokenId];
    }

    // This function approves, or grants, another entity permission to transfer a token on the owner’s behalf.

    function approve(address _to, uint256 _tokenId) public {
        require(msg.sender == ownerOf(_tokenId));

        require(msg.sender != _to);
        allowed[msg.sender][_to] = _tokenId;

        emit Approval(msg.sender, _to, _tokenId);
    }

    //The idea of the takeOwnership() function is to act like a withdraw function. An outside party can call it in order to take tokens out of another user’s account.
    function takeOwnership(uint256 _tokenId) public {
        require(tokenExits[_tokenId]);
        address oldOwner = ownerOf(_tokenId);
        address newOnwer = msg.sender;
        require(newOnwer != oldOwner);
        require(allowed[oldOwner][newOnwer] == _tokenId);
        balance[oldOwner] -= 1;
        tokenOwners[_tokenId] = newOnwer;
        balance[newOnwer] += 1;
        emit Transfer(oldOwner, newOnwer, _tokenId);
    }

    /**The transfer() function is another method used for
 transferring tokens. It allows the owner of the token
  to send it to another user, similar to a standalonecryptocurrency. This transfer can only be initiated
  if the receiving account has previouslybeen approved to own the token by the sending account. */

    function removeFromTokenList(address owner, uint256 _tokenId) private {
        for (uint256 i = 0; ownerToekns[owner][i] != _tokenId; i++) {
            ownerToekns[owner][i] = 0;
        }
    }

    function transfer(address _to, uint256 _tokenId) public {
        address currentOwner = msg.sender;
        address newOnwer = _to;
        require(tokenExits[_tokenId]);
        require(currentOwner == ownerOf(_tokenId));
        require(newOnwer != address(0));
        removeFromTokenList(currentOwner, _tokenId);
        balance[currentOwner] -= 1;
        tokenOwners[_tokenId] = newOnwer;
        balance[newOnwer] += 1;
        emit Transfer(currentOwner, newOnwer, _tokenId);
    }
}
