# Achievement-badge-system-for-games
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title GameAchievements
 * @dev A smart contract for managing game achievements and badges
 * @author Your Name
 */
contract GameAchievements {
    
    // Structure to define an achievement
    struct Achievement {
        string name;
        string description;
        uint256 points;
        bool exists;
    }
    
    // Mapping from achievement ID to Achievement struct
    mapping(uint256 => Achievement) public achievements;
    
    // Mapping from player address to achievement ID to unlock status
    mapping(address => mapping(uint256 => bool)) public playerAchievements;
    
    // Mapping from player address to total points earned
    mapping(address => uint256) public playerPoints;
    
    // Array to keep track of all achievement IDs
    uint256[] public achievementIds;
    
    // Contract owner (game administrator)
    address public owner;
    
    // Events
    event AchievementCreated(uint256 indexed achievementId, string name, uint256 points);
    event AchievementUnlocked(address indexed player, uint256 indexed achievementId, uint256 pointsEarned);
    
    // Modifier to restrict access to owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can perform this action");
        _;
    }
        owner = msg.sender;
    }
    
    /**
     * @dev Creates a new achievement (only owner)
     * @param _achievementId Unique identifier for the achievement
     * @param _name Name of the achievement
     * @param _description Description of the achievement
     * @param _points Points awarded for this achievement
     */
    function createAchievement(
        uint256 _achievementId,
        string memory _name,
        string memory _description,
        uint256 _points
    ) external onlyOwner {
        require(!achievements[_achievementId].exists, "Achievement already exists");
        require(bytes(_name).length > 0, "Achievement name cannot be empty");
        require(_points > 0, "Points must be greater than zero");
        
        achievements[_achievementId] = Achievement({
            name: _name,
            description: _description,
            points: _points,
            exists: true
        });
        
        achievementIds.push(_achievementId);
        
        emit AchievementCreated(_achievementId, _name, _points);
    }
    
    /**
     * @dev Unlocks an achievement for a player (only owner)
     * @param _player Address of the player
     * @param _achievementId ID of the achievement to unlock
     */
    function unlockAchievement(address _player, uint256 _achievementId) 
        external 
        onlyOwner 
        achievementExists(_achievementId) 
    {
        require(_player != address(0), "Invalid player address");
        require(!playerAchievements[_player][_achievementId], "Achievement already unlocked");
        
        playerAchievements[_player][_achievementId] = true;
        playerPoints[_player] += achievements[_achievementId].points;
        
        emit AchievementUnlocked(_player, _achievementId, achievements[_achievementId].points);
    }
    
    /**
     * @dev Checks if a player has unlocked a specific achievement
     * @param _player Address of the player
     * @param _achievementId ID of the achievement
     * @return bool True if achievement is unlocked, false otherwise
     */
    function hasAchievement(address _player, uint256 _achievementId) 
        external 
        view 
        achievementExists(_achievementId) 
        returns (bool) 
    {
        return playerAchievements[_player][_achievementId];
    }
    
    /**
     * @dev Gets total points earned by a player
     * @param _player Address of the player
     * @return uint256 Total points earned
     */
    function getPlayerPoints(address _player) external view returns (uint256) {
        return playerPoints[_player];
    }
    
    /**
     * @dev Gets all achievement IDs
     * @return uint256[] Array of all achievement IDs
     */
    function getAllAchievementIds() external view returns (uint256[] memory) {
        return achievementIds;
    }
    
    /**
     * @dev Gets achievement details by ID
     * @param _achievementId ID of the achievement
     * @return name Name of the achievement
     * @return description Description of the achievement
     * @return points Points awarded for the achievement
     */
    function getAchievementDetails(uint256 _achievementId) 
        external 
        view 
        achievementExists(_achievementId) 
        returns (string memory name, string memory description, uint256 points) 
    {
        Achievement memory achievement = achievements[_achievementId];
        return (achievement.name, achievement.description, achievement.points);
    }
}    
    // Modifier to check if achievement exists
    modifier achievementExists(uint256 _achievementId) {
        require(achievements[_achievementId].exists, "Achievement does not exist");
        _;
    }
    
    constructor() {
