import SwiftUI
import Kingfisher

// Mock Episode model for testing
struct MockEpisode: Identifiable {
    let id: Int
    let episodeNumber: Int
    let seasonNumber: Int
    let name: String
    let overview: String?
    let runtime: Int?
    let stillPath: String?
    
    var fullStillURL: String? {
        guard let stillPath = stillPath else { return nil }
        return "https://image.tmdb.org/t/p/w500\(stillPath)"
    }
}

struct EpisodeCardTestView: View {
    @FocusState private var focusedEpisode: Int?
    @State private var selectedEpisodeId: Int? = nil
    
    let episode: MockEpisode
    let progress: Double
    let isFocused: Bool
    
    var body: some View {
        let isSelected = selectedEpisodeId == episode.id
        
        Button(action: {
            selectedEpisodeId = episode.id
        }) {
            VStack(alignment: .leading, spacing: 10) {
                // Episode thumbnail
                ZStack(alignment: .bottomLeading) {
                    KFImage(URL(string: episode.fullStillURL ?? ""))
                        .placeholder {
                            Rectangle()
                                .fill(Color.white.opacity(0.1))
                                .overlay(
                                    Image(systemName: "tv")
                                        .font(.title)
                                        .foregroundColor(.white.opacity(0.3))
                                )
                        }
                        .resizable()
                        .aspectRatio(16 / 9, contentMode: .fill)
                        .frame(height: 180)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    
                    // Progress bar overlay
                    if progress > 0 && progress < 0.95 {
                        VStack {
                            Spacer()
                            GeometryReader { geo in
                                Rectangle()
                                    .fill(Color.white.opacity(0.3))
                                    .frame(height: 4)
                                    .overlay(
                                        Rectangle()
                                            .fill(Color.accentColor)
                                            .frame(
                                                width: geo.size.width * progress,
                                                height: 4
                                            ),
                                        alignment: .leading
                                    )
                            }
                            .frame(height: 4)
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    }
                }
                
                VStack(alignment: .leading, spacing: 6) {
                    HStack {
                        Text("Episode \(episode.episodeNumber)")
                            .font(.caption)
                            .foregroundColor(.white.opacity(0.6))
                        
                        Spacer()
                        
                        if let runtime = episode.runtime, runtime > 0 {
                            Text("\(runtime)m")
                                .font(.caption2)
                                .foregroundColor(.white.opacity(0.5))
                        }
                    }
                    
                    Text(episode.name)
                        .font(.subheadline.weight(.semibold))
                        .foregroundColor(.white)
                        .lineLimit(2)
                    
                    if let overview = episode.overview, !overview.isEmpty {
                        Text(overview)
                            .font(.caption2)
                            .foregroundColor(.white.opacity(0.6))
                            .lineLimit(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(14)
            .background(
                isSelected
                    ? Color.white.opacity(0.15)
                    : Color.white.opacity(0.05)
            )
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 14, style: .continuous)
                    .strokeBorder(
                        isFocused
                            ? Color.white.opacity(0.4)
                            : Color.clear,
                        lineWidth: 2
                    )
            )
        }
        .buttonStyle(.plain)
        .focused($focusedEpisode, equals: episode.episodeNumber)
        .scaleEffect(isFocused ? 1.03 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isFocused)
    }
}

// MARK: - Previews

#Preview("Normal State") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        EpisodeCardTestView(
            episode: MockEpisode(
                id: 1,
                episodeNumber: 2,
                seasonNumber: 1,
                name: "Chapter Two: The Weirdo on Maple Street",
                overview: "Lucas, Mike and Dustin try to talk to the girl they found in the woods.",
                runtime: 55,
                stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
            ),
            progress: 0,
            isFocused: false
        )
        .frame(width: 360)
        .padding()
    }
}

