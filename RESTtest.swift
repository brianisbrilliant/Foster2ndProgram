// Brian Foster
// can I get to a REST API from a playground? Yes.

// URLSession is required in order to get to the internet.
// APIs are all through URLs.

// POST GET PUT DELETE

// @escaping means a Closure that runs AFTER the function call. This enables the Collection Handler to wait for the files from the server to fully load, and THEN give them to us, instead of having the app freeze inside of that function.

import Foundation       // what does this give us? This gives us the URL struct, the URL Session, the JSONSerialization



// we are adding a closure here to make our data more accessible to the larger program. the closure goes in the parameters for fetchGists()
// storing as a Result type, which is an enum with two cases, one for success, one for failure.
// the Result enum returns one type for success ("Any" in this case) and another type for failure ("Error" in all cases). This allows us to test the "Result" of running this function, and to deal with the error if there is one, or to move on with our lives with the data, if successful.
// We also need for this closure to be @escaping, because we need the Result to continue to exist after this function has run.
    // We change some of the print() statements to use completion instead after building this.
func fetchGists(completion: @escaping (Result<[Gist], Error>) -> Void) {
    print("Starting fetchGists().")
    defer {
        print("Ending fetchGists().")       // this will run when the function ends.
    }
    
    
    /// Create the parts (components) of the URL and make sure it was created correctly.
    var componentURL = URLComponents()
    componentURL.scheme = "https"
    componentURL.host = "api.github.com"
    componentURL.path = "/gists/public"
    
    // create a new variable named "validURL" if we correctly set up componentURl.
    // I do not yet understand how to tell the difference.
    guard let validURL = componentURL.url else {
        print("URL Creation failed.")
        return
    }
    
    /// if all of the above worked correctly, let's do something with that URL.
    //calling the function "dataTask() and giving it a closure . . . idk what the (data, response, error) are.
    // this involves the Completion Handler.
        // Data is the data that we want from the API, it's our responsibility to parse that into JSON
        // Response is the URL Response, 200, 400, 500, etc. We will "downcast" this to the simpler "HTTPURLResponse" type.
        // Error is an error that we can give feedback to our users
    // we are  going to locally cache these as "data, response, and error
    // don't forget to call .resume() at the end of this, it won't start the code back up until we do this.
    URLSession.shared.dataTask(with: validURL) { (data,response, error) in
        
        
        // Here we are dealing with the Completion Handler's Response.
        if let httpResponse = response as? HTTPURLResponse {
            print("API Status: \(httpResponse.statusCode)") // error codes: 200 success, 400 client error, 500 server error
            
            // Here we are dealing with the Completion Handler's Error, and to confirm that we have Data
            // did it all work fine? If not, end the program early.
            guard let validData = data, error == nil else {
                // print("API Error: \(error!.localizedDescription)")       // print is moved to the function call.
                completion(Result.failure(error!))
                return
            }
            
            
            // Here we are handling the Completion Handler's Data.
            // feed the json serializer our data, which returns a json object.
            // jsonserialization has the Error protocal, which lets us use try/catch things to test it.
            do {
                // sending it our validData, with no options, so an empty array.
                //let json = try JSONSerialization.jsonObject(with: validData, options: [])     // this code went to the Gist.decode() method.
                let gists = try JSONDecoder().decode([Gist].self, from: validData)
                // print(json)             // if it works, print the data       // print is moved to the function call.
                completion(.success(gists))
            } catch let serializationError {
                print(serializationError.localizedDescription)      // print is moved to the function call.
                completion(.failure(serializationError))
            }
            
            // Gists Fetched!
        }
    }.resume()      // crucial, dont' forget
    
}



// Mark: Creating the Data Model

// creating codable data models.
// we want this to mirror the Gist, but only the information that we want for our app.
// Codable is a typealias protocol from the Swift Standard Library that allows us to Encode and Decode our JSON.

struct Gist: Encodable {
    let id: String?          // can this be a constant? Yes, for now at least. it's optional, because we won't send it to github.
    let isPublic: Bool
    let description: String
    
    enum CodingKeys: String, CodingKey {
        case id, description, isPublic = "public"
    }
    
    
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        // make sure there are always values for what we create.
        try container.encode(isPublic, forKey: .isPublic)
        try container.encode(description, forKey: .description)
        // id is created by github, not us. we'll create an optional string
        try container.encodeIfPresent(id, forKey: .id)
    }
}

// it's better to separate these, why?
extension Gist: Decodable {
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(String.self, forKey: .id)
        self.isPublic = try container.decode(Bool.self, forKey: .isPublic)
        self.description = try container.decode(String.self, forKey: .description)
    }
}
        




print("Fetching Gists")
fetchGists { (result) in
    switch result {
    case .success(let gists):
        for gist in gists {
            print("\(gist)")
        }
    case .failure(let error):
        print(error)
    }
}

print("Encoding a Gist")
let testGist = Gist(id: nil, isPublic: true, description: "Hello World!")

// testing to make sure that the testGist is being encoded correctly.
// HOWEVER the instructor says we don't have to do our own encoding and decoding. Maybe he'll show us the easy way next?
do {
    let gistData = try JSONEncoder.encode(testGist)
    let stringData = String(data: gistData, encoding: .utf8)
    print(stringData)
} catch {
    print("Encoding Failed")
}
