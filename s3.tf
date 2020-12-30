resource "aws_s3_bucket" "website_breaches_bucket" {
  bucket = "website-breaches-bucket"
  acl = "private"

  website {
    index_document = "index.html"
    error_document = "index.html"
  }
}

resource "aws_s3_bucket_policy" "website_breaches_s3_policy" {
  bucket = aws_s3_bucket.website_breaches_bucket.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Id": "WEBSITEPOLICY",
  "Statement": [
    {
      "Sid": "IPAllow",
      "Effect": "Allow",
      "Principal": "${aws_cloudfront_origin_access_identity.oai_website_breaches.iam_arn}",
      "Action": "s3:GetObject",
      "Resource": "arn:aws:s3:::website-breaches-bucket/*"
    }
  ]
}
POLICY
}