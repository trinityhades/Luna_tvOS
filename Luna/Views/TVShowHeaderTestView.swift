import SwiftUI

// Mock data for testing
struct MockTVShow {
    let name: String
    let voteAverage: Double
    let voteCount: Int
    let firstAirDate: String
    let contentRating: String?
}


enum DetailButtonFocus: Hashable {
    case play, bookmark, addToList
}

struct TVShowHeaderTestView: View {
    let tvShow: MockTVShow
    let playButtonText: String
    let hasServices: Bool
    
    @State private var isBookmarked: Bool = false
    @FocusState private var focusedButton: DetailButtonFocus?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 30) {
            // Title
            VStack(alignment: .center, spacing: 16) {
                Text(tvShow.name)
                    .font(.system(size: 64, weight: .heavy))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.7), radius: 12, x: 0, y: 4)
                    .lineLimit(2)
                    .minimumScaleFactor(0.8)
                    .multilineTextAlignment(.center)
            }
            .frame(maxWidth: .infinity)
            
            // Action buttons and metadata
            VStack(alignment: .leading, spacing: 20) {
                HStack(spacing: 16) {
                    // Play button
                    Button {
                        // Action
                    } label: {
                        HStack(spacing: 12) {
                            Image(systemName: hasServices ? "play.fill" : "exclamationmark.triangle.fill")
                                .font(.title3)
                            Text(hasServices ? playButtonText : "No Services")
                                .font(.title3.weight(.bold))
                        }
                        .frame(height: 66)
                        .frame(minWidth: 880)
                        .padding(.horizontal, 48)
                        .background(
                            RoundedRectangle(cornerRadius: 36, style: .continuous)
                                .fill(.white)
                        )
                        .foregroundColor(.black)
                    }
                    .buttonStyle(CardButtonStyle())
                    .focused($focusedButton, equals: .play)
                    .scaleEffect(focusedButton == .play ? 1.05 : 1.0)
                    .shadow(color: .white.opacity(0.3), radius: focusedButton == .play ? 16 : 0)
                    .animation(.easeOut(duration: 0.15), value: focusedButton == .play)
                    .disabled(!hasServices)
                    
                    // Bookmark button
                    Button {
                        isBookmarked.toggle()
                    } label: {
                        Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            .font(.title2)
                            .frame(width: 66, height: 66)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white.opacity(0.15))
                            )
                            .foregroundColor(isBookmarked ? .yellow : .white)
                    }
                    .buttonStyle(CardButtonStyle())
                    .focused($focusedButton, equals: .bookmark)
                    .scaleEffect(focusedButton == .bookmark ? 1.08 : 1.0)
                    .shadow(color: isBookmarked ? .yellow.opacity(0.5) : .white.opacity(0.3),
                           radius: focusedButton == .bookmark ? 16 : 0)
                    .animation(.easeOut(duration: 0.15), value: focusedButton == .bookmark)
                    
                    // Add to list button
                    Button {
                        // Action
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .fontWeight(.bold)
                            .frame(width: 66, height: 66)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.white.opacity(0.15))
                            )
                            .foregroundColor(.white)
                    }
                    .buttonStyle(CardButtonStyle())
                    .focused($focusedButton, equals: .addToList)
                    .scaleEffect(focusedButton == .addToList ? 1.08 : 1.0)
                    .shadow(color: .white.opacity(0.3), radius: focusedButton == .addToList ? 16 : 0)
                    .animation(.easeOut(duration: 0.15), value: focusedButton == .addToList)
                }
                
                // Metadata row
                HStack(spacing: 14) {
                    // Rating
                    if tvShow.voteAverage > 0 {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                                .font(.callout)
                            Text(String(format: "%.1f", tvShow.voteAverage))
                                .font(.callout.weight(.semibold))
                                .foregroundColor(.white.opacity(0.9))
                            Text("(\(formatVoteCount(tvShow.voteCount)))")
                                .font(.callout)
                                .foregroundColor(.white.opacity(0.6))
                        }
                    }
                    
                    if tvShow.voteAverage > 0 && (!tvShow.firstAirDate.isEmpty || tvShow.contentRating != nil) {
                        Text("•")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.5))
                    }
                    
                    // Year
                    if !tvShow.firstAirDate.isEmpty {
                        let year = String(tvShow.firstAirDate.prefix(4))
                        Text(year)
                            .font(.callout.weight(.semibold))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    
                    // Age rating
                    if let rating = tvShow.contentRating {
                        Text("•")
                            .font(.callout)
                            .foregroundColor(.white.opacity(0.5))
                        Text(rating)
                            .font(.callout.weight(.semibold))
                            .padding(.horizontal, 8)
                            .padding(.vertical, 3)
                            .background(Color.white.opacity(0.2))
                            .clipShape(RoundedRectangle(cornerRadius: 4))
                            .foregroundColor(.white.opacity(0.9))
                    }
                }
            }
        }
    }
    
    private func formatVoteCount(_ count: Int) -> String {
        if count >= 1000 {
            return String(format: "%.1fK", Double(count) / 1000.0)
        }
        return "\(count)"
    }
}