#Preview("Focused State") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        EpisodeCardTestView(
            episode: MockEpisode(
                id: 1,
                episodeNumber: 2,
                seasonNumber: 1,
                name: "Chapter Two: The Weirdo on Maple Street",
                overview: "Lucas, Mike and Dustin try to talk to the girl they found in the woods.",
                runtime: 55,
                stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
            ),
            progress: 0,
            isFocused: true
        )
        .frame(width: 360)
        .padding()
    }
}

#Preview("With Progress") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        EpisodeCardTestView(
            episode: MockEpisode(
                id: 1,
                episodeNumber: 2,
                seasonNumber: 1,
                name: "Chapter Two: The Weirdo on Maple Street",
                overview: "Lucas, Mike and Dustin try to talk to the girl they found in the woods.",
                runtime: 55,
                stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
            ),
            progress: 0.65,
            isFocused: false
        )
        .frame(width: 360)
        .padding()
    }
}

#Preview("Focused With Progress") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        EpisodeCardTestView(
            episode: MockEpisode(
                id: 1,
                episodeNumber: 2,
                seasonNumber: 1,
                name: "Chapter Two: The Weirdo on Maple Street",
                overview: "Lucas, Mike and Dustin try to talk to the girl they found in the woods.",
                runtime: 55,
                stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
            ),
            progress: 0.65,
            isFocused: true
        )
        .frame(width: 360)
        .padding()
    }
}

#Preview("Grid Layout - Multiple Cards") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        ScrollView {
            LazyVGrid(
                columns: [GridItem(.adaptive(minimum: 280, maximum: 360), spacing: 32)],
                alignment: .leading,
                spacing: 32
            ) {
                ForEach([
                    MockEpisode(
                        id: 1,
                        episodeNumber: 1,
                        seasonNumber: 1,
                        name: "Chapter One: The Vanishing of Will Byers",
                        overview: "On his way home from a friend's house, young Will sees something terrifying.",
                        runtime: 48,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 2,
                        episodeNumber: 2,
                        seasonNumber: 1,
                        name: "Chapter Two: The Weirdo on Maple Street",
                        overview: "Lucas, Mike and Dustin try to talk to the girl they found in the woods.",
                        runtime: 55,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 3,
                        episodeNumber: 3,
                        seasonNumber: 1,
                        name: "Chapter Three: Holly, Jolly",
                        overview: "An increasingly concerned Nancy looks for Barb and finds out what Jonathan's been up to.",
                        runtime: 51,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 4,
                        episodeNumber: 4,
                        seasonNumber: 1,
                        name: "Chapter Four: The Body",
                        overview: "Refusing to believe Will is dead, Joyce tries to connect with her son.",
                        runtime: 50,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 5,
                        episodeNumber: 5,
                        seasonNumber: 1,
                        name: "Chapter Five: The Flea and the Acrobat",
                        overview: "Hopper breaks into the lab while Nancy and Jonathan confront the force that took Will.",
                        runtime: 52,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 6,
                        episodeNumber: 6,
                        seasonNumber: 1,
                        name: "Chapter Six: The Monster",
                        overview: "Jonathan and Nancy look for the monster, Steve and Tommy look for Jonathan.",
                        runtime: 46,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 7,
                        episodeNumber: 7,
                        seasonNumber: 1,
                        name: "Chapter Seven: The Bathtub",
                        overview: "Eleven struggles to reach Will, while Lucas warns that the bad men are coming.",
                        runtime: 41,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    ),
                    MockEpisode(
                        id: 8,
                        episodeNumber: 8,
                        seasonNumber: 1,
                        name: "Chapter Eight: The Upside Down",
                        overview: "Dr. Brenner holds Hopper and Joyce for questioning while the boys wait with Eleven.",
                        runtime: 54,
                        stillPath: "/8SIy2jKIw7n5vSBErFvmfD7rkr0.jpg"
                    )
                ]) { episode in
                    EpisodeCardTestView(
                        episode: episode,
                        progress: episode.id == 1 ? 0.95 : (episode.id == 2 ? 0.4 : 0),
                        isFocused: episode.id == 2
                    )
                }
            }
            .padding()
        }
    }
}
