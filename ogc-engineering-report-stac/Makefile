# Makefile for STAC Liability and Claims Extension - OGC Engineering Report

.PHONY: all clean docker-build local-build help

# Default target
all: help

help:
	@echo "STAC Liability and Claims Extension - OGC Engineering Report"
	@echo ""
	@echo "Available targets:"
	@echo "  make local-build    - Build with local Metanorma installation"
	@echo "  make docker-build   - Build with Docker containerized Metanorma"
	@echo "  make clean          - Remove generated files"
	@echo "  make help           - Show this help message"
	@echo ""
	@echo "Prerequisites:"
	@echo "  Local build: Metanorma installed (https://www.metanorma.org/install/)"
	@echo "  Docker build: Docker installed and running"

local-build:
	@echo "Building with local Metanorma installation..."
	metanorma compile --agree-to-terms -t ogc -x xml,html,doc,pdf document.adoc
	@echo "Build complete! Output files:"
	@ls -lh document.{xml,html,doc,pdf} 2>/dev/null || echo "Some output files may not have been generated"

docker-build:
	@echo "Building with Docker containerized Metanorma..."
	docker run --rm \
		-v "$$(pwd)":/metanorma \
		-v $${HOME}/.fontist/fonts/:/config/fonts \
		metanorma/metanorma \
		metanorma compile --agree-to-terms -t ogc -x xml,html,doc,pdf document.adoc
	@echo "Build complete! Output files:"
	@ls -lh document.{xml,html,doc,pdf} 2>/dev/null || echo "Some output files may not have been generated"

clean:
	@echo "Cleaning generated files..."
	rm -f document.xml document.html document.doc document.pdf
	rm -rf documents/
	@echo "Clean complete!"
