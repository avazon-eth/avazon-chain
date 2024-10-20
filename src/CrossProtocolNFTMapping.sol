// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract CrossProtocolNFTMapping {

    // 다른 프로토콜의 NFT를 나타내는 구조체
    struct NFT {
        address nftContract; // 다른 프로토콜의 NFT 컨트랙트 주소
        uint256 chainId;     // 해당 프로토콜의 체인 ID
    }

    // 다른 프로토콜의 NFT를 현재 프로토콜의 소유자 주소와 매핑
    mapping(bytes32 => address) public nftToOwner;

    // 다른 프로토콜의 NFT가 매핑될 때 발생하는 이벤트
    event CrossProtocolNFTMapped(address indexed nftContract, uint256 indexed chainId, address indexed owner);

    /**
     * @dev NFT 컨트랙트 주소와 체인 ID를 사용하여 고유 키 생성
     * @param nftContract 다른 프로토콜의 NFT 컨트랙트 주소
     * @param chainId 해당 프로토콜의 체인 ID
     * @return 매핑에 사용할 고유 키
     */
    function _getNFTKey(address nftContract, uint256 chainId) internal pure returns (bytes32) {
        return keccak256(abi.encodePacked(nftContract, chainId));
    }

    /**
     * @dev 다른 프로토콜의 NFT를 현재 프로토콜의 소유자 주소와 매핑하는 함수
     * @param nftContract 다른 프로토콜의 NFT 컨트랙트 주소
     * @param chainId 해당 프로토콜의 체인 ID
     * @param owner 현재 프로토콜의 소유자 주소
     */
    function mapCrossProtocolNFT(address nftContract, uint256 chainId, address owner) external {
        require(nftContract != address(0), "Invalid NFT contract address");
        require(owner != address(0), "Invalid owner address");

        // NFT 컨트랙트 주소와 체인 ID를 사용하여 고유 키 생성
        bytes32 nftKey = _getNFTKey(nftContract, chainId);

        // NFT와 소유자 주소 매핑
        nftToOwner[nftKey] = owner;

        emit CrossProtocolNFTMapped(nftContract, chainId, owner);
    }

    /**
     * @dev 특정 프로토콜의 NFT 소유자 조회 함수
     * @param nftContract 다른 프로토콜의 NFT 컨트랙트 주소
     * @param chainId 해당 프로토콜의 체인 ID
     * @return 현재 프로토콜의 소유자 주소
     */
    function getOwner(address nftContract, uint256 chainId) external view returns (address) {
        bytes32 nftKey = _getNFTKey(nftContract, chainId);
        return nftToOwner[nftKey];
    }
}
