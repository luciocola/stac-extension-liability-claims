# Contributing to STAC Liability and Claims Extension

Thank you for your interest in contributing to the STAC Liability and Claims Extension! This document provides guidelines and instructions for contributing.

## Code of Conduct

All contributors are expected to adhere to the [STAC Specification Code of Conduct](https://github.com/radiantearth/stac-spec/blob/master/CODE_OF_CONDUCT.md).

## How to Contribute

### Reporting Issues

- Use the GitHub issue tracker to report bugs or suggest features
- Check existing issues before creating a new one
- Provide clear descriptions and examples when possible
- For bugs, include steps to reproduce the issue

### Submitting Changes

1. Fork the repository
2. Create a new branch for your changes (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Test your changes thoroughly
5. Commit your changes with clear, descriptive messages
6. Push to your fork
7. Submit a pull request

### Pull Request Guidelines

- Provide a clear description of the changes
- Reference any related issues
- Ensure all tests pass
- Update documentation as needed
- Follow the existing code style

## Development Setup

### Prerequisites

- Python 3.8 or higher
- Node.js and npm (for running markdown and JSON validation)

### Installing Dependencies

For Python validation:
```bash
pip install jsonschema
```

For Node.js tools (optional):
```bash
npm install
```

### Running Tests

Validate all examples:
```bash
chmod +x validate-all.sh
./validate-all.sh
```

Validate a specific file:
```bash
python validate.py examples/item-environmental.json
```

Run npm tests (if Node.js is set up):
```bash
npm test
```

## Schema Changes

When modifying the JSON schema:

1. Update `json-schema/schema.json`
2. Update the README.md documentation
3. Update or add examples in the `examples/` directory
4. Validate all examples against the new schema
5. Update the CHANGELOG.md
6. Increment the version number appropriately

## Documentation

- Keep README.md up to date with schema changes
- Add examples for new fields or use cases
- Use clear, concise language
- Follow markdown best practices

## Versioning

This project follows [Semantic Versioning](https://semver.org/):

- MAJOR version for incompatible API changes
- MINOR version for backwards-compatible functionality additions
- PATCH version for backwards-compatible bug fixes

## Questions?

If you have questions about contributing, please open an issue for discussion.

## License

By contributing, you agree that your contributions will be licensed under the Apache License 2.0.
