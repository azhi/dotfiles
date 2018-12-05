kube-pod-connect() {
  executable=/usr/bin/kube-pod-connect
  echo -ne "\033]0;root@$2\007"
  $executable "$@"
}

kubectl() {
  executable=/usr/bin/kubectl

  found=false
  for arg in $@
  do
    if [[ $found == true && ${arg:0:1} != "-" ]]; then
      host=$arg
      break
    fi
    if [[ $arg == "exec" ]]; then
      found=true
    fi
  done

  if [[ $found == true ]]; then
    echo -ne "\033]0;root@$host\007"
  fi
  $executable "$@"
}
