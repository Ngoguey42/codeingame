

# sh maker.sh | pbcopy
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml && ./a.out

rm -rf tot.ml
cat ft.ml >> tot.ml
cat types.ml >> tot.ml

cat make_vertices_data.ml >> tot.ml
cat make_edges_data.ml >> tot.ml

cat make_graph.ml >> tot.ml

echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
