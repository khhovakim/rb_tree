#ifndef   __RB_TREE_ITERATOR__
# define  __RB_TREE_ITERATOR__

# include <bits/c++config.h>                // For std::ptrdiff_t
# include <bits/stl_iterator_base_types.h>  // For std::bidirectional_iterator_tag

# include "rb_tree_base_node.h"  // For cxx::rb_tree_base_node
# include "rb_tree_node.h"       // For cxx::rb_tree_node

namespace cxx {
  /// @brief Iterator for red-black trees.
  /// This class provides an iterator for traversing red-black trees.
  /// It supports both read and write access to the elements of the tree.

  template <typename T>
  struct rb_tree_iterator
  {
  private:
    using _base_type = rb_tree_base_node;
    using _base_ptr  = rb_tree_base_node *;
    using _node_ptr  = rb_tree_node<T> *;

  public:
    using value_type = T;
    using pointer    = T*;
    using reference  = T&;

    using iterator_category = std::bidirectional_iterator_tag;
    using difference_type   = std::ptrdiff_t;

    /// @brief Constructor with a node pointer and nil pointer.
    /// Initializes the iterator with the given node and nil pointers.
    /// @param node Pointer to the node.
    /// @param nil  Pointer to the nil node.
    explicit rb_tree_iterator(_node_ptr node, const _base_ptr nil)
      : _node { node }, _nil { nil }
    { }

    /// @brief Copy constructor.
    /// Initializes the iterator with another iterator.
    constexpr rb_tree_iterator(const rb_tree_iterator& other)
      : _node { other._node }, _nil { other._nil }
    { }

    /// @brief Dereference operator.
    /// Returns a reference to the value stored in the node pointed to by the iterator.
    /// @return Reference to the value.
    constexpr reference operator*() const noexcept {
      return _node->m_valueField;
    }

    /// @brief Arrow operator.
    /// Returns a pointer to the value stored in the node pointed to by the iterator.
    /// @return Pointer to the value.
    constexpr pointer operator->() const noexcept {
      return &_node->m_valueField;
    }

    /// @brief Pre-increment operator.
    /// Moves the iterator to the next node in the tree.
    /// @return Reference to the updated iterator.
    rb_tree_iterator& operator++() {
      _node = static_cast<_node_ptr>(_base_type::_next(_node, _nil));
      return *this;
    }

    /// @brief Post-increment operator.
    /// Moves the iterator to the next node in the tree and returns a copy of the original iterator.
    /// @return Copy of the original iterator.
    rb_tree_iterator operator++(int) {
      const rb_tree_iterator tmp = *this;
      ++(*this);
      return tmp;
    }

    /// @brief Pre-decrement operator.
    /// Moves the iterator to the previous node in the tree.
    /// @return Reference to the updated iterator.
    rb_tree_iterator& operator--() {
      _node = static_cast<_node_ptr>(_base_type::_prev(_node, _nil));
      return *this;
    }

    /// @brief Post-decrement operator.
    /// Moves the iterator to the previous node in the tree and returns a copy of the original iterator.
    /// @return Copy of the original iterator.
    rb_tree_iterator operator--(int) {
      constexpr rb_tree_iterator tmp = *this;
      --(*this);
      return tmp;
    }

    /// @brief Equality operator.
    /// Checks if two iterators point to the same node.
    constexpr bool operator==(const rb_tree_iterator& other) const noexcept {
      return _node == other._node;
    }

    /// @brief Inequality operator.
    /// Checks if two iterators point to different nodes.
    constexpr bool operator!=(const rb_tree_iterator& other) const noexcept {
      return _node != other._node;
    }

    _node_ptr _node;      ///< Pointer to the current node in the tree.
    const _base_ptr _nil; ///< Pointer to the nil node in the tree.
  };

} // namespace cxx

