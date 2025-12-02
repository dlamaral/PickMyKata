//
//  ConfettiView.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 26/11/2025.
//

import SwiftUI

struct ConfettiParticle: Identifiable {
    let id = UUID()
    let color: Color
    let destX: CGFloat
    let destY: CGFloat
    let size: CGFloat
    let initialRotation: Double
    let spinAmount: Double
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    
    // Animation States
    @State private var explodePhase: Bool = false
    @State private var fadePhase: Bool = false
    
    let colors: [Color] = [.red, .blue, .green, .yellow, .orange, .purple, .pink, .cyan, .mint]
    
    var body: some View {
        ZStack {
            ForEach(particles) { particle in
                Rectangle()
                    .fill(particle.color)
                    .frame(width: particle.size, height: particle.size)
                    // Rotate
                    .rotationEffect(.degrees(particle.initialRotation + (explodePhase ? particle.spinAmount : 0)))
                    // Position (Move from 0,0 to destination)
                    .offset(
                        x: explodePhase ? particle.destX : 0,
                        y: explodePhase ? particle.destY + (fadePhase ? 150 : 0) : 0
                    )
                    // Fade out at the end
                    .opacity(fadePhase ? 0.0 : 1.0)
            }
        }
        // Important: Prevents confetti from blocking taps on buttons below it
        .allowsHitTesting(false)
        .onAppear {
            generateParticles()
            runAnimationSequence()
        }
    }
    
    private func runAnimationSequence() {
        // 1. Explode out immediately
        withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
            explodePhase = true
        }
        
        // 2. Fade out slowly after a short delay
        withAnimation(.easeIn(duration: 1.2).delay(0.2)) {
            fadePhase = true
        }
    }
    
    private func generateParticles() {
        var newParticles: [ConfettiParticle] = []
        
        // 75 particles is a safe number that looks good but won't crash Previews
        for _ in 0..<75 {
            let angle = Double.random(in: 0..<360)
            let distance = CGFloat.random(in: 100...400)
            
            let endX = cos(angle * .pi / 180) * distance
            let endY = sin(angle * .pi / 180) * distance
            
            let particle = ConfettiParticle(
                color: colors.randomElement()!,
                destX: endX,
                destY: endY,
                size: CGFloat.random(in: 6...12),
                initialRotation: Double.random(in: 0...360),
                spinAmount: Double.random(in: 180...720)
            )
            newParticles.append(particle)
        }
        
        self.particles = newParticles
    }
}

#Preview {
    ZStack {
        Color.black.edgesIgnoringSafeArea(.all)
        ConfettiView()
    }
}
