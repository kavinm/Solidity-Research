import { StandardMerkleTree } from "@openzeppelin/merkle-tree";
import fs from "fs";

// (1)
const values = [
  ["0x0000000000000000000000000000000000000001", "0"],
  ["0x0000000000000000000000000000000000000002", "1"],
  ["0x0000000000000000000000000000000000000003", "2"],
];

// (2)
const tree = StandardMerkleTree.of(values, ["address", "uint256"]);

// (3)
console.log("Merkle Root:", tree.root);

// (4)
fs.writeFileSync("treeAddresses.json", JSON.stringify(tree.dump()));
