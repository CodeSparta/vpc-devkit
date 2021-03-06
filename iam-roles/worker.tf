resource "aws_iam_instance_profile" "worker" {
  name = "${var.cluster_name}-worker-profile"

  role = aws_iam_role.worker_role.name
}

resource "aws_iam_role" "worker_role" {
  name = "${var.cluster_name}-worker-role"
  path = "/"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
                "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow",
            "Sid": ""
        }
    ]
}
EOF

  tags =  merge(
  var.default_tags,
    { 
    "Name" =  "${var.cluster_name}-worker-role"
    }
  )
}

resource "aws_iam_role_policy" "worker_policy" {
name = "${var.cluster_name}-worker-policy"
role = aws_iam_role.worker_role.id

policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "ec2:Describe*",
      "Resource": "*"
    }
  ]
}
EOF

}
