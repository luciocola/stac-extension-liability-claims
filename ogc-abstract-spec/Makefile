# Makefile for OGC Abstract Specification Topic
# Requires Metanorma to be installed: https://www.metanorma.org/install/

DOCUMENT = document
FORMATS = xml,html,doc,pdf

.PHONY: all clean html pdf doc xml help

# Default target
all: $(DOCUMENT).html $(DOCUMENT).pdf $(DOCUMENT).doc $(DOCUMENT).xml

# Build all formats
$(DOCUMENT).html $(DOCUMENT).pdf $(DOCUMENT).doc $(DOCUMENT).xml: $(DOCUMENT).adoc sections/*.adoc
	metanorma compile --agree-to-terms -t ogc -x $(FORMATS) $(DOCUMENT).adoc

# Individual format targets
html: $(DOCUMENT).html

pdf: $(DOCUMENT).pdf

doc: $(DOCUMENT).doc

xml: $(DOCUMENT).xml

# Clean build artifacts
clean:
	rm -f $(DOCUMENT).html $(DOCUMENT).pdf $(DOCUMENT).doc $(DOCUMENT).xml
	rm -rf $(DOCUMENT)_files/
	rm -rf $(DOCUMENT)_images/

# Help target
help:
	@echo "Available targets:"
	@echo "  all   - Build all output formats (HTML, PDF, DOC, XML)"
	@echo "  html  - Build HTML output only"
	@echo "  pdf   - Build PDF output only"
	@echo "  doc   - Build Word DOC output only"
	@echo "  xml   - Build XML output only"
	@echo "  clean - Remove all build artifacts"
	@echo "  help  - Show this help message"
	@echo ""
	@echo "Prerequisites:"
	@echo "  Install Metanorma: https://www.metanorma.org/install/"
	@echo ""
	@echo "Docker alternative:"
	@echo "  make docker"

# Docker build target
docker:
	docker run --rm -v "$$(pwd)":/metanorma \
		-v $${HOME}/.fontist/fonts/:/config/fonts \
		metanorma/metanorma \
		metanorma compile --agree-to-terms -t ogc -x $(FORMATS) $(DOCUMENT).adoc

# Validate only (no output generation)
validate:
	metanorma compile --agree-to-terms -t ogc -x xml $(DOCUMENT).adoc --validate
