# Quick Submission Reference Card

## 🚀 Submit in 5 Steps

### 1️⃣ Fork Repository
Visit: https://github.com/ogcincubator/bblocks-stac
Click: "Fork" button

### 2️⃣ Upload via Web (Easiest)
- In your fork, navigate to `_sources/extensions/`
- Create new folder: `liability-claims`
- Upload files from `ogc-submission-package/`:
  - `bblock.json`
  - `description.md`
  - `schema.json`
  - `context.jsonld`
- Create subfolder `examples/` and upload 4 example files

### 3️⃣ Create Pull Request
- Click "Compare & pull request"
- Title: `Add STAC Liability and Claims Extension`
- Description: Copy from `ogc-bblock/PR-DESCRIPTION.md`

### 4️⃣ Wait for Review
- Automated tests run (5-10 minutes)
- OGC team reviews (1-2 weeks)
- Address any feedback if requested

### 5️⃣ Extension Goes Live
- Merged into OGC registry
- Auto-published documentation
- Referenceable by other building blocks

---

## 📦 Files to Upload

```
ogc-submission-package/
├── bblock.json          → Upload to liability-claims/
├── description.md       → Upload to liability-claims/
├── schema.json          → Upload to liability-claims/
├── context.jsonld       → Upload to liability-claims/
└── examples/            → Create subfolder
    ├── item-basic.json
    ├── item-with-prov.json
    ├── item-with-quality.json
    └── collection-basic.json
```

---

## 🔗 Quick Links

| Resource | URL |
|----------|-----|
| **Target Repo** | https://github.com/ogcincubator/bblocks-stac |
| **Your Package** | `ogc-submission-package/` |
| **Full Guide** | `OGC-SUBMISSION-GUIDE.md` |
| **PR Template** | `ogc-bblock/PR-DESCRIPTION.md` |
| **Checklist** | `ogc-bblock/SUBMISSION-CHECKLIST.md` |

---

## ✅ Pre-Flight Check

- [x] All files validated
- [x] Schema compiles
- [x] Examples pass validation
- [x] Dependencies verified
- [x] Documentation complete
- [x] License specified (Apache 2.0)
- [x] Archive created (16KB)

**Status**: 🟢 Ready to Submit

---

## 💡 Tips

- **Use Web Interface** if you're not comfortable with Git
- **Copy PR Description** exactly from `ogc-bblock/PR-DESCRIPTION.md`
- **Upload Examples** to subfolder, not root
- **Watch Automated Tests** - they validate everything
- **Respond Promptly** to review feedback

---

## 📧 Support

**Extension Author**: Lucio Colaiacomo  
**Email**: luciocol@gmail.com  
**GitHub**: @luciocola

**OGC Building Blocks**:  
- Docs: https://opengeospatial.github.io/bblocks/
- GitHub: https://github.com/opengeospatial/bblocks

---

**Date Prepared**: 2025-12-13  
**Version**: 1.1.0  
**Identifier**: `ogc.contrib.stac.extensions.liability-claims`
