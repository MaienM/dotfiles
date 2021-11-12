function ffprobe-res() {
	for file in "$@"; do
		echo "$(ffprobe -v error -select_streams v:0 -show_entries stream=width,height -of csv=s=x:p=0 "$file") $file"
	done
}
