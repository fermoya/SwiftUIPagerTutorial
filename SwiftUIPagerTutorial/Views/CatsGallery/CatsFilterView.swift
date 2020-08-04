//
//  CatsFilterView.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import SwiftUI
import SwiftUIPager

struct CatsFilterView: View {

    @Binding var categoryId: String?
    @Binding var breedId: String?

    @State private var editedCategoryId: String?
    @State private var editedBreedId: String?

    @State private var breedsPage = 0
    @State private var categoriesPage = 0
    @StateObject private var viewModel = CatsFilterViewModel()

    @Environment(\.presentationMode) private var presentationMode

    var body: some View {
        NavigationView {
            GeometryReader { proxy in
                List {
                    Section(header: Text("Categories")) {
                        if viewModel.categoriesResponse.isEmpty {
                            categoriesProgressView
                        } else {
                            Pager(page: $categoriesPage, data: viewModel.categoriesResponse) { category in
                                page(for: category)
                            }
                            .multiplePagination()
                            .loopPages(repeating: 2)
                            .interactive(0.7)
                            .swipeInteractionArea(.allAvailable)
                            .preferredItemSize(CGSize(width: 60, height: 60))
                            .itemSpacing(10)
                            .frame(width: proxy.size.width,
                                   height: 150)
                        }
                    }
                    Section(header: Text("Breeds")) {
                        if viewModel.breedsResponse.isEmpty {
                            breedsProgressView
                        } else {
                            Pager(page: $breedsPage, data: viewModel.breedsResponse) { breed in
                                page(for: breed)
                            }
                            .padding()
                            .rotation3D()
                            .multiplePagination()
                            .itemAspectRatio(0.7)
                            .itemSpacing(10)
                            .frame(width: proxy.size.width,
                                   height: proxy.size.height / 2)
                        }
                    }
                }
                .listRowInsets(EdgeInsets(.zero))
                .listStyle(GroupedListStyle())
            }
            .navigationBarTitle("Filters", displayMode: .inline)
            .navigationBarItems(leading: cancelButton,
                                trailing: saveButton)
        }
        .onAppear(perform: {
            editedCategoryId = categoryId
            editedBreedId = breedId
        })
    }

    private var breedsProgressView: some View {
        ProgressView()
            .onDisappear {
                withAnimation {
                    if let breedId = self.breedId {
                        print(breedId)
                        print(viewModel.breedsResponse.map { $0.id })
                        breedsPage = viewModel.breedsResponse.firstIndex { $0.id == breedId } ?? 0
                        print(breedsPage)
                    }
                }
            }
    }

    private var categoriesProgressView: some View {
        ProgressView()
            .onDisappear {
                withAnimation {
                    if let categoryId = self.categoryId {
                        categoriesPage = viewModel.categoriesResponse.firstIndex { "\($0.id)" == categoryId } ?? 0
                    }
                }
            }
    }

    private func page(for breed: CatsBreed) -> some View {
        ZStack {
            Rectangle()
                .fill(editedBreedId == breed.id ? Color(white: 0.9, opacity: 1) : Color.white)
            VStack(alignment: .leading, spacing: 3) {
                Text(breed.name)
                    .font(.title2)
                    .bold()
                Text(breed.description)
                Spacer()
            }
            .padding()
        }
        .cornerRadius(5)
        .shadow(radius: 3)
        .onTapGesture {
            withAnimation {
                guard editedBreedId != "\(breed.id)" else {
                    return editedBreedId = nil
                }
                editedBreedId = breed.id
            }
        }
    }

    private func page(for category: CatsCategory) -> some View {
        Image(category.name)
            .resizable()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .aspectRatio(contentMode: .fill)
            .overlay(Circle().stroke(Color.blue, lineWidth: editedCategoryId == "\(category.id)" ? 3 : 1))
            .onTapGesture {
                withAnimation {
                    guard editedCategoryId != "\(category.id)" else {
                        return editedCategoryId = nil
                    }
                    editedCategoryId = "\(category.id)"
                    categoriesPage = viewModel.categoriesResponse.firstIndex(of: category)!
                }
            }
    }

    private var cancelButton: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Cancel")
                .padding()
        })
    }

    private var saveButton: some View {
        Button(action: {
            categoryId = editedCategoryId
            breedId = editedBreedId
            presentationMode.wrappedValue.dismiss()
        }, label: {
            Text("Save")
                .padding()
        })
    }
}

struct CatsFilterView_Previews: PreviewProvider {
    static var previews: some View {
        CatsFilterView(categoryId: .constant(nil),
                       breedId: .constant(nil))
    }
}
