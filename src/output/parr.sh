parr() {
	local key value name
	for name in "$@"; do
		echo '('
		eval "
		for key in \"\${!$name[@]}\"; do
			value=\${$name[\$key]}
			echo -e \"\\t[\$key]=\\\`\$value\\\`\"
		done"
		echo ')'
	done
}