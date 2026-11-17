package main

import rego.v1

tags := {"Owner": "a", "CostCenter": "b", "Environment": "c"}

provider_ok := {"path": "versions.tf", "contents": {"provider": {"aws": [{"default_tags": [{"tags": tags}]}]}}}

bucket := {"path": "main.tf", "contents": {"resource": {"aws_s3_bucket": {"b": [{"bucket": "x"}]}}}}

block := {"path": "main.tf", "contents": {"resource": {"aws_s3_bucket_public_access_block": {"b": [{
	"bucket": "${aws_s3_bucket.b.id}",
	"block_public_acls": true,
	"block_public_policy": true,
	"ignore_public_acls": true,
	"restrict_public_buckets": true,
}]}}}}

wildcard(action) := {"path": "iam.tf", "contents": {"data": {"aws_iam_policy_document": {"p": [{"statement": [{"effect": "Allow", "actions": [action]}]}]}}}}

test_bucket_with_block_passes if {
	count(deny) == 0 with input as [provider_ok, bucket, block]
}

test_bucket_without_block_fails if {
	count(deny) == 1 with input as [provider_ok, bucket]
}

test_service_wildcard_fails if {
	count(deny) == 1 with input as [provider_ok, wildcard("s3:*")]
}

test_star_wildcard_fails if {
	count(deny) == 1 with input as [provider_ok, wildcard("*")]
}

test_missing_default_tags_fails if {
	count(deny) == 1 with input as [{"path": "versions.tf", "contents": {"provider": {"aws": [{"region": "eu-west-1"}]}}}]
}
