# LiquidSwift

LiquidSwift is a Swift wrapper around the Liquid Inference Engine, providing a native Swift API for running AI models locally on Apple devices. It's a core component of the LeapSDK that handles the low-level interaction with the Rust-based inference engine.

## Overview

LiquidSwift provides:

- Type-safe Swift interfaces for the Liquid Inference Engine
- Async/await support for text generation
- Proper memory management for C interop
- Support for chat-based conversations
- Constraint-based generation (regex, JSON schema, etc.)
- Real-time generation statistics
- Token-by-token streaming

## Architecture

```
┌─────────────────┐
│   LeapSDK       │
├─────────────────┤
│  LiquidSwift    │  ← Swift wrapper (this module)
├─────────────────┤
│ Liquid Rust API │  ← inference_engine.xcframework
└─────────────────┘
```

## Core Components

### LiquidInferenceEngine

The main class that wraps the Rust inference engine:

```swift
// Initialize the engine
let options = LiquidInferenceEngineOptions(
    bundlePath: "/path/to/model.bundle",
    cacheOptions: LiquidCacheOptions(path: "/cache", maxEntries: 100),
    cpuThreads: 4
)
let engine = try LiquidInferenceEngine(options: options)

// Get model information
let modelId = try engine.getModelId()
let config = try engine.getBundleConfig()

// Generate text from chat messages
let messages = [
    LiquidMessage(role: "system", text: "You are a helpful assistant."),
    LiquidMessage(role: "user", text: "Hello!")
]

engine.generate(
    messages: messages,
    options: LiquidGenerateOptions(
        samplerParams: LiquidSamplerParams(temperature: 0.7)
    ),
    onToken: { token in
        print(token, terminator: "")
    },
    onComplete: { result in
        switch result {
        case .success:
            print("\nGeneration complete")
        case .failure(let error):
            print("Error: \(error)")
        }
    }
)
```

### Message Types

```swift
// Simple text message
let message = LiquidMessage(role: "user", text: "Hello!")

// Multi-modal message with image
let message = LiquidMessage(
    role: "user",
    content: [
        LiquidMessageContent(text: "What's in this image?"),
        LiquidMessageContent(jpeg: imageData)
    ]
)
```

### Generation Options

```swift
let options = LiquidGenerateOptions(
    resetHistory: false,
    sequenceLength: 2048,
    samplerParams: LiquidSamplerParams(
        temperature: 0.7,
        topP: 0.9,
        minP: 0.05,
        repetitionPenalty: 1.1,
        rngSeed: 42
    ),
    constraint: LiquidConstraint(
        type: .jsonSchema,
        config: """
        {
            "type": "object",
            "properties": {
                "name": {"type": "string"},
                "age": {"type": "number"}
            }
        }
        """
    ),
    onStats: { stats in
        print("Tokens/sec: \(stats.tokenPerSecond)")
    }
)
```

### Constraint-Based Generation

LiquidSwift supports three types of constraints:

1. **Regex Constraints**

   ```swift
   let constraint = LiquidConstraint(
       type: .regex,
       config: "^[A-Z][a-z]+$"  // Generate a capitalized word
   )
   ```

2. **JSON Schema Constraints**

   ```swift
   let constraint = LiquidConstraint(
       type: .jsonSchema,
       config: jsonSchemaString
   )
   ```

3. **Two-Step DSL Constraints**
   ```swift
   let constraint = LiquidConstraint(
       type: .twoStepDSL,
       config: dslConfig
   )
   ```

### Logging

Set up logging to monitor the inference engine:

```swift
// Initialize logging
LiquidInferenceEngine.setupLogging(level: .info) { level, target, message in
    print("[\(level)] \(target): \(message)")
}
```

### Static Methods

```swift
// Initialize backends (call once at app startup)
LiquidInferenceEngine.initializeLiquid()

// Get compatibility IDs
let compatibilityIds = LiquidInferenceEngine.getBundleCompatibilityIDs()
```

## Error Handling

LiquidSwift uses the `LiquidError` enum for error handling:

```swift
public enum LiquidError: Error {
    case success
    case loadError
    case invalidArgument
    case invalidBufferSize
    case exceedContextLength
    case internalError
    case notFound

    init(code: Int32) {
        // Maps C error codes to Swift errors
    }
}
```

## Memory Management

LiquidSwift handles all memory management for the C interop:

- Automatic cleanup of C strings and structures
- Proper retain/release cycles for callbacks
- Safe handling of async operations

## Thread Safety

- The engine itself is not thread-safe for concurrent generation
- Generation happens on background queues with callbacks on the main queue
- Multiple engines can be created for parallel processing

## Integration with LeapSDK

LiquidSwift is used by LeapSDK through the `LiquidInferenceEngineRunner` class, which implements the `ModelRunner` protocol:

```swift
// This is handled internally by LeapSDK
let modelRunner = try LiquidInferenceEngineRunner(url: modelURL)
let conversation = modelRunner.createConversation()
```

## Requirements

- iOS 17.2+ / macOS 14.0+
- Liquid Inference Engine xcframework
- Swift 5.9+

## Platform Support

- iOS (arm64)
- iOS Simulator (arm64, x86_64)
- macOS (arm64)
- Mac Catalyst (arm64)

## Performance Considerations

- Models are loaded into memory on initialization
- Token generation happens incrementally with streaming
- Use cache options for faster repeated inference
- Adjust CPU threads based on device capabilities

## Example: Complete Chat Session

```swift
// Initialize engine
LiquidInferenceEngine.initializeLiquid()
let engine = try LiquidInferenceEngine(bundlePath: modelPath)

// Validate messages
let messages = [
    LiquidMessage(role: "system", text: "You are a helpful assistant."),
    LiquidMessage(role: "user", text: "Write a haiku about Swift programming.")
]

if let validationError = try engine.validate(messages: messages) {
    print("Validation failed: \(validationError)")
    return
}

// Check token count
let tokenCount = try engine.getPromptTokensSize(messages: messages)
print("Prompt uses \(tokenCount) tokens")

// Generate response
var fullResponse = ""
engine.generate(
    messages: messages,
    options: LiquidGenerateOptions(
        samplerParams: LiquidSamplerParams(temperature: 0.8)
    ),
    onToken: { token in
        fullResponse += token
        print(token, terminator: "")
    },
    onComplete: { result in
        if case .success = result {
            print("\n\nComplete response: \(fullResponse)")
        }
    }
)
```

## Advanced Features

### Simple Prompt Generation

For non-chat use cases:

```swift
engine.generateForPrompt(
    prompt: "Once upon a time",
    options: options,
    onToken: { token in
        print(token, terminator: "")
    },
    onComplete: { _ in }
)
```

### Engine State Management

```swift
// Get current state
let state = try engine.getState()
print("Position: \(state.currentPosition)/\(state.maxSequenceLength)")

// Reset engine
try engine.reset()

// Stop generation
try engine.stop()
```

## Debugging

Enable debug logging to see detailed engine operations:

```swift
LiquidInferenceEngine.setupLogging(level: .debug) { level, target, message in
    print("[\(level)] \(target): \(message)")
}
```

Common log targets:

- `inference_engine::engine` - Engine lifecycle
- `inference_engine::backend::executorch` - Model execution
- Token generation statistics and performance metrics
