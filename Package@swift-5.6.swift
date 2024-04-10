// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "opentelemetry-swift",
    platforms: [
        .macOS(.v10_13),
        .iOS(.v11),
        .tvOS(.v11),
        .watchOS(.v3)
    ],
    products: [
        .library(name: "OpenTelemetryApi", type: .static, targets: ["OpenTelemetryApi"]),
        .library(name: "OpenTelemetrySdk", type: .static, targets: ["OpenTelemetrySdk"]),
        .library(name: "ResourceExtension", type: .static, targets: ["ResourceExtension"]),
        .library(name: "URLSessionInstrumentation", type: .static, targets: ["URLSessionInstrumentation"]),
        .library(name: "SignPostIntegration", type: .static, targets: ["SignPostIntegration"]),
        .library(name: "OpenTracingShim-experimental", type: .static, targets: ["OpenTracingShim"]),
        .library(name: "SwiftMetricsShim", type: .static, targets: ["SwiftMetricsShim"]),
        .library(name: "JaegerExporter", type: .static, targets: ["JaegerExporter"]),
        .library(name: "ZipkinExporter", type: .static, targets: ["ZipkinExporter"]),
        .library(name: "StdoutExporter", type: .static, targets: ["StdoutExporter"]),
        .library(name: "PrometheusExporter", type: .static, targets: ["PrometheusExporter"]),
        .library(name: "OpenTelemetryProtocolExporter", type: .static, targets: ["OpenTelemetryProtocolExporterGrpc"]),
        .library(name: "OpenTelemetryProtocolExporterHTTP", type: .static, targets: ["OpenTelemetryProtocolExporterHttp"]),
        .library(name: "PersistenceExporter", type: .static, targets: ["PersistenceExporter"]),
        .library(name: "InMemoryExporter", type: .static, targets: ["InMemoryExporter"]),
        .library(name: "DatadogExporter", type: .static, targets: ["DatadogExporter"]),
        .library(name: "NetworkStatus", type: .static, targets: ["NetworkStatus"]),
    ],
    dependencies: [
        .package(url: "https://github.com/undefinedlabs/opentracing-objc", from: "0.5.2"),
        .package(url: "https://github.com/undefinedlabs/Thrift-Swift", from: "1.1.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.0.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.20.2"),
        .package(url: "https://github.com/apple/swift-log.git", from: "1.4.4"),
        .package(url: "https://github.com/apple/swift-metrics.git", from: "2.1.1"),
        .package(url: "https://github.com/ashleymills/Reachability.swift", from: "5.1.0")
    ],
    targets: [
        .target(name: "OpenTelemetryApi",
                dependencies: []),
        .target(name: "OpenTelemetrySdk",
                dependencies: ["OpenTelemetryApi"]),
        .target(name: "ResourceExtension",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SDKResourceExtension",
                exclude: ["README.md"]),
        .target(name: "URLSessionInstrumentation",
                dependencies: ["OpenTelemetrySdk", "NetworkStatus"],
                path: "Sources/Instrumentation/URLSession",
                exclude: ["README.md"]),
        .target(name: "NetworkStatus",
                dependencies: [
                    "OpenTelemetryApi",
                    .product(name: "Reachability", package: "Reachability.swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux]))
                ],
                path: "Sources/Instrumentation/NetworkStatus",
                linkerSettings: [.linkedFramework("CoreTelephony", .when(platforms: [.iOS], configuration: nil))]),
        .target(name: "SignPostIntegration",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Instrumentation/SignPostIntegration",
                exclude: ["README.md"]),
        .target(name: "OpenTracingShim",
                dependencies: [
                    "OpenTelemetrySdk",
                    .product(name: "Opentracing", package: "opentracing-objc")
                ],
                path: "Sources/Importers/OpenTracingShim",
                exclude: ["README.md"]),
        .target(name: "SwiftMetricsShim",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "CoreMetrics", package: "swift-metrics")],
                path: "Sources/Importers/SwiftMetricsShim",
                exclude: ["README.md"]),
        .target(name: "JaegerExporter",
                dependencies: [
                    "OpenTelemetrySdk",
                    .product(name: "Thrift", package: "Thrift-Swift", condition: .when(platforms: [.iOS, .macOS, .tvOS, .macCatalyst, .linux]))
                ],
                path: "Sources/Exporters/Jaeger"),
        .target(name: "ZipkinExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Zipkin"),
        .target(name: "PrometheusExporter",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "NIO", package: "swift-nio"),
                               .product(name: "NIOHTTP1", package: "swift-nio")],
                path: "Sources/Exporters/Prometheus"),
        .target(name: "OpenTelemetryProtocolExporterCommon",
                dependencies: ["OpenTelemetrySdk",
                               .product(name: "Logging", package: "swift-log"),
                               .product(name: "SwiftProtobuf", package: "swift-protobuf")],
                path: "Sources/Exporters/OpenTelemetryProtocolCommon"),
        .target(name: "OpenTelemetryProtocolExporterHttp",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon"],
                path: "Sources/Exporters/OpenTelemetryProtocolHttp"),
        .target(name: "OpenTelemetryProtocolExporterGrpc",
                dependencies: ["OpenTelemetrySdk",
                               "OpenTelemetryProtocolExporterCommon",
                               .product(name: "GRPC", package: "grpc-swift")],
                path: "Sources/Exporters/OpenTelemetryProtocolGrpc"),
        .target(name: "StdoutExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Stdout"),
        .target(name: "InMemoryExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/InMemory"),
        .target(name: "DatadogExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/DatadogExporter",
                exclude: ["NOTICE", "README.md"]),
        .target(name: "PersistenceExporter",
                dependencies: ["OpenTelemetrySdk"],
                path: "Sources/Exporters/Persistence"),
    ]
)
