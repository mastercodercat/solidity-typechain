// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
// When running the script with `hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
import { ethers } from 'hardhat';
import { Contract, ContractFactory } from 'ethers';

async function main(): Promise<void> {
  // Hardhat always runs the compile task when running scripts through it.
  // If this runs in a standalone fashion you may want to call compile manually
  // to make sure everything is compiled
  // await run("compile");
  // We get the contract to deploy
  const ChallengeFactory: ContractFactory = await ethers.getContractFactory(
    'Challenge',
  );
  const challenge: Contract = await ChallengeFactory.deploy();
  await challenge.deployed();
  console.log('Challenge deployed to: ', challenge.address);

  
  const IncrementorFactory: ContractFactory = await ethers.getContractFactory(
    'TestToken',
  );
  const incrementor: Contract = await IncrementorFactory.deploy();
  await incrementor.deployed();
  console.log('Incrementor deployed to: ', incrementor.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error: Error) => {
    console.error(error);
    process.exit(1);
  });
