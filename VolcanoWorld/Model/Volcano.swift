//
//  Volcano.swift
//  VolcanoWorld
//
//  Created by Алексей Авер on 13.10.2025.
//


import Foundation

struct Volcano: Identifiable, Hashable, Codable {
    let id: Int
    
    let name: String
    let overview: String
    let mythology: String
    
    var isFavorite: Bool
    
    let status: VolcanoStatus
    let geographic: GeographicData
    
    let quickFacts: [String]
    let eruptionTimeline: [EruptionEvent]
    let historicalOverview: String
    let fascinatingFacts: [String]
    
    let photos: [String]
    var userPhotos: [Data]
}

struct VolcanoStatus: Hashable, Codable {
    let isActive: Bool
    let altitude: String
    let lastEruption: String
    let type: String
}

struct GeographicData: Hashable, Codable {
    let latitude: String
    let longitude: String
    let country: String
}

struct EruptionEvent: Identifiable, Hashable, Codable {
    let id: UUID
    let year: String
    let vei: String
    let description: String
}

let defaultVesuvius: Volcano = {
    Volcano(
        id: 0,
        name: "Mount Vesuvius",
        overview: "Mount Vesuvius is best known for its eruption in AD 79 that destroyed the Roman cities of Pompeii and Herculaneum. It is the only volcano on mainland Europe to have erupted in the last hundred years.",
        mythology: "The Romans believed Vesuvius was sacred to Hercules, and the ancient city at its base was named Herculaneum in his honor.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "1281m",
            lastEruption: "1944",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "40.8214°",
            longitude: "14.4260°",
            country: "Italy"
        ),
        quickFacts: [
            "Destroyed Pompeii and Herculaneum in AD 79",
            "Over 3 million people live in its danger zone",
            "Has erupted more than 50 times since AD 79"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "AD 79",  vei: "VEI 5", description: "Catastrophic Plinian eruption that buried Pompeii"),
            EruptionEvent(id: UUID(), year: "1631",   vei: "VEI 4", description: "Major eruption killed 4,000 people"),
            EruptionEvent(id: UUID(), year: "1906",   vei: "VEI 4", description: "Violent eruption with lava fountains"),
            EruptionEvent(id: UUID(), year: "1944",   vei: "VEI 3", description: "Most recent eruption during WWII")
        ],
        historicalOverview: "Mount Vesuvius is best known for its eruption in AD 79 that destroyed the Roman cities of Pompeii and Herculaneum. It is the only volcano on mainland Europe to have erupted in the last hundred years.",
        fascinatingFacts: [
            "Destroyed Pompeii and Herculaneum in AD 79",
            "Over 3 million people live in its danger zone",
            "Has erupted more than 50 times since AD 79",
            "Part of the Campanian volcanic arc",
            "Considered one of the most dangerous volcanoes in the world"
        ],
        photos: ["vesuvius1", "vesuvius2", "vesuvius3", "vesuvius4", "vesuvius5"],
        userPhotos: []
    )
}()


let defaultFuji: Volcano = {
    Volcano(
        id: 1,
        name: "Mount Fuji",
        overview: "Mount Fuji is Japan's highest mountain and an iconic symbol of the nation. It last erupted in 1707-1708 during the Edo period. The volcano has been worshipped as a sacred mountain and is a UNESCO World Heritage Site.",
        mythology: "In Japanese mythology, Mount Fuji is home to the fire goddess Kagutsuchi. Legends say the mountain appeared overnight in 286 BC after an earthquake.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "3776m",
            lastEruption: "1707–1708",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "35.3606°",
            longitude: "138.7274°",
            country: "Japan"
        ),
        quickFacts: [
            "Japan's highest peak at 3,776 meters",
            "Visible from Tokyo on clear days (100km away)",
            "Sacred mountain in Shinto religion",
            "Climbed by over 300,000 people annually",
            "Featured in countless artworks, including Hokusai's famous prints"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "864–866",   vei: "VEI 4", description: "Jogan eruption created lava flows"),
            EruptionEvent(id: UUID(), year: "1707–1708", vei: "VEI 5", description: "Hōei eruption, most recent activity")
        ],
        historicalOverview: "Mount Fuji is Japan's highest mountain and an iconic symbol of the nation. It last erupted in 1707-1708 during the Edo period. The volcano has been worshipped as a sacred mountain and is a UNESCO World Heritage Site.",
        fascinatingFacts: [
            "Japan's highest peak at 3,776 meters",
            "Visible from Tokyo on clear days (100km away)",
            "Sacred mountain in Shinto religion",
            "Climbed by over 300,000 people annually",
            "Featured in countless artworks, including Hokusai's famous prints"
        ],
        photos: ["fuji1", "fuji2", "fuji3", "fuji4", "fuji5"],
        userPhotos: []
    )
}()


