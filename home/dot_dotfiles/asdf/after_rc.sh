asdf_data_dir=${ASDF_DATA_DIR:-$HOME/.asdf}

if [ -d $asdf_data_dir ]; then
  export PATH="$asdf_data_dir/shims:$PATH"
fi
