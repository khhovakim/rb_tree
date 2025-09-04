#ifndef   __RB_TREE__
# define  __RB_TREE__

# include <bits/c++config.h>    // For std::size_t
# include <bits/stl_pair.h>     // For std::pair
# include <bits/stl_function.h> // For std::less

# include "rb_tree_node.h"     // For cxx::rb_tree_node
# include "rb_tree_iterator.h" // For cxx::rb_tree_iterator, cxx::rb_tree_const_iterator
# include "rb_tree_utility.h"  // For cxx::_clear_rb_tree, cxx::_height_rb_tree

namespace cxx {

  ///
  /// @brief Red-Black Tree implementation.
  ///
  /// This class provides an implementation of a balanced binary search tree
  /// using the Red-Black Tree algorithm. It supports efficient insertion,
  /// deletion, and lookup operations.
  ///
  /// @tparam ValueType Type of values stored in the tree.
  /// @tparam Compare Comparison functor used to order elements, defaults to std::less<ValueType>.
  ///
  template <typename ValueType, typename Compare = std::less<ValueType>>
  class rb_tree
  {
    using node       = rb_tree_node<ValueType>;
    using base       = typename node::base;
    using node_ptr   = node*;
    using base_ptr   = typename node::base_ptr;
    using color      = typename base::color;
  
  public:
    using value_type = ValueType;
    using reference  = ValueType&;
    using pointer    = ValueType*;
    using cmp_type   = Compare;
    using size_type  = std::size_t;
    
  public:
    using iterator        = rb_tree_iterator<node>;
    using const_iterator  = rb_tree_const_iterator<node>;
    
  public:
    using pair_type  = std::pair<iterator, bool>;
    
    /// @brief Constructs an empty Red-Black Tree with an optional comparison functor.
    explicit rb_tree(const cmp_type& comp = cmp_type())
      : _comp { comp }
    {
      _nil = new base;
      _nil->_color  = color::Black;
      _nil->_parent = _root;
      _root = _nil;
    }

    /// @brief Copy constructor. Creates a deep copy of another Red-Black Tree.
    rb_tree(const rb_tree& other)
      : _comp { other._comp }, _size { other._size }
    {
      _copy(other._root, other._nil);
    }

    /// @brief Destructor. Clears the tree and releases resources.
    ~rb_tree() {
      clear(_root, _nil);
      delete _nil;
    }

    /// @brief Assignment operator.
    rb_tree& operator=(const rb_tree& other);

    public:

    /// @brief Removes all elements from the tree.
    void clear() noexcept {
      _clear_rb_tree(_root, _nil);
      _root = _nil;
      _size = 0;
    }

    /// @brief Returns the number of elements in the tree.
    [[nodiscard]]
    size_type size() const noexcept {
      return _size;
    }

    /// @brief Checks if the tree is empty.
    [[nodiscard]]
    bool empty() const noexcept {
      return _size == 0;
    }

    /// @brief Returns the comparison functor used by the tree.
    [[nodiscard]]
    cmp_type key_comp() const noexcept {
      return _comp;
    }

    /// @brief Returns the height of the tree.
    [[nodiscard]]
    size_type height() const noexcept {
      return _height_rb_tree(_root, _nil);
    }

    [[nodiscard]]
    const node_ptr root() const noexcept {
      return _root;
    }

    [[nodiscard]]
    const base_ptr nil() const noexcept {
      return _nil;
    }

    [[nodiscard]]
    const node_ptr min() const noexcept {
      return static_cast<node_ptr>(base::_minimum(_root, _nil));
    }

    [[nodiscard]]
    const node_ptr max() const noexcept {
      return static_cast<node_ptr>(base::_maximum(_root, _nil));
    }

    /// @brief Inserts a value into the tree.
    /// @param value The value to insert.
    /// @return A pair containing a pointer to the inserted node and a boolean indicating success.
    pair_type insert(const value_type& value) {
      return _insert(new_node);
    }