let defaultKrakatoa: Volcano = {
    Volcano(
        id: 2,
        name: "Krakatoa",
        overview: "Krakatoa is infamous for its catastrophic 1883 eruption, one of the deadliest and most destructive volcanic events in recorded history. The explosion was heard 3,000 miles away and created tsunamis that killed over 36,000 people.",
        mythology: "Local legends speak of a divine battle between two mountains, Krakatoa and nearby Rajabasa, that ended in a catastrophic explosion.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "813m",
            lastEruption: "2020",
            type: "Caldera"
        ),
        geographic: GeographicData(
            latitude: "-6.1020°",
            longitude: "105.4230°",
            country: "Indonesia"
        ),
        quickFacts: [
            "1883 eruption was one of the loudest sounds in history",
            "The explosion was heard in Australia, 3,000 miles away",
            "Generated tsunamis up to 40 meters high",
            "Lowered global temperatures by 1.2°C for a year",
            "Anak Krakatau (\"Child of Krakatoa\") emerged in 1927"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "1883", vei: "VEI 6", description: "Catastrophic eruption heard worldwide"),
            EruptionEvent(id: UUID(), year: "1927", vei: "VEI 2", description: "Birth of Anak Krakatau"),
            EruptionEvent(id: UUID(), year: "2018", vei: "VEI 3", description: "Major eruption and tsunami"),
            EruptionEvent(id: UUID(), year: "2020", vei: "VEI 2", description: "Recent volcanic activity")
        ],
        historicalOverview: "Krakatoa is infamous for its catastrophic 1883 eruption, one of the deadliest and most destructive volcanic events in recorded history. The explosion was heard 3,000 miles away and created tsunamis that killed over 36,000 people.",
        fascinatingFacts: [
            "1883 eruption was one of the loudest sounds in history",
            "The explosion was heard in Australia, 3,000 miles away",
            "Generated tsunamis up to 40 meters high",
            "Lowered global temperatures by 1.2°C for a year",
            "Anak Krakatau (\"Child of Krakatoa\") emerged in 1927"
        ],
        photos: ["krakatoa1", "krakatoa2", "krakatoa3", "krakatoa4", "krakatoa5"],
        userPhotos: []
    )
}()


let defaultMaunaLoa: Volcano = {
    Volcano(
        id: 3,
        name: "Mauna Loa",
        overview: "Mauna Loa is the world's largest active volcano by volume and area. It makes up about half of the Big Island of Hawaii and has erupted 33 times since 1843. Its lava flows are typically fluid and relatively non-explosive.",
        mythology: "In Hawaiian mythology, Mauna Loa is home to Pele, the goddess of fire and volcanoes, who is said to create land by flowing lava.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "4169m",
            lastEruption: "2022",
            type: "Shield Volcano"
        ),
        geographic: GeographicData(
            latitude: "19.4750°",
            longitude: "-155.6082°",
            country: "United States (Hawaii)"
        ),
        quickFacts: [
            "Largest volcano on Earth by volume (75,000 km³)",
            "Makes up 51% of the Big Island of Hawaii",
            "Summit is 4,169 meters above sea level",
            "Base is about 5,000 meters below sea level",
            "Has erupted an average of once every 6 years since 1843"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "1950", vei: "VEI 3", description: "Largest eruption in modern times"),
            EruptionEvent(id: UUID(), year: "1984", vei: "VEI 2", description: "Three-week eruption threatening Hilo"),
            EruptionEvent(id: UUID(), year: "2022", vei: "VEI 2", description: "First eruption in 38 years")
        ],
        historicalOverview: "Mauna Loa is the world's largest active volcano by volume and area. It makes up about half of the Big Island of Hawaii and has erupted 33 times since 1843. Its lava flows are typically fluid and relatively non-explosive.",
        fascinatingFacts: [
            "Largest volcano on Earth by volume (75,000 km³)",
            "Makes up 51% of the Big Island of Hawaii",
            "Summit is 4,169 meters above sea level",
            "Base is about 5,000 meters below sea level",
            "Has erupted an average of once every 6 years since 1843"
        ],
        photos: ["maunaloa1", "maunaloa2", "maunaloa3", "maunaloa4", "maunaloa5"],
        userPhotos: []
    )
}()


