import 'dart:typed_data';

class AudioCapturePipeline {
  bool _isRecording = false;

  void startRecording() {
    // Stub: Initialize PCM audio capture pipeline (C++ FFI)
    _isRecording = true;
    print("AudioCapturePipeline: Started capturing PCM audio.");
  }

  void stopRecording() {
    _isRecording = false;
    print("AudioCapturePipeline: Stopped capturing PCM audio.");
  }

  Float32List getBuffer() {
    if (!_isRecording) throw Exception("Not recording.");
    // Stub: Return PCM buffer to be sent over WebSocket
    return Float32List(1024);
  }
}
