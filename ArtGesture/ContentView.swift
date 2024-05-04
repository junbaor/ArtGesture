//
//  ContentView.swift
//  ArtGesture
//
//  Created by junbaor on 2024/5/4.
//

import SwiftUI

/**
 问题：
        图片在 ScrollView 中可以单指左右移动，也可以双指缩放。
        但双指缩放的优先级比较低，用户想缩放时大概率不是两个手指同时接触屏幕，容易就会被识别为移动，导致缩放很难被触发

 期望：
        单指拖动时，一旦屏幕多一个手指，就中断移动手势，判定为缩放
 */
struct ContentView: View {
    
    @State var lastScale = 1.0
    @State var scale = 1.0

    var body: some View {
        VStack {
            ScrollView([.horizontal, .vertical], showsIndicators: false){
                Image("test_image")
                    .resizable()
                    .aspectRatio(contentMode:.fill)
                    .frame(width: 400 * scale, height: 400 * scale)
                    .clipped()
                    .border(Color.yellow)
            }
            .frame(width: 300, height: 300)
            .highPriorityGesture (
                 MagnificationGesture()
                    .onChanged { value in
                        let tempScale = lastScale * value.magnitude
                        
                        // 不要缩的比预期小
                        if (tempScale < 1) {
                            return
                        }
                        
                        scale = lastScale * value.magnitude
                    }
                    .onEnded { value in
                        lastScale = scale
                    }
            )
            .border(Color.red)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
