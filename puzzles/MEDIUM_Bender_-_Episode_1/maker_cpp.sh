
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

rm -f tot.cpp

cat city.cpp >> tot.cpp
cat directions.cpp >> tot.cpp
cat states.hpp >> tot.cpp
cat bender.hpp >> tot.cpp
cat main.cpp >> tot.cpp

x86_64-w64-mingw32-g++.exe -static -Wextra -Wall -std=c++11 tot.cpp
