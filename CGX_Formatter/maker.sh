
# sh maker.sh | pbcopy
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

printf "" > tot.ml

# cat ft.ml >> tot.ml
cat stream.ml >> tot.ml
cat read_write_primitive.ml >> tot.ml
cat cfg.ml >> tot.ml


echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
