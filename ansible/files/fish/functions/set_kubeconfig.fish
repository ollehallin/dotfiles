function set_kubeconfig --description 'Sets KUBECONFIG to all files in $HOME/.kube/'
  set --local result
  for file in (ls -1 $HOME/.kube/*/*config)
    set result "$file:$result"
  end
  if test -f $HOME/.kube/config
    set result "$HOME/.kube/config:$result"
  end

  set -Ux KUBECONFIG "$result"
  echo "KUBECONFIG=$KUBECONFIG"
end
