sudo snap install --classic certbot
certbot --version
certbot  -h

certbot certonly --manual --preferred-challenges=dns --key-type rsa --email harishchimmili07@gmai.com \
--server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d *.harishk8s.com

certbot certonly --manual --preferred-challenges=dns --key-type rsa --email harishchimmili07@gmai.com \
--server https://acme-v02.api.letsencrypt.org/directory --agree-tos -d harishk8s.com


wildcard domain - cd /etc/letsencrypt/live/harishk8s.com
naked domain - cd /etc/letsencrypt/live/harishk8s-0001

cd /etc/letsencrypt/live/harishk8s-0001
kubectl create secret tls wc-tls-secret --cert=fullchain.pem --key=privkey.pem
cd /etc/letsencrypt/live/harishk8s-0001
kubectl create secret tls nk-tls-secret --cert=fullchain.pem --key=privkey.pem

kubectl describe secrets wc-tls-secret
kubectl describe secrets nk-tls-secret

kubectl get secret wc-tls-secret -o jsonpath='{.data.tls\.crt}' | base64 --decode
kubectl get secret nk-tls-secret -o jsonpath='{.data.tls\.crt}' | base64 --decode

#Ingress Controller
'Ingress Controller can be in any namespace. But the Ingress Resource & SSL/TLS Secret must be in the same Namespace where the application is deployed. For example, if prometheus and grafana are in monitoring namespace, the ingress & SSL must also be in the monitoring namespace. Thats means POD, Deployment, Service, Secret & Ingress must be in the same namespace.'

https://github.com/kubernetes/ingress-nginx

kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.15.0/deploy/static/provider/aws/deploy.yaml
For K8S B36 Ingress Controller 1.15.0 is deployed and tested.
 

app1.harishk8s.com
app2.harishk8s.com
app3.harishk8s.com

vote.harishk8s.com
www.harishk8s.com
result.harishk8s.com
bg.harishk8s.com
canary.harishk8s.com
harishk8s.com

cd /etc/letsencrypt/live/harishk8s.com-0001
kubectl create secret -n default tls nk-harishk8s.com --cert=fullchain.pem --key=privkey.pem

cd /etc/letsencrypt/live/harishk8s.com/
kubectl create secret -n default tls wc-harishk8s.com --cert=fullchain.pem --key=privkey.pem




