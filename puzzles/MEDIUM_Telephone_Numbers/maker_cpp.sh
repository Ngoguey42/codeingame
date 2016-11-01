
# sh maker.sh | pbcopy
# sh maker.sh > /dev/clipboard
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

# printf "" > tot.ml

# echo "(* CFG:" >> tot.ml
# cat cfg >> tot.ml
# echo "*)" >> tot.ml

# cat utils.ml >> tot.ml
# cat stream.ml >> tot.ml
# cat read_write_primitive.ml >> tot.ml
# cat cfg.ml >> tot.ml


# echo ";; (* End of modules declaration *)" >> tot.ml

set -e

rm -f /tmp/Answer.cpp

cat trie.hpp >> /tmp/Answer.cpp
cat main.cpp >> /tmp/Answer.cpp

x86_64-w64-mingw32-g++.exe -static -Wextra -Wall -std=c++11 /tmp/Answer.cpp
