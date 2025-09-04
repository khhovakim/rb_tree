#include "rb_tree_base_node.h"

// This namespace encapsulates the fundamental components and algorithms used to manage
// Red-Black Tree nodes, including operations for finding minimum and maximum nodes within
// the tree structure.
namespace cxx {

  // Finds the minimum node in the Red-Black Tree rooted at _x.
  // Traverses left children until reaching the leftmost node or the nil sentinel.
  constexpr rb_tree_base_node *
  rb_tree_base_node::_minimum(_base_ptr _x, const _base_ptr _nil) noexcept
  {
    if ( _x == _nil ) {
      return _x;
    }

    while ( _x->_left != _nil ) {
      _x = _x->_left;
    }

    return _x;
  }

  // Finds the maximum node in the Red-Black Tree rooted at _x.
  // Traverses right children until reaching the rightmost node or the nil sentinel.
  constexpr rb_tree_base_node *
  rb_tree_base_node::_maximum(_base_ptr _x, const _base_ptr _nil) noexcept
  {
    if ( _x == _nil ) {
      return _x;
    }

    while ( _x->_right != _nil ) {
      _x = _x->_right;
    }

    return _x;
  }

} // namespace cxx

// Implementation of next and prev node search in Red-Black Tree.
// These functions find the in-order successor (_next) and predecessor (_prev)
// of a given node in the tree, handling the nil sentinel node appropriately.
namespace cxx {

  // Finds the in-order successor of node _x in the Red-Black Tree.
  // If _x has a right child, the successor is the minimum node in the right subtree.
  // Otherwise, traverse up the tree until finding a node that is a left child of its parent.
  constexpr rb_tree_base_node *
  rb_tree_base_node::_next(_base_ptr _x, const _base_ptr _nil) noexcept
  {
    if ( _x == _nil ) {
      return _x;
    }

    if ( _x->_right != _nil ) {
      return _minimum(_x->_right, _nil);
    }

    _base_ptr _parent = _x->_parent;
    while ( _parent != _nil && _x == _parent->_right ) {
      _x = _parent;
      _parent = _parent->_parent;
    }

    return _parent;
  }

  // Finds the in-order predecessor of node _x in the Red-Black Tree.
  // If _x has a left child, the predecessor is the maximum node in the left subtree.
  // Otherwise, traverse up the tree until finding a node that is a right child of its parent.
  constexpr rb_tree_base_node *
  rb_tree_base_node::_prev(_base_ptr _x, const _base_ptr _nil) noexcept
  {
    if ( _x == _nil ) {
      return _x;
    }

    if ( _x->_left != _nil ) {
      return _maximum(_x->_left, _nil);
    }

    _base_ptr _parent = _x->_parent;
    while ( _parent != _nil && _x == _parent->_left ) {
      _x = _parent;
      _parent = _parent->_parent;
    }

    return _parent;
  }

} // namespace cxx
