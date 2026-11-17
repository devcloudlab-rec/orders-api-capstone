package main

import rego.v1

# Conftest runs with --combine, so input is a list of {path, contents},
# one entry per Terraform file. These helpers flatten the HCL shape.
resources(type) := [{"name": n, "cfg": c} |
	some f in input
	some n, blocks in object.get(object.get(f.contents, "resource", {}), type, {})
	some c in blocks
]

data_sources(type) := [{"name": n, "cfg": c} |
	some f in input
	some n, blocks in object.get(object.get(f.contents, "data", {}), type, {})
	some c in blocks
]

providers(type) := [c |
	some f in input
	some c in object.get(object.get(f.contents, "provider", {}), type, [])
]
