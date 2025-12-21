#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

echo "Starting Vize Pre-flight Checks..."

echo "Formatting code..."
dart format .

echo "Analyzing for linting issues..."
flutter analyze

echo "Running unit tests..."
flutter test

echo "Running pub publish dry-run..."
dart pub publish --dry-run

echo "All checks passed! Vize is ready to launch."