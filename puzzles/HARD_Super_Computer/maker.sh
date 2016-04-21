
# sh maker.sh | pbcopy
# sh maker.sh > /dev/clipboard
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

function put_lib_file() {

	LIB_NAME=$1
	FILE_PREFIX=$2
	MODULE_NAME=$3

	printf "(* Embedding %s's library %s.mli in code: *)\n"\
		   $LIB_NAME $FILE_PREFIX\
		   >> tot.ml
	printf "module type %s_intf =\n" $MODULE_NAME >> tot.ml
	echo "sig" >> tot.ml
	cat $LIB_NAME/$FILE_PREFIX.mli >> tot.ml
	echo "end" >> tot.ml
	printf "(* End of %s's %s.mli *)\n"\
		   $LIB_NAME $FILE_PREFIX\
		   >> tot.ml

	printf "(* Embedding %s's library %s.ml in code: *)\n"\
		   $LIB_NAME $FILE_PREFIX\
		   >> tot.ml
	printf "module %s : %s_intf =\n" $MODULE_NAME $MODULE_NAME >> tot.ml
	echo "struct" >> tot.ml
	cat $LIB_NAME/$FILE_PREFIX.ml >> tot.ml
	echo "end" >> tot.ml
	printf "(* End of %s's %s.ml *)\n"\
		   $LIB_NAME $FILE_PREFIX\
		   >> tot.ml

}


printf "" > tot.ml

put_lib_file "biocaml" "interval_tree" "Interval"
put_lib_file "filliatr" "binary_heap" "BinHeap"

# echo "(* Embedding BIOCAML's library interval_tree.mli(truncated) in code: *)" >> tot.ml
# echo "module type Interval_intf =" >> tot.ml
# echo "sig" >> tot.ml
# cat biocaml/interval_tree.mli >> tot.ml
# echo "end" >> tot.ml
# echo "(* End of BIOCAML's interval_tree.mli(truncated) *)" >> tot.ml

# echo "(* Embedding BIOCAML's library interval_tree.ml(truncated) in code: *)" >> tot.ml
# echo "module Interval : Interval_intf =" >> tot.ml
# echo "struct" >> tot.ml
# cat biocaml/interval_tree.ml >> tot.ml
# echo "end" >> tot.ml
# echo "(* End of BIOCAML's interval_tree.ml(truncated) *)" >> tot.ml

# cat utils.ml >> tot.ml
# cat stream.ml >> tot.ml
# cat read_write_primitive.ml >> tot.ml
# cat cfg.ml >> tot.ml

echo ";; (* End of modules declaration *)" >> tot.ml

cat main.ml >> tot.ml

cat tot.ml
rm -rf tot.ml
