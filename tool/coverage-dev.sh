#!/bin/bash
## ONLY FOR MAC OR LINUX 

# Install test_coverage globally
# pub global activate test_coverage

# Effective test coverage
test_coverage --no-badge

# Generate coverage info
genhtml -o coverage coverage/lcov.info 

# Open to see coverage info
open coverage/index.html