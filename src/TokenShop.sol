// SPDX-License-Identifier: MIT
pragma solidity 0.8.21;

import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

interface TokenInterface {
    function mint(address account, uint256 amount) external;
}

contract TokenShop {
    AggregatorV3Interface internal priceFeed;
    TokenInterface public minter;
    uint256 public tokenPrice = 200; //1 token = 2.00 usd, with 2 decimal places
    address public owner;

    constructor(address tokenAddress) {
        minter = TokenInterface(tokenAddress);
        /**
         * Network: Sepolia
         * Aggregator: ETH/USD
         * Address: 0x694AA1769357215DE4FAC081bf1f309aDC325306
         */
        priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        owner = msg.sender;
    }

    /**
     * Returns the latest answer
     */
    function getChainlinkDataFeedLatestAnswer() public view returns (int) {
        (, /*uint80 roundID*/ int price, , , ) = /*uint startedAt*/ /*uint timeStamp*/ /*uint80 answeredInRound*/
        priceFeed.latestRoundData();
        return price;
    }

    function tokenAmount(uint256 amountETH) public view returns (uint256) {
        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer()); // Precio ETH/USD con 8 decimales
        uint256 amountUSD = (amountETH * ethUsd) / 10 ** 18; // Convertir ETH a USD
        uint256 amountToken = (amountUSD * 10 ** 2) / tokenPrice; // USD -> tokens (ajustando decimales)
        return amountToken;
    }

    function buyTokens(uint256 amountTokens) public payable {
        require(amountTokens > 0, "Specify an amount of tokens to buy");

        uint256 ethUsd = uint256(getChainlinkDataFeedLatestAnswer()); // ETH/USD con 8 decimales
        uint256 costInUsd = amountTokens * tokenPrice; // Costo en USD con 2 decimales
        uint256 costInEth = (costInUsd * 10 ** 18) / ethUsd; // Convertir USD a ETH con 18 decimales

        require(msg.value >= costInEth, "Not enough MATIC sent");

        // Envía cualquier exceso de MATIC de vuelta al comprador
        uint256 excess = msg.value - costInEth;
        if (excess > 0) {
            payable(msg.sender).transfer(excess);
        }

        // Mintea los tokens al comprador
        minter.mint(msg.sender, amountTokens);
    }

    receive() external payable {
        uint256 amountToken = tokenAmount(msg.value);
        require(amountToken > 0, "Not enough MATIC sent for tokens");
        minter.mint(msg.sender, amountToken);
    }

    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    function withdraw() external onlyOwner {
        payable(owner).transfer(address(this).balance);
    }
}
