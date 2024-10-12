import Foundation

/// A model to hold the quote result returned from the API.
///
/// This struct contains the quote text and the author's name, conforming to `Codable` and `Equatable` for easy decoding and comparison.
struct QuoteResult: Codable, Equatable {
    
    /// The text of the quote.
    let q: String
    
    /// The author of the quote.
    let a: String
}

/// An observable object that fetches and stores a quote.
///
/// `QuoteModel` is responsible for sending a request to the ZenQuotes API, decoding the response, and publishing the quote result.
final class QuoteModel: ObservableObject {
    
    /// The fetched quote result, initially set to `nil`.
    @Published var result: QuoteResult? = nil
    
    /// Fetches a random quote from the ZenQuotes API.
    ///
    /// This method sends a network request to retrieve a random quote, decodes the JSON response, and updates the `result` property.
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
