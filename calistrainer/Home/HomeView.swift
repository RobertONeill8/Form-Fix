//  HomeView.swift
//  calistrainer
//
//   on 14/03/22.
//

import SwiftUI

struct HomeView: View {
    
    @State private var activeTab = 0
    @State private var selectedPractice: HomeExerciseItem
    @State private var showPracticePreparationView = false
    @State private var username: String = ""
    @State private var showOnboarding = false

    private let userDefaults = UserDefaults.standard
    
    private let exerciseItems: [HomeExerciseItem]
    
    init() {
        self.exerciseItems = [
            HomeExerciseItem(
                exercise: .squat,
                description: "Train your lower body",
                image: "Squat",
                isSideFacing: false
            ),
            HomeExerciseItem(
                exercise: .pushup,
                description: "Train your chest and arms",
                image: "Pushup",
                isSideFacing: true
            ),
            HomeExerciseItem(
                exercise: .bentOverRow,
                description: "Train your back and shoulders",
                image: "BentOverRow",
                isSideFacing: true
            )
        ]
        _selectedPractice = State(initialValue: self.exerciseItems.first!)
    }
    
    var body: some View {
        
        ZStack {
            Color("PrimaryGray").ignoresSafeArea()
            VStack {
                VStack(alignment: .leading) {
                    Text("Hello,")
                        .font(.title2)
                        .fontWeight(.bold)
                        .opacity(0.3)
                    Text(username)
                        .font(.title)
                        .fontWeight(.bold)
                        .foregroundColor(.accentColor)
                    Text("Let's practice your calisthenics")
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
                .onTapGesture {
                    showOnboarding = true
                }
                
                Spacer()
                
                TabView(selection: $activeTab) {
                    ForEach(exerciseItems.indices, id: \.self) { index in
                        PracticeItem(exerciseItem: exerciseItems[index])
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
                .onChange(of: activeTab) { index in
                    selectedPractice = exerciseItems[index]
                }
                
                NavigationLink(isActive: $showPracticePreparationView) {
                    PracticePreparationView(
                        exercise: selectedPractice.exercise,
                        isAbleToChoosePerspective: selectedPractice.isSideFacing,
                        isShowingPracticePreparationView: $showPracticePreparationView
                    )
                } label: {
                    PrimaryButton(label: "Practice", fullWidth: true) {
                        showPracticePreparationView = true
                    }
                    .padding([.horizontal, .bottom])
                }

                Spacer()
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, onDismiss: {
            username = userDefaults.string(forKey: "username") ?? ""
        }, content: {
            OnboardingView(isShowingOnboarding: $showOnboarding)
        })
        .onAppear {
            username = userDefaults.string(forKey: "username") ?? ""
            if username.isEmpty {
                showOnboarding = true
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().preferredColorScheme(.dark)
    }
}

