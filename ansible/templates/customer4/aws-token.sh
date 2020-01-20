#!/usr/bin/env bash

cd $(find ~/work -type d -name fr-start || find ~/workspace -type d -name fr-start)
npm run aws:mfa arn:aws:iam::{{ secrets.aws.customer4.account }}:mfa/olle_hallin@{{ secrets.customer4.name }}.com $($HOME/.local/bin/mfa.sh {{ secrets.customer4.name }}) {{ secrets.customer4.name }}
