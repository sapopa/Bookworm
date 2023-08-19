//
//  AddBookView.swift
//  Bookworm
//
//  Created by sebastian.popa on 8/17/23.
//

import SwiftUI

struct AddBookView: View {
    
    @Environment(\.managedObjectContext) var moc
    @Environment(\.dismiss) var dismiss
    
    @State private var title = ""
    @State private var author = ""
    @State private var genre = ""
    @State private var review = ""
    @State private var rating = 3
    
    let genres = ["Fantasy", "Horror", "Kids", "Mystery", "Poetry", "Romance", "Thriller"]
    
    var isFormValid: Bool {
        !(title.isEmpty || author.isEmpty || genre.isEmpty)
    }
    
    @State private var isInvalidAlert = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Name of book", text: $title)
                    TextField("Author's name", text: $author)
                    
                    Picker("Genre", selection: $genre) {
                        ForEach(genres, id: \.self) {
                            Text($0)
                        }
                    }
                }
                
                Section {
                    TextEditor(text: $review)
                    
                    RatingView(rating: $rating)
                } header: {
                    Text("Write a review")
                }
                
                Section {
                    Button("Save") {
                        if isFormValid {
                            if review.isEmpty{
                                review = "You decided not to leave a review for this book."
                            }
                            addBook()
                            
                            try? moc.save()
                            
                            dismiss()
                        } else {
                            isInvalidAlert = true
                        }
                    }
                }
            }
            .navigationTitle("Add book")
            .alert("Please revise your input", isPresented: $isInvalidAlert) {
                Button("OK", role: .cancel) {}
            } message: {
                Text("Your book details are incomplete")
            }
        }
    }
    
    func addBook(){
        let newBook = Book(context: moc)
        newBook.id = UUID()
        newBook.title = title
        newBook.author = author
        newBook.rating = Int16(rating)
        newBook.genre = genre
        newBook.review = review
        newBook.date = Date.now
        
        try? moc.save()
    }
}

struct AddBookView_Previews: PreviewProvider {
    static var previews: some View {
        AddBookView()
    }
}
