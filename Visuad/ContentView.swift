//
//  ContentView.swift
//  Visuad
//
//  Created by Nana Aba Turkson on 4/1/21.
//

import SwiftUI
import Firebase
import GoogleSignIn

@main
struct Visuad: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene{
        WindowGroup{
            ContentView()
        }
    }
    
}

class AppDelegate: NSObject, UIApplicationDelegate, GIDSignInDelegate{
    
    func application(_application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        
        FirebaseApp.configure()
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        return true
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
   
      if let error = error {
        print(error.localizedDescription)
        return
      }

      guard let authentication = user.authentication else { return }
      let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                        accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) {(res, err) in
            if err != nil{
                print((err?.localizedDescription)!)
                return
            }
            print(res!.user.email ?? "User instance is nil")
        }
    }

    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
      
    }
}


struct ContentView: View {
    var body: some View {
        
        ZStack{
            Color.black.ignoresSafeArea()
            
//            VStack{
//                Image("3")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 224.0, height: 330.0)
//                    .padding(.top, -590)
//                    .offset(x: -45, y: 10.0)
//                    //.scaleEffect(CGSize(width: 214, height: 315))
//                    //.clipShape(Rectangle())
//
//                 Image("3")
//                    .resizable()
//                    .scaledToFit()
//                    .frame(width: 224.0, height: 330.0)
//                    .padding(.top, -599)
//                    .offset(x: 47, y: /*@START_MENU_TOKEN@*/10.0/*@END_MENU_TOKEN@*/)
//
//            }
            
                
            
            
            VStack(alignment: .center, spacing: 18
                   , content:{
                    
                    Text("Let the world see you.")
                        //.font(.title)
                        .font(.system(size: 29))
                        //.font(.custom("Helvetica Neue", size: <#T##CGFloat#>))
                        //.font(.system(.largeTitle, design:.rounded))
                        .foregroundColor(.white)
                        .fontWeight(.black)
                        .frame(width: 360, height: 50)
                        .multilineTextAlignment(.center)
                        
                        .padding(.top, 10)
                        .offset(x: 0, y: -10)
                    
                    
                    Button(action: {
                        print("Loging In")
                    }, label: {
                        Text("Log In")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.white)
                            .font(.title)
                            .frame(width: 316.0, height: 52.0)
                            //.border(Color.white)
                            //.border(Color.white, width: 2.5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 50)
                                    .stroke(Color.white, lineWidth: 2)
                            )
                        
                        
                    })
                    
                    Button(action: {
                        print("Signing Up")
                    }, label: {
                        Text("Get Started")
                            .fontWeight(.bold)
                            .font(.system(size: 18))
                            .multilineTextAlignment(.center)
                            .padding()
                            .foregroundColor(.black)
                            .font(.title)
                            .frame(width: 316.0, height: 52.0)
                            //Color("Color")
                            //Color("Color-2")
                            //.background(Color.orange)
                            .background(LinearGradient(gradient: Gradient(colors:[Color("Color"), Color("Color-9"), Color("Color-10"),Color("Color-3")]),startPoint: .leading, endPoint: .trailing))
                            //.background(AngularGradient(gradient: Gradient(colors:[Color("Color-3"), Color("Color")]),center: .center, angle: .degrees(90)))
                            .shadow(color: .gray, radius: 20.0, x: 20, y: 10)
                            .cornerRadius(50)
                        
                    })
                    
                    
                   })
                
                .position(x: 215.0, y: 500)
        }
        
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        CreateUsername()
    }
}

struct GetStarted : View{
    
    @State var userName  = ""
    @State var password = ""
    @State var alert = false
    @State var message = ""
    @Binding var show : Bool
    var body: some View{
        
        VStack{
            Text("Sign Up").fontWeight(.heavy).font(.largeTitle).padding([.top, .bottom], 20)
            
            VStack(alignment: .leading){
                
                VStack(alignment: .leading){
                    Text("Username").font(.headline).fontWeight(.light)
                    HStack{
                        TextField("Enter your username", text:$userName)
                        
                        if userName != ""{
                        }
                    }
                }
                
                Divider()
                
                
            }.padding(.bottom, 15)
            
            
            VStack(alignment:.leading){
                Text("Password").font(.headline).fontWeight(.light).foregroundColor(Color.init(.label).opacity(0.75))
                
                SecureField("Enter Your Password", text: $password)
                
                Divider()
            }.padding(.horizontal, 6)
            
            
            Button(action: {
                signUpWithEmail(email: self.userName, password: self.password){(verified, status) in
                    
                    if !verified{
                        self.message = status
                        self.alert.toggle()
                    }
                    
                    else{
                        UserDefaults.standard.set(true, forKey: "status")
                        self.show.toggle()
                        NotificationCenter.default.post(name: NSNotification.Name("statusChange"), object: nil)
                    }
                }
            }){
                Text("Sign Up").foregroundColor(.white).frame(width: UIScreen.main.bounds.width - 120).padding()
            }.background(Color("Color"))
             .clipShape(Capsule())
            .padding(.top, 45)
            
                
        }.padding()
        .alert(isPresented: $alert)
        {
            Alert(title: Text("Error"), message: Text(self.message), dismissButton: .default(Text("OK")))
        }
    }
}

struct CreateUsername : View{
    
    var body: some View{
        
        Text("Create Username")
        
    }
    
}

struct GoogleSignView: UIViewRepresentable{
    
    func makeUIView(context: UIViewRepresentableContext<GoogleSignView>) -> GIDSignInButton {
        let button = GIDSignInButton()
        button.colorScheme = .dark
        GIDSignIn.sharedInstance()?.presentingViewController = UIApplication.shared.windows.last?.rootViewController
        return button
    }
    
    func updateUIView(_ uiView: GIDSignInButton, context: UIViewRepresentableContext<GoogleSignView>) {

    }
}


func signUpWithEmail(email: String, password: String, completion: @escaping(Bool, String) -> Void){
    
    Auth.auth().createUser(withEmail: email, password: password){(res, err) in
        if err != nil{
            
            completion(false, (err?.localizedDescription)!)
            return
        }
        
        completion(true, (res?.user.email)!)
    }
}
