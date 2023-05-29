resource "aws_s3_bucket_acl" "default" {
  depends_on = [aws_s3_bucket_ownership_controls.default]

  bucket = aws_s3_bucket.default.id
  acl    = "log-delivery-write"
}

resource "aws_s3_bucket_policy" "default" {
  bucket = aws_s3_bucket.default.bucket
  policy = data.aws_iam_policy_document.this.json
}

data "aws_elb_service_account" "this" {}
data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

locals {
  account_id = data.aws_caller_identity.current.account_id
  region     = data.aws_region.current.name
}

// See https://docs.aws.amazon.com/elasticloadbalancing/latest/network/load-balancer-access-logs.html#enable-disable-access-logging
data "aws_iam_policy_document" "this" {
  statement {
    sid       = "AWSLogDeliveryAclCheck"
    effect    = "Allow"
    actions   = ["s3:GetBucketAcl"]
    resources = ["arn:aws:s3:::${var.name}"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.region}:${local.account_id}:*"]
    }
  }

  statement {
    sid       = "AWSLogDeliveryWrite"
    effect    = "Allow"
    actions   = ["s3:PutObject"]
    resources = ["arn:aws:s3:::${var.name}/AWSLogs/${local.account_id}/*"]

    principals {
      type        = "Service"
      identifiers = ["delivery.logs.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [local.account_id]
    }

    condition {
      test     = "ArnLike"
      variable = "aws:SourceArn"
      values   = ["arn:aws:logs:${local.region}:${local.account_id}:*"]
    }
  }
}

resource "aws_s3_bucket_public_access_block" "default" {
  bucket = aws_s3_bucket.default.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