    /// @brief Searches for a node with the given value.
    /// @param value The value to search for.
    /// @return Pointer to the node if found, nullptr otherwise.
    const node_ptr search(const value_type& value) const noexcept {
      node_ptr result = _search(value);
      if ( result != _nil && _values_equivalent(result, value) ) {
        return result; // Value found
      }

      return nullptr; // Value not found
    }
    
  private:
    /// @brief Searches for a node with the given value.
    /// @param value The value to search for.
    /// @return Pointer to the node if found, _nil otherwise.
    node_ptr _search(const value_type& value) const noexcept;

    /// @brief Copies the structure and elements from another tree.
    /// @param other_root Root of the other tree to copy from.
    /// @param other_nil Sentinel node of the other tree.
    void _copy(const node_ptr other_root, const base_ptr other_nil);

    /// @brief Check if a node's value is equal to a given value using the tree comparator.
    /// @param n Pointer to the node to compare.
    /// @param value The value to compare against.
    /// @return true if values are equivalent (i.e. neither is considered less than the other).
    bool _values_equivalent(const node_ptr n, const value_type& value) const noexcept {
      // Two values are equal under Compare if !(a < b) && !(b < a)
      return !_comp(n->_value, value) && !_comp(value, n->_value);
    }

    /// @brief Inserts a new node into the tree and rebalances it.
    /// @param value The value to insert.
    /// @return A pair containing a pointer to the inserted node and a boolean indicating success.
    pair_type _insert(const value_type& value);
  private:
    node_ptr  _root { nullptr }; ///< Pointer to the root node of the tree.
    base_ptr  _nil  { nullptr }; ///< Sentinel node representing leaf/null in the Red-Black Tree.
    size_type _size { 0 };       ///< Number of nodes in the tree.
    cmp_type  _comp;             ///< Comparison functor for ordering elements.
  };

  template <typename ValueType, typename Compare>
  rb_tree<ValueType, Compare>&
  rb_tree<ValueType, Compare>::operator=(const rb_tree& other)
  {
    if ( this == &other ) {
      return *this;
    }

    clear();
    _comp = other._comp;
    _copy(other._root, other._nil);
    _size = other._size;
    return *this;
  }

  template <typename ValueType, typename Compare>
  void rb_tree<ValueType, Compare>::
  _copy(const node_ptr other_root, const base_ptr other_nil)
  {
    if ( other_root == other_nil ) {
      return;
    }

    // Insert the new node into the tree
    insert(other_root->_value);
    // Recursively copy the left and right subtrees
    _copy(other_root->_left, other_nil);
    _copy(other_root->_right, other_nil);
  }

  template <typename ValueType, typename Compare>
  typename rb_tree<ValueType, Compare>::node_ptr
  rb_tree<ValueType, Compare>::_search(const value_type& value) const noexcept
  {
    node_ptr current = _root;
    node_ptr parent  = _nil;

    while ( current != _nil ) {
      parent = current;
      if ( _comp(value, current->_value) ) {
        current = current->_left;
      } else if ( _comp(current->_value, value) ) {
        current = current->_right;
      } else {
        return current; // Value found
      }
    }

    return parent; // Value not found
  }

  template <typename ValueType, typename Compare>
  typename rb_tree<ValueType, Compare>::pair_type
  rb_tree<ValueType, Compare>::_insert(const value_type& value)
  {
    node_ptr parent = _search(value);
    if ( parent != _nil && _values_equivalent(parent, value) ) {
      return { iterator { parent, _nil }, false };
    }

    node_ptr new_node = node::create_node(value, _nil);
    new_node->_parent = parent;
    if ( parent == _nil ) {
      _root = new_node; // Tree was empty, new node becomes root
    } else if ( _comp(new_node->_value, parent->_value) ) {
      parent->_left = new_node; // Insert as left child
    } else {
      parent->_right = new_node; // Insert as right child
    }

    ++_size;
    // Todo: Implement _insert_fixup to maintain Red-Black properties after insertion
    _insert_fixup(new_node, _root, _nil);
    return { iterator { new_node, _nil }, true };
  }
} // namespace cxx

#endif // __RB_TREE__