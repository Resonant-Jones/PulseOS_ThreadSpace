
import SwiftUI

struct MoodView: View {
    @State private var selectedMood: String? = nil
    @State private var moodNote: String = ""

    let moods = ["😄", "🙂", "😐", "😔", "😢"]

    var body: some View {
        VStack(spacing: ThreadSpaceTheme.Layout.padding) {
            Text("How are you feeling?")
                .font(ThreadSpaceTheme.Fonts.title)
                .foregroundColor(ThreadSpaceTheme.Colors.text)

            HStack(spacing: ThreadSpaceTheme.Layout.padding) {
                ForEach(moods, id: \.self) { mood in
                    Text(mood)
                        .font(.system(size: 40))
                        .padding()
                        .background(selectedMood == mood ? ThreadSpaceTheme.Colors.accent.opacity(0.3) : Color.clear)
                        .cornerRadius(10)
                        .onTapGesture {
                            selectedMood = mood
                        }
                }
            }

            TextField("Optional note...", text: $moodNote)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)

            Button(action: logMood) {
                Text("Log Mood")
                    .font(ThreadSpaceTheme.Fonts.body)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ThreadSpaceTheme.Colors.accent)
                    .foregroundColor(.white)
                    .cornerRadius(ThreadSpaceTheme.Layout.cornerRadius)
            }
            .padding(.horizontal)

            Spacer()
        }
        .padding()
    }

    func logMood() {
        // Placeholder: Save selectedMood and moodNote to Journal or HealthKit
        print("Logged mood: \(selectedMood ?? "None") with note: \(moodNote)")
        selectedMood = nil
        moodNote = ""
    }
}

