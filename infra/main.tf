resource "aws_s3_bucket" "exports" {
  bucket = "orders-api-exports"
}

resource "aws_s3_bucket_public_access_block" "exports" {
  bucket                  = aws_s3_bucket.exports.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_versioning" "exports" {
  bucket = aws_s3_bucket.exports.id

  versioning_configuration {
    status = "Enabled"
  }
}

data "aws_iam_policy_document" "exports_rw" {
  statement {
    effect    = "Allow"
    actions   = ["s3:GetObject", "s3:PutObject"]
    resources = ["${aws_s3_bucket.exports.arn}/*"]
  }
}

resource "aws_iam_policy" "exports_rw" {
  name   = "orders-api-exports-rw"
  policy = data.aws_iam_policy_document.exports_rw.json
}
