# STAC API Specification Compatibility Assessment

**Extension:** Liability and Claims Extension v1.0.0  
**Assessment Date:** December 4, 2025  
**Assessed Against:**
- [STAC Spec v1.0.0](https://github.com/radiantearth/stac-spec)
- [STAC API Spec v1.0.0](https://github.com/radiantearth/stac-api-spec)
- [STAC Extensions Best Practices](https://github.com/radiantearth/stac-spec/tree/master/extensions)

---

## Executive Summary

**Overall Compatibility Rating:** ⭐⭐⭐⭐ (4/5 - Good, with recommendations)

The Liability and Claims extension is **largely compatible** with STAC specifications but includes custom authentication/authorization patterns that deviate from standard STAC/OGC API practices. This assessment provides harmonization recommendations to improve interoperability.

### Key Findings

✅ **Strengths:**
- Follows STAC extension template structure
- Proper JSON Schema with validation
- Good use of prefix (`liability:`)
- ISO 19115 quality integration aligns with geospatial standards
- Comprehensive examples

⚠️ **Areas for Harmonization:**
- **Authentication approach** - Custom implementation vs. API-level security
- **Access control fields** - Mixing data metadata with API authentication
- **Alternate assets pattern** - Non-standard authentication metadata

---

## Detailed Compatibility Analysis

### 1. Core STAC Extension Compliance

| Aspect | Status | Notes |
|--------|--------|-------|
| Extension Identifier URI | ✅ PASS | Proper GitHub Pages URI format |
| JSON Schema structure | ✅ PASS | Valid draft-07 schema |
| Field naming (prefixes) | ✅ PASS | Consistent `liability:` prefix |
| Scope declaration | ✅ PASS | Correctly scopes to Items & Collections |
| Maturity classification | ✅ PASS | Declared as "Proposal" |
| Documentation | ✅ PASS | Comprehensive README with examples |

**Recommendation:** None needed - compliant.

---

### 2. Authentication & Authorization (Critical Issue)

#### Current Implementation

The extension currently implements **data-level authentication metadata** within STAC Item assets:

```json
{
  "assets": {
    "secure-image": {
      "href": "https://example.com/image.tif",
      "liability:access_control": {
        "required_auth": true,
        "auth_methods": ["apiKey", "oauth2"],
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

#### STAC API Specification Approach

**STAC API and OGC API - Features handle authentication at the API level, not the data level:**

1. **OpenAPI 3.0 Security Schemes** (API-level):
   ```yaml
   # In openapi.yaml
   components:
     securitySchemes:
       ApiKeyAuth:
         type: apiKey
         in: header
         name: X-API-Key
       OAuth2:
         type: oauth2
         flows:
           authorizationCode:
             authorizationUrl: https://auth.example.com/oauth/authorize
             tokenUrl: https://auth.example.com/oauth/token
             scopes:
               read:items: Read STAC items
   
   security:
     - ApiKeyAuth: []
     - OAuth2: [read:items]
   ```

2. **Asset Access** - Assets inherit API security, no per-asset authentication metadata needed

#### The Problem

❌ **Mixing Concerns:** The extension conflates:
- **Security classification** (data characteristic) → belongs in STAC
- **Authentication mechanism** (API implementation) → belongs in OpenAPI spec
- **Authorization** (access control) → belongs in API implementation

#### Recommended Harmonization

**Option A: Separate Security Classification from API Authentication (Recommended)**

Keep **only security classification metadata** in STAC:

```json
{
  "assets": {
    "secure-image": {
      "href": "https://example.com/image.tif",
      "liability:security_classification": "confidential",
      "liability:access_restrictions": [
        "legal_hold",
        "authorized_investigators_only"
      ],
      "liability:required_roles": ["investigator", "legal_counsel"]
    }
  }
}
```

Move **authentication schemes** to STAC API OpenAPI spec:

```yaml
# STAC API openapi.yaml
components:
  securitySchemes:
    ClaimsApiKey:
      type: apiKey
      in: header
      name: X-Claims-API-Key
      description: API Key for authorized investigators
```

**Option B: Reference Authentication Extension**

If per-asset auth is truly needed, create/use a dedicated **Authentication Extension** that:
- Follows STAC extension patterns
- Works with STAC API security schemes
- References OpenAPI security definitions

```json
{
  "stac_extensions": [
    "https://stac-extensions.github.io/authentication/v1.0.0/schema.json",
    "https://stac-extensions.github.io/liability-claims/v1.0.0/schema.json"
  ],
  "assets": {
    "secure-image": {
      "href": "https://example.com/image.tif",
      "auth:required": true,
      "auth:schemes": ["ClaimsApiKey"],  // References OpenAPI security scheme
      "liability:security_classification": "confidential"
    }
  }
}
```

---

### 3. Alternate Asset Pattern

#### Current Implementation

```json
{
  "liability:alternate": {
    "API_Key_Access": {
      "href": "...",
      "auth": { 
        "schemes": { ... }  
      }
    }
  }
}
```

#### STAC Specification Approach

STAC already has mechanisms for multiple access methods:

**Option 1: Multiple Assets**

```json
{
  "assets": {
    "image-public": {
      "href": "https://public.example.com/image.jpg",
      "title": "Public Preview (Low Resolution)",
      "roles": ["overview"]
    },
    "image-authenticated": {
      "href": "https://secure.example.com/image.tif",
      "title": "Full Resolution (Requires Authentication)",
      "roles": ["data"],
      "liability:security_classification": "confidential"
    }
  }
}
```

**Option 2: STAC Links with Auth Metadata**

```json
{
  "assets": {
    "secure-image": {
      "href": "https://secure.example.com/image.tif"
    }
  },
  "links": [
    {
      "rel": "alternate",
      "href": "https://portal.example.com/image.tif",
      "title": "Browser-based authenticated access",
      "type": "image/tiff"
    }
  ]
}
```

#### Recommendation

❌ **Remove `liability:alternate`** - Use standard STAC patterns:
- Separate assets for different access levels
- Use STAC `links` with `rel="alternate"` for alternative access methods
- Document authentication requirements in API-level specs

---

### 4. Fields Alignment with STAC Best Practices

#### Compliant Fields ✅

| Field | Compliance | Notes |
|-------|------------|-------|
| `liability:claim_id` | ✅ Good | Standard identifier pattern |
| `liability:claim_status` | ✅ Good | Enumerated values |
| `liability:claim_date` | ✅ Good | RFC 3339 datetime |
| `liability:coverage_area` | ✅ Good | GeoJSON geometry |
| `liability:affected_parties` | ✅ Good | Array of objects (acceptable for complex data) |
| `liability:damages_estimated` | ✅ Good | Numeric value |
| `liability:quality` | ✅ Good | ISO 19115 alignment |

#### Fields Needing Revision ⚠️

| Field | Issue | Recommendation |
|-------|-------|----------------|
| `liability:access_control` | Mixes security metadata with auth | Move to `liability:security_classification` only |
| `liability:alternate` | Non-standard asset pattern | Use STAC `assets` or `links` |
| `liability:auth_*` fields | API-level concern | Remove, document in OpenAPI |

---

### 5. Extension Maturity & Process

| Requirement | Status | Evidence |
|-------------|--------|----------|
| Extension template usage | ✅ | Proper structure |
| JSON Schema validation | ✅ | Valid schemas provided |
| Examples provided | ✅ | Multiple example files |
| README documentation | ✅ | Comprehensive docs |
| Minimum implementations | ⚠️  | Proposal stage (0 required) |
| Community review | ⚠️  | Needs STAC community feedback |

**Recommendation:** 
1. Submit to [stac-extensions](https://github.com/stac-extensions) organization
2. Open issue in [radiantearth/stac-spec](https://github.com/radiantearth/stac-spec/issues) with "new extension" label
3. Announce in [STAC Gitter](https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby) for feedback

---

## Harmonization Recommendations

### Priority 1: Critical Changes

1. **Separate Security Classification from Authentication**
   - **Keep:** `liability:security_classification`, `liability:access_restrictions`
   - **Remove:** `liability:access_control.auth_schemes`, `liability:access_control.auth_methods`
   - **Move to API:** Authentication schemes in OpenAPI `securitySchemes`

2. **Remove Custom Alternate Pattern**
   - **Replace:** `liability:alternate` with standard STAC `assets` or `links`
   - **Example:** Create separate assets for different access levels

### Priority 2: Important Improvements

3. **Add OpenAPI Example**
   - Create `examples/stac-api-openapi.yaml` showing proper API-level security
   - Document how STAC API implements authentication for liability claims

4. **Clarify Asset Access Documentation**
   - Update README section on "Secure Assets" to reference API authentication
   - Provide end-to-end example of API + STAC Item with security

### Priority 3: Best Practices

5. **Add Conformance to README**
   - Document conformance with STAC 1.0.0
   - List compatible STAC API versions

6. **Add Use Case Examples**
   - Show integration with STAC API - Features
   - Demonstrate Collection summaries for liability fields

---

## Compatibility Matrix

| Component | Compatible? | Notes |
|-----------|-------------|-------|
| STAC Core 1.0.0 | ✅ Yes | Fields work in Items/Collections |
| STAC API Core | ⚠️  Partial | Auth pattern needs revision |
| STAC API Features | ✅ Yes | Can query via OGC API Features |
| STAC API - Item Search | ✅ Yes | Searchable fields work |
| STAC Browser | ✅ Yes | Fields displayable |
| PySTAC | ✅ Yes | Valid STAC objects |
| stac-validator | ⚠️  Depends | Schema validates, but custom auth may confuse tools |

---

## Implementation Guidance

### For Extension Maintainers

**Immediate Actions:**

1. Create new version (`v1.1.0`) with authentication changes
2. Mark `v1.0.0` fields as deprecated:
   ```json
   {
     "liability:access_control": {
       "deprecated": true,
       "description": "DEPRECATED: Use API-level security schemes instead"
     }
   }
   ```

3. Update all examples to remove auth metadata from STAC Items
4. Add `examples/stac-api-openapi.yaml` with proper security configuration

**Example Migration:**

```diff
  {
    "assets": {
      "evidence": {
        "href": "https://example.com/evidence.tif",
-       "liability:access_control": {
-         "required_auth": true,
-         "auth_methods": ["apiKey"]
-       },
+       "liability:security_classification": "confidential",
+       "liability:required_roles": ["investigator"]
      }
    }
  }
```

### For API Implementers

When implementing STAC API with this extension:

1. **Define security in OpenAPI spec:**
   ```yaml
   components:
     securitySchemes:
       # Your authentication schemes
   
   security:
     - ApiKeyAuth: []
   ```

2. **Filter items based on user roles:**
   ```python
   # Pseudo-code
   if item.properties.get('liability:required_roles'):
       if not user.has_any_role(item.properties['liability:required_roles']):
           # Exclude from results or redact
   ```

3. **Document security requirements in API docs**

---

## References

- [STAC Specification](https://github.com/radiantearth/stac-spec)
- [STAC API Specification](https://github.com/radiantearth/stac-api-spec)
- [STAC Extensions Best Practices](https://github.com/radiantearth/stac-spec/tree/master/extensions)
- [OGC API - Features](http://docs.opengeospatial.org/is/17-069r3/17-069r3.html)
- [OpenAPI 3.0 Security](https://swagger.io/docs/specification/authentication/)
- [STAC Extension Template](https://github.com/stac-extensions/template)

---

## Appendix: Recommended Schema Changes

### Remove from schema.json

```json
// REMOVE THESE DEFINITIONS:
"liability:access_control": { ... },
"liability:alternate": { ... },
"liability:auth_methods": { ... },
"liability:auth_schemes": { ... }
```

### Add to schema.json

```json
// ADD THESE:
"liability:required_roles": {
  "type": "array",
  "items": {
    "type": "string"
  },
  "description": "Roles required to access this asset (enforced at API level)"
},
"liability:security_classification": {
  "type": "string",
  "enum": ["public", "internal", "confidential", "restricted", "classified"],
  "description": "Security classification level of the asset"
}
```

---

## Conclusion

The Liability and Claims extension provides valuable functionality for tracking legal and insurance information in STAC catalogs. With the recommended harmonization changes—primarily separating security classification metadata from API authentication mechanisms—it will achieve full compatibility with STAC and OGC API specifications.

**Next Steps:**
1. Implement Priority 1 changes (authentication separation)
2. Submit to STAC community for review
3. Advance maturity through implementations
4. Consider standalone Authentication extension for community benefit
