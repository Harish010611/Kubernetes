#!/bin/bash
if [ "$1" = 25 ]; then
    echo "Moving 25% of Traffic From OLD to NEW"
    kubectl patch ingress canary-ingress-2 -p '{"metadata": {"annotations":{"nginx.ingress.kubernetes.io/canary-weight":"25"}}}'
elif [ "$1" = 50 ]; then
    echo "Moving 50% of Traffic From OLD to NEW"
    kubectl patch ingress canary-ingress-2 -p '{"metadata": {"annotations":{"nginx.ingress.kubernetes.io/canary-weight":"50"}}}'
elif [ "$1" = 75 ]; then
    echo "Moving 75% of Traffic From OLD to NEW"
    kubectl patch ingress canary-ingress-2 -p '{"metadata": {"annotations":{"nginx.ingress.kubernetes.io/canary-weight":"75"}}}'
elif [ "$1" = 100 ]; then
    echo "All 100% Traffic Is Routed To New Environment."
    kubectl patch ingress canary-ingress-2 -p '{"metadata": {"annotations":{"nginx.ingress.kubernetes.io/canary-weight":"100"}}}'
elif [ "$1" = 'ROLLBACK' ]; then
    echo "Performing Roll Back To Original Env...."
    kubectl patch ingress canary-ingress-2 -p '{"metadata": {"annotations":{"nginx.ingress.kubernetes.io/canary-weight":"0"}}}'
else
    echo "Invalid Input. Give 25 or 50 or 75 or 100 or ROLLBACK as Args...."
fi
