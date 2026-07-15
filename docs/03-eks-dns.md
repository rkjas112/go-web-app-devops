# EKS, ingress, DNS, and cleanup

Use EKS only after the complete Kind deployment is healthy. EKS control-plane
time, EC2 worker nodes, public load balancers, storage, and traffic can consume
AWS credits.

## 1. Review the cluster

The declarative cluster configuration is `eks/cluster.yaml`:

- Cluster: `go-web-app-eks`
- Region: `ap-south-1`
- Managed nodes: two `t3.medium` instances by default
- Autoscaling range: one to three nodes

Confirm that the selected instance type is covered by your credits and service
quotas before creating it.

## 2. Prepare application values

Edit `helm/go-web-app-chart/values-eks.yaml`:

- Replace `your-dockerhub-username` with the Docker Hub account.
- Replace `go-web-app.example.com` with the domain or subdomain you control.

Commit and push those changes. Configure and enable Docker Hub publishing as
described in `docs/02-github-cicd.md`, then allow a successful pipeline to
publish the first image.

## 3. Create EKS

The guard prevents accidental billable creation:

```bash
CONFIRM_EKS_CREATE=yes make eks-create
```

`eksctl` creates the VPC, subnets, security groups, IAM roles, EKS cluster, and
managed node group described in the configuration.

## 4. Install platform components

```bash
make eks-bootstrap
```

This command:

1. Writes the `go-web-app-eks` kubectl context.
2. Installs ingress-nginx for AWS.
3. Installs Argo CD.
4. Applies the EKS Argo CD Application.
5. Prints the AWS load-balancer hostname.

## 5. Map DNS

For a subdomain such as `app.example.com`, create a CNAME record pointing to
the printed ingress load-balancer hostname. If the DNS zone is in Route 53, an
Alias record can also be used where supported. Allow time for DNS propagation.

Verify:

```bash
curl --fail https://app.example.com/healthz
```

Use `http://` instead until TLS and a certificate are configured.

## 6. Delete the cloud environment

When the demonstration is complete, remove the cluster and associated eksctl
resources:

```bash
CONFIRM_EKS_DELETE=yes make eks-delete
```

After deletion, check the AWS console for any retained load balancers, volumes,
Elastic IP addresses, NAT gateways, or Route 53 records. Delete only resources
created for this project.
