const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("EthycsRat", function () {

    it("Should Deploy", async function () {

        let accounts = await ethers.getSigners()

        const nftFactory = await hre.ethers.getContractFactory("EthycsRat");
        const nftContract = await nftFactory.deploy();
        await nftContract.deployed();
    
        console.log("  Deployed:", nftContract.address);

        await nftContract.printTokenURI();

        // describe("mint", function () {

        //     it("Should mint a token", async function () {
        //         expect(
        //             await nftContract.mint(accounts[0].address)
        //         )
        //         .to.emit(todayContract, 'Transfer')
        //         .withArgs(
        //             address(0), 
        //             accounts[0].address,
        //             0
        //             )
        //     });
        // });
    });
});