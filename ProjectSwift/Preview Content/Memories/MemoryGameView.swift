//
//  MemoryGameView.swift
//  ProjectSwift
//
//  Created by Freddy Morales on 08/03/25.
//

import Foundation
import SwiftUI
/*
struct MemoryGameView: View {
    @ObservedObject var viewModel: EmojiMemoryGame
    @AppStorage("DifficultyLevelMemory") var difficultyLevelMemory: Double = 1.0
    @AppStorage("countIntertitial") var countIntertitial: Int = 0
    @Environment(\.presentationMode) var presentationMode
    var tryGame: Bool = false
    @State private var areButtonDissabled = false
    @State var selectedIndex = -1
    @State private var showOpen = false
    @ObservedObject var timerModel = CountDowloadModel()
    @State private var anim = false
    @State private var anim2 = false
    
    var body: some View {
        ZStack {
            Image("natural")
                .resizable()
                .edgesIgnoringSafeArea(.all)
            Color.black.opacity(0.3).edgesIgnoringSafeArea(.all)
            Text("Ready")
                .modifier(CDText())
                .scaleEffect(!anim ? 1 : 0)
                .opacity(!anim2 ? 1 : 0)
                .animation(.easeInOut(duration: 0.5), value: anim)
                .onAppear(perform: {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                        withAnimation {
                            anim2 = true
                        }
                    }
                })
            Text(timerModel.timerValue)
                .modifier(CDText())
                .scaleEffect(anim ? 1 : 0)
                .opacity(anim2 ? 1: 0)
                .animation(.easeInOut(duration: 0.5), value: anim)
                .onChange(of: timerModel.selectedTime) { _ in
                    withAnimation(.easeInOut(duration: 0.5)) {
                    anim = true
                }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                anim2 = false
            }
        }
        VStack {
            HStack {
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    HStack(spacing: 5) {
                        Image(systemName: "chevron.backward")
                            .font(.system(size: 20))
                        Text("Back")
                            .font(.custom("Bebas Neue", size: 20))
                            .multilineTextAlignment(.center)
                        }
                    } //button
                .foregroundColor(.white)
                Spacer()
                Text("Brain game")
                    .font(.custom("Bebas Neue", size: 30))
                    .multilineTextAlignment(.center)
                    .lineLimit(11)
                    .minimumScaleFactor(0.1)
                    .foregroundColor(.white)
                Spacer()
                    VStack {
                        let scoreText = viewModel.gameWon ? viewModel.score + Int(viewModel.gameTimeValue / 5) : viewModel.score
                        Text("Score \(scoreText)")


                        .font(Font.custom("Bebas Neue", size: 20))
                    }
                }
            .padding()
                ZStack{
                    Text("\(viewModel.gameTimeValue.asTimesMinute): \(viewModel.gameTimeValue.asTimesSecond)")
                        .font(.custom("Bebas Neue", size: 20))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundColor(pastelPink)
                    Text(viewModel.hintActive ? "Hint: tap a card" : "")
                        .font(.custom("Bebas Neue", size: 20))
                        .multilineTextAlignment(.center)
                        .lineLimit(1)
                        .foregroundColor(.orange)
                        .offset(y:25)
                }
            Spacer()
                if viewModel.gameWon {
                    VStack {
                        Image("Games2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("Congratulations")
                            .font(Font.custom("Bebas Neue", size: 20))
                            .foregroundColor(oceanGreen)
                            .lineLimit(1)
                            .minimumScaleFactor(0.05)
                        Text("You win")
                            .font(Font.custom("Bebas Neue", size: 40))
                            .foregroundColor(.white)
                        if viewModel.gameTimeValue > 0 {
                            HStack {
                                Text("Bonus")
                                    .font(.custom("Bebas Neue", size: 20))
                                    .foregroundColor(pastelPink)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                                Text(" + \(Int(viewModel.gameTimeValue / 5)) Point")
                                    .font(.custom("Bebas Neue", size: 30))
                                    .foregroundColor(.yellow)
                                    .minimumScaleFactor(0.1)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.5)
                            }
                        }
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(intenseViolet).shadow(color: .black.opacity(0.5), radius: 10, x: 0.0, y: 0.0))
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).frame(width: 100, height: 40, alignment: .center).foregroundColor(oceanGreen)
                                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40, alignment: .center).foregroundColor(.black.opacity(0.3))
                                Text("Menu")
                                    .font(.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                        Button(action: {
                            viewModel.startNewGame()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).frame(width: 100, height: 40, alignment: .center).foregroundColor(oceanGreen)
                                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40, alignment: .center).foregroundColor(.black.opacity(0.3))
                                Text("Again")
                                    .font(.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                    }
                    Spacer()
                } else if viewModel.gameOver {
                    VStack {
                        Image("Games2")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 150)
                        Text("Play Again")
                            .font(.custom("Bebas Neue", size: 30))
                            .foregroundColor(.white)
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Text("Game over")
                            .font(.custom("Bebas Neue", size: 40))
                            .foregroundColor(.white)
                    }
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 20).foregroundColor(.orange).shadow(color: .black.opacity(0.5), radius: 10, x: 0.0, y: 0.0))
                    
                    HStack {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).frame(width: 100, height: 40, alignment: .center).foregroundColor(oceanGreen)
                                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40, alignment: .center).foregroundColor(.black.opacity(0.3))
                                Text("Again")
                                    .font(.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                        Button(action: {
                            viewModel.startNewGame()
                        }) {
                            ZStack {
                                RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 2).frame(width: 100, height: 40, alignment: .center).foregroundColor(oceanGreen)
                                RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 40, alignment: .center).foregroundColor(.black.opacity(0.3))
                                Text("Again")
                                    .font(.custom("Bebas Neue", size: 25))
                                    .foregroundColor(.white)
                                    .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.05)
                            }
                        }
                    }
                    Spacer()
                } else {
                    LazyVGrid(columns: [GridItem](repeating: GridItem(.flexible()),
                              count: difficultyLevelMemory == 2 ? 4 : 3)) {
                        ForEach(viewModel.cards) { card in
                            CardView(card: card)
                                .gesture(
                                    TapGesture()
                                        .onEnded { _ in
                                            if !viewModel.gameOver && selectedIndex
                                                != viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? -1 {
                                                    viewModel.choose(card)
                                                }
                                            selectedIndex = viewModel.cards.firstIndex(where: { $0.id == card.id }) ?? -1
                                        })
                                .disabled(areButtonDissabled)
                                .scaledToFit()
                        }
                    }
                    .padding()
                    .opacity(showOpen ? 1 : 0)
                    Spacer()
                        .onAppear(perform: {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4.2) {
                                withAnimation(.smooth) {
                                    showOpen = true
                                }
                            }
                        })
                }
                if tryGame {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }){
                        ZStack {
                            RoundedRectangle(cornerRadius: 10).frame(width: 200, height: 40, alignment: .center).foregroundColor(.orange)
                            Text(NSLocalizedString("Exit game", comment: ""))
                                .font(Font.custom("Bebas Neue", size: 25))
                                .shadow(color: .black.opacity(0.8), radius: 1, x: 0, y: 0)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
            }
            .onChange(of: viewModel.gameWon, perform : { value in
                if value {
                    viewModel.stopGameTimer()
                }
            })
            .gesture(
                MagnificationGesture(minimumScaleDelta: 1.0)
                    .onChanged { value in
                        if value >= 1 {
                            self.areButtonDissabled = true
                        }
                    }
                    .onEnded { _ in
                        self.areButtonDissabled = false
                    }
            )
        }
    }
}
struct MemoryGame_Previews: PreviewProvider {
    static var previews: some View {
        let emojis = ["🦄", "🐇", "🐰", "🦎", "🦙", "🦁"]
        let game = EmojiMemoryGame(emojis: emojis)
        MemoryGameView(viewModel: game)
            .preferredColorScheme(.dark)
    }
}
struct MemoryGame<CardContent: Equatable> {
    var cards: [Card]
    init(numberOfPairCards: Int, carContentFactory: (Int) -> CardContent) {
        cards = [Card]()
        for index in 0 ..< numberOfPairCards {
            let content = carContentFactory(index)
            cards.append(Card(id: index * 2, content: content))
            cards.append(Card(id: index * 2 + 1, content: content))
        }
        cards.shuffled()
    }
    mutating func choose(_ card: Card) {
        if let choseIndex = cards.firstIndex(where: { $0.id == card.id }),
            !cards[choseIndex].isMatched {
                if let potentialMatchIndex = indexOfTheOneAndOnlyFaceUpCard {
                    if cards[choseIndex].content == cards[potentialMatchIndex].content {
                        cards[choseIndex].isMatched = true
                        cards[potentialMatchIndex].isMatched = true
                    }
                    cards[choseIndex].isFaceUp = true
                } else {
                    indexOfTheOneAndOnlyFaceUpCard = choseIndex
                }
            }
        }
        var indexOfTheOneAndOnlyFaceUpCard: Int? {
            get {
                cards.indices.filter { cards[$0].isFaceUp }.only
            }
            set {
                for index in cards.indices {
                    cards[index].isFaceUp = index == newValue
                }
            }
        }
    struct Card: Identifiable {
        var id: Int
        var isFaceUp = false
        var isMatched = false
        var content: CardContent
    }
}
extension Array {
    var only: Element? {
        count == 1 ? first : nil
    }
}
class EmojiMemoryGame: ObservableObject {
    @Published private var model: MemoryGame<String>
    @Published private(set) var hintActive: Bool = false
    @Published private(set) var gameOver: Bool = false
    @Published private(set) var gameTimeValue: Int = 60
    @AppStorage("DifficultyLevelMemory") var difficultyLevelMemory: Double = 1.0
    
    var score: Int {
        return model.cards.filter { $0.isMatched == true }.count
    }
    private var timer: Timer?
    private var emojis: [String]
    init(emojis: [String]) {
        self.emojis = emojis
        model = EmojiMemoryGame.createMemoryGame(emojis: emojis)
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            self.startGameTimer()
        }
        //startNewGame
    }
    private static func createMemoryGame(emojis: [String]) -> MemoryGame<String> {
        return MemoryGame<String>(numberOfPairCards: emojis.count) { index in
            emojis[index]
        }
    }
    var gameWon: Bool {
        model.cards.allSatisfy { $0.isMatched }
    }
    var cards: [MemoryGame<String>.Card] {
        model.cards
    }
    private var hintTimer: Timer?
    private var gameTimer: Timer?
    private func startHintTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 5, repeats: false) { _ in
            self.hintActive = true
        }
    }
    func startGameTimer() {
        gameTimer?.invalidate()
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: gameTimeValue > 0 ? true : false) { _ in
            self.gameTimeValue -= 1
            if self.gameTimeValue == 0 {
                self.gameTimer?.invalidate()
                withAnimation(.smooth(duration: 0.3)) {
                    self.gameOver = true
                }
            }
        }
    }
    func stopGameTimer() {
        gameTimer?.invalidate()
        hintActive = false
        hintTimer?.invalidate()
    }
    func chose(_ card: MemoryGame<String>.Card) {
        model.choose(card)
        hintActive = false
        startHintTimer()
    }
    func startNewGame() {
        model = EmojiMemoryGame.createMemoryGame(emojis: emojis)
        withAnimation(.smooth(duration: 0.3)) {
            self.gameOver = false
        }
        hintActive = false
        switch difficultyLevelMemory {
        case 0.0:
            gameTimeValue = 60
        case 1.0:
            gameTimeValue = 40
        case 2.0:
            gameTimeValue = 60
        default:
            gameTimeValue = 60
        }
        startGameTimer()
        startHintTimer()
    }
}
struct CardView: View {
    var card: MemoryGame<String>.Card
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                let shape = RoundedRectangle(cornerRadius: 10)
                if card.isFaceUp {
                    shape.fill().gradientFGLinear(colors: [.pink,.white], startP: .topLeading, endP: .bottomTrailing)
                    shape.strokeBorder(lineWidth: 1).foregroundColor(.white)
                    Text(card.content).font(Font.system(size: fontSize(for: geometry.size)))
                } else if card.isMatched {
                    shape.opacity(0)
                } else {
                    shape
                        .gradientFGLinear(colors: [softLilac], startP: .top, endP: .bottom)
                    shape.strokeBorder(lineWidth: 1).foregroundColor(.white)
                    Image("MemoryCard").resizable().aspectRatio(contentMode: .fit).padding(15)
                }
            }
            .rotation3DEffect(
                Angle(degrees: card.isFaceUp ? 0 : 180),
                axis: (x: 0.0, y: 1.0, z: 0.0)
                )
            .animation(.smooth(duration: 0.3))
        }
    }
    private func fontSize(for size: CGSize) -> CGFloat {
        min(size.width, size.height) * 0.7
    }
}

*/
