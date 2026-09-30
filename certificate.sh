#!/bin/bash

echo "===== Checking Certificates ====="

cd /etc/letsencrypt/live/harishk8s.com-0001 || exit 1
ls -ltrh

cd /etc/letsencrypt/live/harishk8s.com || exit 1
ls -ltrh

#################################################
# Install NGINX Ingress Controller
#################################################

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.15.0/deploy/static/provider/aws/deploy.yaml

echo "Waiting for ingress controller..."
kubectl get pods -n ingress-nginx

#################################################
# Create Namespaces
#################################################
kubens ingress-nginx
kubectl create namespace tomcat-app1 --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace tomcat-app2 --dry-run=client -o yaml | kubectl apply -f -
kubectl create namespace tomcat-app3 --dry-run=client -o yaml | kubectl apply -f -

#################################################
# Create Naked Domain TLS Secrets
#################################################

cd /etc/letsencrypt/live/harishk8s.com-0001 || exit 1

kubectl create secret tls nk-harishk8s.com -n tomcat-app1 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret tls nk-harishk8s.com -n tomcat-app2 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret tls nk-harishk8s.com -n tomcat-app3 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -

#################################################
# Create Wildcard Domain TLS Secrets
#################################################

cd /etc/letsencrypt/live/harishk8s.com || exit 1

kubectl create secret tls wc-harishk8s.com -n tomcat-app1 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret tls wc-harishk8s.com -n tomcat-app2 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -
kubectl create secret tls wc-harishk8s.com -n tomcat-app3 --cert=fullchain.pem --key=privkey.pem --dry-run=client -o yaml | kubectl apply -f -

#################################################
# Verify Secrets
#################################################

kubectl describe secret wc-harishk8s.com -n tomcat-app1
kubectl describe secret nk-harishk8s.com -n tomcat-app1

kubectl describe secret wc-harishk8s.com -n tomcat-app2
kubectl describe secret nk-harishk8s.com -n tomcat-app2

kubectl describe secret wc-harishk8s.com -n tomcat-app3
kubectl describe secret nk-harishk8s.com -n tomcat-app3
#################################################
# Create Deployments
#################################################

kubectl create deployment demoapp1 --image=harishchimmili/tomcat-app:v1 -n tomcat-app1

kubectl scale deployment demoapp1 --replicas=3 -n tomcat-app1

kubectl create deployment demoapp2 --image=harishchimmili/login-app:v2 -n tomcat-app2

kubectl scale deployment demoapp2 --replicas=3 -n tomcat-app2

kubectl create deployment demoapp3 --image=harishchimmili/jboss-myapp:v3 -n tomcat-app3
kubectl scale deployment demoapp3 --replicas=3 -n tomcat-app3

#################################################
# Create Services
#################################################

kubectl expose deployment demoapp1 -n tomcat-app1 --port=80 --target-port=8080 --name=tomcat-service
kubectl expose deployment demoapp2 -n tomcat-app2 --port=80 --target-port=8080 --name=login-service
kubectl expose deployment demoapp3 -n tomcat-app3 --port=80 --target-port=8080 --name=jboss-service
kubectl expose deployment demoapp3 -n tomcat-app3 --port=9990 --target-port=9990 --name=jboss-admin-service
kubectl patch deployment demoapp3 -n tomcat-app3 --type='json' -p='[
{"op":"add","path":"/spec/template/spec/containers/0/ports","value":[
{"containerPort":8080},
{"containerPort":9990}
]}]'

#################################################
# Validation
#################################################

for i in {1..3}
do
    echo "================================="
    echo "Namespace : tomcat-app$i"
    echo "================================="

    kubectl get deployment -n tomcat-app$i
    kubectl get pods -n tomcat-app$i
    kubectl get svc -n tomcat-app$i

done

#################################################
# Check Ingress Controller
#################################################

kubectl get pods -n ingress-nginx
kubectl get svc -n ingress-nginx

#################################################
# Check All Resources
#################################################

kubectl get ns
kubectl get deploy -A
kubectl get pods -A
kubectl get svc -A
kubectl get ingress -A

echo "Setup Completed Successfully"