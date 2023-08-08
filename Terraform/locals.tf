locals {
  instance = {
    image  = "ubuntu-22-04-x64"
    name   = "FoodRec"
    region = "sgp1"
    size   = "s-2vcpu-16gb"
    dns_record = {
      frontend   = "foodrec"
      api        = "api-foodrec"
      traefik    = "traefik-foodrec"
      prometheus = "prometheus-foodrec"
      grafana    = "grafana-foodrec"
    }
  }
}