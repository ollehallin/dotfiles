function set_kubeconfig --description 'Sets KUBECONFIG to all files in $HOME/.kube/*/*config'
  set -Ux KUBECONFIG (find $HOME/.kube/ -name '*kubeconfig' | sort | xargs | sed 's/ /:/g')
  echo "$KUBECONFIG"
end
