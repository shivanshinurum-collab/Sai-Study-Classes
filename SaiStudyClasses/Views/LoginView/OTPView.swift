import SwiftUI

struct OTPView: View {
    @Binding var path: NavigationPath
    
    @State private var otp: [String] = Array(repeating: "", count: 4)
    @FocusState private var focusedIndex: Int?
    
    @State private var timeRemaining = 14
    @State private var timerActive = true
    @State private var timer: Timer?
    
    @State private var showError = false
    @State private var errorMessage = ""
    @State private var isVerifying = false
    
    let user: String
    let isMobile: Bool
    
    var body: some View {
        VStack(spacing: 24) {
            
            // Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                }
                Spacer()
            }
            .padding(.horizontal)
            
            Text(uiString.OTPTitile)
                .font(.headline)
            
            Image("OTPIcon")
                .resizable()
                .scaledToFit()
                .frame(width: 90, height: 90)
            
            Text(uiString.OTPSubTitle)
                .foregroundColor(.gray)
            
            Text(user)
                .bold()
            
            // OTP Input Fields
            HStack(spacing: 14) {
                ForEach(0..<4, id: \.self) { index in
                    TextField("", text: $otp[index])
                        .keyboardType(.numberPad)
                        .multilineTextAlignment(.center)
                        .frame(width: 55, height: 55)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(
                                    showError
                                    ? .red
                                    : (focusedIndex == index ? .blue : Color.gray.opacity(0.3)),
                                    lineWidth: 2
                                )
                        )
                        .focused($focusedIndex, equals: index)
                        .disabled(isVerifying)
                        .onChange(of: otp[index]) { _, newValue in
                            
                            // Allow only digits
                            otp[index] = newValue.filter { $0.isNumber }
                            
                            // Keep only 1 digit
                            if otp[index].count > 1 {
                                otp[index] = String(otp[index].last!)
                            }
                            
                            showError = false
                            
                            // Move focus forward
                            if !otp[index].isEmpty {
                                if index < 3 {
                                    focusedIndex = index + 1
                                } else {
                                    focusedIndex = nil
                                    autoVerifyOTP()
                                }
                            }
                        }
                }
            }
            
            // Error Message
            if showError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            // Loading Indicator
            if isVerifying {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
            
            // Resend Timer
            HStack {
                Spacer()
                if timerActive {
                    Text("\(uiString.OTPResendCodeIn) \(timeRemaining)")
                        .foregroundColor(.gray)
                        .font(.subheadline)
                } else {
                    Button(uiString.OTPResend) {
                        resendOTP()
                    }
                    .foregroundColor(.blue)
                    .bold()
                    .disabled(isVerifying)
                }
            }
            .padding(.trailing, 25)
            
            Spacer()
        }
        .onAppear {
            startTimer()
            focusedIndex = 0
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Auto Verify OTP
    func autoVerifyOTP() {
        let enteredOTP = otp.joined()
        
        guard enteredOTP.count == 4 else { return }
        guard !isVerifying else { return }
        
        // Call the API to verify OTP
        checkOTP(email: user, isMobile: isMobile, otp: enteredOTP)
    }

    // MARK: - On Verification Success
    func onVerified(studentData: StudentData) {
        // Store user login status
        UserDefaults.standard.set(user, forKey: "user")
        UserDefaults.standard.set(true, forKey: "isLoggedIn")
        
        // Store student data
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set(studentData.batchId, forKey: "batchId")
        UserDefaults.standard.set(studentData.batchName, forKey: "batchName")
        UserDefaults.standard.set(studentData.wallet, forKey: "wallet")
        UserDefaults.standard.set(studentData.adminId, forKey: "adminId")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        
        // Navigate to next screen
        path.append(Route.SelectGoalView)
    }
    
    // MARK: - Timer Functions
    func startTimer() {
        timeRemaining = 14
        timerActive = true
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                timerActive = false
                timer?.invalidate()
            }
        }
    }
    
    // MARK: - Resend OTP
    func resendOTP() {
        otp = Array(repeating: "", count: 4)
        showError = false
        focusedIndex = 0
        startTimer()
        
        GenerateOTP.sendOTP(email: user, isMobile: isMobile)
    }
    
    // MARK: - Check OTP API Call
    func checkOTP(email: String, isMobile: Bool, otp: String) {
        isVerifying = true
        showError = false
        
        let token = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let device_name = UIDevice.current.name
        let device_os_version = UIDevice.current.systemVersion
        let app_version = "55"
        let versionCode = "55"
        
        var components = URLComponents(
            string: "https://app2.lmh-ai.in/api/MobileApi/checkOTP"
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            URLQueryItem(name: "isFromMobile", value: isMobile ? "1" : "0"),
            URLQueryItem(name: "device_name", value: device_name),
            URLQueryItem(name: "app_version", value: app_version),
            URLQueryItem(name: "device_os_version", value: device_os_version),
            URLQueryItem(name: "token", value: token),
            URLQueryItem(name: "otp", value: otp),
            URLQueryItem(name: "versionCode", value: versionCode)
        ]
        
        guard let url = components?.url else {
            DispatchQueue.main.async {
                isVerifying = false
                showError = true
                errorMessage = "Invalid URL"
            }
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            DispatchQueue.main.async {
                isVerifying = false
            }
            
            if let error = error {
                print("Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    showError = true
                    errorMessage = "Network error. Please try again."
                    clearOTPFields()
                }
                return
            }
            
            guard let data = data else {
                print("No data received")
                DispatchQueue.main.async {
                    showError = true
                    errorMessage = "No response from server"
                    clearOTPFields()
                }
                return
            }
            
            // Print raw response for debugging
            if let jsonString = String(data: data, encoding: .utf8) {
                print("Raw Response:", jsonString)
            }
            
            // Decode the response using CheckOTP model
            do {
                let decoder = JSONDecoder()
                let checkOTPResponse = try decoder.decode(CheckOTP.self, from: data)
                
                print("Status:", checkOTPResponse.status)
                print("Message:", checkOTPResponse.msg)
                
                DispatchQueue.main.async {
                    if (checkOTPResponse.status.lowercased() == "success" ||
                        checkOTPResponse.status.lowercased() == "true" ||
                        checkOTPResponse.status == "1"),
                       let studentData = checkOTPResponse.studentData {
                        // OTP verification successful
                        print("Student Data:", studentData)
                        onVerified(studentData: studentData)
                    } else {
                        // OTP verification failed
                        showError = true
                        errorMessage = checkOTPResponse.msg.isEmpty ?
                            uiString.OTPInvalidError : checkOTPResponse.msg
                        clearOTPFields()
                    }
                }
                
            } catch {
                print("Decoding error:", error.localizedDescription)
                if let decodingError = error as? DecodingError {
                    switch decodingError {
                    case .keyNotFound(let key, let context):
                        print("Missing key:", key.stringValue, "Context:", context.debugDescription)
                    case .typeMismatch(let type, let context):
                        print("Type mismatch:", type, "Context:", context.debugDescription)
                    case .valueNotFound(let type, let context):
                        print("Value not found:", type, "Context:", context.debugDescription)
                    case .dataCorrupted(let context):
                        print("Data corrupted:", context.debugDescription)
                    @unknown default:
                        print("Unknown decoding error")
                    }
                }
                
                DispatchQueue.main.async {
                    showError = true
                    errorMessage = "Invalid response format"
                    clearOTPFields()
                }
            }
            
        }.resume()
    }
    
    // MARK: - Clear OTP Fields
    func clearOTPFields() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            otp = Array(repeating: "", count: 4)
            focusedIndex = 0
        }
    }
}
