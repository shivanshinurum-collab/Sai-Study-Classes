import SwiftUI

struct RegisterView: View {
    @Binding var path: NavigationPath
    
    @State private var name: String = ""
    @State private var number: String = ""
    @State private var referral: String = ""
    
    @State private var nameError: Bool = false
    @State private var numberError: Bool = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            
            // Back Button
            HStack {
                Button {
                    path.removeLast()
                } label: {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.black)
                        .font(.title3.bold())
                }
                Spacer()
            }
            
            Text("Please enter your details before \ncontinue")
                .font(.title3)
                .fontWeight(.bold)
            
            // MARK: - Fields
            VStack(spacing: 12) {
                
                // Name
                TextField("Enter Name", text: $name)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(nameError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                    .onChange(of: name) { _, _ in
                        nameError = false
                    }
                
                // Mobile Number
                HStack {
                    Image("flag")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                    
                    Text("+91")
                    
                    TextField("Mobile Number", text: $number)
                        .keyboardType(.numberPad)
                        .onChange(of: number) { _, newValue in
                            // Only digits + max 10
                            number = newValue.filter { $0.isNumber }
                            if number.count > 10 {
                                number = String(number.prefix(10))
                            }
                            numberError = false
                        }
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(numberError ? Color.red : uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                )
                
                // Referral (Optional)
                TextField("Referral Code (Optional)", text: $referral)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(uiColor.DarkGrayText.opacity(0.6), lineWidth: 1)
                    )
                
                // Error Message
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                }
            }
            
            Spacer()
            
            // MARK: - Continue Button
            Button {
                validate()
            } label: {
                Text("Continue")
                    .font(.title2.bold())
                    .frame(maxWidth: .infinity, minHeight: 50)
                    .foregroundColor(.white)
                    .background(uiColor.ButtonBlue)
                    .cornerRadius(25)
            }
            .padding(.bottom)
        }
        .padding(.horizontal, 22)
        .navigationBarBackButtonHidden(true)
    }
    
    // MARK: - Validation
    func validate() {
        let trimmedName = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let trimmedNumber = number.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedName.isEmpty {
            nameError = true
            errorMessage = "Please enter your name"
            return
        }
        
        if trimmedNumber.isEmpty {
            numberError = true
            errorMessage = "Please enter mobile number"
            return
        }
        
        if trimmedNumber.count != 10 {
            numberError = true
            errorMessage = "Please enter valid 10 digit mobile number"
            return
        }
        
        // All Valid
        errorMessage = ""
        nameError = false
        numberError = false
        
        // Navigate / API Call
        APICall(namee: trimmedName , numberr: trimmedNumber)
    }
    
    func APICall(namee : String , numberr : String){
        
        let token = UserDefaults.standard.string(forKey: "FCMToken")
        let app_version = "55"
        let student_id = UserDefaults.standard.string(forKey: "studentId")
        let isMobile = UserDefaults.standard.string(forKey: "isMobile")
        
        
        var components = URLComponents(
            string: "\(uiString.baseURL)api/MobileApi/updateStudentDetail"
        )
        
        components?.queryItems = [
            URLQueryItem(name: "mobile_email", value: numberr),
            URLQueryItem(name: "isFromMobile", value: (isMobile != nil) ? "1" : "0" ),
            //URLQueryItem(name: "refercode", value: referral),
            URLQueryItem(name: "name", value: namee),
            URLQueryItem(name: "student_id", value: student_id),
            URLQueryItem(name: "versionCode", value: app_version),
            URLQueryItem(name: "token" , value: token),
        ]
        
        guard let url = components?.url else { return}
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in

            if let error = error {
                print("❌ Network Error:", error.localizedDescription)
                return
            }

            guard let data = data else {
                print("❌ No data received")
                return
            }

            // 🔍 PRINT FULL RESPONSE
            if let rawResponse = String(data: data, encoding: .utf8) {
                print("📥 RAW SERVER RESPONSE:")
                print(rawResponse)
            }

            do {
                let response = try JSONDecoder().decode(CheckOTP.self, from: data)
                
                print("✅ Decoded Response:")
                print("   Status:", response.status)
                print("   Message:", response.msg)
                print(" Response     : ", response.studentData ?? "")
                
                DispatchQueue.main.async {
                    next(studentData: response.studentData!)
                }

            } catch {
                print("❌ JSON Decode Error:", error)
            }

        }.resume()
    }
    
    func next(studentData : StudentData){
        UserDefaults.standard.set(studentData.studentId, forKey: "studentId")
        UserDefaults.standard.set(studentData.userEmail, forKey: "userEmail")
        UserDefaults.standard.set(studentData.fullName, forKey: "fullName")
        UserDefaults.standard.set(studentData.enrollmentId, forKey: "enrollmentId")
        UserDefaults.standard.set(studentData.image, forKey: "image")
        UserDefaults.standard.set(studentData.country_code, forKey: "country_code")
        UserDefaults.standard.set(studentData.mobile, forKey: "mobile")
        UserDefaults.standard.set("55", forKey: "versionCode")
        UserDefaults.standard.set(studentData.affiliate_id, forKey: "affiliate_id")
        UserDefaults.standard.set(studentData.paymentType, forKey: "paymentType")
        UserDefaults.standard.set(studentData.admissionDate, forKey: "admissionDate")
        UserDefaults.standard.set(studentData.languageName, forKey: "languageName")
        
        path.append(Route.RegistrationLocationView)
    }
    
}