let defaultEtna: Volcano = {
    Volcano(
        id: 4,
        name: "Mount Etna",
        overview: "Mount Etna is Europe's most active volcano and one of the world's most active. It has been erupting for approximately 500,000 years and has produced more lava than any other volcano in the world.",
        mythology: "Greek mythology places the forge of Hephaestus, god of fire and metalworking, beneath Mount Etna. The giant Typhon was also said to be trapped underneath.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "3357m",
            lastEruption: "2024",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "37.7510°",
            longitude: "14.9934°",
            country: "Italy (Sicily)"
        ),
        quickFacts: [
            "Europe's highest and most active volcano",
            "Has four distinct summit craters",
            "Produces spectacular lava fountains regularly",
            "UNESCO World Heritage Site since 2013",
            "Ancient Greeks believed it was the forge of Hephaestus"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "1669", vei: "VEI 3", description: "Most destructive eruption, destroyed Catania"),
            EruptionEvent(id: UUID(), year: "2002", vei: "VEI 2", description: "Major eruption with lava fountains"),
            EruptionEvent(id: UUID(), year: "2021", vei: "VEI 2", description: "Spectacular paroxysmal eruptions"),
            EruptionEvent(id: UUID(), year: "2024", vei: "VEI 2", description: "Ongoing volcanic activity")
        ],
        historicalOverview: "Mount Etna is Europe's most active volcano and one of the world's most active. It has been erupting for approximately 500,000 years and has produced more lava than any other volcano in the world.",
        fascinatingFacts: [
            "Europe's highest and most active volcano",
            "Has four distinct summit craters",
            "Produces spectacular lava fountains regularly",
            "UNESCO World Heritage Site since 2013",
            "Ancient Greeks believed it was the forge of Hephaestus"
        ],
        photos: ["etna1", "etna2", "etna3", "etna4", "etna5"],
        userPhotos: []
    )
}()


let defaultEyjafjallajokull: Volcano = {
    Volcano(
        id: 5,
        name: "Eyjafjallajokull",
        overview: "This Icelandic volcano became world-famous in 2010 when its eruption produced a massive ash cloud that disrupted air travel across Europe for six days, affecting 10 million travelers.",
        mythology: "Icelandic sagas speak of fire and ice being in constant battle, with volcanoes representing the primordial fire beneath the frozen land.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "1651m",
            lastEruption: "2010",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "63.6333°",
            longitude: "-19.6333°",
            country: "Iceland"
        ),
        quickFacts: [
            "Name means \"island mountain glacier\"",
            "2010 eruption disrupted European air travel for a week",
            "Covered by an ice cap about 100 km²",
            "One of Iceland's smaller ice caps",
            "Ash cloud reached heights of 9 km"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "920",        vei: "VEI 4", description: "Large eruption in medieval times"),
            EruptionEvent(id: UUID(), year: "1821–1823",  vei: "VEI 2", description: "Extended eruption period"),
            EruptionEvent(id: UUID(), year: "2010",       vei: "VEI 4", description: "Famous ash cloud eruption")
        ],
        historicalOverview: "This Icelandic volcano became world-famous in 2010 when its eruption produced a massive ash cloud that disrupted air travel across Europe for six days, affecting 10 million travelers.",
        fascinatingFacts: [
            "Name means \"island mountain glacier\"",
            "2010 eruption disrupted European air travel for a week",
            "Covered by an ice cap about 100 km²",
            "One of Iceland's smaller ice caps",
            "Ash cloud reached heights of 9 km"
        ],
        photos: ["eyjafjallajokull1", "eyjafjallajokull2", "eyjafjallajokull3", "eyjafjallajokull4", "eyjafjallajokull5"],
        userPhotos: []
    )
}()


