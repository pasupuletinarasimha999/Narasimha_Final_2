resource "aws_db_instance" "mydb" {
    allocated_storage                     = 20
    auto_minor_version_upgrade            = true
    availability_zone                     = "us-east-1a"
    db_subnet_group_name                  = aws_db_subnet_group.mydb_subnet_group.name
    delete_automated_backups              = true
    deletion_protection                   = false
    engine                                = "postgres"
    engine_version                        = "16.2"
    instance_class                        = "db.t3.micro"
    multi_az                              = false
    name                                  = "mydb"
    performance_insights_enabled          = false
    port                                  = 5432
    publicly_accessible                   = true
    skip_final_snapshot                   = true
    storage_encrypted                     = true
    storage_type                          = "gp2"
    username                              = "postgres"
	password                              = "Paster813"
    tags = {
    Name = "mydb"  # Set the friendly name or identifier here
  }
}
resource "aws_db_subnet_group" "mydb_subnet_group" {
  name = "mydb-subnet-group"
  subnet_ids = [aws_subnet.private-us-east-1a.id, aws_subnet.private-us-east-1b.id]
}   
