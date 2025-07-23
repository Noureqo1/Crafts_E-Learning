# ADR 002: Use Lottie for Animations

## Status

Accepted

## Context

I need to implement smooth, high-quality animations in our Flutter application. Traditional animation approaches (like Flutter's built-in animations or GIFs) have limitations in terms of performance, file size, and flexibility.

## Decision

I will use the `lottie` package (version ^2.7.0) to implement animations in our Flutter application. Lottie is a mobile library that renders After Effects animations in real-time, allowing animations to be as smooth as possible.

## Consequences

### Positive

- **High Performance**: Vector-based animations that render natively
- **Small File Size**: Lottie files are typically smaller than GIFs or video files
- **Scalability**: Vector animations scale perfectly to any screen size without losing quality
- **Rich Animation Support**: Supports complex animations with features like masks, mattes, and more
- **Easy to Update**: Animations can be updated by designers without code changes
- **Cross-platform**: Works consistently across Android, iOS, and web

### Negative

- Adds a dependency to the project
- Requires Adobe After Effects for creating custom animations
- Some complex After Effects features are not supported
- Requires additional learning for designers unfamiliar with Lottie

### Risks

- If the package becomes unmaintained, we'll need to find an alternative solution
- Complex animations might have performance impacts on lower-end devices
- Requires proper error handling for animation loading states

## Alternatives Considered

1. **Rive (formerly Flare)**:
   - Pros: More powerful for interactive animations, better performance for complex animations
   - Cons: Steeper learning curve, larger file sizes

2. **Flutter's built-in animations**:
   - Pros: No external dependencies, good for simple animations
   - Cons: More complex to implement for sophisticated animations, limited capabilities

3. **GIFs**:
   - Pros: Simple to implement, widely supported
   - Cons: Poor quality on high-DPI screens, large file sizes, no transparency support

## References

- [Lottie for Flutter Documentation](https://pub.dev/packages/lottie)
- [LottieFiles](https://lottiefiles.com/) - A library of free Lottie animations
- [Lottie Web Player](https://lottiefiles.com/web-player) - Preview Lottie animations in the browser
