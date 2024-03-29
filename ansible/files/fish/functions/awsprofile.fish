function awsprofile
  if test -n "$argv[1]"
      set aws_profile "$argv[1]"
  else
      set aws_profile (aws configure list-profiles | fzf --header 'AWS profile')
  end
  if test -n "$aws_profile"
      if ! aws --profile "$aws_profile" sts get-caller-identity > /dev/null 2>&1
          gimme-aws-creds --profile "$aws_profile"
      end
      echo "Setting AWS_PROFILE to $aws_profile"
      set -gx AWS_PROFILE "$aws_profile"
      aws --no-cli-pager sts get-caller-identity
  end
end
