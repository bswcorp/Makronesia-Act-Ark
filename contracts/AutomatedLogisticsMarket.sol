// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

interface IERC20 {
    function transferFrom(address from, address to, uint256 value) external returns (bool);
    function transfer(address to, uint256 value) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract AutomatedLogisticsMarket {
    IERC20 public qstateToken;
    address public sovereignGovernment;

    // Struktur Pasar Komoditas (Contoh: ID 1 = Oksigen Ekstra, ID 2 = Paket Pangan)
    struct CommodityPool {
        uint256 tokenReserve;      // Cadangan $QSTATE di dalam pool
        uint256 resourceReserve;   // Cadangan unit komoditas fisik di dalam pool
        uint256 totalLiquidityShares;
        string commodityName;
    }

    mapping(uint256 => CommodityPool) public marketPools;
    mapping(uint256 => mapping(address => uint256)) public liquidityShares;

    event TradeExecuted(address indexed trader, string tradeType, uint256 amountIn, uint256 amountOut);
    event LiquidityAdded(address indexed provider, uint256 tokensAdded, uint256 resourcesAdded);

    constructor(address _qstateAddress) {
        qstateToken = IERC20(_qstateAddress);
        sovereignGovernment = msg.sender;
    }

    // 1. Eksekusi Pembelian Komoditas oleh Warga menggunakan $QSTATE
    function buyCommodity(uint256 _poolId, uint256 _qstateAmountIn) external returns (uint256 resourceAmountOut) {
        CommodityPool storage pool = marketPools[_poolId];
        require(pool.resourceReserve > 0, "Out of stock in logistics pool");

        // Formula AMM: x * y = k
        // (TokenReserve + amountIn) * (ResourceReserve - amountOut) = TokenReserve * ResourceReserve
        uint256 tokenReserveWithFee = pool.tokenReserve;
        resourceAmountOut = (pool.resourceReserve * _qstateAmountIn) / (tokenReserveWithFee + _qstateAmountIn);
        
        require(resourceAmountOut < pool.resourceReserve, "Insufficient pool depth");

        // Transfer token $QSTATE dari warga ke kas pool pasar
        require(qstateToken.transferFrom(msg.sender, address(0), _qstateAmountIn), "Payment failed");

        pool.tokenReserve += _qstateAmountIn;
        pool.resourceReserve -= resourceAmountOut;

        emit TradeExecuted(msg.sender, "BUY", _qstateAmountIn, resourceAmountOut);
        return resourceAmountOut;
    }

    // 2. Warga Menjual Kembali Sisa Barang Milik Mereka untuk Mendapatkan $QSTATE
    function sellCommodity(uint256 _poolId, uint256 _resourceAmountIn) external returns (uint256 qstateAmountOut) {
        CommodityPool storage pool = marketPools[_poolId];
        
        qstateAmountOut = (pool.tokenReserve * _resourceAmountIn) / (pool.resourceReserve + _resourceAmountIn);
        require(qstateToken.balanceOf(address(this)) >= qstateAmountOut, "Market liquidity dry");

        pool.resourceReserve += _resourceAmountIn;
        pool.tokenReserve -= qstateAmountOut;

        require(qstateToken.transfer(msg.sender, qstateAmountOut), "Payout failed");

        emit TradeExecuted(msg.sender, "SELL", _resourceAmountIn, qstateAmountOut);
        return qstateAmountOut;
    }

    // Inisialisasi awal kedalaman pasar oleh Otoritas Logistik Bahtera
    function initializeMarketPool(uint256 _poolId, string memory _name, uint256 _tokens, uint256 _resources) external {
        require(msg.sender == sovereignGovernment, "Only STG can seed initial logistics pools");
        marketPools[_poolId] = CommodityPool(_tokens, _resources, _tokens, _name);
        emit LiquidityAdded(msg.sender, _tokens, _resources);
    }
}
