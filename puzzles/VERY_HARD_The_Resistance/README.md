
##### Main Features
- Binary_Trie, a `2way-trie` of morse code, containing a `Binary_Trie.iterator` class with a `fold` method, iterating along a given path in the tree.
- An extension of `Binary_Trie.iterator` as `Morse_Trie.iterator` with a method `fold`, taking advantage of `Open Recursion` to control interation/recursion.

##### Algoritm
1. Store the given dictionary in a `2way-trie` of morse code, storing the number of words matching a path, rather than the strings themselves.
2. Convert the given message to ````Left `Right``` directions in the trie.
3. Launch a main iteration over the trie with the directions from the message. Along the path if a word is encountered, launch new sub-iterations(recursions) over the trie with the current path as argument, and store the result of this recursion in class-wide `Hashtbl` (`Dynamic Programming`).
