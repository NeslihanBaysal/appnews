import SwiftUI

struct SearchTabView: View {
    
    @StateObject var searchVM = ArticleSearchViewModel.shared
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    TextField("Search", text: $searchVM.searchQuery, onCommit: search)
                        .padding(.horizontal)
                        .padding(.top, 10)
                        .textFieldStyle(RoundedBorderTextFieldStyle()) // TextField'ı düzenlemek için stil belirtme
                    
                    if !searchVM.searchQuery.isEmpty {
                        Button(action: {
                            search()
                        }, label: {
                            Image(systemName: "magnifyingglass")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        })
                    }
                    
                    if !searchVM.searchQuery.isEmpty {
                        Button(action: {
                            searchVM.searchQuery = ""
                            searchVM.phase = .empty
                        }, label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(.gray)
                                .padding(.trailing, 8)
                        })
                    }
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                if !searchVM.searchQuery.isEmpty || !searchVM.history.isEmpty {
                    ArticleListView(articles: articles)
                        .overlay(overlayView)
                } else {
                    EmptyPlaceholderView(text: "Type your query to search from NNews", image: Image(systemName: "magnifyingglass"))
                }
            }
            .navigationTitle("Search")
        }
    }
    private var articles: [Article] {
        if case .success(let articles) = searchVM.phase {
            return articles
        } else {
            return []
        }
    }
    
    @ViewBuilder
    private var overlayView: some View {
        switch searchVM.phase {
        case .empty:
            if !searchVM.searchQuery.isEmpty {
                ProgressView()
            } else if !searchVM.history.isEmpty {
                SearchHistoryListView(searchVM: searchVM) { newValue in
                    searchVM.searchQuery = newValue
                    search()
                }
            } else {
                EmptyPlaceholderView(text: "Type your query to search from NewsAPI", image: Image(systemName: "magnifyingglass"))
            }
            
        case .success(let articles) where articles.isEmpty:
            EmptyPlaceholderView(text: "No search results found", image: Image(systemName: "magnifyingglass"))
            
        case .failure(let error):
            RetryView(text: error.localizedDescription, retryAction: search)
            
        default: EmptyView()
            
        }
    }
    private func search() {
        let searchQuery = searchVM.searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        if !searchQuery.isEmpty {
            searchVM.addHistory(searchQuery)
            
            Task {
                await searchVM.searchArticle()
            }
        } else {
            searchVM.phase = .empty
        }
    }
}

struct SearchTabView_Previews: PreviewProvider {
    
    @StateObject static var bookmarkVM = ArticleBookmarkViewModel.shared
    
    static var previews: some View {
        SearchTabView()
            .environmentObject(bookmarkVM)
    }
}
