//
//  ContentView.swift
//  KYLE-Edutainment
//
//  Created by Kyle Winfield Burnham on 7/6/23.
//
//pussy boy
import SwiftUI

extension StringProtocol {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}

struct Progression {
    var pickaxe = 1
    var rocks = 0
    var coal = 0
    var iron = 0
}

struct QuizData {
    var showing = false
    var knows = false
}

struct FunFacts {
    var limestoneQuizData = QuizData()
    var coalQuizData = QuizData()
    var cokeQuizData = QuizData()
    var ironOreQuizData = QuizData()
    var pigIronQuizData = QuizData()
    var hireWorkerQuizData = QuizData()
    var steelQuizData = QuizData()
}

struct Resource {
    var count: Int = 0
    var name: String
}

struct Resources {
    var rocks = Resource(name: "Rocks")
    var limestone = Resource(name: "Limestone")
    var coal = Resource(name: "Coal")
    var coke = Resource(name: "Coke")
    var ironOre = Resource(name: "Iron Ore")
    var pigIron = Resource(name: "Pig Iron")
    var steel = Resource(name: "Steel")
    var workers = Resource(name: "Workers")
}

struct ContentView: View {
    @State private var timer: Timer? = nil
    @State private var progression = Progression()
    
    @Environment(\.colorScheme) var colorScheme
    var myPrimaryColor: Color {
        colorScheme == .light ? Color.black : Color.white
    }
    var primaryColorOpposite: Color {
        colorScheme == .light ? Color.white : Color.black
    }
    var myUltraThinMaterial: Color {
        colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.45) : Color(red: 0.1, green: 0.1, blue: 0.1, opacity: 0.25)
    }
    var genericButtonMaterial: Color {
        colorScheme == .light ? Color(red: 0.9, green: 0.9, blue: 0.9, opacity: 0.6) : myUltraThinMaterial
    }
    
    private let extractCost = 15
    private let roastCost = 2
    @State private var resources = Resources()
    
    @State private var purchaseMultiplier = 1
    @State private var funFacts = FunFacts()
    @State private var showingWrongAlert = false
    @State private var showingResetGameAlert = false
    @State private var showingSavedGameAlert = false
    @State private var showingWinAlert = false
    
    var body: some View {
        ZStack {
            AngularGradient(gradient: Gradient(colors: [.brown, .brown, .brown, .gray, .black, .black, .black]), center: (colorScheme == .light ? .topTrailing : .bottomLeading))
                .ignoresSafeArea()
            Image("rocks")
                .resizable()
                .opacity(0.5)
                .edgesIgnoringSafeArea(.all)
            VStack(spacing: 8) {
                Group {
                    Spacer()
                    Spacer()
                    Spacer()
                }
                Group {
                    // Rocks
                    HStack {
                        Spacer()
                        Text("\(resources.rocks.name): \(resources.rocks.count)")
                            .font(.system(size: 26))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button {
                            if resources.rocks.count >= extractCost * purchaseMultiplier {
                                extract()
                            }
                        } label: {
                            HStack {
                                Text("Extract")
                                Image(systemName: "mountain.2")
                                    .font(.system(size: 20))
                                Text("\(extractCost * purchaseMultiplier)\(purchaseMultiplier == 1 ? "rocks" : "")")
                                    .italic(false)
                                    .font(.system(size: 12))
                            }
                            .font(.system(size: 25))
                            .frame(width: 175, height: 50)
                            .foregroundColor(.primary)
                            .background(genericButtonMaterial)
                            .border(myPrimaryColor, width: 1)
                            .italic()
                            .opacity(resources.rocks.count >= extractCost * purchaseMultiplier ? 1 : 0.25)
                        }
                        Spacer()
                    }
                    
                    // Limestone
                    HStack {
                        Spacer()
                        Text("\(resources.limestone.count > 99 ? "L~stone" : resources.limestone.name): \(resources.limestone.count)")
                            .font(.system(size: 26))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button{
                            if resources.limestone.count >= progression.pickaxe * 10 * purchaseMultiplier {
                                if (progression.pickaxe >= 4 && resources.steel.count >= ((progression.pickaxe - 2) / 2) * purchaseMultiplier) || progression.pickaxe < 4 {
                                    upgrade()
                                }
                            }
                        } label: {
                            Text("Upgrade")
                            Image(systemName: "arrow.up.left")
                                .font(.system(size: 20))
                            Text("\(progression.pickaxe * 10 * purchaseMultiplier)\(purchaseMultiplier == 1 ? "L" : "")\n\(progression.pickaxe >= 4 ? ((progression.pickaxe - 2) / 2) * purchaseMultiplier : 0)\(purchaseMultiplier == 1 ? "stl" : "")")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 22))
                        .frame(width: 170, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(resources.limestone.count >= progression.pickaxe * 10 && purchaseMultiplier == 1 ? progression.pickaxe < 4 ? 1 : resources.steel.count >= ((progression.pickaxe - 2) / 2) * purchaseMultiplier ? 1 : 0.25 : 0.25)
                        Spacer()
                    }
                    .opacity(progression.rocks > 0 ? 1 : 0)
                    
                    // Coal
                    HStack {
                        Spacer()
                        Text("\(resources.coal.name): \(resources.coal.count)")
                            .font(.system(size: 30))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button{
                            if resources.coal.count >= roastCost * purchaseMultiplier{
                                if funFacts.cokeQuizData.knows {
                                    roast()
                                } else {
                                    funFacts.cokeQuizData.showing = true
                                }
                            }
                        } label: {
                            Text("Roast")
                            Image(systemName: "leaf")
                                .font(.system(size: 20))
                            Text("\(purchaseMultiplier * 2)\(purchaseMultiplier == 1 ? "coal" : "")")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 25))
                        .frame(width: 160, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(resources.coal.count >= roastCost * purchaseMultiplier ? 1 : 0.25)
                        Spacer()
                    }
                    .opacity(progression.coal > 0 ? 1 : 0)
                    
                    // Coke
                    HStack {
                        Spacer()
                        Text("\(resources.coke.name): \(resources.coke.count)")
                            .font(.system(size: 30))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button {
                            if resources.pigIron.count >= 2 * purchaseMultiplier && resources.coke.count >= 10 * purchaseMultiplier {
                                if funFacts.steelQuizData.knows {
                                    makeSteel()
                                } else {
                                    funFacts.steelQuizData.showing = true
                                }
                            }
                        } label: {
                            Text("Steel")
                            Image(systemName: "square.2.layers.3d.top.filled")
                                .font(.system(size: 20))
                            Text("\(10 * purchaseMultiplier)\(purchaseMultiplier == 1 ? "coke" : "")\n\(2 * purchaseMultiplier)\(purchaseMultiplier == 1 ? "pig" : "")")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 25))
                        .frame(width: 150, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(resources.pigIron.count >= 2 * purchaseMultiplier && resources.coke.count >= 10 * purchaseMultiplier ? 1 : 0.25)
                        Spacer()
                    }
                    .opacity(progression.coal > 1 ? 1 : 0)
                    
                    // Iron Ore
                    HStack {
                        Spacer()
                        Text("\(resources.ironOre.name): \(resources.ironOre.count)")
                            .font(.system(size: 30))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button{
                            if resources.ironOre.count >= 4 * purchaseMultiplier && resources.coke.count >= 2 * purchaseMultiplier && resources.limestone.count >= 1 * purchaseMultiplier {
                                if funFacts.pigIronQuizData.knows {
                                    smelt()
                                } else {
                                    funFacts.pigIronQuizData.showing = true
                                }
                            }
                        } label: {
                            Text("Smelt")
                            Image(systemName: "oven")
                                .font(.system(size: 20))
                            Text("\(4 * purchaseMultiplier)\(purchaseMultiplier == 1 ? "ore" : "")\n\(2 * purchaseMultiplier)\(purchaseMultiplier == 1 ? "coke" : "")\n\(purchaseMultiplier)\(purchaseMultiplier == 1 ? "L" : "")")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 25))
                        .frame(width: 160, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(resources.ironOre.count >= 4 * purchaseMultiplier && resources.coke.count >= 2 * purchaseMultiplier && resources.limestone.count >= purchaseMultiplier ? 1 : 0.25)
                        Spacer()
                    }
                    .opacity(progression.iron > 0 ? 1 : 0)
                    
                    // Pig Iron
                    HStack {
                        Spacer()
                        Text("\(resources.pigIron.name): \(resources.pigIron.count)")
                            .font(.system(size: 30))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button{
                            if resources.pigIron.count >= purchaseMultiplier {
                                if funFacts.hireWorkerQuizData.knows {
                                    hire()
                                } else {
                                    funFacts.hireWorkerQuizData.showing = true
                                }
                            }
                        } label: {
                            Text("Hire")
                            Image(systemName: "figure.archery")
                                .font(.system(size: 20))
                            Text("\(purchaseMultiplier)\(purchaseMultiplier == 1 ? "pig" : "")\n+\(purchaseMultiplier)\nrck/sec")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 25))
                        .frame(width: 160, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(resources.pigIron.count >= purchaseMultiplier ? 1 : 0.25)
                        Spacer()
                    }
                    .opacity(progression.iron > 1 ? 1 : 0)
                    
                    // Steel
                    HStack {
                        Spacer()
                        Text("\(resources.steel.name): \(resources.steel.count)")
                            .font(.system(size: 30))
                            .shadow(color: primaryColorOpposite, radius: 2)
                            .bold()
                        Spacer()
                        Spacer()
                        Spacer()
                        Button{
                            if progression.iron < 4 && resources.steel.count >= 10 {
                                showingWinAlert = true
                            }
                        } label: {
                            Text("Score!")
                            Image(systemName: "flag.checkered.2.crossed")
                                .font(.system(size: 20))
                            Text("10stl")
                                .italic(false)
                                .font(.system(size: 12))
                        }
                        .font(.system(size: 25))
                        .frame(width: 170, height: 50)
                        .foregroundColor(.primary)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 1)
                        .italic()
                        .opacity(progression.iron < 4 ? resources.steel.count >= 10 ? 1 : 0.25 : 0)
                        Spacer()
                    }
                    .opacity(progression.iron >= 3 ? 1 : 0)
                }
                // MINE
                Button {
                    mine()
                } label: {
                    VStack {
                        Image(systemName: "arrow.up.left")
                        Text("MINE")
                    }
                    .frame(width: 250, height: 250)
                }
                .background(myUltraThinMaterial)
                .foregroundColor(.primary)
                .border(.primary, width: 3)
                .font(.system(size: 30))
                .bold()
                Spacer()
                Spacer()
                HStack {
                    // Restart Button
                    Group {
                        Spacer()
                        Spacer()
                        HStack {
                            Text("Restart")
                            Image(systemName: "eraser")
                        }
                        .foregroundColor(.primary)
                        .onTapGesture(perform: showResetGameAlert)
                        .font(.system(size: 20))
                        .frame(width: 120, height: 35)
                        .background(genericButtonMaterial)
                        .border(.primary, width: 2)
                        .italic()
                        .bold()
                        Spacer()
                        Spacer()
                    }
                    // Purchase Multiplier
                    Button {
                        loopPurchaseMultiplier()
                    } label: {
                        Text("x\(purchaseMultiplier)")
                            .frame(width: 100, height: 30)
                    }
                    .onTapGesture(perform: loopPurchaseMultiplier)
                    .foregroundColor(.primary)
                    .font(.system(size: 18))
                    .background(genericButtonMaterial)
                    .border(.primary, width: 1)
                    .italic()
                    // Save Button
                    Group {
                        Spacer()
                        Spacer()
                        VStack {
                            Button {
                                saveData()
                            } label: {
                                HStack {
                                    Text("Save")
                                    Image(systemName: "pencil.line")
                                }
                                .bold()
                            }
                            .font(.system(size: 20))
                            .frame(width: 120, height: 35)
                            .foregroundColor(.primary)
                            .background(genericButtonMaterial)
                            .border(.primary, width: 2)
                            .italic()
                        }
                        Spacer()
                        Spacer()
                    }
                }
                Group {
                    Spacer()
                    Spacer()
                    Spacer()
                }
            }
        }
        .onAppear(perform: loadData)
        .onAppear(perform: startTimer)
        // Limestone Quiz
        .alert("Extracting limestone...", isPresented: $funFacts.limestoneQuizData.showing) {
            Button("Okay", action: extractLimestone)
        } message: {
            Text("Limestone is used as a flux to remove the impurities and dirt from iron ores.")
        }
        // Coal Quiz
        .alert("Extracting coal...", isPresented: $funFacts.coalQuizData.showing) {
            Button("Okay", action: extractCoal)
        } message: {
            Text("Coal can be roasted (heated very hot where there is no oxygen) to produce coke.")
        }
        // Coke Quiz
        .alert("Roasting coal...", isPresented: $funFacts.cokeQuizData.showing) {
            Button("Okay", action: roast)
        } message: {
            Text("Coke is used to smelt ores.") // EDIT
        }
        // Iron Ore Quiz
        .alert("Extracting iron ore...", isPresented: $funFacts.ironOreQuizData.showing) {
            Button("Okay", action: extractIronOre)
        } message: {
            Text("Iron ores are rocks and minerals from which metallic iron can be economically extracted.")
        }
        // Pig Iron Quiz
        .alert("Smelting iron ore...", isPresented: $funFacts.pigIronQuizData.showing) {
            Button("Okay", action: smelt)
        } message: {
            Text("Pig iron is called pig iron because when being cast, each ingot looks like a piglet suckling milk from a sow.")
        }
        // Steel Quiz
        .alert("Smelting pig iron...", isPresented: $funFacts.steelQuizData.showing) {
            Button("Okay", action: makeSteel)
        } message: {
            Text("Steel is light, flexible and rust-resistant when compared to iron.")
        }
        // Worker Quiz
        .alert("Finding workers...", isPresented: $funFacts.hireWorkerQuizData.showing) {
            Button("Okay", action: hire)
        } message: {
            Text("Mining is the extraction of valuable geological materials from the Earth and other astronomical objects.")
        }
        // Win!
        .alert("Did you know!?", isPresented: $showingWinAlert) {
            Button("Okay", action: doNothing)
        } message: {
            Text("Steel is harder than pure iron.")
        }
        // Reset Game Alert
        .alert("Restart Game?", isPresented: $showingResetGameAlert) {
            Button("Yes", action: resetData)
            Button("Cancel", action: doNothing)
        } message: {
            Text("Want to try your hand at a better score?")
        }
        // Save Alert
        .alert("Game Saved!", isPresented: $showingSavedGameAlert) {
            Button("Okay", action: doNothing)
        }
    }
    func doNothing(){}
    func upgrade(){
        switch(progression.pickaxe){
        case 1..<4:
            resources.limestone.count -= progression.pickaxe * 10
            progression.pickaxe += 1
        default:
            resources.limestone.count -= progression.pickaxe * 10 * purchaseMultiplier
            resources.steel.count -= (progression.pickaxe - 2) / 2 * purchaseMultiplier
            progression.pickaxe += 2 * purchaseMultiplier
        }
    }
    func mine(){
        resources.rocks.count += progression.pickaxe
    }
    func roast(){
        useCoal()
        resources.coke.count += purchaseMultiplier
        if funFacts.cokeQuizData.knows == false {
            funFacts.cokeQuizData.knows = true
            progression.coal += 1
        }
    }
    func smelt(){
        resources.ironOre.count -= 4 * purchaseMultiplier
        resources.coke.count -= 2 * purchaseMultiplier
        resources.limestone.count -= 1 * purchaseMultiplier
        resources.pigIron.count += 2 * purchaseMultiplier
        if funFacts.pigIronQuizData.knows == false {
            funFacts.pigIronQuizData.knows = true
            progression.iron += 1
        }
    }
    func makeSteel(){
        resources.pigIron.count -= 2 * purchaseMultiplier
        resources.coke.count -= 10 * purchaseMultiplier
        resources.steel.count += 1 * purchaseMultiplier
        if funFacts.steelQuizData.knows == false {
            funFacts.steelQuizData.knows = true
            progression.iron += 1
        }
    }
    func hire(){
        resources.pigIron.count -= purchaseMultiplier
        resources.workers.count += purchaseMultiplier
        if funFacts.hireWorkerQuizData.knows == false {
            funFacts.hireWorkerQuizData.knows = true
            progression.rocks += 1
        }
    }
    func useRocks(){
        resources.rocks.count -= extractCost * purchaseMultiplier
    }
    func useCoal(){
        resources.coal.count -= roastCost * purchaseMultiplier
    }
    func extract(){
        if purchaseMultiplier == 1 {
            if (progression.coal > 1 || progression.pickaxe > 1) && progression.iron == 0 {
                funFacts.ironOreQuizData.showing = true
            } else if resources.rocks.count >= extractCost {
                let roll = Int.random(in: 0..<100)
                if roll < 50 {
                    if funFacts.limestoneQuizData.knows {
                        extractLimestone()
                    } else {
                        funFacts.limestoneQuizData.showing = true
                    }
                } else if roll < 90 {
                    if funFacts.coalQuizData.knows {
                        extractCoal()
                    } else {
                        funFacts.coalQuizData.showing = true
                    }
                } else {
                    if funFacts.ironOreQuizData.knows {
                        extractIronOre()
                    } else {
                        funFacts.ironOreQuizData.showing = true
                    }
                }
            }
        } else if resources.rocks.count >= extractCost {
            useRocks()
            resources.limestone.count += Int(0.5 * Double(purchaseMultiplier))
            resources.coal.count += Int(0.4 * Double(purchaseMultiplier))
            resources.ironOre.count += Int(0.1 * Double(purchaseMultiplier))
        }
    }
    func extractLimestone(){
        useRocks()
        resources.limestone.count += purchaseMultiplier
        if funFacts.limestoneQuizData.knows == false {
            funFacts.limestoneQuizData.knows = true
            progression.rocks += purchaseMultiplier
        }
    }
    func extractCoal(){
        useRocks()
        resources.coal.count += purchaseMultiplier
        if funFacts.coalQuizData.knows == false {
            funFacts.coalQuizData.knows = true
            progression.coal += purchaseMultiplier
        }
    }
    func extractIronOre(){
        useRocks()
        resources.ironOre.count += purchaseMultiplier
        if funFacts.ironOreQuizData.knows == false {
            funFacts.ironOreQuizData.knows = true
            progression.iron += purchaseMultiplier
        }
    }
    func showResetGameAlert(){
        showingResetGameAlert = true
    }
    func winGame(){
        resources.steel.count -= 5
        progression.iron += 1
    }
    func loopPurchaseMultiplier(){
        switch(purchaseMultiplier){
        case 1:
            fallthrough
        case 10:
            fallthrough
        case 100:
            fallthrough
        case 1000:
            fallthrough
        case 10000:
            purchaseMultiplier *= 10
        default:
            purchaseMultiplier = 1
        }
    }
    
    // SAVE DATA
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func saveData(){
        // 1 0 0 0 34 1 3 2 0 etc
        var data = ""
        data += "\(progression.pickaxe) \(progression.rocks) \(progression.coal) \(progression.iron) "
        data += "\(resources.rocks.count) \(resources.limestone.count) \(resources.coal.count) "
        data += "\(resources.coke.count) \(resources.ironOre.count) \(resources.pigIron.count) "
        data += "\(purchaseMultiplier) \(resources.workers.count) \(resources.steel.count) "
        data += "\(funFacts.limestoneQuizData.knows ? 1 : 0) \(funFacts.coalQuizData.knows ? 1 : 0) "
        data += "\(funFacts.cokeQuizData.knows ? 1 : 0) \(funFacts.ironOreQuizData.knows ? 1 : 0) "
        data += "\(funFacts.pigIronQuizData.knows ? 1 : 0) \(funFacts.hireWorkerQuizData.knows ? 1 : 0) "
        data += "\(funFacts.steelQuizData.knows ? 1 : 0) "
        let url = getDocumentsDirectory().appendingPathComponent("saveData.txt")
        do {
            try data.write(to: url, atomically: true, encoding: .utf8)
            showingSavedGameAlert = true
        } catch {
            print(error.localizedDescription)
        }
    }
    func loadData(){
        let url = getDocumentsDirectory().appendingPathComponent("saveData.txt")
        
        do {
            let readData = try String(contentsOf: url)
            let readDataValues = readData.split(separator: " ")
            
            var index = 0
            for readDataValue in readDataValues {
                if index < 20 {
                    
                    switch (index) {
                    case 0:
                        progression.pickaxe = Int(readDataValue) ?? 1
                    case 1:
                        progression.rocks = Int(readDataValue) ?? 0
                    case 2:
                        progression.coal = Int(readDataValue) ?? 0
                    case 3:
                        progression.iron = Int(readDataValue) ?? 0
                    case 4:
                        resources.rocks.count = Int(readDataValue) ?? 0
                    case 5:
                        resources.limestone.count = Int(readDataValue) ?? 0
                    case 6:
                        resources.coal.count = Int(readDataValue) ?? 0
                    case 7:
                        resources.coke.count = Int(readDataValue) ?? 0
                    case 8:
                        resources.ironOre.count = Int(readDataValue) ?? 0
                    case 9:
                        resources.pigIron.count = Int(readDataValue) ?? 0
                    case 10:
                        purchaseMultiplier = Int(readDataValue) ?? 1
                    case 11:
                        resources.workers.count = Int(readDataValue) ?? 0
                    case 12:
                        resources.steel.count = Int(readDataValue) ?? 0
                    case 13:
                        funFacts.limestoneQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 14:
                        funFacts.coalQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 15:
                        funFacts.cokeQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 16:
                        funFacts.ironOreQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 17:
                        funFacts.pigIronQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 18:
                        funFacts.hireWorkerQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    case 19:
                        funFacts.steelQuizData.knows = (Int(readDataValue) ?? 0) != 0
                    default:
                        doNothing()
                    }
                    index += 1
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    func resetData(){
        progression.pickaxe = 1
        progression.rocks = 0
        progression.coal = 0
        progression.iron = 0
        resources.rocks.count = 0
        resources.limestone.count = 0
        resources.coal.count = 0
        resources.coke.count = 0
        resources.ironOre.count = 0
        resources.pigIron.count = 0
        resources.steel.count = 0
        resources.workers.count = 0
        purchaseMultiplier = 1
        funFacts.limestoneQuizData.knows = false
        funFacts.coalQuizData.knows = false
        funFacts.cokeQuizData.knows = false
        funFacts.ironOreQuizData.knows = false
        funFacts.pigIronQuizData.knows = false
        funFacts.hireWorkerQuizData.knows = false
        funFacts.steelQuizData.knows = false
    }
    func startTimer(){
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { tempTimer in
            resources.rocks.count += resources.workers.count
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

// IDEAS
/*
 venomous or not? (okay to pick up)
 does the bunny like $it?
 - what is "$this"?
    - lol runes
    - rocks/crystals
    - language (code/real)
    - color (for Luca)
    - religion trivia (chakras?)
    - coffee
 phyics
  -> (laws)
 spot $it (pop-up: "did you know $trivia")
  ->(layer images)
    - chakras (label)
 tower defense (?)
 deck builder
 economics (idle game)
 */
