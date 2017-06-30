1) scp ./install-* ubuntu@ 'bastion'
2) ssh -A ubuntu@ 'bastion'
3) ./install-all.sh install-ips.list
3) ssh -A kubernetes-0.seb.wescale
4) sudo kubeadm init
 copy 
kubeadm join --token 05b546.21d33fcc671029ef 10.0.0.203:6443

5)
  sudo cp /etc/kubernetes/admin.conf $HOME/
  sudo chown $(id -u):$(id -g) $HOME/admin.conf
  export KUBECONFIG=$HOME/admin.conf

6) kubectl apply -f http://docs.projectcalico.org/v2.3/getting-started/kubernetes/installation/hosted/kubeadm/1.6/calico.yaml
7) kubectl get pods --all-namespaces
8) ssh -A kubernetes-1.seb.wescale sudo kubeadm join --token 05b546.21d33fcc671029ef 10.0.0.203:6443
9) ssh -A kubernetes-2.seb.wescale sudo kubeadm join --token 05b546.21d33fcc671029ef 10.0.0.203:6443

10) scp kubernetes-0.seb.wescale:~/admin.conf .
11) export KUBECONFIG=$HOME/admin.conf

12) ssh -A kubernetes-0.seb.wescale
13) sudo vi /etc/kubernetes/manifests/kube-apiserver.yaml
14) add :

    - --oidc-issuer-url=http://keycloack.seb.wescale:8080/auth/realms/kubernetes
    - --oidc-client-id=kubernetes
    - --oidc-ca-file=/path/to/ca.pem
    - --oidc-username-claim=email

