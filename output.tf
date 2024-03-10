
//Output of Load Balancer DNS
output "LoadBalancerDNS" {
    value = aws_alb.myalb.dns_name
}

//Public IP for 1st Instance
output "Instance1IP" {
  value = aws_instance.Instance_1.public_ip
}

//Public IP for 2nd Instance
output "Instance2IP" {
  value = aws_instance.Instance_2.public_ip
}