"""Version-local STAC schema regression checks without network resolution."""

import copy
import json
import unittest
from pathlib import Path

from jsonschema import Draft7Validator, FormatChecker
from referencing import Registry, Resource

ROOT = Path(__file__).parent
URL = "https://luciocola.github.io/stac-extension-liability-claims/v1.9.0/schema.json"


class ProvenanceSchemaTests(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        schema = json.loads((ROOT / "schema.json").read_text())
        profile = json.loads((ROOT / "provenance.schema.json").read_text())
        registry = Registry().with_resource(profile["$id"], Resource.from_contents(profile))
        registry = registry.with_resource(URL, Resource.from_contents(schema))
        for name in ("mdj.json", "dqc.json", "iso19157-lineage.json"):
            dependency = json.loads((ROOT.parent / "v1.7.0" / name).read_text())
            dependency_url = f"https://luciocola.github.io/stac-extension-liability-claims/v1.7.0/{name}"
            registry = registry.with_resource(dependency_url, Resource.from_contents(dependency))
        cls.validator = Draft7Validator(schema, registry=registry, format_checker=FormatChecker())
        cls.profile = profile
        cls.schema = schema
        cls.registry = registry

    def test_schema_references_resolve(self):
        resolver = self.registry.resolver(URL)

        def check(value):
            if isinstance(value, dict):
                if "$ref" in value:
                    resolver.lookup(value["$ref"])
                for child in value.values():
                    check(child)
            elif isinstance(value, list):
                for child in value:
                    check(child)

        check(self.schema)

    def item(self, properties):
        return {"type": "Feature", "stac_extensions": [URL], "properties": properties, "assets": {}}

    def test_reference_and_asset_fields(self):
        self.validator.validate(self.item({"liability:provenance_ref": "https://example.org/jobs/123/prov"}))
        value = self.item({"liability:claim_id": "claim-1"})
        value["assets"]["evidence"] = {"liability:provenance_ref": "https://example.org/jobs/123/prov"}
        self.validator.validate(value)
        self.assertFalse(self.validator.is_valid(self.item({"liability:provenance_ref": "not a URI"})))

    def test_legacy_fields_remain_optional_and_permissive(self):
        for properties in (
            {"liability:claim_id": "claim-1"},
            {"liability:prov": {}},
            {"liability:prov": {"entity": {"ex:output": {"prov:type": "wfprov:Artifact"}}}},
            {"liability:prov": {"entity": {"ex:output": {"prov:type": "LegacyType"}}}},
        ):
            self.validator.validate(self.item(properties))

    def test_typed_multiple_and_repeated_prov_records(self):
        graph = {"entity": {
            "ex:output": [
                {"prov:type": [
                    {"$": "wfprov:Artifact", "type": "prov:QUALIFIED_NAME"},
                    {"$": "wf4ever:File", "type": "prov:QUALIFIED_NAME"},
                ]},
                {"prov:label": ["output", "published vector"]},
            ]
        }}
        self.validator.validate(self.item({"liability:prov": graph}))

    def test_new_inline_field_rejects_empty_graph(self):
        self.assertFalse(self.validator.is_valid(self.item({"liability:job_provenance": {}})))

    def test_evidence_keys_and_uris(self):
        self.validator.validate(self.item({"liability:evidence_refs": ["provenance", "https://example.org/evidence"]}))
        self.assertFalse(self.validator.is_valid(self.item({"liability:evidence_refs": ["not a key or URI"]})))

    def test_example(self):
        example = json.loads((ROOT / "examples/item-publication-provenance.json").read_text())
        self.validator.validate(example)
        invalid = copy.deepcopy(example)
        invalid["properties"]["liability:job_provenance"]["prefix"]["prov"] = "https://wrong.example/"
        self.assertFalse(self.validator.is_valid(invalid))


if __name__ == "__main__":
    unittest.main()
