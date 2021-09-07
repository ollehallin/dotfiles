function aws_token
  set aws_profile (aws configure list-profiles | fzf --header 'AWS profile')
  if test -n "$aws_profile"
      if ! aws --profile "$aws_profile" sts get-caller-identity > /dev/null 2>&1
          gimme-aws-creds --profile "$aws_profile"
      end
      set -gx AWS_PROFILE "$aws_profile"
      aws --no-cli-pager sts get-caller-identity
  end
end

function awsprofile
  set aws_profile (aws configure list-profiles | fzf --header 'AWS profile')
  if test -n "$aws_profile"
      if ! aws --profile "$aws_profile" sts get-caller-identity > /dev/null 2>&1
          gimme-aws-creds --profile "$aws_profile"
      end
      set -gx AWS_PROFILE "$aws_profile"
      aws --no-cli-pager sts get-caller-identity
  end
end
