import AVFoundation

final class CameraImageSource: NSObject, ImageSource {
    
    // MARK: - Child Types
    
    enum SetupError: Swift.Error {
        
        case invalidCameraAuthorization(AVAuthorizationStatus)
        
        case noCaptureDeviceFound
        
        case cannotAttachCaptureInput(AVCaptureInput)
        
        case cannotAttachCaptureOutput(AVCaptureOutput)
        
        case captureOutputWithoutVideoConnection(AVCaptureOutput)
        
    }
    
    enum FrameError: Swift.Error {
        
        case cmSampleBufferGetImageBufferReturnedNil
        
        case createCGImageReturnedNil
        
    }
    
    private enum Constant {
        
        static let sessionPreset: AVCaptureSession.Preset = .vga640x480
        
        static let videoSettings = [
            (kCVPixelBufferPixelFormatTypeKey as String):
                kCVPixelFormatType_32BGRA
        ]
        
        static let cameraPosition: AVCaptureDevice.Position = .front
        
        static let sessionQueueLabel
            = "eu.ezytarget.autoselfie.SessionQueue"
        
        static let videoDataOutputQueueLabel
            = "eu.ezytarget.autoselfie.VideoDataOutputQueue"
        
    }
    
    // MARK: - Values
        
    private(set) var feedStarted = false
    
    var authorizationStatus: AVAuthorizationStatus {
        AVCaptureDevice.authorizationStatus(for: .video)
    }
        
    private var frameHandler: ((Result<CMSampleBuffer, Swift.Error>) -> ())?
    
    private let captureSession: AVCaptureSession
    
    private let captureSessionQueue: DispatchQueue
    
    private let captureOutputQueue: DispatchQueue
    
    private let frameHandlerQueue: DispatchQueue
    
    // MARK: - Init
    
    override convenience init() {
        let captureSession = AVCaptureSession()
        self.init(
            captureSession: captureSession,
            captureSessionQueue:
                DispatchQueue(label: Constant.sessionQueueLabel),
            captureOutputQueue:
                DispatchQueue(label: Constant.videoDataOutputQueueLabel),
            frameHandlerQueue: DispatchQueue.global(qos: .userInteractive)
        )
    }
    
    init(
        captureSession: AVCaptureSession,
        captureSessionQueue: DispatchQueue,
        captureOutputQueue: DispatchQueue,
        frameHandlerQueue: DispatchQueue
    ) {
        self.captureSession = captureSession
        self.captureSessionQueue = captureSessionQueue
        self.captureOutputQueue = captureOutputQueue
        self.frameHandlerQueue = frameHandlerQueue
    }
            
    // MARK: - Entry Points
    
    func startFeed(
        completionHandler: ((Result<Bool, Swift.Error>) -> ())? = nil,
        frameHandler: ((Result<CMSampleBuffer, Swift.Error>) -> ())?
    ) {
        guard !feedStarted else {
            completionHandler?(.success(false))
            return
        }
        
        let authorizationStatus = self.authorizationStatus
        guard authorizationStatus == .authorized else {
            let authorizationError =
                SetupError.invalidCameraAuthorization(authorizationStatus)
                
            completionHandler?(.failure(authorizationError))
            return
        }
        
        feedStarted = true
        self.frameHandler = frameHandler
        
        captureSessionQueue.async {
            do {
                try self.syncSetUpCaptureSessionInput()
                try self.syncSetUpCaptureSessionOutput()
                
                self.captureSession.startRunning()
            } catch {
                self.feedStarted = false

                completionHandler?(.failure(error))
                return
            }
                
            completionHandler?(.success(true))
        }
    }
    
    func stopFeed() {
        feedStarted = false
        frameHandler = nil
    }
    
    // MARK: - Implementations
    
    // MARK: Video Capture Input
    
    private func syncSetUpCaptureSessionInput() throws {
        guard let deviceInput
                = approvedDeviceInput(for: Constant.cameraPosition) else {
            throw SetupError.noCaptureDeviceFound
        }
                
        captureSession.beginConfiguration()
        
        captureSession.sessionPreset = Constant.sessionPreset
        
        syncRemoveCaptureSessionInput()

        captureSession.addInput(deviceInput)
        captureSession.commitConfiguration()
        
        let device = deviceInput.device
        try device.lockForConfiguration()
        device.isSubjectAreaChangeMonitoringEnabled = true
        device.unlockForConfiguration()
    }
    
    private func approvedDeviceInput(for position: AVCaptureDevice.Position)
    -> AVCaptureDeviceInput? {
        let discoverySession = AVCaptureDevice.DiscoverySession(
            deviceTypes: [.builtInWideAngleCamera],
            mediaType: .video,
            position: .unspecified
        )

        return discoverySession.devices.lazy.compactMap {
            device -> AVCaptureDeviceInput? in
            guard device.position == position else {
                return nil
            }
            
            return self.approvedCaptureInput(from: device)
        }.first
    }
    
    private func approvedCaptureInput(from device: AVCaptureDevice)
    -> AVCaptureDeviceInput? {
        let deviceInput: AVCaptureDeviceInput
        do {
            deviceInput = try AVCaptureDeviceInput(device: device)
        } catch {
            NSLog("WARNING: CameraManager: captureInput(_): device: \(device.debugDescription): \(error)")
            return nil
        }
        
        if captureSession.canAddInput(deviceInput) {
            return deviceInput
        } else {
            return nil
        }
    }
    
    private func syncRemoveCaptureSessionInput() {
        captureSession.inputs.forEach(captureSession.removeInput)
    }
    
    // MARK: Video Capture Output
    
    private func syncSetUpCaptureSessionOutput() throws  {
        captureSession.beginConfiguration()
        
        let captureOutput = initCaptureOutput()
        
        guard captureSession.canAddOutput(captureOutput) else {
            throw SetupError.cannotAttachCaptureOutput(captureOutput)
        }
        
        captureSession.addOutput(captureOutput)
        captureSession.commitConfiguration()
    }
    
    private func initCaptureOutput() -> AVCaptureOutput {
        let captureOutput = AVCaptureVideoDataOutput()
        captureOutput.videoSettings = Constant.videoSettings
        captureOutput.alwaysDiscardsLateVideoFrames = true
        captureOutput.setSampleBufferDelegate(self, queue: captureOutputQueue)
        return captureOutput
    }
    
    private func syncRemoveCaptureSessionOutput() {
        captureSession.outputs.forEach(captureSession.removeOutput)
    }
}

// MARK: - AVCaptureVideoDataOutputSampleBufferDelegate

extension CameraImageSource: AVCaptureVideoDataOutputSampleBufferDelegate {
    
    public func captureOutput(
        _ output: AVCaptureOutput,
        didOutput sampleBuffer: CMSampleBuffer,
        from connection: AVCaptureConnection
    ) {
        handleAsync(sampleBuffer)
    }
    
    private func handleAsync(_ sampleBuffer: CMSampleBuffer) {
        frameHandlerQueue.async {
            self.handle(sampleBuffer)
        }
    }
        
    private func handle(_ sampleBuffer: CMSampleBuffer) {
        frameHandler?(.success(sampleBuffer))
    }
    
}
