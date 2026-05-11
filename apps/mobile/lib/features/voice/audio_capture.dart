import 'dart:typed_data';
import 'dart:ffi';
import 'dart:io';

// Mocks the native FFI functions
typedef StartCaptureC = Void Function();
typedef StartCaptureDart = void Function();

typedef StopCaptureC = Void Function();
typedef StopCaptureDart = void Function();

typedef GetBufferC = Pointer<Float> Function();
typedef GetBufferDart = Pointer<Float> Function();

class AudioCapturePipeline {
  bool _isRecording = false;
  late DynamicLibrary _dylib;

  AudioCapturePipeline() {
    _initFfi();
  }

  void _initFfi() {
    try {
      if (Platform.isAndroid) {
        _dylib = DynamicLibrary.open('libaudio_capture.so');
      } else if (Platform.isIOS) {
        _dylib = DynamicLibrary.process();
      } else {
        // Fallback or mock for desktop/tests
         _dylib = DynamicLibrary.process();
      }
    } catch (e) {
      // Ignore during mock environment / tests without native library
    }
  }

  void startRecording() {
    _isRecording = true;
    try {
      final startCapture = _dylib.lookupFunction<StartCaptureC, StartCaptureDart>('StartCapture');
      startCapture();
    } catch (e) {
      // Mock failure behavior
      // ignore: avoid_print
      print("FFI mock: startRecording called");
    }
  }

  void stopRecording() {
    _isRecording = false;
    try {
      final stopCapture = _dylib.lookupFunction<StopCaptureC, StopCaptureDart>('StopCapture');
      stopCapture();
    } catch (e) {
      // Mock failure behavior
      // ignore: avoid_print
      print("FFI mock: stopRecording called");
    }
  }

  Float32List getBuffer() {
    if (!_isRecording) throw Exception("Not recording.");

    try {
      final getBufferNative = _dylib.lookupFunction<GetBufferC, GetBufferDart>('GetBuffer');
      Pointer<Float> pcmBuffer = getBufferNative();
      return pcmBuffer.asTypedList(1024);
    } catch (e) {
       // Fallback stub to appease compilation prior to native compilation
      return Float32List(1024);
    }
  }
}