let defaultStHelens: Volcano = {
    Volcano(
        id: 6,
        name: "Mount St. Helens",
        overview: "Mount St. Helens is best known for its catastrophic eruption on May 18, 1980, which was the deadliest and most economically destructive volcanic event in U.S. history. The eruption reduced the mountain's height by 400 meters.",
        mythology: "Native American legends tell of a battle between two warrior gods that created the mountain and its destructive power.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "2549m",
            lastEruption: "2008",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "46.1914°",
            longitude: "-122.1956°",
            country: "United States (Washington)"
        ),
        quickFacts: [
            "1980 eruption killed 57 people",
            "Lost 400 meters of elevation in the eruption",
            "Lateral blast traveled at 300 mph",
            "Destroyed 250 homes and 47 bridges",
            "Most active volcano in the Cascade Range"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "1800",       vei: "VEI 5", description: "Major eruption in modern era"),
            EruptionEvent(id: UUID(), year: "1980",       vei: "VEI 5", description: "Catastrophic lateral blast"),
            EruptionEvent(id: UUID(), year: "2004–2008",  vei: "VEI 2", description: "Dome-building eruptions")
        ],
        historicalOverview: "Mount St. Helens is best known for its catastrophic eruption on May 18, 1980, which was the deadliest and most economically destructive volcanic event in U.S. history. The eruption reduced the mountain's height by 400 meters.",
        fascinatingFacts: [
            "1980 eruption killed 57 people",
            "Lost 400 meters of elevation in the eruption",
            "Lateral blast traveled at 300 mph",
            "Destroyed 250 homes and 47 bridges",
            "Most active volcano in the Cascade Range"
        ],
        photos: ["sthelens1", "sthelens2", "sthelens3", "sthelens4", "sthelens5"],
        userPhotos: []
    )
}()


let defaultPopocatepetl: Volcano = {
    Volcano(
        id: 7,
        name: "Popocatepetl",
        overview: "Known affectionately as \"El Popo,\" this volcano has been continuously active since 1994. It is one of Mexico's most active volcanoes and lies just 70 km from Mexico City, home to over 20 million people.",
        mythology: "Aztec legend tells of the warrior Popocatépetl and his love Iztaccíhuatl, who were transformed into mountains by the gods.",
        isFavorite: false,
        status: VolcanoStatus(
            isActive: true,
            altitude: "5426m",
            lastEruption: "2024",
            type: "Stratovolcano"
        ),
        geographic: GeographicData(
            latitude: "19.0225°",
            longitude: "-98.6278°",
            country: "Mexico"
        ),
        quickFacts: [
            "Second-highest peak in Mexico",
            "Name means \"smoking mountain\" in Nahuatl",
            "Over 25 million people live within its threat zone",
            "Has had over 20 major eruptions since 1519",
            "Continuously monitored by scientists"
        ],
        eruptionTimeline: [
            EruptionEvent(id: UUID(), year: "1519", vei: "VEI 3", description: "Eruption witnessed by Cortés"),
            EruptionEvent(id: UUID(), year: "1947", vei: "VEI 3", description: "Major 20th century eruption"),
            EruptionEvent(id: UUID(), year: "2000", vei: "VEI 3", description: "Large eruption forcing evacuations"),
            EruptionEvent(id: UUID(), year: "2024", vei: "VEI 2", description: "Ongoing activity with ash emissions")
        ],
        historicalOverview: "Known affectionately as \"El Popo,\" this volcano has been continuously active since 1994. It is one of Mexico's most active volcanoes and lies just 70 km from Mexico City, home to over 20 million people.",
        fascinatingFacts: [
            "Second-highest peak in Mexico",
            "Name means \"smoking mountain\" in Nahuatl",
            "Over 25 million people live within its threat zone",
            "Has had over 20 major eruptions since 1519",
            "Continuously monitored by scientists"
        ],
        photos: ["popocatepetl1", "popocatepetl2", "popocatepetl3", "popocatepetl4", "popocatepetl5"],
        userPhotos: []
    )
}()

let defaultVolcanoes: [Volcano] = [
    defaultVesuvius,
    defaultFuji,
    defaultKrakatoa,
    defaultMaunaLoa,
    defaultEtna,
    defaultEyjafjallajokull,
    defaultStHelens,
    defaultPopocatepetl
]
