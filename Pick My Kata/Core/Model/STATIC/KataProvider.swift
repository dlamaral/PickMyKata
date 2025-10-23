//
//  KataProvider.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation

public struct KataProvider {
    
    public static let masterList: [KarateStyle: [Kata]] = [
        
        // MARK: - Shotokan
        .shotokan: [
            Kata(name: "Taikyoku Shodan", description: "The first basic kata created by Gichin Funakoshi to teach beginners the foundation of stance, direction changes, and linear power generation.", difficulty: .beginner),
            Kata(name: "Heian Shodan", description: "Introduces fundamental blocks, punches, and hip rotation. Emphasizes strong stances and coordination of basic defense-offense sequences.", difficulty: .beginner),
            Kata(name: "Heian Nidan", description: "Builds on Shodan with higher coordination and fluid transitions, introducing front kicks and more dynamic movement.", difficulty: .beginner),
            Kata(name: "Heian Sandan", description: "Focuses on lateral movement and body shifting with a mixture of inside and outside blocks to develop agility and balance.", difficulty: .beginner),
            Kata(name: "Heian Yondan", description: "Introduces more advanced techniques like double blocks and combinations that enhance timing and control.", difficulty: .intermediate),
            Kata(name: "Heian Godan", description: "Complex Heian kata emphasizing jumping, multi-directional defense, and rapid stance changes.", difficulty: .intermediate),
            Kata(name: "Tekki Shodan", description: "Practiced entirely in kiba-dachi (horse stance), emphasizing strong hips, stability, and close-range defensive movements.", difficulty: .intermediate),
            Kata(name: "Tekki Nidan", description: "Expands on Tekki Shodan with more intricate hand techniques and increased rhythm control while maintaining a rooted stance.", difficulty: .intermediate),
            Kata(name: "Tekki Sandan", description: "Final Tekki kata focusing on advanced body mechanics and transitions, representing mastery of close-range combat forms.", difficulty: .advanced),
            Kata(name: "Bassai Dai", description: "Meaning 'to storm a fortress,' this kata develops power and explosive transitions, emphasizing breaking through defensive positions.", difficulty: .intermediate),
            Kata(name: "Bassai Sho", description: "A shorter, lighter variation of Bassai Dai with more circular and deceptive movements.", difficulty: .advanced),
            Kata(name: "Kanku Dai", description: "Translates to 'viewing the sky.' It is a long and dynamic kata combining defense, counterattack, and rhythm variation.", difficulty: .advanced),
            Kata(name: "Kanku Sho", description: "Derived from Kanku Dai, this kata features agile techniques and quick transitions suited for tournament performance.", difficulty: .advanced),
            Kata(name: "Jion", description: "Characterized by steady rhythm and powerful basic techniques, symbolizing traditional Buddhist temple discipline.", difficulty: .intermediate),
            Kata(name: "Enpi", description: "Meaning 'flying swallow,' it emphasizes speed, jumping, and dynamic directional changes.", difficulty: .advanced),
            Kata(name: "Gankaku", description: "Originally Chinto, this kata focuses on balance, precision, and one-legged stances resembling a crane’s motion.", difficulty: .advanced),
            Kata(name: "Hangetsu", description: "Translates to 'half-moon.' Combines slow tension breathing with strong circular techniques, promoting internal power.", difficulty: .advanced),
            Kata(name: "Jitte", description: "Meaning 'ten hands,' it prepares the practitioner to defend against multiple opponents with solid stances and redirections.", difficulty: .advanced),
            Kata(name: "Chinte", description: "A feminine kata featuring circular, soft movements ending with distinctive returning hand techniques.", difficulty: .advanced),
            Kata(name: "Sochin", description: "Powerful kata emphasizing rooted stances and internal tension, reflecting strong spirit and stability.", difficulty: .advanced),
            Kata(name: "Meikyo", description: "Meaning 'bright mirror,' symbolizing clarity and reflection. Includes flowing arm movements and smooth transitions.", difficulty: .advanced),
            Kata(name: "Nijushiho", description: "Translates to '24 steps.' It combines fluidity and explosive bursts, emphasizing advanced timing and control.", difficulty: .advanced),
            Kata(name: "Gojushiho Dai", description: "Composed of 54 movements, it demands precision and advanced rhythm. Known for dynamic finger and open-hand techniques.", difficulty: .master),
            Kata(name: "Gojushiho Sho", description: "A shorter and faster version of Gojushiho Dai with quick directional shifts and deceptive hand actions.", difficulty: .master),
            Kata(name: "Wankan", description: "A short kata meaning 'King’s Crown,' emphasizing timing, fluidity, and effective use of minimal movement.", difficulty: .intermediate),
            Kata(name: "Unsu", description: "Meaning 'cloud hands,' this is one of Shotokan’s most advanced kata, known for spinning jumps, fluidity, and high technical mastery.", difficulty: .master),
            Kata(name: "Ji'in", description: "A sister kata to Jion and Jitte, emphasizing strong hip control, defensive timing, and rooted stances.", difficulty: .advanced)
        ],
        
        // MARK: - Goju-ryu
        .gojuRyu: [
            Kata(name: "Sanchin", description: "Meaning 'three battles'—body, mind, and spirit. The foundational kata of Goju-ryu emphasizing breathing control, posture, and inner strength through tension and rooted movement.", difficulty: .beginner),
            Kata(name: "Tensho", description: "The soft counterpart to Sanchin, focusing on circular, flowing hand techniques and deep breathing to cultivate relaxed power and fluid transitions.", difficulty: .intermediate),
            Kata(name: "Gekisai Dai Ichi", description: "Created to introduce Goju-ryu principles to beginners, it blends hard and soft techniques, emphasizing strong stances and simple defensive applications.", difficulty: .beginner),
            Kata(name: "Gekisai Dai Ni", description: "Builds on Gekisai Dai Ichi, introducing open-hand movements and more circular techniques to balance offense and defense.", difficulty: .beginner),
            Kata(name: "Saifa", description: "Meaning 'to tear and destroy,' it introduces whipping hand techniques and rapid transitions between offense and defense.", difficulty: .intermediate),
            Kata(name: "Seiyunchin (Seiunchin)", description: "Focuses on stability, powerful stances, and close-range grappling-like motions, developing control and grounded strength.", difficulty: .intermediate),
            Kata(name: "Shisochin", description: "Translates to 'four directions of conflict,' combining both soft and hard energy to enhance body control and awareness.", difficulty: .advanced),
            Kata(name: "Sanseru (Sanseiru)", description: "Meaning '36 hands,' emphasizing short, rapid movements and breath synchronization for close combat efficiency.", difficulty: .advanced),
            Kata(name: "Sepai", description: "Translates to '18 hands.' It features circular defenses and redirection of force, embodying Goju-ryu’s blend of hardness and softness.", difficulty: .advanced),
            Kata(name: "Kururunfa", description: "Means 'holding on long and striking suddenly.' Characterized by fast-slow rhythm changes and deceptive timing for close-range fighting.", difficulty: .advanced),
            Kata(name: "Seisan", description: "Meaning '13 hands,' one of the oldest Okinawan kata, developing precise balance, breathing, and coordinated offensive-defensive flow.", difficulty: .advanced),
            Kata(name: "Suparinpei (Pecchurin)", description: "The most advanced Goju-ryu kata with 108 movements, representing mastery of circular motion, breath control, and mental focus.", difficulty: .master),
            Kata(name: "Taikyoku Jodan", description: "A simple kata emphasizing high-level strikes and basic directional changes, designed for beginners to grasp fundamental mechanics.", difficulty: .beginner),
            Kata(name: "Taikyoku Chudan", description: "Centers on mid-level attacks and defenses to develop stability and precision of movement in core techniques.", difficulty: .beginner),
            Kata(name: "Taikyoku Gedan", description: "Focuses on low-level blocks and stances, improving hip engagement and foundational defense for new practitioners.", difficulty: .beginner)
        ],
        
        // MARK: - Shito-ryu
        .shitoRyu: [
            Kata(name: "Heian Shodan / Pinan Shodan", description: "Introduces fundamental movements, balance, and directional changes. Builds coordination and awareness of defensive techniques.", difficulty: .beginner),
            Kata(name: "Heian Nidan / Pinan Nidan", description: "Focuses on transitioning between offense and defense with precision, adding more complex timing and stances.", difficulty: .beginner),
            Kata(name: "Heian Sandan / Pinan Sandan", description: "Develops coordination between upper and lower body, emphasizing simultaneous block-strike combinations.", difficulty: .beginner),
            Kata(name: "Heian Yondan / Pinan Yondan", description: "Introduces advanced stance control and changes in rhythm to develop versatility in defensive applications.", difficulty: .intermediate),
            Kata(name: "Heian Godan / Pinan Godan", description: "Emphasizes fluid transitions and multidirectional awareness, preparing practitioners for advanced kata complexity.", difficulty: .intermediate),
            Kata(name: "Naifanchin Shodan (Naihanchi)", description: "Trains rooted stances and lateral movement for stability and close-range defense using powerful hip control.", difficulty: .intermediate),
            Kata(name: "Naifanchin Nidan", description: "Builds on Shodan with refined hip rotation and application of counterattacks in narrow movement paths.", difficulty: .intermediate),
            Kata(name: "Naifanchin Sandan", description: "Advances control of timing and dynamic tension, teaching short-range striking power and structure.", difficulty: .advanced),
            Kata(name: "Juroku", description: "A short kata emphasizing coordination of upper and lower body through smooth transitions and controlled breathing.", difficulty: .intermediate),
            Kata(name: "Matsukaze", description: "Focuses on circular defense and quick counterattack combinations, integrating soft and hard energy.", difficulty: .intermediate),
            Kata(name: "Jion", description: "Symbolic for its calm and deliberate rhythm, emphasizing strong stances, timing, and powerful basic techniques.", difficulty: .advanced),
            Kata(name: "Jitte", description: "Trains against staff attacks conceptually, emphasizing defense and countering through strong arm and hip movements.", difficulty: .advanced),
            Kata(name: "Ji'in", description: "Combines symmetry, control, and spiritual focus through smooth defensive transitions and strong posture.", difficulty: .advanced),
            Kata(name: "Wanshu", description: "Features fast throws and sudden changes in direction, developing agility and explosive counterattacks.", difficulty: .intermediate),
            Kata(name: "Rohai", description: "Known for its one-legged balance techniques and refined hand strikes, enhancing coordination and focus.", difficulty: .advanced),
            Kata(name: "Bassai Dai", description: "Meaning 'to penetrate a fortress,' it develops explosive power and assertive movement through linear attacks.", difficulty: .advanced),
            Kata(name: "Bassai Sho", description: "A more subtle version emphasizing fluidity and evasion rather than direct force.", difficulty: .advanced),
            Kata(name: "Tomari Bassai", description: "Focuses on sharp timing and rhythm variations, characteristic of the Tomari lineage.", difficulty: .advanced),
            Kata(name: "Matsumura Bassai", description: "An older variant stressing fast, decisive action and dynamic tension.", difficulty: .advanced),
            Kata(name: "Kosokun Dai (Kushanku Dai)", description: "One of the most complex kata, teaching expansive movement and long-range strategy with smooth transitions.", difficulty: .advanced),
            Kata(name: "Kosokun Sho (Kushanku Sho)", description: "A compact version focusing on circular defenses and precision in short sequences.", difficulty: .advanced),
            Kata(name: "Shiho Kosokun", description: "Develops awareness in four directions and quick reorientation under pressure.", difficulty: .advanced),
            Kata(name: "Chinto (Gankaku)", description: "Emphasizes balance and angled attacks, mimicking combat on uneven ground.", difficulty: .advanced),
            Kata(name: "Chinte", description: "Blends soft, circular hand techniques with unusual rhythm and balance challenges.", difficulty: .advanced),
            Kata(name: "Gojushiho (Useishi)", description: "Features intricate hand techniques and rhythm changes to enhance dexterity and precision.", difficulty: .master),
            Kata(name: "Unshu (Unsu)", description: "A dynamic kata incorporating jumping and spinning techniques symbolizing adaptability and flow.", difficulty: .master),
            Kata(name: "Sanchin", description: "Centers on dynamic tension and breathing for developing internal strength and body alignment.", difficulty: .beginner),
            Kata(name: "Tensho", description: "Highlights the soft, flowing aspect of Goju influence with coordinated breathing and open-hand control.", difficulty: .intermediate),
            Kata(name: "Saifa", description: "Introduces circular blocking and explosive strikes to develop offensive rhythm and flow.", difficulty: .intermediate),
            Kata(name: "Seiyunchin", description: "Focuses on strong stances and grappling principles to reinforce grounded power and precision.", difficulty: .advanced),
            Kata(name: "Shisochin", description: "Emphasizes four-directional balance and contrast between fast and slow movements.", difficulty: .advanced),
            Kata(name: "Sanseru", description: "Uses compact movements for short-range combat, blending soft and hard responses.", difficulty: .advanced),
            Kata(name: "Sepai", description: "Integrates open-hand defenses and rhythm changes to teach control of distance and timing.", difficulty: .advanced),
            Kata(name: "Kururunfa", description: "Combines quick directional shifts and explosive short-range counters.", difficulty: .advanced),
            Kata(name: "Seisan", description: "Trains balance, breathing, and power delivery across linear and circular motions.", difficulty: .advanced),
            Kata(name: "Suparinpei", description: "The most advanced kata, symbolizing completeness through long, intricate patterns.", difficulty: .master),
            Kata(name: "Nipaipo", description: "Introduces short, powerful bursts of energy and rapid technique changes.", difficulty: .advanced),
            Kata(name: "Pachu", description: "Develops soft redirection and fluid transitions in mid-range combat.", difficulty: .advanced),
            Kata(name: "Heiku", description: "Focuses on timing, control, and redirection through circular, flowing movements.", difficulty: .advanced),
            Kata(name: "Paiku", description: "Combines precise hand strikes with dynamic stances, demanding control and balance.", difficulty: .advanced),
            Kata(name: "Annan", description: "Characterized by open-hand movements and high agility, symbolizing adaptability.", difficulty: .advanced),
            Kata(name: "Annanko", description: "A variant emphasizing rhythm, breathing, and coordination of both hard and soft elements.", difficulty: .advanced),
            Kata(name: "Aoyagi (Seiryu)", description: "Named 'Blue Dragon,' this kata refines soft redirection and smooth transitions.", difficulty: .advanced),
            Kata(name: "Niseishi (Nijushiho)", description: "Features fluid circular transitions and techniques to harmonize breathing and movement.", difficulty: .advanced),
            Kata(name: "Sochin", description: "Demands strong posture and controlled breathing to express firmness and inner focus.", difficulty: .master),
            Kata(name: "Shinpa", description: "Modern kata emphasizing rhythm and dynamic expansion of energy in short bursts.", difficulty: .advanced),
            Kata(name: "Chatanyara Kushanku", description: "A sophisticated variant of Kushanku with expansive, expressive movement and speed control.", difficulty: .master),
            Kata(name: "Papuren (Hakkaku)", description: "Blends grace and precision through slow, deliberate breathing and fluid transitions.", difficulty: .master)
        ]
    ]
}
