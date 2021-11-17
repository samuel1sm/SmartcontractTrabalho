//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;


contract Lottery {
    
    address public admin;
    address payable[] jogadores;
    uint[] palpites;
    uint[] indices;
    
    constructor() {
        admin = msg.sender;
    }
    
    function participate(uint bicho) public payable{
        
        require(msg.value == 1 ether , "O valor precisa ser 1 ETH");
        
        require(msg.sender != admin , "O administrador nao pode participar da loteria");
        
        require(bicho <=10 && bicho > 0, "O numero do bicho precisa ser entre 1 e 10");
        
        jogadores.push(payable(msg.sender));
        palpites.push(bicho);
    }
    
    function draw() public {
        
        require(admin == msg.sender, "Voce nao e o administrador");

        require(jogadores.length >= 2 , "Nao ha jogadores o suficiente na loteria");
        
        //uint bixoVencedor = random() % 11;
        uint bixoVencedor = 8;
        
        for(uint i = 0; i < palpites.length; i++){
            if(palpites[i] == bixoVencedor){
                indices.push(i);
            }
        }
        
        uint total = getBalance();
        
        address payable vencedor;
        
        if(indices.length == 0){
            payable(admin).transfer(total);
        } else {
            for(uint j = 0; j < indices.length; j++){
                vencedor = jogadores[indices[j]];
                vencedor.transfer((total * 90) / (100 * indices.length));
            }
            payable(admin).transfer( (total * 10) / 100);
        }
        
       newLottery(); 
        
    }
    
    function random() internal view returns(uint){
       return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, jogadores.length)));
    }
    
    function newLottery() internal {
        jogadores = new address payable[](0);
        palpites = new uint[](0);
        indices = new uint[](0);
    }
    
    function getBalance() public view returns(uint){
        return address(this).balance;
    }

}