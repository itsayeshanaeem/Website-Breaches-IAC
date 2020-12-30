# Challenge 3: Website Deployment IAC

This Repo includes how I terraformed my resources for the website.

## codepipeline.tf
* includes the aws codepipeline which I am using as a CI/CD tool.
* source is the github repo (https://github.com/itsayeshanaeem/Website-Breaches)
* for build I am using  aws codebuild

## codebuild.tf
* includes the codebuild for the website for which the source is buildspec.yml

## cloudfont.tf
* includes set up for Restricting Access to Amazon S3 Content by Using an Origin Access Identity via Cloudfront user.


## s3.tf
* includes the bucket which I am deploying the website to.
* acl was set to public so it could be publically accessed.

*  OAuthToken was used to build up the connection with the repo.