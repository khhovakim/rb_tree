#ifndef   __RB_TREE_NODE__
# define  __RB_TREE_NODE__

# include "rb_tree_base_node.h"  // For rb_tree_base_node

namespace cxx {

  /// @struct rb_tree_node
  /// @brief Node structure for Red-Black Tree, templated by value type.
  ///
  /// Inherits from rb_tree_base_node and stores a value of type ValueType.
  ///
  /// @tparam ValueType The type of value stored in the node.
  template <typename ValueType>
  struct rb_tree_node : public rb_tree_base_node
  {
    using base      = rb_tree_base_node;
    using base_ptr  = rb_tree_base_node *;
    using node_ptr  = rb_tree_node *;
    using color     = typename base::color;

    ValueType _value; ///< Value stored in the node.

    /// @brief Constructs a new rb_tree_node with the given value.
    /// @param value The value to store in the node.
    explicit rb_tree_node(const ValueType& value)
      : _value { value }
    { }

    /// @brief Creates a new node with the given value.
    /// @param value The value to store in the new node.
    /// @return Pointer to the newly created node.
    [[nodiscard]]
    static node_ptr create_node(const value_type& value, const base_ptr nil) noexcept {
      // Allocate a new node holding `value`.
      node_ptr new_node = new node(value);
      // Initialize children to the tree sentinel `_nil` (represents null leaves).
      new_node->_left   = nil;
      new_node->_right  = nil;
      // New nodes start as red; balancing logic will fix colors/structure as needed.
      new_node->_color  = color::Red;
      // Parent is assigned by the insertion routine.
      return new_node;
    }
  };

}
#endif // __RB_TREE_NODE__