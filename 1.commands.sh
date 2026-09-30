kubectl create ns app1
kubectl create ns app2
kubectl create ns app3

---
apiVersion: v1
kind: Namespace
metadata:
  name: app3

#!/bin/bash
#Creating TLS Secrets for namespace app1, app2 and app3.

#Cheking for key
cd /etc/letsencrypt/live/harishk8s-0001
ls -ltrh
cd /etc/letsencrypt/live/harishk8s
ls -lrth 

#Createting secret
cd /etc/letsencrypt/live/harishk8s-0001 || exit 1

# Create wc-tls-secret if it does not exist
if kubectl get secret wc-tls-secret >/dev/null 2>&1; then
    echo "wc-tls-secret already exists."
else
    kubectl create secret tls wc-tls-secret \
        --cert=fullchain.pem \
        --key=privkey.pem
    echo "wc-tls-secret created successfully."
fi

# Create nk-tls-secret if it does not exist
if kubectl get secret nk-tls-secret >/dev/null 2>&1; then
    echo "nk-tls-secret already exists."
else
    kubectl create secret tls nk-tls-secret \
        --cert=fullchain.pem \
        --key=privkey.pem
    echo "nk-tls-secret created successfully."
fi

#Install Ingress-controller
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.15.0/deploy/static/provider/aws/deploy.yaml
kubens ingress-nginx

#create Namespace
kubectl create namespace tomcat-app1
kubectl create namespace tomcat-app2
kubectl create namespace tomcat-app3

#Create keys
cd /etc/letsencrypt/live/harishk8s.com-0001
kubectl create secret -n tomcat-app1 tls nk-harishk8s.com --cert=fullchain.pem --key=privkey.pem
kubectl create secret -n tomcat-app2 tls nk-harishk8s.com --cert=fullchain.pem --key=privkey.pem
kubectl create secret -n tomcat-app3 tls nk-harishk8s.com --cert=fullchain.pem --key=privkey.pem

cd /etc/letsencrypt/live/harishk8s.com/
kubectl create secret -n tomcat-app1 tls wc-harishk8s.com --cert=fullchain.pem --key=privkey.pem
kubectl create secret -n tomcat-app2 tls wc-harishk8s.com --cert=fullchain.pem --key=privkey.pem
kubectl create secret -n tomcat-app3 tls wc-harishk8s.com --cert=fullchain.pem --key=privkey.pem

kubectl describe secrets -n tomcat-app1 wc-harishk8s.com
kubectl describe secrets -n tomcat-app1 nk-kharishk8s.com

#Create container
kubectl create -n tomcat-app1 deploy demoapp1 --image harishchimmili/tomcat-app:v1 --replicas 3
kubectl create -n tomcat-app2 deploy demoapp2 --image harishchimmili/login-app:v2 --replicas 3
kubectl create -n tomcat-app3 deploy demoapp3 --image harishchimmili/jboss-myapp:v2 --replicas 3

#Expose Port
kubectl expose deployment demoapp1 -n tomcat-app1 --port=80 --target-port=8080 --name=tomcat-service
kubectl expose deployment demoapp2 -n tomcat-app2 --port=80 --target-port=8080 --name=login-service
kubectl expose deployment demoapp3 -n tomcat-app3 --port=80 --target-port=8080 --name=jboss-service
kubectl expose deployment demoapp3 -n tomcat-app3 --port=80 --target-port=8080 --name=jboss-service
kubectl expose deployment demoapp3 -n tomcat-app3 --port=80 --target-port=9990 --name=jboss-admin-service

#Check the SVC,PODS,GET
for I in {1..3}; do kubectl get pods,svc -n tomcat-app$I; deployment





kubectl expose deployment demoapp1 -n tomcat-app1 --port=80 --target-port=8080 --name=tomcat-service
``

kubectl expose tomcat-app1 demoapp1 --port=80 --target-port=8080 --name=tomcat-service
kubectl expose tomcat-app2 demoapp2 --port=80 --target-port=8080 --name=tomcat-service
kubectl expose tomcat-app2 demoapp3 --port=80 --target-port=8080 --name=tomcat-service


for I in {1..3}; do kubectl get pods,svc -n tomcat-app$I; done
========================================================================================================================



kubectl expose -n tomcat-app1 deploy demoapp1 --port 80 
kubectl expose -n app2 deploy demoapp2 --port 80 
kubectl expose -n app3 deploy demoapp3 --port 80


for I in {1..3}; do kubectl get pods,svc -n app$I; done

app1.harishk8s.com
app2.harishk8s.com
app3.harishk8s.com

vote.kharishk8s.com
www.harishk8s.com
result.harishk8s.com
bg.harishk8s.com
canary.harishk8s.com
harishk8s.com

kubectl config set-context --current --namespace=app1
kubectl config set-context --current --namespace=app2

#https://github.com/ahmetb/kubectx/releases/tag/v0.9.5
kubens tomcat-app1
kubens tomcat-app2
kubens tomcat-app3





