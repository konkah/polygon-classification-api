#Log the load balancer app URL
output "app_url" {
  value = aws_alb.polygon_load_balancer.dns_name
}
