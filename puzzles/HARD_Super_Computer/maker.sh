
# sh maker.sh | pbcopy
# sh maker.sh > /dev/clipboard
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

printf "" > tot.ml

echo "(* Embedding BIOCAML's library interval_tree.mli(truncated) in code: *)" >> tot.ml
echo "module type Interval_intf =" >> tot.ml
echo "sig" >> tot.ml
cat biocaml/interval_tree.mli >> tot.ml
echo "end" >> tot.ml
echo "(* End of BIOCAML's interval_tree.mli(truncated) *)" >> tot.ml

echo "(* Embedding BIOCAML's library interval_tree.ml(truncated) in code: *)" >> tot.ml
echo "module Interval : Interval_intf =" >> tot.ml
echo "struct" >> tot.ml
cat biocaml/interval_tree.ml >> tot.ml
echo "end" >> tot.ml
echo "(* End of BIOCAML's interval_tree.ml(truncated) *)" >> tot.ml

# cat utils.ml >> tot.ml
# cat stream.ml >> tot.ml
# cat read_write_primitive.ml >> tot.ml
# cat cfg.ml >> tot.ml


echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
