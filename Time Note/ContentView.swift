import SwiftUI

struct ContentView: View {
    @State private var todoItems = [TodoItem]()
    @State private var text = ""
    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    func timeString(time: Double) -> String {
        let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        let milliseconds = Int(time * 1000) % 1000
        return String(format:"%02i:%02i:%02i.%03i", hours, minutes, seconds, milliseconds)
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(todoItems.indices, id: \.self) { index in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(self.todoItems[index].task).font(.title)
                                .foregroundColor(.gray)
                            Text(timeString(time: self.todoItems[index].time))
                                .font(.headline)
                                .foregroundColor(.black)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            self.todoItems[index].isActive.toggle()
                        }) {
                            Text(self.todoItems[index].isActive ? "Stop" : "Start")
                        }
                        
                        Button(action: {
                            self.todoItems[index].time = 0.0
                        }) {
                            Text("Reset")
                        }
                        
                        Button(action: {
                            self.todoItems.remove(at: index)
                        }) {
                            Text("Delete")
                        }
                    }
                }
            }
            
            HStack {
                TextField("Enter task", text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button( action: {
                    if !self.text.isEmpty {
                        self.todoItems.append(TodoItem(task: self.text, isActive: true))
                        self.text = ""
                    }
                    
                }) {
                    Label("Save", systemImage: "arrow.up")
                }
            }
            .padding()
        }
        .onReceive(timer) { _ in
            for index in self.todoItems.indices where self.todoItems[index].isActive {
                self.todoItems[index].time += 0.1
            }
        }
        .onAppear(perform: loadData)
        .onDisappear(perform: saveData)
    }
    
    func saveData() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(todoItems) {
            UserDefaults.standard.set(encoded, forKey: "TodoItems")
        }
    }
    
    func loadData() {
        if let savedItems = UserDefaults.standard.object(forKey: "TodoItems") as? Data {
            let decoder = JSONDecoder()
            if let loadedItems = try? decoder.decode([TodoItem].self, from: savedItems) {
                
                self.todoItems = loadedItems
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
