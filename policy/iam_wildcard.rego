package main

import rego.v1

# Team rule: no allow statement with a wildcard action ("*" or "service:*").
deny contains msg if {
	some doc in data_sources("aws_iam_policy_document")
	some stmt in doc.cfg.statement
	object.get(stmt, "effect", "Allow") == "Allow"
	some action in stmt.actions
	action == "*"
	msg := sprintf("data.aws_iam_policy_document.%s allows the action %s", [doc.name, action])
}

deny contains msg if {
	some doc in data_sources("aws_iam_policy_document")
	some stmt in doc.cfg.statement
	object.get(stmt, "effect", "Allow") == "Allow"
	some action in stmt.actions
	endswith(action, ":*")
	msg := sprintf("data.aws_iam_policy_document.%s allows the action %s", [doc.name, action])
}
