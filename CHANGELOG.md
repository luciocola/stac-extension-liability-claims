# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2024-11-25

### Added
- Initial release of STAC Liability and Claims Extension
- JSON Schema for liability and claims metadata
- Core fields for claim tracking:
  - `liability:claim_id` - Unique claim identifier
  - `liability:claim_status` - Current status of claim
  - `liability:claim_type` - Type/category of claim
  - `liability:responsible_party` - Responsible party identification
- Financial tracking fields:
  - `liability:damages_estimated` - Estimated damages value
  - `liability:damages_currency` - Currency code (ISO 4217)
- Legal and insurance fields:
  - `liability:legal_jurisdiction` - Legal jurisdiction
  - `liability:insurance_provider` - Insurance provider name
  - `liability:policy_number` - Policy number
- Temporal tracking:
  - `liability:incident_date` - When incident occurred
  - `liability:claim_date` - When claim was filed
  - `liability:resolution_date` - When claim was resolved
- Geospatial field:
  - `liability:coverage_area` - Geographic area affected by claim
- Supporting fields:
  - `liability:affected_parties` - List of affected parties
  - `liability:evidence_refs` - References to evidence
  - `liability:notes` - Additional comments
- Comprehensive README with documentation
- Example STAC items demonstrating extension usage
- Python validation script
- Shell script for batch validation

[Unreleased]: https://github.com/yourusername/stac-extension-liability-claims/compare/v1.0.0...HEAD
[1.0.0]: https://github.com/yourusername/stac-extension-liability-claims/releases/tag/v1.0.0
