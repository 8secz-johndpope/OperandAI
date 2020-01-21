//
//  OperandChat.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-12-02.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import CoreData
import os
import Speech
import SnapKit
import UIKit

/// Operand chat view
class OperandChatVC: UICollectionViewController, UICollectionViewDelegateFlowLayout, NSFetchedResultsControllerDelegate, UITextFieldDelegate, SFSpeechRecognizerDelegate {
    
    // MARK: Variables
    
    // Logger
    let app = OSLog(subsystem: "group.nameless.financials", category: "Operand Chat")
    
    // Scroll count used to not scroll to bottom every time user selects Operand Chat
    static var scrollCount: UInt8 = 0
    
    // Speech recognizer
    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))!
    
    // Speech recognition request
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    
    // Speech recognition task
    private var recognitionTask: SFSpeechRecognitionTask?
    
    // Speech audio engine
    private let audioEngine = AVAudioEngine()
    
    // Keey track of recording state
    private var isRecording: Bool = false {
        didSet {
            inputTextFieldEdited()
        }
    }
    
    // Keep track of recording availability state
    private var recordingAvailable: Bool = false {
        didSet {
            inputTextFieldEdited()
        }
    }
    
    // Used to populate the UICollectionView easier
    lazy var fetchedResultsController: NSFetchedResultsController<Message> = {
        // Fetch Messages from CoreData
        let fetchRequest = NSFetchRequest<Message>(entityName: "Message")
        // Sort the items by date
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "date", ascending: true)]
        let delegate = UIApplication.shared.delegate as! AppDelegate
        let context = delegate.persistentContainer.viewContext
        // Get our controller to get items for OperandChat
        let frc = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        frc.delegate = self
        return frc
    }()
    
    // Used to help load multiple messages is needed
    var blockOperations = [BlockOperation]()
    
    // The container for the textfield and send button
    let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let voiceStartBtn: VoiceSendButton = {
        let button = VoiceSendButton()
        button.setImage(UIImage(systemName: "waveform.circle.fill"), for: .normal)
        button.isUserInteractionEnabled = true
        button.accessibilityIdentifier = "Voice input"
        button.tintColor = .tertiaryLabel
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let voiceEndBtn: VoiceEndButton = {
        let button = VoiceEndButton()
        button.setImage(UIImage(systemName: "pause.circle.fill"), for: .normal)
        button.isUserInteractionEnabled = true
        button.accessibilityIdentifier = "Voice input"
        button.tintColor = .red
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    let textSndBtn: TextSendButton = {
        let button = TextSendButton()
        button.setImage(UIImage(systemName: "arrow.up.circle.fill"), for: .normal)
        button.isUserInteractionEnabled = true
        button.accessibilityIdentifier = "Send text message to Operand"
        button.tintColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 0.98)
        button.contentVerticalAlignment = .fill
        button.contentHorizontalAlignment = .fill
        return button
    }()
    
    // Input text field with dynamic text size
    let inputTextField: UITextField = {
        let textfield = UITextField()
        let customFont = interLightBeta(size: 16)
        textfield.font = UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)
        textfield.placeholder = "Enter message..."
        return textfield
    }()
    
    // Bottom contraint to move messageInputContainerView up and down with keyboard
    var bottomConstraint: NSLayoutConstraint = NSLayoutConstraint()
    
    // MARK: View Loading
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        os_log(.info, log: self.app, "View did load")
        
        // Allows a tap outside textfields to hide the keyboard
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)
        
        // Setup view's components
        setupInputComponents()
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        // Set navigation bar
        self.title = "Operand"
        self.navigationController?.navigationBar.backgroundColor = .secondarySystemBackground
        self.navigationController!.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name: "Inter-Regular", size: 20)!]
        
        // Load data
        do {
            try fetchedResultsController.performFetch()
        } catch let err {
            os_log(.fault, log: self.app, "Error loading chat data: %s", err.localizedDescription)
        }
        
        // Setting collection view
        collectionView.delegate   = self
        collectionView.dataSource = self
        collectionView?.backgroundColor = .systemBackground
        collectionView?.register(ChatLogMessageCell.self, forCellWithReuseIdentifier: "cellId")
        collectionView?.alwaysBounceVertical = true
        
        // Adding keyboard targets
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        // Asynchronously make the authorization request.
        speechRecognizer.delegate = self
        SFSpeechRecognizer.requestAuthorization { authStatus in
            
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    self.recordingAvailable = true
                case .denied:
                    self.recordingAvailable = false
                case .restricted:
                    self.recordingAvailable = false
                case .notDetermined:
                    self.recordingAvailable = false
                default:
                    self.recordingAvailable = false
                }
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        os_log(.info, log: self.app, "Ready to be presented")
        
        // Generate haptic feedback when Operand Chat is presented
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
        
    }
    
    override func  viewDidAppear(_ animated: Bool) {
        
        // Only scroll to bottom the first time the view is loaded
        // Note: you can still scroll to bottom by tapping textfield
        if OperandChatVC.scrollCount == 0 {
            os_log(.info, log: self.app, "View did appear, scrolling collection view to last message")
            self.scrollToBottom(animated: false)
            OperandChatVC.scrollCount += 1
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        // Ensure tab bar is not hidden when dismissing view
        tabBarController?.tabBar.isHidden = false
    }
    
    /// Remove move view up when keyboard appears logic
    deinit {
        os_log(.info, log: self.app, "Keyboard observers deinitialized")
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: Collection View
    
    /// If a message is selected the keyboard should retract
    override func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        inputTextField.resignFirstResponder()
    }
    
    /// Load the view controller with the number of saved messaged in CoreData
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let count = fetchedResultsController.sections?[0].numberOfObjects {
            os_log(.info, log: self.app, "%d messages loaded into view", count)
            return count
        }
        os_log(.error, log: self.app, "Messages not loaded into view")
        return 0
    }
    
    /// Load the contents of each cell
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! ChatLogMessageCell
        let message = fetchedResultsController.object(at: indexPath)
        
        if let messageText = message.text {
            
            cell.messageTextView.text = messageText
            
            // Find the estimated size of the cell to adapt the view's height and
            // width depending on message content
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let customFont = interLightBeta(size: 16)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)], context: nil)
            
            // If message is sender, it will be on the right and in blue
            // otherwise it will show gray, with a profile image, and on the left
            if message.isSender {
                // Set size of bubble and its contained string
                cell.messageTextView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 32, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 18)
                cell.textBubbleView.frame = CGRect(x: view.frame.width - estimatedFrame.width - 40, y: 0, width: estimatedFrame.width + 24, height: estimatedFrame.height + 18)
                
                // Set colours and profileImageView
                cell.textBubbleView.backgroundColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 0.98)
                cell.messageTextView.textColor = .white
                cell.profileImageView.isHidden = true
            } else {
                // Set size of bubble and its contained string
                cell.messageTextView.frame = CGRect(x: 46 + 8, y: 0, width: estimatedFrame.width + 16, height: estimatedFrame.height + 18)
                cell.textBubbleView.frame = CGRect(x: 46, y: 0, width: estimatedFrame.width + 24, height: estimatedFrame.height + 18)
                
                // Set profile image only if it is a server response
                cell.profileImageView.image = UIImage(systemName: "o.circle")
                cell.profileImageView.tintColor = .label
                cell.profileImageView.frame = CGRect(x: 5, y: estimatedFrame.height - 10, width: 30, height: 30)
                
                // Set colours and profileImageView
                cell.textBubbleView.backgroundColor = .tertiarySystemGroupedBackground
                cell.messageTextView.textColor = .label
                cell.profileImageView.isHidden = false
            }
        } else {
            os_log(.error, log: self.app, "Error unwrapping message text, returning a default cell at index %d", indexPath.row)
        }
        
        return cell
    }
    
    /// Return the size of the collection view itself, this is what will adjust the spacing between two messages
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let message = fetchedResultsController.object(at: indexPath)
        
        if let messageText = message.text {
            let size = CGSize(width: 250, height: 1000)
            let options = NSStringDrawingOptions.usesFontLeading.union(.usesLineFragmentOrigin)
            let customFont = interLightBeta(size: 16)
            let estimatedFrame = NSString(string: messageText).boundingRect(with: size, options: options, attributes: [NSAttributedString.Key.font: UIFontMetrics(forTextStyle: .headline).scaledFont(for: customFont)], context: nil)
            return CGSize(width: view.frame.width, height: estimatedFrame.height + 18)
        }
        
        os_log(.error, log: self.app, "Error unwrapping message text, returning a default cell size")
        return CGSize(width: view.frame.width, height: 200)
    }
    
    /// Move the very first message down from the navigation bar
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 0, right: 0)
    }
    
    // MARK: Fetch Results Controller
    
    /// If the results controller has changed (message added to  CoreData), add that new content to the view
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        if type == .insert {
            
            // If multiple messages were added, load them one by one
            blockOperations.append(BlockOperation(block: {
                self.collectionView.insertItems(at: [newIndexPath!])
            }))
        }
    }
    
    /// We need to adjust where we sit in the collection view if a new message comes in
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        // Load all the messages using BlockOperations
        collectionView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }) { (completed) in
            // Once complete, scroll to bottom of view
            self.scrollToBottom()
        }
    }
    
    // MARK: Action Functions
    
    /// If the return button on the keyboard is pressed, dismiss the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        os_log(.error, log: self.app, "Return button on keyboard pressed")
        return false
    }
    
    /// This is the only way to send a message
    @objc func sendButtonPressed() {
        
        os_log(.info, log: self.app, "Send button pressed")
        
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()
        
        guard let messageText = inputTextField.text, !messageText.isEmpty else {
            os_log(.info, log: self.app, "Text field is empty, returning")
            return
        }
        
        // Add message to CoreData
        addMessage(text: messageText, sender: true)
        
        // Reset the text message input field once
        // we add the message to CoreData
        inputTextField.text = nil
        inputTextField.text = ""
        
        // TO-DO: SERVER CALL HERE
    }
    
    /// Move keyboard up when needed
    @objc func keyboardWillShow(notification: NSNotification) {
        
        os_log(.info, log: self.app, "View moved to accomodate keyboard")
        
        // If keyboard is about to appear, hide the tab bar
        tabBarController?.tabBar.isHidden = true
        
        // Change the location of the messageInputContainerView to above the keyboard
        guard let userInfo = notification.userInfo else {return}
        guard let keyboardSize = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect else {return}
        view.removeConstraint(bottomConstraint)
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: -keyboardSize.height)
        view.addConstraint(bottomConstraint)
        
        // Change size of send button and animate changes
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
            self.scrollToBottom(animated: false)
        }, completion: nil)
    }
    
    /// Bring keyboard back to normal position
    @objc func keyboardWillHide(notification: NSNotification) {
        os_log(.info, log: self.app, "View reset while keyboard retracts")
        
        // If keyboard is about to disappear, show the tab bar
        tabBarController?.tabBar.isHidden = false
        
        // Change the location of the messageInputContainerView to above the tab bar
        view.removeConstraint(bottomConstraint)
        bottomConstraint = NSLayoutConstraint(item: messageInputContainerView, attribute: .bottom, relatedBy: .equal, toItem: view.safeAreaLayoutGuide, attribute: .bottom, multiplier: 1, constant: 0)
        view.addConstraint(bottomConstraint)
        
        // Change size of send button and animate changes
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    @objc func recordButtonTapped() {
        
        // If we are already recording end audio recording
        if audioEngine.isRunning {
            
            // Disable the voice button to prevent a crash
            // and stop the audio engine
            self.voiceEndBtn.isEnabled = false
            audioEngine.stop()
            
            // End processing the audio request
            DispatchQueue.global().sync { [weak self] in
                
                guard let strongSelf = self else {return}
                strongSelf.recognitionRequest?.endAudio()
            }
            
            os_log(.info, log: self.app, "Ended audio recording")
            return
            
        } else {
            
            // Give haptic feedback for when the audio recording starts
            let generator = UIImpactFeedbackGenerator(style: .soft)
            generator.impactOccurred()
            
            // Start the recording
            do {
                try startRecording()
                self.isRecording = true
                os_log(.info, log: self.app, "Starting voice recording for text field")
            } catch {
                os_log(.fault, log: self.app, "Recording Not Available")
            }
        }
        
    }
    
    // MARK: Helper Functions
    
    /// Find the last element in the CoreData messages and scroll to that element
    private func scrollToBottom(animated: Bool = true) {
        
        let lastItem = fetchedResultsController.sections![0].numberOfObjects - 1
        let indexPath = IndexPath(item: lastItem, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: animated)
    }
    
    /// Setup initial view
    private func setupInputComponents() {
        
        // Set the message container to the bottom of the view
        self.view.addSubview(messageInputContainerView)
        messageInputContainerView.snp.makeConstraints { (make) in
            make.centerX.equalTo(self.view)
            make.width.equalTo(self.view.safeAreaLayoutGuide.snp.width)
            make.height.equalTo(48)
        }
        
        // Send button will be a wide bar
        messageInputContainerView.addSubview(voiceStartBtn)
        voiceStartBtn.snp.makeConstraints { (make) in
            make.right.equalTo(messageInputContainerView.snp.right).offset(-8)
            make.width.equalTo(34)
            make.height.equalTo(34)
            make.centerY.equalTo(messageInputContainerView.snp.centerY)
            
        }
        voiceStartBtn.addTarget(self, action: #selector(self.recordButtonTapped), for: .touchUpInside)
        
        messageInputContainerView.addSubview(voiceEndBtn)
        voiceEndBtn.isHidden = true
        voiceEndBtn.snp.makeConstraints { (make) in
            make.right.equalTo(messageInputContainerView.snp.right).offset(-8)
            make.width.equalTo(34)
            make.height.equalTo(34)
            make.centerY.equalTo(messageInputContainerView.snp.centerY)
            
        }
        voiceEndBtn.addTarget(self, action: #selector(self.recordButtonTapped), for: .touchUpInside)
        
        // Send button will be a wide bar
        messageInputContainerView.addSubview(textSndBtn)
        textSndBtn.isHidden = true
        textSndBtn.snp.makeConstraints { (make) in
            make.right.equalTo(messageInputContainerView.snp.right).offset(-8)
            make.width.equalTo(34)
            make.height.equalTo(34)
            make.centerY.equalTo(messageInputContainerView.snp.centerY)
            
        }
        textSndBtn.addTarget(self, action: #selector(self.sendButtonPressed), for: .touchUpInside)
        
        // Set textfield
        messageInputContainerView.addSubview(inputTextField)
        inputTextField.delegate = self
        inputTextField.backgroundColor = .systemBackground
        inputTextField.snp.makeConstraints { (make) in
            make.bottom.equalTo(messageInputContainerView.snp.bottom)
            make.left.equalTo(messageInputContainerView.snp.left).offset(8)
            make.right.equalTo(voiceStartBtn.snp.left).offset(-8)
            make.height.equalTo(messageInputContainerView.snp.height)
        }
        inputTextField.addTarget(self, action: #selector(self.inputTextFieldEdited), for: .allEditingEvents)
        
        // Horizontal line on top of the textfield
        let topBorderView = UIView()
        topBorderView.backgroundColor = .systemGray3
        messageInputContainerView.addSubview(topBorderView)
        topBorderView.snp.makeConstraints { (make) in
            make.height.equalTo(0.5)
            make.bottom.equalTo(messageInputContainerView.snp.top)
            make.width.equalTo(messageInputContainerView.snp.width)
        }
        
        // Adjust collectionView to be not hide the messageInputContainerView
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.snp.makeConstraints { (make) in
            make.bottom.equalTo(topBorderView.snp.top).offset(-8)
            make.top.equalTo(self.view.safeAreaLayoutGuide.snp.top)
            make.leading.equalTo(self.view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(self.view.safeAreaLayoutGuide.snp.trailing)
        }
        
        // Set background color
        self.view.backgroundColor = .systemBackground
    }
    
    @objc func inputTextFieldEdited() {
        if !recordingAvailable {
            textSndBtn.isHidden = false
            voiceStartBtn.isHidden = true
            voiceEndBtn.isHidden = true
        }
        else if isRecording {
            // Show stop recording button
            textSndBtn.isHidden = true
            voiceStartBtn.isHidden = true
            voiceEndBtn.isHidden = false
        } else if inputTextField.hasText {
            // Show send button
            textSndBtn.isHidden = false
            voiceStartBtn.isHidden = true
            voiceEndBtn.isHidden = true
        } else {
            // Show record button
            voiceStartBtn.isHidden = false
            textSndBtn.isHidden = true
            voiceEndBtn.isHidden = true
            
        }
    }
    
    // MARK: Core Data
    
    /// Add a message to CoreData
    /// - Parameter text: String of text to be added
    /// - Parameter sender: Boolean, true if it is the user, false if server
    /// - Parameter service: [Optional] Service associated with the message
    /// - Todo: Use the service string as we add services to Operand
    private func addMessage(text: String, sender: Bool, service: String = "FINANCIALS") {
        
        // Get AppDelegate delegate to access CoreData
        let delegate = UIApplication.shared.delegate as? AppDelegate
        if let context = delegate?.persistentContainer.viewContext {
            
            if sender {
                let message = createMessageWithText(text: text, minutesAgo: 0, context: context, isSender: sender)
                os_log(.info, log: self.app, "Message added: %s", message.text ?? "<empty>")
            } else {
                let message = createMessageWithText(text: text, minutesAgo: 0, context: context, service: service)
                os_log(.info, log: self.app, "Server message added: %s", message.text ?? "<empty>")
            }
            
            
            do {
                // Try to save the new message
                try(context.save())
            } catch let err {
                os_log(.fault, log: self.app, "Error adding chat message: %s", err.localizedDescription)
            }
        } else {
            os_log(.error, log: self.app, "Error getting AppDelegate")
        }
        
        inputTextFieldEdited()
    }
    
    /// Create a new message for user or server response
    /// - Parameter text: String of text to be added
    /// - Parameter minutesAgo: Time the message was sent relative to this instance
    /// - Parameter context: AppDelegate persistentContainer instance
    /// - Parameter isSender: [Optional] Defaults to server response
    /// - Parameter service: [Optional] String of service being used, defaults to FINANCIALS
    /// - Returns: NSManaged Message object
    private func createMessageWithText(text: String, minutesAgo: Double, context: NSManagedObjectContext, isSender: Bool = false, service: String = "USER") -> Message {
        let message = NSEntityDescription.insertNewObject(forEntityName: "Message", into: context) as! Message
        message.text = text
        message.date = NSDate().addingTimeInterval(-minutesAgo * 60) as Date
        message.isSender = isSender
        message.service = service
        return message
    }
    
    /// Clear all messages from CoreData
    static private func clearData() {
        
        let delegate = UIApplication.shared.delegate as? AppDelegate
        let app = OSLog(subsystem: "group.nameless.financials", category: "Operand Chat Core Data")
        os_log(.info, log: app, "Attempting to delete all messages in CoreData")
        
        if let context = delegate?.persistentContainer.viewContext {
            
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Message")
            do {
                let tmpMessages = try context.fetch(fetchRequest)
                for message in tmpMessages {
                    context.delete(message)
                }
                try(context.save())
            } catch let err {
                os_log(.fault, log: app, "Error clearing all chat data: %s", err.localizedDescription)
            }
        }
        
    }
    
    // MARK: SFSpeechRecognizerDelegate
    
    private func startRecording() throws {
        
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode
        
        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                // Update the text view with the results.
                self.inputTextField.text = result.bestTranscription.formattedString
                isFinal = result.isFinal
                os_log(.debug, log: self.app, "Text %s", result.bestTranscription.formattedString)
            }
            
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                // Setting view up, for audio engine to be stopped
                os_log(.debug, log: self.app, "Audio engine being stopped")
                self.voiceEndBtn.isEnabled = false
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                
                self.recognitionRequest = nil
                self.recognitionTask = nil
                
                // Audio recording done, and we can renable the stop recording button
                os_log(.debug, log: self.app, "Voice processing ended")
                self.voiceEndBtn.isEnabled = true
                self.isRecording = false
                
                // Give haptic feedback for when the recording stops
                let generator = UIImpactFeedbackGenerator(style: .soft)
                generator.impactOccurred()
            }
        }
        
        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        
        audioEngine.prepare()
        try audioEngine.start()
        
    }
    
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            os_log(.info, log: app, "Speech recognizer available")
            self.recordingAvailable = true
        } else {
            self.recordingAvailable = false
            os_log(.info, log: app, "Speech recognition not available")
        }
    }
    
}
