     #ifndef   __RB_TREE_BASE_NODE__
# define  __RB_TREE_BASE_NODE__

namespace cxx {
  /// @enum rb_tree_node_color
  /// @brief Enumeration for the color of a node in a Red-Black Tree.
  ///
  /// This enumeration defines the two possible colors for nodes in a Red-Black Tree:
  /// Red and Black. These colors are used to maintain the balancing properties of the tree.
  enum class rb_tree_node_color {
      Red   = false, ///< Represents a red node in the tree.
      Black = true   ///< Represents a black node in the tree.
  };
  /// @struct rb_tree_base_node
  /// @brief Base node structure for a Red-Black Tree.
  ///
  /// This structure represents the fundamental node used in a Red-Black Tree implementation.
  /// It contains pointers to the parent, left child, and right child nodes, as well as the color of the node.
  /// The structure also provides static utility functions for traversing and querying the tree, such as finding
  /// the minimum and maximum nodes in a subtree, and obtaining the next and previous nodes in an in-order traversal.
  ///
  /// @tparam _color     Enum type representing the color of the node (red or black).
  /// @tparam _base_ptr  Pointer type to rb_tree_base_node.
  ///
  /// Members:
  ///   - _parent: Pointer to the parent node.
  ///   - _left: Pointer to the left child node.
  ///   - _right: Pointer to the right child node.
  ///   - _color: Color of the node (red or black).
  ///
  /// Static Member Functions:
  ///   - _minimum: Returns the minimum node in the subtree rooted at a given node.
  ///   - _maximum: Returns the maximum node in the subtree rooted at a given node.
  ///   - _next: Returns the next node in the in-order traversal.
  ///   - _prev: Returns the previous node in the in-order traversal.
  ///
  /// All functions take a sentinel node (_nil) representing the leaf/null node in the Red-Black Tree.
  struct rb_tree_base_node
  {
    using _node_color           = rb_tree_node_color ;
    using _base_ptr             = rb_tree_base_node *;

    _base_ptr   _parent { nullptr };          ///< Pointer to the parent node.
    _base_ptr   _left   { nullptr };          ///< Pointer to the left child node.
    _base_ptr   _right  { nullptr };          ///< Pointer to the right child node.
    _node_color _color  { _node_color::Red }; ///< Color of the node (red or black).

    /// @brief Minimum node in the subtree.
    /// @param _x Pointer to the node from which to find the minimum.
    /// @param _nil Sentinel node representing leaf/null in the Red-Black Tree.
    /// @return Pointer to the minimum node in the subtree rooted at `_x`.
    static constexpr _base_ptr _minimum(_base_ptr _x, const _base_ptr _nil) noexcept;

    /// @brief Maximum node in the subtree.
    /// @param _x Pointer to the node from which to find the maximum.
    /// @param _nil Sentinel node representing leaf/null in the Red-Black Tree.
    /// @return Pointer to the maximum node in the subtree rooted at `_x`.
    static constexpr _base_ptr _maximum(_base_ptr _x, const _base_ptr _nil) noexcept;

    /// @brief Get the next node in the in-order traversal.
    /// @param _x   Pointer to the current node.
    /// @param _nil Sentinel node representing leaf/null in the Red-Black Tree.
    /// @return Pointer to the next node in the in-order traversal.
    static constexpr _base_ptr _next(_base_ptr _x, const _base_ptr _nil) noexcept;

    /// @brief Get the previous node in the in-order traversal.
    /// @param _x Pointer to the current node.
    /// @param _nil Sentinel node representing leaf/null in the Red-Black Tree.
    /// @return Pointer to the previous node in the in-order traversal.
    static constexpr _base_ptr _prev(_base_ptr _x, const _base_ptr _nil) noexcept;

  };
} // namespace cxx

#endif // __RB_TREE_BASE_NODE__