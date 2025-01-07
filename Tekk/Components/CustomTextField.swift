struct CustomTextField: View {
    @StateObject private var globalSettings = GlobalSettings()
    
    let placeholder: String
    let icon: String
    @Binding var text: String
    var isSecure: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    // Instead of passing isTextVisible as a parameter, make it a @State property
    @State private var isTextVisible: Bool = false
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .foregroundColor(globalSettings.primaryYellowColor)
                .frame(width: 20)
            
            if isSecure {
                ZStack(alignment: .trailing) {
                    if isTextVisible {
                        TextField(placeholder, text: $text)
                            .font(.custom("Poppins-Regular", size: 16))
                            .autocapitalization(.none)
                            .keyboardType(keyboardType)
                    } else {
                        SecureField(placeholder, text: $text)
                            .font(.custom("Poppins-Regular", size: 16))
                            .autocapitalization(.none)
                            .keyboardType(keyboardType)
                    }
                    
                    Button(action: {
                        isTextVisible.toggle()
                    }) {
                        Image(systemName: isTextVisible ? "eye.slash.fill" : "eye.fill")
                            .foregroundColor(globalSettings.primaryYellowColor)
                    }
                    .padding(.trailing, 8)
                }
            } else {
                TextField(placeholder, text: $text)
                    .font(.custom("Poppins-Regular", size: 16))
                    .autocapitalization(.none)
                    .keyboardType(keyboardType)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.gray.opacity(0.1))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(globalSettings.primaryYellowColor.opacity(0.3), lineWidth: 1)
        )
    }
} 