# ADR 001: Use flutter_launcher_icons for App Icons

## Status

Accepted

## Context

I need to manage and generate app launcher icons for both Android and iOS platforms in our Flutter application. Manually creating and maintaining multiple icon sizes for different devices and platforms is time-consuming and error-prone.

## Decision

I will use the `flutter_launcher_icons` package (version ^0.13.1) to automatically generate app launcher icons from a single source image.

## Consequences

### Positive

- **Simplified Workflow**: Generate all required icon sizes from a single source image
- **Consistency**: Ensures consistent icon appearance across all platforms and devices
- **Time-saving**: Automates the process of creating multiple icon sizes
- **Easy Updates**: Update the app icon by simply replacing the source image and running the generator
- **Cross-platform**: Supports both Android and iOS with a single configuration

### Negative

- Adds a development dependency to the project
- Requires running a build command to update icons
- May require additional configuration for complex icon requirements

### Risks

- If the package becomes unmaintained, we'll need to find an alternative solution
- Initial setup requires proper configuration for both platforms

## Alternatives Considered

### 1. Manual Icon Generation

- **Pros**: Full control over each icon size and variation
- **Cons**: Time-consuming, error-prone, and difficult to maintain

### 2. Online Icon Generators

- **Pros**: No additional dependencies
- **Cons**: Requires manual process for each update, potential consistency issues

## References

- [flutter_launcher_icons on pub.dev](https://pub.dev/packages/flutter_launcher_icons)
- [Flutter Documentation: Adding a Launcher Icon](https://flutter.dev/docs/development/ui/assets-and-images#updating-the-launcher-icon)