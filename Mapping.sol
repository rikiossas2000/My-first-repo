// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract FavoriteRecords {
    // State variables
    mapping(string => bool) public approvedRecords;
    mapping(address => mapping(string => bool)) private userFavoritesMapping;
    mapping(address => string[]) private userFavoritesList; // Simpan order

    string[] private approvedList;

    // Custom error
    error NotApproved(string album);

    constructor() {
        // Load approved albums
        string[9] memory albums = [
            "Thriller",
            "Back in Black",
            "The Bodyguard",
            "The Dark Side of the Moon",
            "Their Greatest Hits (1971-1975)",
            "Hotel California",
            "Come On Over",
            "Rumours",
            "Saturday Night Fever"
        ];

        for (uint i = 0; i < albums.length; i++) {
            approvedRecords[albums[i]] = true;
            approvedList.push(albums[i]);
        }
    }

    // Get all approved albums
    function getApprovedRecords() public view returns (string[] memory) {
        return approvedList;
    }

    // Add album to sender's favorites
    function addRecord(string memory album) public {
        if (!approvedRecords[album]) {
            revert NotApproved(album);
        }
        if (!userFavoritesMapping[msg.sender][album]) {
            userFavoritesMapping[msg.sender][album] = true;
            userFavoritesList[msg.sender].push(album);
        }
    }

    // Get favorites of a user
    function getUserFavorites(address user) public view returns (string[] memory) {
        return userFavoritesList[user];
    }

    // Reset sender's favorites
    function resetUserFavorites() public {
        string[] storage list = userFavoritesList[msg.sender];
        for (uint i = 0; i < list.length; i++) {
            userFavoritesMapping[msg.sender][list[i]] = false;
        }
        delete userFavoritesList[msg.sender];
    }
}
