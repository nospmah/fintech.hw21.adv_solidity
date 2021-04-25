pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

/*
 * @title PupperCoinSale
 * @dev PupperCoinSale contract inherriting functionality from several openzeppelin contracts
 */
contract PupperCoinSale is

    Crowdsale, 
    MintedCrowdsale, 
    CappedCrowdsale, 
    TimedCrowdsale, 
    RefundablePostDeliveryCrowdsale {
        
    constructor(
        uint256 goal,               // Goal: 300 Ether
        uint256 rate,               // Rate in TKNbits - TODO
        uint256 open,               // Sale open: now
        uint256 close,              // Sale close: now + 24 weeks
        address payable wallet,     // Sale beneficiary
        PupperCoin token)           // PupperCoin token
     
        Crowdsale(rate, wallet, token)
        RefundableCrowdsale(goal)
        CappedCrowdsale(goal)
        TimedCrowdsale(open, close)
        
        public
        
    { }
}


/*
 * @title PupperCoinSaleDeployer
 * @dev Utility deployment contract.
 */
contract PupperCoinSaleDeployer {
    
    address public token_sale_address;
    address public token_address;

    // Now is within 15s, measured in seconds
    uint public test_now = now;
    
    // Setter for testing sale duration
    function setTestNow(uint new_now) public {
        test_now = new_now;
    }

    constructor(
        string memory name,         // Sale name: PupperCoin
        string memory symbol,       // Token symbol: PUP
        uint256 goal,               // Goal: 300 Ether
        uint256 rate,               // Rate in TKNbits - TODO
        address payable wallet)     // This address will receive all Ether raised by the sale
    
        public
    {
        // Init new PupperCoin and save address
        PupperCoin token = new PupperCoin(name, symbol, 0);
        token_address = address(token);

        // Init new PupperCoinSale and save address
        PupperCoinSale coin_sale = new PupperCoinSale(goal, rate, now, now + 24 weeks, wallet, token);
        token_sale_address = address(coin_sale);

        // Make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}
