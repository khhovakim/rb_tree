#ifndef   __RB_TREE_NODE__
# define  __RB_TREE_NODE__

# include "rb_tree_base_node.h"  // For rb_tree_base_node

namespace cxx {

  ///! @struct rb_tree_node
  ///! @brief Node structure for Red-Black Tree, templated by value type.
  ///
  ///! Inherits from rb_tree_base_node and stores a value of type ValueType.
  ///
  ///! @tparam ValueType The type of value stored in the node.
  template <typename ValueType>
  struct rb_tree_node : public rb_tree_base_node
  {
    ValueType _value { } ///< Value stored in the node.

    ///! @brief Constructs a new rb_tree_node with the given value.
    ///! @param value The value to store in the node.
    explicit rb_tree_node(const ValueType& value);
  };

}
#endif // __RB_TREE_NODE__