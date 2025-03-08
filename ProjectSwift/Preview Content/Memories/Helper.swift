//
//  Helper.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import SwiftUI

//countdowloadmodel
class CountDowloadModel: ObservableObject {
    @Published var timerValue: String = "3"
    @Published var selectedTime: Int = 3
    private var startTimer: Timer?
    
    init(){
        self.startCDTimer()
        self.timerValue = "3"
    }
    func startCDTimer(){
        startTimer?.invalidate()
        startTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [self] _ in
            if self.selectedTime == 0 {
                self.startTimer?.invalidate()
            } else {
                self.timerValue = "\(selectedTime)"
                self.selectedTime -= 1
            }
        }
    }
}
//Modifier
struct CDText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("Bebas Neue", size: 150))
            .lineLimit(21)
            .minimumScaleFactor(0.1)
            .foregroundStyle(.pink)
            .shadow(color: .black, radius: 2, x: 0.0, y: 1)
            .padding(70)
    }
}
//MARK: - INT-extensions
extension Int {
    var asTimestampD: String {
        let hour = self / 3600
        let minute = self / 60 % 60
        let second = self % 60
        return String(format: "%02i%02i%02i", hour, minute, second)
    }
}
extension Int {
    var asTimesHour: String {
        let hour = self / 3600
        return String(format: "%02i", hour)
    }
}
extension Int {
    var asTimesMinute: String {
        let minute = self / 60 % 60
        return String(format: "%02i", minute)
    }
}
extension Int {
    var asTimesSecond: String {
        let second = self % 60
        return String(format: "%02i", second)
    }
}
extension Int {
    var asTimesHourNo0: String {
        let hour = self / 3600
        return String(format: "%02i", hour)
    }
}
extension Int {
    var asTimesMinuteNo0: String {
        let minute = self / 60 % 60
        return String(format: "%02i", minute)
    }
}
// GRADIENT: EXTENSION
extension View {
    public func gradientFGLinear(colors: [Color], startP: UnitPoint, endP: UnitPoint) -> some View {
        self.overlay(LinearGradient(gradient: .init(colors: colors),
                                    startPoint: startP, endPoint: endP))
        .mask(self)
    }
    public func gradientFGRadial(colors: [Color]) -> some View {
        self.overlay(RadialGradient(gradient: .init(colors: colors), center: .center, startRadius: 2, endRadius: 600))
    }
    public func gradientFGAngular(colors: [Color]) -> some View {
        self.overlay(AngularGradient(gradient: .init(colors: colors), center: .center))
    }
}
// extension color {
extension  Color {
    static func random() -> Color {
        return  Color(red: Double.random(in: 0...1), green: Double.random(in: 0...1), blue: Double.random(in: 0...1))
    }
}
//hex color
extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
func ColorSelected(colorHex: UInt) -> Color {
    Color(hex:colorHex)
}
var greenWater = Color(hex: 0x43736e)
var deepBlue = Color(hex: 0x264653) // Azul petróleo oscuro
var turquoiseGreen = Color(hex: 0x2a9d8f) // Verde turquesa
var sandYellow = Color(hex: 0xe9c46a) // Amarillo arena
var softOrange = Color(hex: 0xf4a261) // Naranja suave
var terracottaRed = Color(hex: 0xe76f51) // Rojo terracota
var darkTeal = Color(hex: 0x006d77) // Verde azulado oscuro
var waterGreen = Color(hex: 0x83c5be) // Verde agua
var iceBlue = Color(hex: 0xedf6f9) // Azul hielo
var pastelPink = Color(hex: 0xffafcc) // Rosa pastel
var coralRed = Color(hex: 0xf08080) // Rojo coral
var intenseViolet = Color(hex: 0x8a2be2) // Violeta intenso
var deepPurple = Color(hex: 0x6a0572) // Púrpura profundo
var darkIndigo = Color(hex: 0x3d348b) // Azul índigo oscuro
var brightYellow = Color(hex: 0xffc300) // Amarillo brillante
var forestGreen = Color(hex: 0x1b4332) // Verde bosque
var jungleGreen = Color(hex: 0x2d6a4f) // Verde selva
var clayRed = Color(hex: 0xb56576) // Rojo arcilla
var cherryRed = Color(hex: 0xff5e6c) // Rojo cereza
var oceanGreen = Color(hex: 0x0a9396) // Verde océano
var softLilac = Color(hex: 0xcdb4db) // Lila suave



