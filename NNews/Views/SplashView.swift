import SwiftUI

struct SplashView: View {
    @State var isActive : Bool = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
            if isActive {
                ContentView()
            }
            else {
                VStack{
                    VStack{
                        Image("splash")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 150, height: 150)
                        Text("NNEWS")
                            .font(Font.custom("Baskerville-Bold", size: 30))
                            .foregroundColor(.red.opacity(0.80))
                    }
                    .scaleEffect(size)
                    .opacity(opacity)
                    .onAppear {
                        withAnimation(.easeIn(duration: 1.5)){
                            self.size = 0.9
                            self.opacity = 1.00
                        }
                    }
                }
                .onAppear{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3.0){
                        withAnimation{
                            self.isActive = true
                        }
                    }
                }
            }
    }
}
struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
