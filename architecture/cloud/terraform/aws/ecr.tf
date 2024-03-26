resource "aws_ecr_repository" "polygon_container_hub" {
    name = "polygon-container-hub"

    image_scanning_configuration {
	    scan_on_push = true
	}
}

resource "aws_ecr_lifecycle_policy" "default_policy" {
    repository = aws_ecr_repository.polygon_container_hub.name

	  policy = <<EOF
	{
	    "rules": [
	        {
	            "rulePriority": 1,
	            "description": "Keep only the last ${var.UNTAGGED_IMAGES} untagged images.",
	            "selection": {
	                "tagStatus": "untagged",
	                "countType": "imageCountMoreThan",
	                "countNumber": ${var.UNTAGGED_IMAGES}
	            },
	            "action": {
	                "type": "expire"
	            }
	        }
	    ]
	}
	EOF

}

resource "null_resource" "docker_packaging" {
	
	  provisioner "local-exec" {
	    command = <<EOF
		aws configure set aws_access_key_id ${var.AWS_ACCESS_KEY_ID}
		aws configure set aws_secret_access_key ${var.AWS_SECRET_ACCESS_KEY}
		aws configure set region ${var.AWS_DEFAULT_REGION}
	    aws ecr get-login-password --region ${var.AWS_DEFAULT_REGION} | docker login --username AWS --password-stdin ${data.aws_caller_identity.current.account_id}.dkr.ecr.${var.AWS_DEFAULT_REGION}.amazonaws.com
	    pwd
		ls ../../..
		docker build -t "${aws_ecr_repository.polygon_container_hub.repository_url}:latest" -f ../../containers/Prod.Dockerfile ../../../..
	    docker push "${aws_ecr_repository.polygon_container_hub.repository_url}:latest"
	    EOF
	  }
	

	  triggers = {
	    "run_at" = timestamp()
	  }
	

	  depends_on = [
	    aws_ecr_repository.polygon_container_hub,
	  ]
}
