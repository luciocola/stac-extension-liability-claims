# Quick Reference: Liability Claims Extension v1.1.0

**For STAC implementers and API developers**

---

## Extension URI

```json
"stac_extensions": [
  "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
]
```

---

## Security Fields (Asset-Level)

### Recommended Fields

```json
{
  "assets": {
    "evidence": {
      "href": "https://example.com/evidence.tif",
      
      // Security classification (REQUIRED for restricted assets)
      "liability:security_classification": "confidential",
      
      // Access restrictions (legal/policy constraints)
      "liability:access_restrictions": [
        "legal_hold",
        "authorized_investigators_only"
      ],
      
      // Required roles (enforced at API level)
      "liability:required_roles": ["investigator", "legal_counsel"]
    }
  }
}
```

### Security Classification Levels

| Level | Meaning | Example |
|-------|---------|---------|
| `public` | Publicly accessible | Press releases, public reports |
| `internal` | Internal use only | Internal memos, company analyses |
| `confidential` | Requires authorization | Investigation evidence, financial data |
| `restricted` | Highly restricted | Attorney-client privileged documents |
| `classified` | Security clearance required | Classified government data |

---

## Deprecated Fields (v1.0.0)

❌ **Do NOT use these in new implementations:**

```json
// DEPRECATED - Use OpenAPI securitySchemes instead
"liability:access_control": { ... }

// DEPRECATED - Use separate assets or links instead
"liability:alternate": { ... }
```

---

## OpenAPI Security (API-Level)

### Minimal Setup

```yaml
# openapi.yaml
components:
  securitySchemes:
    ApiKeyAuth:
      type: apiKey
      in: header
      name: X-API-Key

security:
  - ApiKeyAuth: []
```

### OAuth2 with Scopes

```yaml
components:
  securitySchemes:
    OAuth2:
      type: oauth2
      flows:
        authorizationCode:
          authorizationUrl: https://auth.example.com/oauth/authorize
          tokenUrl: https://auth.example.com/oauth/token
          scopes:
            read:items: Read STAC items
            read:evidence: Access evidence assets
            write:items: Create/update items

security:
  - OAuth2: [read:items]
```

### Multiple Auth Methods

```yaml
security:
  - ApiKeyAuth: []
  - OAuth2: [read:items]
  - BearerAuth: []
```

---

## API Implementation Pattern

### 1. User Authentication

```python
# Authenticate user and extract roles
user = authenticate(request.headers.get('X-API-Key'))
user_roles = user.roles  # e.g., ['investigator', 'claim_adjuster']
```

### 2. Item Filtering

```python
def can_access_item(item, user_roles):
    """Check if user can access item based on assets"""
    for asset in item['assets'].values():
        classification = asset.get('liability:security_classification', 'public')
        required_roles = asset.get('liability:required_roles', [])
        
        if classification == 'public':
            continue
        
        if required_roles and not any(role in user_roles for role in required_roles):
            return False
    
    return True
```

### 3. Asset Access Control

```python
def can_access_asset(asset, user_roles):
    """Check if user can access specific asset"""
    classification = asset.get('liability:security_classification', 'public')
    required_roles = asset.get('liability:required_roles', [])
    
    if classification == 'public':
        return True
    
    if not required_roles:
        # No specific roles required, but classification implies some auth
        return len(user_roles) > 0
    
    # Check if user has any of the required roles
    return any(role in user_roles for role in required_roles)
```

### 4. Error Responses

```python
# 401 Unauthorized - No auth provided
{
  "code": "UNAUTHORIZED",
  "message": "Authentication required. Provide valid API key or OAuth token."
}

# 403 Forbidden - Insufficient permissions
{
  "code": "INSUFFICIENT_ROLE",
  "message": "This asset requires 'legal_counsel' role. Your roles: ['investigator']",
  "details": {
    "required_roles": ["legal_counsel"],
    "user_roles": ["investigator"],
    "classification": "restricted"
  }
}
```

