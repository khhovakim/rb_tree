#include <cstddef>    // For std::size_t
#include <algorithm>  // For std::max

#include "include/rb_tree_base_node.h" // For rb_tree_base_node

namespace cxx {

  std::size_t
  _height_rb_tree(const rb_tree_base_node* node, const rb_tree_base_node* nil) noexcept
  {
    if ( node == nil ) {
      return 0;
    }
    const std::size_t left_height  = _height_rb_tree(node->_left, nil);
    const std::size_t right_height = _height_rb_tree(node->_right, nil);
    return 1 + std::max(left_height, right_height);
  }

} // namespace cxx
