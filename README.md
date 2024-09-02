# Hybrid-DNS-with-Route53-Resolver

## Note: It does not follow the law of idempotence entirely since I use provisioners in this scenario. 

#### Since it's for lab project, I exclude terraform.tfvars from .gitignore file.

![hybrid-dns](https://github.com/user-attachments/assets/831f67b8-04d2-4022-82b9-0f6ae73689c6)


## Lab Goal

OnPrem App Server and Cloud App Server must be resolved using DNS. 

```bash
  # From OnPrem App Server
  ping app.tunlyinaung.aws


  # From Cloud App Server
  ping app.tunlyinaung.onprem
```