namespace cxx {
  /// @brief Const iterator for red-black trees.
  /// This class provides an iterator for traversing red-black trees.
  /// It supports to read access to the elements of the tree.

  template <typename T>
  struct rb_tree_const_iterator
  {
  private:
    using _base_type = rb_tree_base_node;
    using _base_ptr  = const rb_tree_base_node *;
    using _node_ptr  = const rb_tree_node<T> *;
    using _iterator  = rb_tree_iterator<T>;

  public:
    using value_type = T;
    using pointer    = const T*;
    using reference  = const T&;

    using iterator_category = std::bidirectional_iterator_tag;
    using difference_type   = std::ptrdiff_t;

    /// @brief Constructor with a base pointer.
    /// Initializes the const iterator with the given base pointer.
    /// @param node Pointer to the base node.
    /// @param nil  Pointer to the nil  node.
    explicit rb_tree_const_iterator(_node_ptr node, _base_ptr nil)
      : _node { node }, _nil { nil }
    { }

    /// @brief Constructor from a non-const iterator.
    /// Initializes the const iterator with a non-const iterator.
    /// @param it The non-const iterator to copy from.
    explicit rb_tree_const_iterator(const _iterator& it)
      : _node { it._node }, _nil { it._nil }
    { }

    /// @brief Copy constructor.
    /// Initializes the const iterator with another const iterator.
    /// @param other The other const iterator to copy from.
    rb_tree_const_iterator(const rb_tree_const_iterator& other)
      : _node { other._node }, _nil { other._nil }
    { }

    /// @brief Dereference operator.
    /// Returns a const reference to the value pointed to by the iterator.
    /// @return Const reference to the value.
    reference operator*() const noexcept {
      return _node->value;
    }

    /// @brief Arrow operator.
    /// Returns a const pointer to the value pointed to by the iterator.
    /// @return Const pointer to the value.
    pointer operator->() const noexcept {
      return &_node->value;
    }

    /// @brief Pre-increment operator.
    /// Moves the iterator to the next node in the tree.
    /// @return Reference to the updated iterator.
    rb_tree_const_iterator& operator++() noexcept {
      _node = static_cast<_node_ptr>(_base_type::_next(_node, _nil));
      return *this;
    }

    /// @brief Post-increment operator.
    /// Moves the iterator to the next node in the tree.
    /// @return Value of the iterator before incrementing.
    rb_tree_const_iterator operator++(int) noexcept {
      constexpr rb_tree_const_iterator tmp = *this;
      ++(*this);
      return tmp;
    }

    /// @brief Pre-decrement operator.
    /// Moves the iterator to the previous node in the tree.
    /// @return Reference to the updated iterator.
    rb_tree_const_iterator& operator--() noexcept {
      _node = static_cast<_node_ptr>(_base_type::_prev(_node, _nil));
      return *this;
    }

    /// @brief Post-decrement operator.
    /// Moves the iterator to the previous node in the tree.
    /// @return Value of the iterator before decrementing.
    rb_tree_const_iterator operator--(int) noexcept {
      const rb_tree_const_iterator tmp = *this;
      --(*this);
      return tmp;
    }

    /// @brief Inequality operator.
    /// Checks if two const iterators point to different nodes.
    /// @param other The other const iterator to compare with.
    /// @return True if the iterators are not equal, false otherwise.
    constexpr bool operator!=(const rb_tree_const_iterator& other) const noexcept {
      return _node != other._node;
    }

    /// @brief Equality operator.
    /// Checks if two const iterators point to the same node.
    /// @param other The other const iterator to compare with.
    /// @return True if the iterators are equal, false otherwise.
    constexpr bool operator==(const rb_tree_const_iterator& other) const noexcept {
      return _node == other._node;
    }

    _node_ptr _node; ///< Pointer to the current node in the tree.
    _base_ptr _nil;  ///< Pointer to the nil node in the tree.
  };
} // namespace cxx

#endif // __RB_TREE_ITERATOR__