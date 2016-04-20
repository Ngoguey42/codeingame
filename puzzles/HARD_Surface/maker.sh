
# sh maker.sh | pbcopy
# sh maker.sh > /dev/clipboard
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

printf "" > tot.ml

# echo "(* CFG:" >> tot.ml
# cat cfg >> tot.ml
# echo "*)" >> tot.ml

# cat utils.ml >> tot.ml
# cat stream.ml >> tot.ml
cat node.ml >> tot.ml
cat map.ml >> tot.ml


echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
