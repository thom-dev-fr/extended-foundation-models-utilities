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
import Foundation
import FoundationModels
@testable import FoundationModelsUtilities
import Testing

extension ChatCompletionsTests {
  @Suite struct Configuration {
    init() { MockSSEProtocol.reset() }

    @Test func `stores provided properties`() {
      let url = URL(string: "https://api.example.com/v1")!
      let model = ChatCompletionsLanguageModel(
        name: "foo",
        url: url,
        additionalHeaders: ["Authorization": "Bearer test"],
        capabilities: [.toolCalling, .vision]
      )
      #expect(model.name == "foo")
      #expect(model.url == url)
      #expect(model.additionalHeaders == ["Authorization": "Bearer test"])
      #expect(model.capabilities.contains(.toolCalling))
      #expect(model.capabilities.contains(.vision))
      #expect(!model.capabilities.contains(.guidedGeneration))
    }

    @Test func `defaults to tool calling only`() {
      let model = ChatCompletionsLanguageModel(
        name: "foo",
        url: URL(string: "https://api.example.com/v1")!
      )
      #expect(model.capabilities.contains(.toolCalling))
      #expect(!model.capabilities.contains(.vision))
      #expect(!model.capabilities.contains(.reasoning))
      #expect(!model.capabilities.contains(.guidedGeneration))
    }

    @Test func `deprecated guided generation initializer maps to tool calling and guided generation`() {
      let model = ChatCompletionsLanguageModel(
        name: "foo",
        url: URL(string: "https://api.example.com/v1")!,
        supportsGuidedGeneration: true
      )
      #expect(model.capabilities.contains(.toolCalling))
      #expect(model.capabilities.contains(.guidedGeneration))
      #expect(!model.capabilities.contains(.vision))
      #expect(!model.capabilities.contains(.reasoning))
    }

    @Test func `deprecated guided generation initializer maps false to default capabilities`() {
      let model = ChatCompletionsLanguageModel(
        name: "foo",
        url: URL(string: "https://api.example.com/v1")!,
        supportsGuidedGeneration: false
      )
      #expect(model.capabilities.contains(.toolCalling))
      #expect(!model.capabilities.contains(.guidedGeneration))
      #expect(!model.capabilities.contains(.vision))
      #expect(!model.capabilities.contains(.reasoning))
    }

    @Test func `deprecated guided generation setter preserves other capabilities`() {
      var model = ChatCompletionsLanguageModel(
        name: "foo",
        url: URL(string: "https://api.example.com/v1")!,
        capabilities: [.toolCalling, .vision, .reasoning, .guidedGeneration]
      )

      model.supportsGuidedGeneration = false
      #expect(model.capabilities.contains(.toolCalling))
      #expect(model.capabilities.contains(.vision))
      #expect(model.capabilities.contains(.reasoning))
      #expect(!model.capabilities.contains(.guidedGeneration))

      model.supportsGuidedGeneration = true
      #expect(model.capabilities.contains(.toolCalling))
      #expect(model.capabilities.contains(.vision))
      #expect(model.capabilities.contains(.reasoning))
      #expect(model.capabilities.contains(.guidedGeneration))
    }
  }
}
