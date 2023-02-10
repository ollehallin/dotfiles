function set_kubeconfig --description 'Sets KUBECONFIG to all files in $HOME/.kube/* and updates $HOME/.kube/config'
  set --local result
  for file in (ls -1 $HOME/.kube/*/*config)
    set result "$file:$result"
  end
  if test -f $HOME/.kube/config
    set result "$HOME/.kube/config:$result"
  end

  set result (echo $result | sed 's/:$//g')

  env KUBECONFIG="$result" kubectl config view --flatten > $HOME/.kube/config
  echo "Created $HOME/.kube/config to contain the union of $result"
end
