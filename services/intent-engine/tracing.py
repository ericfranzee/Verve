from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource

def init_tracer():
    resource = Resource.create({"service.name": "verve-intent-engine"})
    provider = TracerProvider(resource=resource)

    # Configure OTLP exporter to send traces to Jaeger
    otlp_exporter = OTLPSpanExporter(endpoint="http://localhost:4317", insecure=True)
    processor = BatchSpanProcessor(otlp_exporter)

    provider.add_span_processor(processor)
    trace.set_tracer_provider(provider)

    print("OpenTelemetry tracing initialized for Python Intent Engine")