---

## Common Patterns

### Multiple Access Levels (Same Data)

```json
{
  "assets": {
    "full-resolution": {
      "href": "https://secure.example.com/image.tif",
      "roles": ["data"],
      "liability:security_classification": "confidential",
      "liability:required_roles": ["investigator"]
    },
    "low-resolution": {
      "href": "https://public.example.com/preview.jpg",
      "roles": ["overview"],
      "liability:security_classification": "public"
    }
  }
}
```

### Alternative Access Methods (Links)

```json
{
  "assets": { ... },
  "links": [
    {
      "rel": "alternate",
      "href": "https://portal.example.com/items/item-001",
      "title": "View in authenticated portal",
      "type": "text/html"
    }
  ]
}
```

### Mixed Security Assets

```json
{
  "assets": {
    "evidence": {
      "liability:security_classification": "restricted",
      "liability:required_roles": ["legal_counsel"]
    },
    "report": {
      "liability:security_classification": "confidential",
      "liability:required_roles": ["investigator", "legal_counsel"]
    },
    "overview": {
      "liability:security_classification": "internal",
      "liability:required_roles": ["claim_adjuster", "investigator", "legal_counsel"]
    },
    "thumbnail": {
      "liability:security_classification": "public"
    }
  }
}
```

---

## Validation

### Check Schema Compliance

```bash
npm install
npm test
```

### Validate with PySTAC

```python
import pystac

item = pystac.Item.from_file('item.json')
item.validate()
```

---

## Migration Checklist

Migrating from v1.0.0 → v1.1.0:

- [ ] Update `stac_extensions` URI to v1.1.0
- [ ] Replace `liability:access_control` with OpenAPI security
- [ ] Replace `liability:alternate` with separate assets
- [ ] Add `liability:required_roles` to restricted assets
- [ ] Verify `liability:security_classification` is set
- [ ] Create OpenAPI specification
- [ ] Implement role-based filtering in API
- [ ] Update tests and documentation

---

## Resources

- **Full Specification:** [README.md](README.md)
- **Examples:** [examples/](examples/)
- **OpenAPI Template:** [examples/stac-api-openapi.yaml](examples/stac-api-openapi.yaml)
- **Compatibility Assessment:** [STAC-API-COMPATIBILITY.md](STAC-API-COMPATIBILITY.md)
- **Migration Guide:** [RELEASE-v1.1.0.md](RELEASE-v1.1.0.md)

---

## Quick Examples

### Minimal Item (Public)

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "claim-001",
  "properties": {
    "datetime": "2024-12-04T10:00:00Z",
    "liability:claim_id": "CLM-001",
    "liability:claim_status": "pending"
  },
  "geometry": { "type": "Point", "coordinates": [0, 0] },
  "assets": {
    "report": {
      "href": "https://example.com/report.pdf",
      "type": "application/pdf",
      "liability:security_classification": "public"
    }
  }
}
```

### Secure Item (Confidential)

```json
{
  "stac_version": "1.0.0",
  "stac_extensions": [
    "https://stac-extensions.github.io/liability-claims/v1.1.0/schema.json"
  ],
  "type": "Feature",
  "id": "claim-002",
  "properties": {
    "datetime": "2024-12-04T10:00:00Z",
    "liability:claim_id": "CLM-002",
    "liability:claim_status": "under_investigation"
  },
  "geometry": { "type": "Point", "coordinates": [0, 0] },
  "assets": {
    "evidence": {
      "href": "https://secure.example.com/evidence.tif",
      "type": "image/tiff",
      "liability:security_classification": "confidential",
      "liability:access_restrictions": ["legal_hold"],
      "liability:required_roles": ["investigator", "legal_counsel"]
    }
  }
}
```

---

## Support

- **GitHub Issues:** Report bugs and request features
- **STAC Gitter:** https://gitter.im/SpatioTemporal-Asset-Catalog/Lobby
- **Email:** api-support@example.com (replace with your contact)
