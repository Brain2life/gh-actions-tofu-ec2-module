# gh-actions-tofu-ec2-module

This repository contains OpenTofu/Terraform module that allows GitHub actions CI to deploy EC2 instances.  
For more information about example usage of this module, see exercise #8 from [github.com/Brain2life/github-ci-test](https://github.com/Brain2life/github-ci-test)

The following IAM roles were used for EC2 read-only and write permissions:
- [AmazonEC2ReadOnlyAccess](https://docs.aws.amazon.com/aws-managed-policy/latest/reference/AmazonEC2ReadOnlyAccess.html)
- [Basic EC2 launch instance wizard access](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-policies-ec2-console.html#ex-launch-wizard)

## Links
- [IAM JSON policy elements: Sid](https://docs.aws.amazon.com/IAM/latest/UserGuide/reference_policies_elements_sid.html)
- [github.com/Brain2life/github-ci-test](https://github.com/Brain2life/github-ci-test)