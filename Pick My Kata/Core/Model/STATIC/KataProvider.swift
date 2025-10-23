//
//  KataProvider.swift
//  Pick My Kata
//
//  Created by Diogo Amaral on 21/10/2025.
//

import Foundation

// We create a 'KataProvider' struct to act as a namespace.
// This is cleaner than just having a global variable.
// We can access the list from anywhere in the app by calling 'KataProvider.masterList'.
public struct KataProvider {
    
    // 1. This is our static master list, using the 'KarateStyle' enum
    //    as the key for type-safety and efficiency.
    public static let masterList: [KarateStyle: [String]] = [
        
        // 2. Shotokan List
        .shotokan: [
            "Kihon Kata",
            "Heian Shodan",
            "Heian Nidan",
            "Heian Sandan",
            "Heian Yondan",
            "Heian Godan",
            "Tekki Shodan",
            "Tekki Nidan",
            "Tekki Sandan",
            "Bassai Dai",
            "Bassai Sho",
            "Kanku Dai",
            "Kanku Sho",
            "Jion",
            "Enpi",
            "Gankaku",
            "Hangetsu",
            "Jitte",
            "Chinte",
            "Sochin",
            "Meikyo",
            "Nijushiho",
            "Gojushiho Dai",
            "Gojushiho Sho",
            "Wankan",
            "Unsu",
            "Ji'in"
        ],
        
        // 3. Goju-ryu List
        .gojuRyu: [
            "Sanchin",
            "Tensho",
            "Gekisai Dai Ichi",
            "Gekisai Dai Ni",
            "Saifa",
            "Seiyunchin (Seiunchin)",
            "Shisochin",
            "Sanseru (Sanseiru)",
            "Sepai",
            "Kururunfa",
            "Seisan",
            "Suparinpei (Pecchurin)",
            "Taikyoku Jodan",
            "Taikyoku Chudan",
            "Taikyoku Gedan"
        ],
        
        // 4. Shito-ryu List
        .shitoRyu: [
            "Heian Shodan / Pinan Shodan",
            "Heian Nidan / Pinan Nidan",
            "Heian Sandan / Pinan Sandan",
            "Heian Yondan / Pinan Yondan",
            "Heian Godan / Pinan Godan",
            "Naifanchin Shodan (Naihanchi)",
            "Naifanchin Nidan",
            "Naifanchin Sandan",
            "Juroku",
            "Matsukaze",
            "Jion",
            "Jitte",
            "Ji'in",
            "Wanshu",
            "Rohai",
            "Bassai Dai",
            "Bassai Sho",
            "Tomari Bassai",
            "Matsumura Bassai",
            "Kosokun Dai (Kushanku Dai)",
            "Kosokun Sho (Kushanku Sho)",
            "Shiho Kosokun",
            "Chinto (Gankaku)",
            "Chinte",
            "Gojushiho (Useishi)",
            "Unshu (Unsu)",
            "Sanchin",
            "Tensho",
            "Saifa",
            "Seiyunchin",
            "Shisochin",
            "Sanseru",
            "Sepai",
            "Kururunfa",
            "Seisan",
            "Suparinpei",
            "Nipaipo",
            "Pachu",
            "Heiku",
            "Paiku",
            "Annan",
            "Annanko",
            "Aoyagi (Seiryu)",
            "Niseishi (Nijushiho)",
            "Sochin",
            "Shinpa",
            "Chatanyara Kushanku",
            "Papuren (Hakkaku)"
        ]
    ]
}
