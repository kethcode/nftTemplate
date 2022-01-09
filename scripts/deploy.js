
const delay = ms => new Promise(res => setTimeout(res, ms));

const main = async () => {
    
    const [deployer] = await ethers.getSigners();

    const nftFactory = await hre.ethers.getContractFactory("EthycsRat");
    const nftContract = await nftFactory.deploy();
    await nftContract.deployed();

    console.log("Deployed:", nftContract.address);
    console.log("Deployer:", deployer.address);

    console.log("Waiting for bytecode to propogate (60sec)");
    await delay(60000);

    console.log("Verifying on Etherscan");

    await hre.run("verify:verify", {
        address: nftContract.address,
      });

    console.log("Verified on Etherscan");
};

const runMain = async () => {
    try {
        await main();
        process.exit(0);
    } catch (error) {
        console.log(error);
        process.exit(1);
    }
};

runMain();