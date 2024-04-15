//  CreateApplicationView.swift
//  LoveIsBlind
//
//  Created by Nyaradzo Bere on 3/12/24.
//
import Foundation
import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

struct CreateApplicationView: View {
    @EnvironmentObject var sessionStore: SessionStore
    @State private var showRecordBioView = false


    @State private var name: String = ""
    @State private var sex: String = ""
    @State private var genderIdentity: String = ""
    @State private var describeYourself: String = ""
    @State private var occupation: String = ""
    @State private var hobbies: String = ""
    @State private var whyAreYouSingle: String = ""
    @State private var roleModels: String = ""
    @State private var dealBreakers: String = ""
    @State private var inputImage: UIImage?
    @State private var showImagePicker: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    @State private var navigateToRecordBioView = false

    var body: some View {
        NavigationView {
            
            ScrollView {
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                Spacer()
                VStack(alignment: .leading, spacing: 20) {
                    
                    VStack(alignment: .leading) {
                        Text("Name")
                            .foregroundColor(Color(hex: "#F0F1F0"))
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                        TextField("", text: $name)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                
                    VStack(alignment: .leading) {
                        Text("Sex")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        
                        Picker("Select Sex", selection: $sex) {
                            Text("Select...").tag("")
                            Text("Male").tag("Male")
                            Text("Female").tag("Female")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: 50))

                    }
                    Spacer()
                        
                    VStack(alignment: .leading) {
                        Text("Gender Identity")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        Picker("Select Gender Identity", selection: $genderIdentity) {
                            Text("Select...").tag("")
                            Text("Man").tag("Man")
                            Text("Woman").tag("Woman")
                            Text("Non-binary").tag("Non-binary")
                        }
                        .pickerStyle(MenuPickerStyle())
                        .font(.system(size: 50))
                    }
//                    }
//                    .padding()
//                    .background(Color(hex: "##33BFFE"))
//                    .opacity(0.6)
//                    .cornerRadius(8)
                    
                    VStack(alignment: .leading) {
                        Text("Describe yourself in 1 sentence")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $describeYourself)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Occupation")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $occupation)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("What are your hobbies?")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $hobbies)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Why do you think you're single?")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $whyAreYouSingle)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Who are your relationship role models?")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $roleModels)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
                    
                    VStack(alignment: .leading) {
                        Text("What are your relationship deal breakers?")
                            .font(.system(size: 30, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                        TextField("", text: $dealBreakers)
                            .padding()
                            .background(Color(hex: "#33BFFE"))
                            .opacity(0.6)
                            .cornerRadius(8)
                            .font(Font.system(size: 16, weight: .light, design: .default))
                            .foregroundColor(Color(hex: "#F0F1F0"))
                    }
 
                    if let image = inputImage {
                        Image(uiImage: image)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .cornerRadius(8)
                    } else {
                        Text("No profile picture selected")
                            .font(.system(size: 20, weight: .ultraLight, design: .default))
                            .foregroundColor(Color(hex: "#FFEDD0"))
                    }
                    
                    Button("Select Profile Picture") {
                        showImagePicker = true
                    }
                    .padding()
                    .font(.system(size: 20, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .offset(x: -15)
                    
                    Divider().overlay(.black)
                    
                    Button("Send Application", action: saveProfile)
                        .padding()
                        .font(.system(size: 35, weight: .ultraLight, design: .default))
                        .foregroundColor(.white)
                        .offset(x: -15)
                    
                    Button("Record my bio") {
                        print("Direct navigation button for RecordBioView tapped.")
                        self.navigateToRecordBioView = true
                    }
                    .font(.system(size: 35, weight: .ultraLight, design: .default))
                    .foregroundColor(.white)
                    .onChange(of: navigateToRecordBioView) { newValue in
                        print("navigateToRecordBioView changed to: \(newValue)")
                    }
                }
                .padding(.horizontal, 40)
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(image: $inputImage)
                }
                .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Submission Status"),
                        message: Text(alertMessage),
                        dismissButton: .default(Text("OK"), action: {
//                            print("Alert dismissed. Navigating to RecordBioView now.")
//                            self.navigateToRecordBioView = true
                        })
                    )
                }
                NavigationLink(destination: RecordBioView(), isActive: $navigateToRecordBioView) {
                    EmptyView()
                }
            }
            .background(
                Image("ApplicationBackground")
                    .resizable() // Make the image resizable
                    .aspectRatio(contentMode: .fill) // Fill the screen, potentially cropping the image
                    .edgesIgnoringSafeArea(.all)
            )
        }
    }
    
    func allFieldsValid() -> Bool {
        return !name.isEmpty && !sex.isEmpty && !genderIdentity.isEmpty && !describeYourself.isEmpty && inputImage != nil
    }
    
    func loadImage() {
        guard let _ = inputImage else { return }
        // Additional processing if required
    }
    
    func saveProfile() {
        print("saveProfile() called")
        
        if !allFieldsValid() {
            print("Validation failed.")
            alertMessage = "Please fill out all fields and select a profile picture before saving."
            showAlert = true
            return
        }

        guard let uid = Auth.auth().currentUser?.uid else {
            print("Cannot get UID.")
            return
        }
        print("UID is: \(uid)")
        
        guard let email = Auth.auth().currentUser?.email else {
            print("Cannot get email.")
            return
        }
        print("Email is: \(email)")
        
        guard let image = inputImage else {
            print("No image selected.")
            return
        }

        print("Starting to upload image.")
        uploadImage(image) { url, error in
            if let error = error {
                print("Error uploading profile picture: \(error.localizedDescription)")
                self.alertMessage = "Error uploading profile picture. Please try again."
                self.showAlert = true
                return
            }

            guard let profileImageURL = url else {
                print("Cannot get profile image URL.")
                self.alertMessage = "Error getting profile picture URL. Please try again."
                self.showAlert = true
                return
            }
            print("Profile image URL is: \(profileImageURL)")

            let db = Firestore.firestore()
            let docRef = db.collection("users").document(uid)

            let values: [String: Any] = [
                "email": email,
                "name": name,
                "sex": sex,
                "genderIdentity": genderIdentity,
                "describeYourself": describeYourself,
                "occupation": occupation,
                "hobbies": hobbies,
                "whyAreYouSingle": whyAreYouSingle,
                "roleModels": roleModels,
                "dealBreakers": dealBreakers,
                "profilePictureUrl": profileImageURL.absoluteString,
                "profileCompleted": true,
                "profileReviewed": false,
                "bioSubmitted": false
            ]

            print("Saving profile information to Firestore.")
             docRef.setData(values) { error in
                 if let error = error {
                     print("Firestore error: \(error.localizedDescription)")
                     self.alertMessage = "Error saving profile. Please try again."
                     self.showAlert = true
                 } else {
                     print("Profile successfully saved. Triggering navigation to RecordBioView.")
                     self.alertMessage = "Application sent!"
                     self.showAlert = true
                     // Ensure navigation is triggered after alert dismissal
                 }
            }
        }
    }

    func uploadImage(_ image: UIImage, completion: @escaping (_ url: URL?, _ error: Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil, NSError(domain: "FirebaseAuthError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to retrieve user ID"]))
            return
        }

        let storage = Storage.storage().reference().child("profilePictures").child("\(uid).jpg")
        guard let imageData = image.jpegData(compressionQuality: 0.75) else {
            completion(nil, NSError(domain: "ImageError", code: 2, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"]))
            return
        }

        storage.putData(imageData, metadata: nil) { _, error in
            if let error = error {
                print("Upload error: \(error.localizedDescription)")
                completion(nil, error)
                return
            }

            storage.downloadURL { url, error in
                if let error = error {
                    print("Download URL error: \(error.localizedDescription)")
                }
                completion(url, error)
            }
        }
    }
}

struct CreateApplicationView_Previews: PreviewProvider {
    static var previews: some View {
        CreateApplicationView().environmentObject(SessionStore())
    }
}

