import { numToBytes32 } from "@chainlink/test-helpers/dist/src/helpers";
import { assert, expect } from "chai";
import { BigNumber, ContractReceipt, ContractTransaction } from "ethers";
import { network, deployments, ethers, run } from "hardhat";
import { CHAINS } from "../../helper-hardhat";
import { APIConsumer } from "../../typechain-types/contracts/APIConsumer";
import { LinkToken, MockOracle } from "../../typechain-types/contracts/test";

!CHAINS.local.includes(network.name)
    ? describe.skip
    : describe("APIConsumer Unit Tests", async function () {
          let apiConsumer: APIConsumer;
          let linkToken: LinkToken;
          let mockOracle: MockOracle;

          beforeEach(async () => {
              await deployments.fixture(["mocks", "api"]);
              linkToken = await ethers.getContract("LinkToken");
              const linkTokenAddr: string = linkToken.address;
              apiConsumer = await ethers.getContract("APIConsumer");
              mockOracle = await ethers.getContract("MockOracle");

              await run("fund-link", { contract: apiConsumer.address, linkAddr: linkTokenAddr });
          });

          it(`Should successfully make an API request.`, async () => {
              // @ts-ignore
              await expect(apiConsumer.request(BigNumber.from("100000"))).to.emit(
                  apiConsumer,
                  "ChainlinkRequested"
              );
          });

          it("Our event should successfully fire event on callback.", async () => {
              const callbackValue: number = 777;
              await new Promise(async (resolve, reject) => {
                  apiConsumer.once("DataFulfilled", async () => {
                      console.log("DataFulfilled event fired!");
                      const rInt256: BigNumber = await apiConsumer.rInt256();
                      try {
                          assert.equal(rInt256.toString(), callbackValue.toString());
                          resolve(true);
                      } catch (err) {
                          reject(err);
                      }
                  });
                  const tx: ContractTransaction = await apiConsumer.request(
                      BigNumber.from("10000000")
                  );
                  const txReceipt: ContractReceipt = await tx.wait(1);
                  if (!txReceipt.events) return;
                  const requestId = txReceipt.events[0].topics[1];
                  await mockOracle.fulfillOracleRequest(requestId, numToBytes32(callbackValue));
              });
          });
      });
