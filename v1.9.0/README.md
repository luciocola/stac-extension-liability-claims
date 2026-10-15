# STAC Liability and Claims 1.9.0 - provenance integration

Status: provenance integration release, not independently certified.
Existing versioned schemas are unchanged.

Schema URL:
https://luciocola.github.io/stac-extension-liability-claims/v1.9.0/schema.json

The bundled provenance profile is published alongside the extension schema.
Existing metadata and lineage references use the equivalent published 1.7.0
schemas, rather than depending on the unpublished 1.8.0 directory.

This release preserves the 1.8.0 fields and adds:

- `liability:provenance_ref`: a URI for the authoritative job provenance record.
- `liability:job_provenance`: an optional inline GBB 1.1 job provenance record.
- The same two fields on assets.
- Qualified-name objects, multiple types and repeated entity/activity/agent
  records in the legacy `liability:prov` representation.
- Explicit support for simple STAC asset keys in `liability:evidence_refs`.
  A semantic validator must check that keys exist in the containing Item.

`liability:prov` remains permissive for compatibility. An empty legacy object
does not establish valid provenance. The new inline field requires the bundled
profile, but JSON Schema validation alone does not establish graph consistency.
The GBB kernel additionally parses PROV-JSON and validates identities, relations,
input/output roles and timestamps.

The profile targets the PROV-JSON representation described by OGC draft 26-038.
It is not the graph-array JSON-LD representation used by the OGC provenance
utility building block. These encodings must not be treated as interchangeable.

When moving from 1.8.0, update the declared `stac_extensions` URI to this version.
Old fields continue to validate. New fields are optional. Do not rewrite or
replace previously published 1.8.0 schemas.

The kernel uses standard STAC links and metadata assets by default. Set
`GBB_LIABILITY_SCHEMA_URL` to the published 1.9.0 schema URL only after its schema
and bundled `provenance.schema.json` are actually accessible. This enables the
additional reference on served COP Items without changing saved artifacts.

Neither a provenance graph nor a successful publication proves detection
accuracy, legal responsibility, claim truth or cryptographic authenticity.
Authentication and classification controls remain separate.

Run the local schema tests with:

```sh
python3 -m unittest discover -s v1.9.0 -p 'test_*.py'
```
