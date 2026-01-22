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
        let otp = String(enteredOTP)
        checkOTP(email: user, isMobile: isMobile, otp: otp)
    }

    // MARK: - On Verification Success
    func onVerified(studentData: StudentData) {
        print(studentData.fullName)
        print(studentData.enrollmentId)
        print(studentData.userEmail)
        
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
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.batchId, forKey: "batchId")
        UserDefaults.standard.set(studentData.batchName, forKey: "batchName")
        UserDefaults.standard.set(studentData.referred_by, forKey: "referred_by")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.wallet, forKey: "wallet")
        UserDefaults.standard.set(studentData.adminId, forKey: "adminId")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        UserDefaults.standard.set(studentData.transactionId, forKey: "transactionId")
        UserDefaults.standard.set(studentData.amount, forKey: "amount")
        UserDefaults.standard.set(isMobile, forKey: "isMobile")
        
        if(studentData.fullName == "" && studentData.enrollmentId == "" && studentData.userEmail == "" ) {
            path.append(Route.RegistrationView)
        }
        if(studentData.fullName != "" && studentData.enrollmentId != "" && studentData.userEmail != "" ) {
            path.append(Route.SelectGoalView)
        }
        // Navigate to next screen
        
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
    
    func checkOTP(email: String, isMobile: Bool, otp: String) {
        isVerifying = true
        showError = false

        let token = UserDefaults.standard.string(forKey: "FCMToken") ?? ""
        let deviceName = UIDevice.current.name
        let osVersion = UIDevice.current.systemVersion
        let appVersion = "55"
        let versionCode = "55"
        
        // Try without country_code first, or use the actual phone country code
        let countryCode = "+1"  // Or whatever your actual country code is
        let deviceId = UIDevice.current.identifierForVendor?.uuidString ?? ""

        var components = URLComponents(
            string: "https://marinewisdom.com/api/MobileApi/checkOTP"
        )

        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: email),
            //(name: "country_code", value: countryCode),
            URLQueryItem(name: "device_name", value: deviceName),
            URLQueryItem(name: "device_id", value: deviceId),
            URLQueryItem(name: "app_version", value: appVersion),
            URLQueryItem(name: "device_os_version", value: osVersion),
            URLQueryItem(name: "isFromMobile", value: isMobile ? "1" : "0"),
            URLQueryItem(name: "otp", value: otp),
            URLQueryItem(name: "versionCode", value: versionCode),
            URLQueryItem(name: "token", value: token)
        ]

        guard let url = components?.url else {
            isVerifying = false
            showError = true
            errorMessage = "Invalid URL"
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // 🔍 DETAILED LOGGING
        //print("=" + 50)
        print("🔑 OTP VERIFICATION REQUEST")
       // print("=" + 50)
        print("📧 Email/Mobile:", email)
        print("🔢 OTP Entered:", otp)
        print("📱 Is Mobile:", isMobile)
        print("🌍 Country Code:", countryCode)
        print("🔗 Full URL:", url.absoluteString)
        //print("=" + 50)

        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isVerifying = false
            }

            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                    self.clearOTPFields()
                }
                return
            }

            guard let data = data else {
                print("❌ No data received")
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "No response from server"
                    self.clearOTPFields()
                }
                return
            }

            // 🔍 PRINT FULL RESPONSE
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)
                //print("=" * 50)
            }

            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                print("✅ Decoded Response:")
                print("   Status:", response.status)
                print("   Message:", response.msg)
                
                DispatchQueue.main.async {
                    if response.status == "1"
                        || response.status.lowercased() == "true"
                        || response.status.lowercased() == "success",
                       let studentData = response.studentData {
                        
                        print("✅ OTP VERIFIED SUCCESSFULLY")
                        self.onVerified(studentData: studentData)

                    } else {
                        print("❌ OTP VERIFICATION FAILED")
                        print("   Server Message:", response.msg)
                        self.showError = true
                        self.errorMessage = response.msg.isEmpty
                            ? uiString.OTPInvalidError
                            : response.msg
                        self.clearOTPFields()
                    }
                }

            } catch {
                print("❌ JSON Decode Error:", error)
                DispatchQueue.main.async {
                    self.showError = true
                    self.errorMessage = "Invalid server response"
                    self.clearOTPFields()
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
