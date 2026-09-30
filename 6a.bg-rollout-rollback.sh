#!/bin/bash
if [ "$1" = 'ROLLOUT' ]; then
    echo "Applying or Rollingout Green Env Patch...."
    kubectl patch ingress bluegreen-ingress-1 --patch-file /tmp/green-patch.yml
elif [ "$1" = 'ROLLBACK' ]; then
    echo "Performing Roll Back To Blue Env.."
    kubectl patch ingress bluegreen-ingress-1 --patch-file /tmp/blue-patch.yml
else
    echo "Invalid Input. Give ROLLOUT or ROLLBACK as Argument"
fi
