//
//  UpdateItemView.swift
//  usebetter
//
//  Created by Prashanth Jaligama on 5/20/22.
//

import Foundation
import SwiftUI

struct ReadOnlyItemView: View {
    @State var item: UBItem
    @State private var itemName: String = ""
    @State private var itemCount: String = "1"
    @EnvironmentObject var userFeedData: UserFeedModel
    
    var body: some View {
        ZStack(alignment: .top) {
            VStack {
                Spacer()
                    .frame(height: 50)
                if let imageURL = item.imageURL {
                    AsyncImage(url: URL(string: imageURL)) { image1 in
                        image1.resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120,  alignment: .center)
                    } placeholder: {
                        ProgressView()
                    }
                }
                else {
                    AsyncImage(url: URL(string: "notAvailable")) { image1 in
                        image1.resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 120,  alignment: .center)
                    } placeholder: {
                        ProgressView()
                    }
                }
                
                Spacer()
                    .frame(height: 50)
                Text(item.name)
                    .frame(width: 400)
                
                HStack {
                    Text("Tags:")
                    Text(item.getTags)
                }
                .padding(20)
                
                HStack {
                    Text("Available Counts: ")
                    Text(item.itemCount)
                       .frame(width: 50)
                }
                Spacer().frame(height: 50)
                HStack {
                   
                    Text("shared By: ")
                    Text("David").frame(width:150)
                        .foregroundColor(.green)
                        .font(.callout)
                    
                }
                Spacer().frame(height: 50)
                Button("Request To Use Better", action: {
                    print("Item requested")
                })
                .font(.subheadline)
            }
            .frame(minWidth: 0, maxHeight: .infinity, alignment: .topLeading)
            .padding(5)
        }
        .navigationBarTitle("View Item", displayMode: .inline)
        .edgesIgnoringSafeArea([.bottom])
    }
}


struct ReadOnlyItemView_Previews: PreviewProvider {
    static var previews: some View {
        ReadOnlyItemView(item: UBItem(name: "Some long name to see"))
    }
}
