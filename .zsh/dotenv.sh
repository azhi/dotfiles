dotenv() {
  bash -c "
  path=\$(pwd)
  while [[ \"\$path\" != \"\" && ! -e \"\$path/.env\" ]]; do
    path=\${path%/*}
  done
  if [[ -e \"\$path/.env\" ]]; then
    set -a
    source \"\$path/.env\"
    set +a
    exec $*
  else
    echo \"Error: .env not found!\"
    exit 1
  fi
  "
}