// MARK: - Previews

#Preview("Default State") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "Stranger Things",
                voteAverage: 8.6,
                voteCount: 20200,
                firstAirDate: "2016-07-15",
                contentRating: "TV-14"
            ),
            playButtonText: "Play S1E1",
            hasServices: true
        )
        .padding(60)
    }
}

#Preview("Play Button Focused") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "Stranger Things",
                voteAverage: 8.6,
                voteCount: 20200,
                firstAirDate: "2016-07-15",
                contentRating: "TV-14"
            ),
            playButtonText: "Play S1E1",
            hasServices: true
        )
        .padding(60)
        .onAppear {
            // Simulate focus - in real tvOS this happens automatically
        }
    }
}

#Preview("Long Title") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "The Haunting of Hill House",
                voteAverage: 8.2,
                voteCount: 5400,
                firstAirDate: "2018-10-12",
                contentRating: "TV-MA"
            ),
            playButtonText: "Play S1E1",
            hasServices: true
        )
        .padding(60)
    }
}

#Preview("Very Long Title") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "Only Murders in the Building: A Comedy Mystery Series",
                voteAverage: 8.4,
                voteCount: 1820,
                firstAirDate: "2021-08-31",
                contentRating: "TV-14"
            ),
            playButtonText: "Continue S3E5",
            hasServices: true
        )
        .padding(60)
    }
}

#Preview("No Services Available") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "Breaking Bad",
                voteAverage: 9.1,
                voteCount: 15600,
                firstAirDate: "2008-01-20",
                contentRating: "TV-MA"
            ),
            playButtonText: "Play S1E1",
            hasServices: false
        )
        .padding(60)
    }
}

#Preview("Minimal Metadata") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "New Series",
                voteAverage: 7.5,
                voteCount: 124,
                firstAirDate: "2026-01-01",
                contentRating: nil
            ),
            playButtonText: "Play S1E1",
            hasServices: true
        )
        .padding(60)
    }
}

#Preview("Continue Watching") {
    ZStack {
        Color.black.ignoresSafeArea()
        
        TVShowHeaderTestView(
            tvShow: MockTVShow(
                name: "The Last of Us",
                voteAverage: 8.8,
                voteCount: 8950,
                firstAirDate: "2023-01-15",
                contentRating: "TV-MA"
            ),
            playButtonText: "Continue S1E7",
            hasServices: true
        )
        .padding(60)
    }
}

#Preview("With Backdrop") {
    ZStack {
        // Simulated backdrop with gradient
        LinearGradient(
            gradient: Gradient(colors: [
                Color(red: 0.2, green: 0.1, blue: 0.3),
                Color.black
            ]),
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
        
        VStack {
            Spacer()
            
            TVShowHeaderTestView(
                tvShow: MockTVShow(
                    name: "Stranger Things",
                    voteAverage: 8.6,
                    voteCount: 20200,
                    firstAirDate: "2016-07-15",
                    contentRating: "TV-14"
                ),
                playButtonText: "Play S1E1",
                hasServices: true
            )
            .padding(.horizontal, 60)
            .padding(.bottom, 100)
        }
    }
}
