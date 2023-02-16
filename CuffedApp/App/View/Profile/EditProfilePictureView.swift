//
//  EditProfilePicture.swift
//  CuffedApp
//
//  Created by Jonathan on 15/2/23.
//

import SwiftUI

struct EditProfilePictureView: View {
    
    @State private var scale: CGFloat = 1
    @State private var lastScale: CGFloat = 0
    @State private var offset: CGSize = .zero
    @State private var lastStoredOfsset: CGSize = .zero
    @Binding var image: UIImage?
    @GestureState private var isInteracting: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    var crop: CropImageType = .circle
    var onCrop: (UIImage?, Data?) -> Void
    
    var body: some View {
        
        NavigationStack {
            
            GeometryReader { geometry in
                
                imageView()
                    .navigationTitle(Strings.profilePicture)
                    .navigationBarTitleDisplayMode(.inline)
                    .toolbarBackground(.visible, for: .navigationBar)
                    .toolbarBackground(Color.black, for: .navigationBar)
                    .toolbarColorScheme(.dark, for: .navigationBar)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(content: {
                        OverView(geometry: geometry)
                    })
                    .toolbar {
                        
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                let renderer = ImageRenderer(content: imageView(true))
                                renderer.proposedSize = .init(crop.size())
                                
                                if let image = renderer.uiImage {
                                    let imageData = image.pngData()
                                    onCrop(image, imageData)
                                } else {
                                    onCrop(nil, nil)
                                }
                                
                                dismiss()
                            } label: {
                                Image(systemName: Strings.checkMark)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                        
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button {
                                dismiss()
                            } label: {
                                Image(systemName: Strings.xMark)
                                    .font(.caption)
                                    .fontWeight(.semibold)
                            }
                        }
                    }
            }
        }
    }
    
    @ViewBuilder
    func imageView(
        _ hideGrids: Bool = false
    ) -> some View {
        
        let cropSize = crop.size()
        
        GeometryReader {
            
            let size = $0.size
            if let image {
                
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .overlay(content: {
                        
                        GeometryReader { proxy in
                            
                            let rect = proxy.frame(in: .named(Strings.cropView))
                            Color.clear
                                .onChange(of: isInteracting) { newValue in
                                    withAnimation(.easeOut(duration: 0.2)) {
                                        
                                        if rect.minX > 0 {
                                            offset.width = (offset.width - rect.minX)
                                            haptics(.medium)
                                        }
                                        if rect.minY > 0 {
                                            offset.height = (offset.height - rect.minY)
                                            haptics(.medium)
                                        }
                                        if rect.maxX < size.width {
                                            offset.width = (rect.minX - offset.width)
                                            haptics(.medium)
                                        }
                                        if rect.maxY < size.height {
                                            offset.height = (rect.minY - offset.height)
                                            haptics(.medium)
                                        }
                                    }
                                    if !newValue {
                                        lastStoredOfsset = offset
                                    }
                                }
                        }
                    })
                    .frame(size)
            }
        }
        .scaleEffect(scale)
        .offset(offset)
        .coordinateSpace(name: Strings.cropView)
        .gesture(
            DragGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let translation = value.translation
                    offset = CGSize(
                        width: translation.width + lastStoredOfsset.width,
                        height: translation.height + lastStoredOfsset.height
                    )
                })
        )
        .gesture(
            MagnificationGesture()
                .updating($isInteracting, body: { _, out, _ in
                    out = true
                })
                .onChanged({ value in
                    let updateScale = value + lastScale
                    scale = (updateScale < 1 ? 1 : updateScale)
                })
                .onEnded({ _ in
                    withAnimation(.easeOut(duration: 0.2)) {
                        if scale < 1 {
                            scale = 1
                            lastScale = 0
                        } else {
                            lastScale = scale - 1
                        }
                    }
                })
        )
        .frame(cropSize)
        .cornerRadius(crop == .circle ? cropSize.height / 2 : 0 )
    }
}

struct EditProfilePicture_Previews: PreviewProvider {
    
    static var previews: some View {
        
        EditProfilePictureView(
            image: .constant(UIImage()), onCrop: { _, _ in}
        )
    }
}
