import Foundation

// Model to hold the quote result
struct QuoteResult: Codable, Equatable {
    let q: String // Quote text
    let a: String // Author
}

// ObservableObject to fetch and store the quote
final class QuoteModel: ObservableObject {
    @Published var result: QuoteResult? = nil

    func fetchQuote() {
        let urlString = "https://zenquotes.io/api/random"
        guard let url = URL(string: urlString) else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Unable to get data: \(error)")
                return
            }

            guard let data = data else {
                print("No data returned")
                return
            }

            do {
                // Decode the JSON response
                if let decodedData = try JSONDecoder().decode([QuoteResult]?.self, from: data)?.first {
                    DispatchQueue.main.async {
                        self.result = decodedData
                    }
                } else {
                    print("Error decoding data")
                }
            } catch {
                print("Error decoding data: \(error)")
            }
        }

        task.resume()
    }
}
