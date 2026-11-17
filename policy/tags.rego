package main

import rego.v1

# Team rule: the aws provider sets Owner, CostCenter and Environment on everything.
required := {"Owner", "CostCenter", "Environment"}

deny contains msg if {
	some p in providers("aws")
	tags := object.get(object.get(p, "default_tags", [{}])[0], "tags", {})
	missing := required - {k | some k, _ in tags}
	count(missing) > 0
	msg := sprintf("aws provider default_tags is missing: %v", [sort(missing)])
}

deny contains msg if {
	count(providers("aws")) == 0
	msg := "no aws provider block found"
}
