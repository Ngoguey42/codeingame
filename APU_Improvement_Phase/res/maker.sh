

# sh maker.sh | pbcopy
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml && ./a.out

rm -rf tot.ml
cat ft_string.ml >> tot.ml
cat types.ml >> tot.ml
cat make_edge_array.ml >> tot.ml
cat graph_make.ml >> tot.ml

echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
