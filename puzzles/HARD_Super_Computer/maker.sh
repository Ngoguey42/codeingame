
# sh maker.sh | pbcopy
# sh maker.sh > /dev/clipboard
# and paste to codingame

# or

# sh maker.sh > tmp.ml && ocamlc tmp.ml

function put_ml_header() {

	STR="$@"
	COUNT_STAR=$(( 80 - 1 - 3 - 3 - ${#STR} ))
	STARS="$(seq  -f '*' -s '' $COUNT_STAR)"

	echo "(* ************************************************************************** *)"
	printf "(* %s %s *)\n" "$STR" "$STARS"
	echo "(* ************************************************************************** *)"
	return
}

function put_lib_file() {

	LIB_NAME=$1
	FILE_PREFIX=$2
	MODULE_NAME=$3

	put_ml_header $(
		printf "Embedding %s's library %s.mli in code"\
			   $LIB_NAME $FILE_PREFIX)
	printf "module type %s_intf =\n" $MODULE_NAME
	echo "sig"
	cat $LIB_NAME/$FILE_PREFIX.mli | sed 's/^/  /'
	echo "end"
	put_ml_header $(
		printf "End of %s's %s.mli"\
			   $LIB_NAME $FILE_PREFIX)

	echo ""

	put_ml_header $(
		printf "Embedding %s's library %s.ml in code"\
			   $LIB_NAME $FILE_PREFIX)
	printf "module %s : %s_intf =\n" $MODULE_NAME $MODULE_NAME
	echo "struct"
	cat $LIB_NAME/$FILE_PREFIX.ml | sed 's/^/  /'
	echo "end"
	put_ml_header $(
		printf "End of %s's %s.ml"\
			   $LIB_NAME $FILE_PREFIX)

	echo ""
	echo ""
}

put_lib_file "biocaml" "interval_tree" "Interval"
put_lib_file "filliatr" "binary_heap" "BinHeap"

# cat schedule.ml
# cat calculation.ml
cat task.ml
cat pass1.ml

echo ";; (* End of modules declaration *)"

cat main.ml
