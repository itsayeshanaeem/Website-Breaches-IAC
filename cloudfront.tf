resource "aws_cloudfront_origin_access_identity" "oai_website_breaches" {
    comment = "website breaches oai"
}

resource "aws_cloudfront_distribution" "blog" {
  origin {
    domain_name = aws_s3_bucket.website_breaches_bucket.bucket_regional_domain_name
    origin_id   = "S3-website-breaches-bucket"

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.oai_website_breaches.cloudfront_access_identity_path
    }
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"

  default_cache_behavior {
    allowed_methods  = ["GET", "HEAD"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "S3-website-breaches-bucket"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    compress = true
    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}
/* -> to adjust the setting
restrictions {
    geo_restriction {
      restriction_type = "whitelist"
      locations        = ["US", "CA", "GB", "DE"]
    }
  }
*/
