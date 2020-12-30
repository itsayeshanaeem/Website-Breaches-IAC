resource "aws_s3_bucket" "website_breaches" {
  bucket = "website-breaches"
  acl    = "public-read"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "website_breaches_policy" {
  bucket = aws_s3_bucket.website_breaches.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "WEBSITEPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::website-breaches/*"
    }
  ]
}
POLICY
}