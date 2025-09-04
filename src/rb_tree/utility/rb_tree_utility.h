#ifndef   __RB_TREE_UTILITY__
# define  __RB_TREE_UTILITY__

# include <bits/c++config.h>    // For std::size_t

# include "rb_tree_node.h" // For rb_tree_node, rb_tree_base_node

namespace cxx {

  /// @brief Recursively deletes all nodes in the subtree rooted at `node`, except the sentinel `nil`.
  /// @param node Pointer to the current node.
  /// @param nil Sentinel node pointer (not deleted).
  /// @tparam ValueType The type of value stored in the node.
  template <typename ValueType>
  inline void _clear_rb_tree(rb_tree_node<ValueType>* node, const rb_tree_base_node* nil) noexcept
  {
    if ( node == nil ) {
      return;
    }

    _clear_rb_tree(node->_left, nil);
    _clear_rb_tree(node->_right, nil);
    delete node;
  }

  /// @brief Calculate the height of the subtree rooted at `node`.
  /// @param node Pointer to the root of the subtree.
  /// @param nil Sentinel node representing leaf/null in the Red-Black Tree.
  /// @return Height of the subtree.
  std::size_t 
  _height_rb_tree(const rb_tree_base_node* node, const rb_tree_base_node* nil) noexcept;

} // namespace cxx

#endif // __RB_TREE_UTILITY__