output "security_group_id" {
    value = aws_security_group.rds_sg.id

}
// This endpoint is needes to connect to your db instabce
output "aws_db_instance_endpoint" {
    value = aws_db_instance.myinstance.endpoint
  
}