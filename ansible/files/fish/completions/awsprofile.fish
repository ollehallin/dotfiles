complete -x --command awsprofile --description "AWS profile" --no-files --arguments "(grep '\[profile' $HOME/.aws/config | sed 's/\[profile //g; s/\]//g' | fzf)"
