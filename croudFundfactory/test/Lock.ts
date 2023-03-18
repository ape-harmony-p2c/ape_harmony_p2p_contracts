import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { BigNumberish } from 'ethers';
import { CroudSaleFactory, CroudSale } from "../typechain-types";

describe("Lock", function () {
  interface CroudSaleDeployment {
    maxFund: BigNumberish; //amount of token desired
    endTime: BigNumberish;//end time of the sale determined by block.timestamp
    benificiary: string;//owner of the sale and recipient of sale funds 
    name: string;// token name and symbol this is just to maintain interoperability
  }
  

  async function deployfactoryFixture() {
    const SimpleToken = await ethers.getContractFactory('simpleERC20');
    const simpleToken = await SimpleToken.deploy();
    const Factory = await ethers.getContractFactory('croudSaleFactory');
  
    const factory = await Factory.deploy(simpleToken.address) as CroudSaleFactory;
    return { factory };
  }


  async function deployCroudsaleFixture() {
    const [signer1, signer2] = await ethers.getSigners();
    const { factory } = await deployfactoryFixture();
    const saleAddress = await factory.deployCroudSale(ethers.utils.parseEther('1'), 100, signer1.address, "test");
    
    //await deployment on frontend with spinner
    
    //using this to get the first deployment in the mapping
    const deployedAddres = await factory.ownedCroudSales(signer1.address, 0)

    //connect to deployed sale address
    const sale = await ethers.getContractAt("croudSale",deployedAddres, signer1) as CroudSale;

    return { factory, sale, signer1, signer2};
  }
  describe("DeployCroudSale",function () {
    it("Should deploy presale",async () => {
      const {factory,sale, signer1, signer2} = await deployCroudsaleFixture();
      //deployment args passes check
      //dont do this in production
      console.log('sale active', await sale.isActive())
      expect(await sale.name()).to.be.equal('test')
    })
    it("Should mint tokens",async () => {
      const {factory,sale, signer1, signer2} = await deployCroudsaleFixture();
      //deployment args passes check
      //dont do this in production
      expect(await sale.name()).to.be.equal('test')
    })
    
  })


});
