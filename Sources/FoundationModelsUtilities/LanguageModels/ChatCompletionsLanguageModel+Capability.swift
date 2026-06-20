//===----------------------------------------------------------------------===//
//
// This source file is part of the Foundation Models open source project.
//
// Copyright © 2024-2027 Apple Inc. and the Foundation Models project authors.
//
// Licensed under the Apache License v2.0
//
// See LICENSE.txt for license information
//
//===----------------------------------------------------------------------===//
public import FoundationModels

extension ChatCompletionsLanguageModel {

  /// The capabilities declared by default for a chat completions model.
  ///
  /// Chat completions endpoints vary widely in their support for images,
  /// reasoning traces, and structured output, so only tool calling is declared
  /// by default. Add other capabilities explicitly when the provider reliably
  /// supports them.
  public static let defaultCapabilities: [LanguageModelCapabilities.Capability] = [
    .toolCalling
  ]

  public var supportsToolCalling: Bool {
    get { capabilities.contains(.toolCalling) }
    set { enableCapability(.toolCalling, enabled: newValue) }
  }
  
  public var supportsReasoning: Bool {
    get { capabilities.contains(.reasoning) }
    set { enableCapability(.reasoning, enabled: newValue) }
  }
  
  public var supportsVision: Bool {
    get { capabilities.contains(.vision) }
    set { enableCapability(.vision, enabled: newValue) }
  }
  
  /// Whether the endpoint supports the `response_format` field for structured output.
  public var supportsGuidedGeneration: Bool {
    get { capabilities.contains(.guidedGeneration) }
    set { enableCapability(.guidedGeneration, enabled: newValue) }
  }
  
  private mutating func enableCapability(_ capability: LanguageModelCapabilities.Capability, enabled: Bool) {
    var activeCapabilities = declaredCapabilities
    if enabled {
      if !activeCapabilities.contains(capability) {
        activeCapabilities.append(capability)
      }
    } else {
      activeCapabilities.removeAll { $0 == capability }
    }
    self.capabilities = LanguageModelCapabilities(capabilities: activeCapabilities)
  }
  
  private var declaredCapabilities: [LanguageModelCapabilities.Capability] {
    var declaredCapabilities: [LanguageModelCapabilities.Capability] = []
    if capabilities.contains(.toolCalling) {
      declaredCapabilities.append(.toolCalling)
    }
    if capabilities.contains(.reasoning) {
      declaredCapabilities.append(.reasoning)
    }
    if capabilities.contains(.vision) {
      declaredCapabilities.append(.vision)
    }
    if capabilities.contains(.guidedGeneration) {
      declaredCapabilities.append(.guidedGeneration)
    }
    return declaredCapabilities
  }
}
