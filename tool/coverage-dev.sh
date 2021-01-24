#!/bin/bash
## ONLY FOR MAC OR LINUX 

# Effective test coverage
fvm flutter test --coverage

# Generate coverage info
genhtml -o coverage coverage/lcov.info 

# Open to see coverage info
open coverage/index.html