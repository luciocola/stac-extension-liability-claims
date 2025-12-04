# STAC Liability Claims Extension v1.1.0 - Release Summary

**Release Date:** December 4, 2024  
**Version:** 1.1.0  
**Status:** Proposal (maturity classification)

---

## Overview

Version 1.1.0 represents a **major architectural improvement** to the Liability and Claims Extension, harmonizing it with official STAC and OGC API specifications. This release separates security classification metadata (data characteristics) from API authentication (implementation details).

## Key Changes

### ✅ What's New

1. **`liability:required_roles` Field**
   - Specifies which user roles can access an asset
   - Metadata-only (enforcement happens at API level)
   - Example: `["investigator", "legal_counsel"]`

2. **OpenAPI Security Example**
   - Complete `stac-api-openapi.yaml` showing proper API-level authentication
   - Demonstrates API keys, OAuth2, and JWT bearer tokens
   - Role-based access control (RBAC) implementation guidance

3. **STAC API Compatibility Assessment**
   - Comprehensive analysis vs. official STAC specs
   - Detailed harmonization recommendations
   - Migration patterns and best practices

### ⚠️ Breaking Changes (Deprecations)

**These fields are deprecated and will be removed in v2.0.0:**

| Field | Replacement | Reason |
|-------|-------------|--------|
| `liability:access_control` | OpenAPI `securitySchemes` | Authentication is API concern, not data metadata |
| `liability:alternate` | STAC `assets` or `links` | Duplicates standard STAC patterns |

**Migration is required** for implementations using v1.0.0.

---

## Migration Guide

### From v1.0.0 to v1.1.0

#### Step 1: Update Extension URI

```diff
  "stac_extensions": [
-   "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
+   "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ]
```

#### Step 2: Replace Authentication Fields in Items

**Before (v1.0.0):**
```json
{
  "assets": {
    "evidence": {
      "href": "https://secure.example.com/image.tif",
      "liability:access_control": {
        "required_auth": true,
        "auth_methods": ["apiKey"],
        "auth_schemes": {
          "apiKey": {
            "type": "apiKey",
            "in": "header",
            "name": "X-Claims-API-Key"
          }
        }
      }
    }
  }
}
```

**After (v1.1.0):**
```json
{
  "assets": {
    "evidence": {
      "href": "https://secure.example.com/image.tif",
      "liability:security_classification": "confidential",
      "liability:required_roles": ["investigator", "legal_counsel"]
    }
  }
}
```

#### Step 3: Create OpenAPI Security Configuration

Create `openapi.yaml` for your STAC API:

```yaml
components:
  securitySchemes:
    ClaimsApiKey:
      type: apiKey
      in: header
      name: X-Claims-API-Key
      
security:
  - ClaimsApiKey: []
```

See `examples/stac-api-openapi.yaml` for complete example.

#### Step 4: Replace Alternate Assets

**Before (v1.0.0):**
```json
{
  "assets": {
    "main": {
      "href": "https://secure.example.com/data.tif",
      "liability:alternate": {
        "public": {
          "href": "https://public.example.com/preview.jpg"
        }
      }
    }
  }
}
```

**After (v1.1.0):**
```json
{
  "assets": {
    "full-resolution": {
      "href": "https://secure.example.com/data.tif",
      "liability:security_classification": "confidential",
      "roles": ["data"]
    },
    "public-preview": {
      "href": "https://public.example.com/preview.jpg",
      "liability:security_classification": "public",
      "roles": ["overview"]
    }
  }
}
```

---

## Compatibility

### Backward Compatibility

- **JSON Schema:** Deprecated fields still validate (with warnings)
- **Existing Items:** v1.0.0 items remain valid but should migrate
- **Tools:** STAC validators will accept both versions

### Forward Compatibility

- v1.1.0 removes deprecated fields from recommended usage
- v2.0.0 will remove deprecated fields entirely

---

## Implementation Checklist

For extension users migrating to v1.1.0:

- [ ] Update extension URI to `v1.1.0` in all STAC Items/Collections
- [ ] Remove `liability:access_control` from assets
- [ ] Remove `liability:alternate` from assets
- [ ] Add `liability:required_roles` where access control is needed
- [ ] Ensure `liability:security_classification` is set on all restricted assets
- [ ] Create/update STAC API OpenAPI spec with security schemes
- [ ] Implement role checking in API backend
- [ ] Update documentation and API clients
- [ ] Test with STAC validators

For API implementers:

- [ ] Define OpenAPI security schemes
- [ ] Implement authentication middleware
- [ ] Implement role-based access control
- [ ] Filter items/assets based on user roles
- [ ] Return appropriate HTTP 401/403 errors
- [ ] Document authentication in API docs
- [ ] Provide user role management interface

---

## Benefits of v1.1.0

1. **Standards Compliance:** Aligns with STAC and OGC API best practices
2. **Separation of Concerns:** Data metadata vs. API implementation
3. **Simplified Items:** Less complex STAC JSON, easier to read
4. **Flexible Authentication:** Change auth methods without touching STAC data
5. **Tool Compatibility:** Works with standard STAC tools and validators
6. **Scalability:** Easier to manage authentication at API layer

---

## Examples

### Complete v1.1.0 Example

See `examples/item-with-security-v1.1.json` for a full STAC Item with:
- Multiple security classification levels
- Required roles per asset
- Access restrictions
- Public, internal, confidential, and restricted assets

### OpenAPI Example

See `examples/stac-api-openapi.yaml` for:
- API Key authentication
- OAuth2 with scopes
- JWT bearer tokens
- Role-based access control
- Asset proxy endpoints
- Error responses (401, 403)

---

## Documentation Updates

- **README.md:** Updated with v1.1.0 patterns and migration guide
- **STAC-API-COMPATIBILITY.md:** Compatibility assessment and recommendations
- **CHANGELOG.md:** Detailed change log with deprecations
- **Examples:** New v1.1.0 examples added, v1.0.0 examples preserved

---

## Testing

Validate your v1.1.0 items:

```bash
# Install dependencies
npm install

# Run validation
npm test

# Format examples
npm run format-examples
```

---

## Support and Feedback

- **Issues:** https://github.com/yourusername/stac-extension-liability-claims/issues
- **Discussions:** https://github.com/yourusername/stac-extension-liability-claims/discussions
- **STAC Gitter:** https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby

---

## Roadmap

### v1.1.x (Patch Releases)
- Bug fixes
- Documentation improvements
- Additional examples

### v2.0.0 (Future Major Release)
- **Remove** deprecated fields (`liability:access_control`, `liability:alternate`)
- Potentially add new quality/lineage enhancements
- Advanced RBAC patterns

---

## Credits

This release incorporates feedback from:
- STAC community best practices
- OGC API Features specification
- OpenAPI 3.0 security patterns
- ISO 19115/19115-4 standards alignment

---

## License

Apache License 2.0 - See [LICENSE](LICENSE) for details
