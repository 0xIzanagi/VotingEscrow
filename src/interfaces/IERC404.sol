// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.10;

interface IERC404 {
    // =============================================================
    //                            EVENTS
    // =============================================================
    event ERC20Transfer(address indexed from, address indexed to, uint256 amount);
    event Approval(address indexed owner, address indexed spender, uint256 amount);
    event Transfer(address indexed from, address indexed to, uint256 indexed id);
    event ERC721Approval(address indexed owner, address indexed spender, uint256 indexed id);
    event ApprovalForAll(address indexed owner, address indexed operator, bool approved);

    // =============================================================
    //                            ERRORS
    // =============================================================

    error NotFound();
    error AlreadyExists();
    error InvalidRecipient();
    error InvalidSender();
    error UnsafeRecipient();
    error ApprovalCallerNotOwnerNorApproved();
    error ApprovalQueryForNonexistentToken();
    error BalanceQueryForZeroAddress();
    error MintToZeroAddress();
    error MintZeroQuantity();
    error OwnerQueryForNonexistentToken();
    error TransferCallerNotOwnerNorApproved();
    error TransferFromIncorrectOwner();
    error TransferToNonERC721ReceiverImplementer();
    error TransferToZeroAddress();
    error URIQueryForNonexistentToken();
    error MintERC2309QuantityExceedsLimit();
    error OwnershipNotInitializedForExtraData();

    // =============================================================
    //                            STRUCTS
    // =============================================================

    struct TokenOwnership {
        // The address of the owner.
        address addr;
        // Stores the start time of ownership with minimal overhead for tokenomics.
        uint64 startTimestamp;
        // Whether the token has been burned.
        bool burned;
        // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
        uint24 extraData;
    }

    struct TokenApprovalRef {
        address value;
    }

    // =============================================================
    //                        EXTERNAL FUNCTIONS
    // =============================================================

    /// @dev Total supply in fractionalized representation
    function totalSupply() external view returns (uint256);

    /// @dev Current mint counter, monotonically increasing to ensure accurate ownership
    function minted() external view returns (uint256);

    /// @dev Balance of user in fractional representation
    function balanceOf(address) external view returns (uint256);

    /// @dev Allowance of user in fractional representation
    function allowance(address, address) external view returns (uint256);

    /// @dev Approval in native representaion
    function getApproved(uint256) external view returns (address);

    /// @dev Approval for all in native representation
    function isApprovedForAll(address, address) external view returns (bool);

    /// @dev Addresses whitelisted from minting / burning for gas savings (pairs, routers, etc)
    function whitelist(address) external view returns (bool);

    /// @dev Token name
    function name() external view returns (string memory);

    /// @dev Token symbol
    function symbol() external view returns (string memory);

    /// @notice Initialization function to set pairs / etc
    ///         saving gas by avoiding mint / burn on unnecessary targets
    function setWhitelist(address target, bool state) external;

    /// @notice Function to find owner of a given native token
    function ownerOf(uint256 id) external view returns (address owner);

    /// @notice tokenURI must be implemented by child contract
    function tokenURI(uint256 id) external view returns (string memory);

    /// @notice Function for token approvals
    /// @dev This function assumes id / native if amount less than or equal to current max id
    function approve(address spender, uint256 amountOrId) external returns (bool);

    /// @notice Function native approvals
    function setApprovalForAll(address operator, bool approved) external;

    /// @notice Function for mixed transfers
    /// @dev This function assumes id / native if amount less than or equal to current max id
    function transferFrom(address from, address to, uint256 amountOrId) external;

    /// @notice Function for fractional transfers
    function transfer(address to, uint256 amount) external returns (bool);

    /// @notice Function for native transfers with contract support
    function safeTransferFrom(address from, address to, uint256 id) external;

    /// @notice Function for native transfers with contract support and callback data
    function safeTransferFrom(address from, address to, uint256 id, bytes calldata data) external;
}
