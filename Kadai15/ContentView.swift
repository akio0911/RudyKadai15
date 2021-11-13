//
//  ContentView.swift
//  Kadai15
//

import SwiftUI

struct Fruit: Identifiable {
    var id = UUID()
    var name: String
    var isChecked: Bool
}

struct FruitList: View {
    @State var showInputView = false
    @State  var fruits: [Fruit] = [
        Fruit(name: "りんご", isChecked: false),
        Fruit(name: "みかん", isChecked: true),
        Fruit(name: "バナナ", isChecked: false),
        Fruit(name: "パイナップル", isChecked: true)
    ]

    var body: some View {
        NavigationView {
            List {
                ForEach(fruits) { item in
                    FruitView(fruit: item)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showInputView = true
                    }, label: {
                        Image(systemName: "plus")
                    })
                }
            }
            .fullScreenCover(
                isPresented: $showInputView,
                content: { InputView(onCancel: {
                    showInputView = false
                }, onSave: {
                    fruits.append($0)
                    showInputView = false
                }) }
            )
        }
    }
}

struct FruitView: View {
    @State var fruit: Fruit

    var body: some View {
        HStack {
            CheckMark(isChecked: $fruit.isChecked)
            Text(fruit.name)
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            fruit.isChecked.toggle()
        }
    }
}

struct InputView: View {
    @State var text: String = ""

    var onCancel: () -> Void
    var onSave: (Fruit) -> Void

    var body: some View {
        NavigationView {
            HStack {
                Text("名前")
                TextField("", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
            }
            .padding()
            .frame(maxHeight: .infinity, alignment: .top)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        addIfPossible()
                    }
                }
            }
        }
    }
    private func addIfPossible() {
        let name = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if name == "" { return }
        onSave(Fruit(name: name, isChecked: false))
    }
}

struct CheckMark: View {
    @Binding var isChecked: Bool

    var body: some View {
        Image(systemName: "checkmark")
            .foregroundColor(isChecked ? .red : .white)
            .font(.system(size: 20, weight: .bold))
    }
}

struct ContentView: View {
    var body: some View {
        FruitList()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
