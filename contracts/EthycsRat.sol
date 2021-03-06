// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity >=0.6.0 <0.9.0;

// Thank you m1guelpf
// https://github.com/m1guelpf/erc721-drop

// Thank you transmissions11
// https://github.com/Rari-Capital/solmate

import "./LilOwnable.sol";
// import "solmate/tokens/ERC721.sol";
// import "solmate/utils/SafeTransferLib.sol";
import "@rari-capital/solmate/src/tokens/ERC721.sol";
import "@rari-capital/solmate/src/utils/SafeTransferLib.sol";

// Thank you OpenZeppelin
import "@openzeppelin/contracts/utils/Strings.sol"; // kinda dont want to use Strings.  will replace later.

//...and thank you Brecht
import { Base64 } from "./Base64.sol";

// import "hardhat/console.sol";

error DoesNotExist();
error NoTokensLeft();
error NotEnoughETH();

contract EthycsRat is LilOwnable, ERC721 {
    uint256 public constant TOTAL_SUPPLY = 10;
    uint256 public constant PRICE_PER_MINT = 0.01 ether;

    uint256 public totalSupply;

    event Minted(address sender, uint256 tokenId);

    // Build an SVG
    
    string svgPart1 = "<svg version='1.0' xmlns='http://www.w3.org/2000/svg' width='320pt' height='320pt' viewBox='0 0 1280 640' preserveAspectRatio='xMidYMid meet'><style>.base { fill: ";
    string svgTextColor = "black";
    string svgPart2 = "; font-family: serif; font-size: 200px; }</style><text x='50%' y='5%' class='base' dominant-baseline='middle' text-anchor='middle'>";
    string svgOwnerNamePossessive = "Ethycs'";
    string svgPart3 = " Rat</text><g transform='translate(80.000000,840.000000) scale(0.090000,-0.090000)' fill='#000000' stroke='none'><path d='M6990 4870 c-809 -76 -1445 -489 -1761 -1143 -96 -201 -157 -416 -174 -623 l-7 -81 -142 -6 c-100 -4 -219 -19 -411 -52 -687 -117 -798 -132 -1089 -146 -396 -18 -497 -43 -1336 -323 -256 -85 -499 -163 -540 -173 -99 -24 -336 -23 -470 1 -145 26 -330 77 -600 164 -292 95 -353 109 -404 92 -59 -19 -73 -69 -35 -124 70 -102 358 -233 684 -311 301 -73 481 -95 825 -102 529 -10 825 39 1326 222 326 120 353 125 643 125 134 0 428 -7 655 -17 545 -21 901 -23 981 -3 33 8 63 14 66 15 4 0 28 -28 53 -62 137 -182 382 -316 671 -369 50 -8 167 -18 260 -21 161 -5 171 -7 191 -29 31 -32 76 -41 272 -53 l173 -10 67 -41 c37 -23 126 -87 198 -141 72 -55 138 -99 146 -99 8 0 23 9 32 19 17 19 16 23 -38 118 -58 102 -65 123 -43 123 14 0 95 -40 250 -124 59 -32 114 -55 122 -52 8 3 20 16 26 30 10 21 6 31 -31 80 -24 31 -40 60 -36 63 4 4 84 -18 178 -50 95 -31 174 -54 177 -52 2 3 -16 31 -41 63 -24 32 -61 88 -82 125 l-38 67 69 0 c77 0 262 -20 468 -51 106 -16 209 -22 425 -26 l285 -5 32 -29 c39 -34 69 -40 193 -37 109 2 118 -1 324 -116 65 -37 146 -81 178 -97 57 -29 61 -29 79 -13 10 9 19 24 19 32 0 9 -30 47 -67 85 -41 42 -63 72 -55 75 7 2 63 -12 125 -32 121 -38 301 -80 319 -74 6 2 -31 41 -83 87 -52 46 -98 90 -103 99 -9 16 -26 17 234 -4 l79 -7 11 28 c8 20 7 31 -1 42 -31 36 -312 181 -454 233 -49 19 -91 34 -93 35 -3 3 97 157 126 195 11 14 91 64 178 111 l159 86 130 1 c72 0 186 8 255 16 69 9 229 27 355 41 127 14 281 32 344 40 63 8 116 13 118 11 2 -2 -8 -34 -22 -71 -27 -74 -30 -85 -16 -85 5 0 20 28 34 63 14 34 31 61 37 59 6 -1 16 11 21 27 7 19 21 33 41 40 17 6 33 9 35 7 2 -2 -10 -34 -26 -71 -35 -77 -35 -75 -21 -75 15 0 45 54 64 113 12 38 24 57 47 70 17 9 36 14 41 11 12 -7 4 -217 -11 -312 -6 -39 -5 -52 4 -52 16 0 23 45 31 188 5 81 10 110 18 102 6 -6 36 -53 66 -105 104 -178 174 -285 188 -285 15 0 19 -8 -66 130 -70 112 -92 169 -123 323 -20 95 -20 99 -3 112 22 16 17 22 104 -130 146 -255 172 -297 182 -287 6 6 1 24 -16 51 -14 22 -26 46 -26 54 0 7 -6 21 -14 32 -28 42 -88 223 -100 308 -10 65 12 73 63 23 36 -35 39 -44 71 -191 24 -113 37 -155 47 -155 9 0 12 7 9 18 -3 9 -21 91 -41 180 -20 90 -40 175 -45 188 -11 28 -30 32 -30 7 0 -13 -3 -14 -12 -5 -9 9 -2 23 34 60 54 55 64 74 78 139 9 38 8 57 -5 92 -15 43 -15 43 16 82 17 22 43 46 58 53 50 26 216 58 324 64 59 2 107 9 107 13 0 5 -18 9 -40 9 -22 0 -40 5 -40 10 0 6 3 10 6 10 28 0 291 53 299 61 11 11 2 11 -50 -1 -22 -5 -130 -23 -240 -40 -110 -17 -233 -39 -272 -49 -67 -17 -73 -18 -73 -3 0 28 78 110 153 163 77 53 73 68 -4 18 -30 -19 -55 -28 -67 -25 -22 7 -50 -21 -122 -127 -29 -43 -54 -76 -56 -74 -5 5 40 137 57 168 6 13 45 65 86 114 144 175 154 188 148 193 -3 3 -26 -17 -51 -45 -24 -29 -53 -54 -63 -58 -10 -3 -35 -27 -56 -53 l-37 -47 7 38 c11 60 -12 45 -31 -20 -13 -46 -34 -79 -96 -153 -44 -52 -84 -97 -89 -98 -16 -6 -41 70 -35 106 3 19 30 89 60 155 31 66 54 123 51 125 -2 2 -33 -54 -68 -124 l-65 -129 -7 38 c-4 22 -3 49 4 65 13 32 71 287 71 311 -1 30 -16 -10 -30 -77 -10 -47 -19 -68 -37 -79 -14 -9 -23 -25 -23 -41 0 -41 -11 -18 -32 65 -33 131 -37 156 -38 221 0 34 -4 62 -8 62 -5 0 -7 -76 -5 -169 4 -175 -6 -291 -33 -373 l-16 -48 -39 23 c-91 51 -87 44 -95 220 -8 171 -23 213 -25 65 -1 -76 -3 -87 -11 -62 -5 16 -19 34 -31 40 -15 6 -33 42 -62 119 -47 124 -84 200 -92 191 -3 -3 12 -45 35 -93 53 -116 131 -367 118 -380 -2 -2 -79 34 -172 80 -175 86 -426 189 -550 227 l-71 21 -5 73 c-8 129 -78 240 -184 292 -47 23 -67 27 -142 26 -149 -2 -234 -41 -277 -126 -42 -83 -31 -172 30 -253 l25 -32 -42 -12 c-24 -6 -59 -19 -78 -28 -32 -16 -58 -17 -277 -10 -280 10 -392 28 -505 82 -40 20 -188 102 -328 182 -321 185 -595 334 -730 397 -243 115 -493 202 -668 234 -105 19 -361 26 -492 14z m3415 -531 c53 -13 119 -67 145 -120 11 -21 24 -66 29 -100 l8 -60 -51 8 c-28 4 -87 8 -131 8 -69 0 -89 -4 -135 -28 l-53 -28 -40 38 c-21 21 -45 50 -53 65 -17 33 -18 108 -2 143 29 65 171 102 283 74z m1392 -606 c-3 -10 -5 -2 -5 17 0 19 2 27 5 18 2 -10 2 -26 0 -35z m-35 -180 c16 -32 7 -46 -20 -28 -25 18 -27 32 -10 72 l12 28 3 -25 c2 -14 9 -35 15 -47z m221 -55 c-21 -73 -29 -85 -58 -90 -38 -8 -38 4 4 53 21 24 43 54 50 67 19 36 21 25 4 -30z m-13 -154 c0 -8 -5 -12 -10 -9 -6 4 -8 11 -5 16 9 14 15 11 15 -7z m-167 -436 c6 -43 2 -46 -16 -9 -14 28 -13 41 4 41 3 0 9 -15 12 -32z m-20 -54 c37 -75 30 -77 -11 -3 -18 32 -29 59 -24 59 4 0 20 -25 35 -56z m-98 -134 c7 -30 12 -56 10 -58 -1 -2 -17 22 -34 52 -33 59 -39 104 -18 125 10 10 14 5 20 -26 5 -21 15 -63 22 -93z'/><path d='M11900 2362 c0 -21 13 -42 26 -42 10 0 11 6 5 22 -8 23 -31 37 -31 20z'/></g></svg>";

    constructor() payable ERC721("Ethycs' Rat", "ETHYCS") {}

    function mint() external payable {
        if (totalSupply + 1 >= TOTAL_SUPPLY) revert NoTokensLeft();
        if (msg.value < PRICE_PER_MINT) revert NotEnoughETH();
        
        _mint(msg.sender, totalSupply++);
        emit Minted(msg. sender, totalSupply);
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
        if (ownerOf[id] == address(0)) revert DoesNotExist();

        //return string(abi.encodePacked(baseURI, id));
        string memory finalSvg = string(abi.encodePacked(svgPart1, svgTextColor, svgPart2, svgOwnerNamePossessive, svgPart3));
        string memory combinedWord = string(abi.encodePacked(svgOwnerNamePossessive, " Rat"));

        // Get all the JSON metadata in place and base64 encode it.
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // We set the title of our NFT as the generated word.
                        combinedWord,
                        '", "description": "A Rat for Ethycs.", "image": "data:image/svg+xml;base64,',
                        // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Just like before, we prepend data:application/json;base64, to our data.
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return finalTokenUri;
    }

    // function printTokenURI() public view {
    //     string memory finalSvg = string(abi.encodePacked(svgPart1, svgTextColor, svgPart2, svgOwnerNamePossessive, svgPart3));
    //             string memory combinedWord = string(abi.encodePacked(svgOwnerNamePossessive, " Rat"));

    //     // Get all the JSON metadata in place and base64 encode it.
    //     string memory json = Base64.encode(
    //         bytes(
    //             string(
    //                 abi.encodePacked(
    //                     '{"name": "',
    //                     // We set the title of our NFT as the generated word.
    //                     combinedWord,
    //                     '", "description": "A Rat for Ethycs.", "image": "data:image/svg+xml;base64,',
    //                     // We add data:image/svg+xml;base64 and then append our base64 encode our svg.
    //                     Base64.encode(bytes(finalSvg)),
    //                     '"}'
    //                 )
    //             )
    //         )
    //     );

    //     // Just like before, we prepend data:application/json;base64, to our data.
    //     string memory finalTokenUri = string(
    //         abi.encodePacked("data:application/json;base64,", json)
    //     );
    //     console.log("\n--------------------");
    //     console.log(finalTokenUri);
    //     console.log("--------------------\n");
    // }

    function withdraw() external {
        if (msg.sender != _owner) revert NotOwner();

        SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        pure
        override(LilOwnable, ERC721)
        returns (bool)
    {
        return
            interfaceId == 0x7f5828d0 || // ERC165 Interface ID for ERC173
            interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
            interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC165
            interfaceId == 0x01ffc9a7; // ERC165 Interface ID for ERC721Metadata
    }
}