# Source: http://tedwise.com/2016/02/26/using-sdkman-with-the-fish-shell

function sdk --description 'Software Development Kit Manager'
  set after_env (mktemp -t after_env.XXXXXX)
  set path_env (mktemp -t path_env.XXXXXX)

    bash -c "source ~/.sdkman/bin/sdkman-init.sh && printenv > $after_env"

    # remove any pre-existing .sdkman paths
    for elem in $PATH
      switch $elem
        case '*/.sdkman/*'
          # ignore
        case '*'
          echo "$elem" >> $path_env
      end
    end

    for env in (cat $after_env)
      set env_name (echo $env | sed s/=.\*//)
      set env_value (echo $env | sed s/.\*=//)
      switch $env_name
        case 'PATH'
          for elem in (echo $env_value | tr ':' '\n')
            switch $elem
              case '*/.sdkman/*'
                echo "$elem" >> $path_env
            end
          end
        case '*'
          switch $env_value
            case '*/.sdkman/*'
              set -ge $env_name
              eval set -U $env_name $env_value > /dev/null
          end
      end
    end
    set -ge PATH
    set -Ux PATH (cat $path_env) ^ /dev/null

    rm -f $after_env
    rm -f $path_env
end
