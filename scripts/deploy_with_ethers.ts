// This script can be used to deploy the "Storage" contract using ethers.js library.
// Please make sure to compile "./contracts/1_Storage.sol" file before running this script.
// And use Right click -> "Run" from context menu of the file to run the script. Shortcut: Ctrl+Shift+S

import { deploy } from './ethers-lib'

(async () => {
  try {
    const myContract = await deploy('MyContract', [])
    console.log(`address: ${myContract.address}`)
  } catch (e) {
    console.log(e.message)
  }
})()
