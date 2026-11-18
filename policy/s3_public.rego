package main

import rego.v1

# Team rule: every bucket has a public access block with all four flags on.
flags := ["block_public_acls", "block_public_policy", "ignore_public_acls", "restrict_public_buckets"]

protected contains name if {
	some blk in resources("aws_s3_bucket_public_access_block")
	every f in flags {
		blk.cfg[f] == true
	}
	name := trim_suffix(trim_prefix(blk.cfg.bucket, "${aws_s3_bucket."), ".id}")
}

deny contains msg if {
	some b in resources("aws_s3_bucket")
	not b.name in protected
	msg := sprintf("aws_s3_bucket.%s needs a public access block with all four flags set to true", [b.name])
}
