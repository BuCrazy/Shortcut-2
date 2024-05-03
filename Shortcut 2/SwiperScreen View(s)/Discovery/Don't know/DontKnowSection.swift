//
//  Don'tKnowSection.swift
//  Shortcut 2
//
//  Created by Pavlo Bilashchuk on 7/16/23.
//

import SwiftUI

struct Don_tKnowSection: View {
    
    @EnvironmentObject var activityLogDataLayer: ActivityCalendar
    @EnvironmentObject var storedNewWordItemsDataLayer: storedNewWordItems
    @EnvironmentObject var storedStatesDataLayer: storedStates
    
    @AppStorage("currentLevelSelected_key") var currentLevelSelected: String = "elementary"
    
    @Binding var topWords: [NewWordItem]
    @Binding var bottomWords: [NewWordItem]
    @Binding var selectedWordItem: NewWordItem?
    
//    @Binding var bottomWords: [WordItemStruct]
//    @Binding var selectedWordItem: WordItemStruct?
    var body: some View {
        VStack(alignment: .leading) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(bottomWords, id: \.id) { slovo in
                        WordChip(
                            chipWord: slovo.word,
                            onRemove: {
                                withAnimation {
                                    self.bottomWords.removeAll { $0 == slovo }}
                            }, onSwipe: { direction in
                                changeCategory(direction: direction, for: slovo)},
                            location: .bottomWords)
                       // WordChip(chipWord: slovo.word)
                           // .transition(.scale)
                            .onTapGesture {
                                let impact = UIImpactFeedbackGenerator(style: .medium)
                                impact.impactOccurred()
                                selectedWordItem = slovo
                            }
                    }
                }
                .padding(.leading, 20)
                .padding(.vertical,16)
            }
        }
    }
    
    func changeCategory(direction: Direction, for word: NewWordItem) {
        let newItem = NewWordItem(
            id: word.id,
            position_now: word.position_now,
            pos: word.pos,
            word: word.word,
            phonetics: word.phonetics,
            definition: word.definition,
            collocations: word.collocations,
            sentence: word.sentence,
            video: word.video,
            movie: word.movie,
            movie_quote: word.movie_quote,
            dateAdded: Date(),
            timesReviewed: 1,
            grade: 1,
            ukranian: word.ukranian,
            russian: word.russian,
            bulgarian: word.bulgarian,
            chinese: word.chinese,
            czech: word.czech,
            danish: word.danish,
            dutch: word.dutch,
            estonian: word.estonian,
            finnish: word.finnish,
            french: word.french,
            german: word.german,
            greek: word.greek,
            hungarian: word.hungarian,
            indonesian: word.indonesian,
            italian: word.italian,
            japanese: word.japanese,
            korean: word.korean,
            latvian: word.latvian,
            lithuanian: word.lithuanian,
            norwegian: word.norwegian,
            polish: word.polish,
            portuguese: word.portuguese,
            romanian: word.romanian,
            slovak: word.slovak,
            slovenian: word.slovenian,
            spanish: word.spanish,
            swedish: word.swedish,
            turkish: word.turkish
        )
        
        switch direction {
        case .up:
            withAnimation {
                topWords.insert(newItem, at: 0)
                switch currentLevelSelected {
                    case "elementary":
                        storedNewWordItemsDataLayer.elementaryBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.elementaryKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    case "beginner":
                        storedNewWordItemsDataLayer.beginnerBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.beginnerKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    case "intermediate":
                        storedNewWordItemsDataLayer.intermediateBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.intermediateKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    case "advanced":
                        storedNewWordItemsDataLayer.advancedBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.advancedKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    case "nativelike":
                        storedNewWordItemsDataLayer.nativelikeBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.nativelikeKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    case "borninengland":
                        storedNewWordItemsDataLayer.borninenglandBeingLearned.removeAll { item in
                            item.position_now == newItem.position_now
                        }
                        storedNewWordItemsDataLayer.borninenglandKnewAlready.append(wordItemNew(
                            id: newItem.id,
                            position_now: newItem.position_now,
                            word: newItem.word,
                            dateAdded: storedStatesDataLayer.currentDate,
                            timesReviewed: 1,
                            consecutiveCorrectRecalls: 10,
                            progress: 0
                        ))
                    default:
                        print("Default")
                    }
            }
        case .down:
            withAnimation {
                bottomWords.insert(newItem, at: 0)
            }
        }
    }
    
}

struct Don_tKnowSection_Previews: PreviewProvider {
    static var previews: some View {
        let newWordItem = NewWordItem(
            id: 10,
            position_now: 10,
            pos: "pos",
            word: "word",
            phonetics: "phonetics",
            definition: "definition",
            collocations: "collocations",
            sentence: "sentence",
            video: "video",
            movie: "movie",
            movie_quote: "movie_quote",
            dateAdded: Date(),
            timesReviewed: 1,
            grade: 1,
            ukranian: "ukranian",
            russian: "russian",
            bulgarian: "bulgarian",
            chinese: "chinese",
            czech: "czech",
            danish: "danish",
            dutch: "dutch",
            estonian: "estonian",
            finnish: "finnish",
            french: "french",
            german: "german",
            greek: "greek",
            hungarian: "hungarian",
            indonesian: "indonesian",
            italian: "italian",
            japanese: "japanese",
            korean: "korean",
            latvian: "latvian",
            lithuanian: "lithuanian",
            norwegian: "norwegian",
            polish: "polish",
            portuguese: "portuguese",
            romanian: "romanian",
            slovak: "slovak",
            slovenian: "slovenian",
            spanish: "spanish",
            swedish: "swedish",
            turkish: "turkish"
        )
        return Don_tKnowSection(topWords: .constant([newWordItem]) ,bottomWords: .constant([newWordItem]), selectedWordItem: .constant(newWordItem))
//        let wordItem = WordItemStruct(ENAFtransl: "verb: hê", ENAMtransl: "አላቸው", ENARtransl: "verb: ملك, اضطر, حاز, تضمن, اشتمل", ENAZtransl: "verb: olmaq, malik olmaq, içmək, kərkilətdirmək", ENBEtransl: "verb: мець", ENBGtransl: "verb: имам, притежавам, пия, налага се, получавам, ям, прекарвам, разбирам, знам, карам, придобивам, обладавам, раждам, претърпявам, преживявам, излъгвам, побеждавам, позволявам, накарвам, нареждам, поканвам; noun: заможен човек, мошеничество", ENBNtransl: "verb: সহ্য করা, পাত্তয়া, অধিকারে পাত্তয়া, আয়ত্তে পাত্তয়া, অভ্যন্তরে ধারণ করা, অভিজ্ঞতা লাভ করা, উপভোগ করা, ভোগ করা; : অধিকার বা আয়ত্তে পাওয়া", ENBStransl: "verb: imati, posjedovati, nositi, baviti se", ENCAtransl: "verb: tenir", ENCEBtransl: "verb: aduna", ENCOtransl: "avè", ENCStransl: "verb: mít, dostat, vlastnit, obdržet, trpět, dát si, vzít si, porodit, podrobit se čemu, půjčit si, obelstít, konat", ENCYtransl: ": cael, gael, nghael, chael; verb: gân, gânt, gawn, gawsai, gawsant, gawsech, gawsem, gawsent, gawsid, gawsit, gawsoch, gawsom, gawson, gawswn, gefais, gefaist, geffych, gei, geid, geiff, geir, ges, gest, gewch, ca’, caech, caed, caem, caent, caer, caet, caf, cafodd, cafwyd, caffai, caffech, caffed, caffem, caffent, caffer, caffet, caffid, caffit, caffo, caffoch, caffom, caffont, caffwn, caffwyf, câi, caiff, cân, cânt, cawn, cawsai, cawsant, cawsech, cawsem, cawsent, cawsid, cawsit, cawsoch, cawsom, cawson, cawswn, cefais, cefaist, ceffych, cei, ceid, ceiff, ceir, ces, cest, cewch, cha’, chaech, chaed, chaem, chaent, chaer, chaet, chaf, chafodd, chafwyd, chaffai, chaffech, chaffed, chaffem, chaffent, chaffer, chaffet, chaffid, chaffit, chaffo, chaffoch, chaffom, chaffont, chaffwn, chaffwyf, châi, chaiff, chân, chânt, chawn, chawsai, chawsant, chawsech, chawsem, chawsent, chawsid, chawsit, chawsoch, chawsom, chawson, chawswn, chefais, chefaist, cheffych, chei, cheid, cheiff, cheir, ches, chest, chewch, ga’, gaech, gaed, gaem, gaent, gaer, gaet, gaf, gafodd, gafwyd, gaffai, gaffech, gaffed, gaffem, gaffent, gaffer, gaffet, gaffid, gaffit, gaffo, gaffoch, gaffom, gaffont, gaffwn, gaffwyf, gâi, gaiff", ENDAtransl: "verb: have, være, eje", ENDEtransl: "verb: haben, besitzen, verfügen über, sein, machen, bekommen, nehmen, erleben, kriegen, mögen, abhalten", ENELtransl: "verb: έχω, λαμβάνω, αναγκάζομαι, κατέχω, γαμώ", ENEOtransl: "havas", ENEStransl: "verb: tener, haber, tomar, poseer, llevar, padecer, tolerar, echarse, parir, permitir, dar a luz, dormir con, pegar", ENETtransl: "verb: olema, omama, saama, laskma, pidama, evima, sööma, hankima, tüssama, lubama, alt tõmbama, varuks hoidma", ENEUtransl: "verb: eduki", ENFAtransl: "verb: داشتن, دارا بودن, گذاشتن, رسیدن به, دانستن, کردن, مالک بودن, وادار کردن, باعی انجام کاری شدن, صرف کردن, جلب کردن, بدست اوردن, در مقابل دارا, بهره مند شدن از; noun: مالک", ENFItransl: "verb: olla, saada, hankkia, nauttia, syödä, juoda, pitää kiinni, tahtoa, suvaita, olla jklla, viedä voitto jksta, huiputtaa, pettää, saada jku tekemään jtk, antaa tehdä jtk", ENFRtransl: "verb: avoir, posséder, prendre, comporter, tenir, comprendre, être obligé", ENFYtransl: "verb: hawwe", ENGAtransl: "verb: faigh, luigh le, gnéas a bheith agat le", ENGDtransl: "have", ENGLtransl: "verb: ter", ENGUtransl: "verb: પાસે હોવું", ENHAWtransl: "loaʻa", ENHAtransl: "yi", ENHItransl: ": रखना, पास रखना, सहन करना, जरुरत पड़ना; verb: लेना, प्राप्त करना, वश में रखना, ग्रसित होना, बाध्य होना, जानना", ENHMNtransl: "verb: muaj", ENHRtransl: "verb: imati, posjedovati, nositi, baviti se", ENHTtransl: "verb: gen", ENHUtransl: "verb: bír, van valamije, rendelkezik vmivel", ENHYtransl: "verb: ունենալ, ասել, բռնել, տալ, անել տալ", ENIDtransl: "verb: memiliki, punya, mempunyai, ada, mengalami, mendapatkan, mendapat, menemukan, memperoleh, mendapati, ingin, memegang, menyuruh, memberi, berbicara, paham, tdk dpt menjawab, menguraikan, mempersandangkan, mengizinkan, menyajikan", ENIGtransl: "verb: inwe ihe", ENIStransl: "verb: hafa", ENITtransl: "verb: avere, essere, disporre, fare, possedere, ottenere, prendere, ricevere, contare, bere, mangiare, compiere, toccare", ENIWtransl: "verb: לִהיוֹת בַּעַל לְ-, לִהיוֹת לוֹ, לִהיוֹת מוּכְרָח, לָקַחַת, לָלֶדֶת", ENJAtransl: "verb: 受ける, 有る, 帯びる, 居る, 入る, 備える, 含む, つけている, 擁する", ENJWtransl: "duwe", ENKAtransl: "verb: ქონა, ყოლა", ENKKtransl: "verb: бар, болу", ENKMtransl: "verb: មាន", ENKNtransl: ": ಪಡೆದಿರು, ಹೊಂದಿರು; verb: ಅನುಭವಿಸು", ENKOtransl: "verb: 있다, 하다, 가지다, 잡다, 띠다, 하게 하다, 지게 하다, 속이다, 접하다, 시키다, 되다, ...이 있다, ...하지 않으면 안 되다, 경험하다, 해두다, 허용하다", ENKUtransl: "verb: hebûn", ENKYtransl: "бар", ENLAtransl: "verb: habeo, possideo, teneo, utor, gero, debeo, regredior", ENLBtransl: "hunn", ENLOtransl: "verb: ມີ", ENLTtransl: "verb: turėti, gauti, pasirūpinti, patirti, pavesti, žinoti, jausti, laikyti, valgyti, privalėti, reikėti, suprasti, gimdyti, susidėti, norėti, teigti, gerti, sakyti, atsivesti, nugalėti, nenoromis leisti, pakęsti, nutverti, malonėti, apsukti, kąsti, suvalgyti; noun: apgavystė, apgaulė", ENLVtransl: "verb: būt, saņemt, ņemt, likt, dabūt, izjust, uzņemt, dzert, saprast, apgalvot, vajadzēt, uzvarēt, sacīt, uzbaudīt, gūt virsroku, piemānīt, atļaut, pieļaut, pavēlēt; noun: mānīšana, viltus", ENMGtransl: "eFA", ENMItransl: "verb: mau", ENMKtransl: "verb: има", ENMLtransl: "verb: ലഭിക്കുക", ENMNtransl: "verb: -тай/-тэй, -той/-төй", ENMRtransl: ": सहाय्यक क्रियापद म्हणून क्रियापदांचे पूर्णकाळी रूप बनवण्यासाठी वापर", ENMStransl: "verb: mempunyai", ENMTtransl: "verb: kellu", ENMYtransl: "verb: ရှိ", ENNEtransl: "verb: हुनु, राख्नु", ENNLtransl: "auxiliary verb: hebben; verb: hebben, krijgen, bezitten, houden, gebruiken, ontvangen", ENNOtransl: "verb: ha", ENNYtransl: "verb: tanga", ENORtransl: "ଅଛି", ENPAtransl: "ਕੋਲ", ENPLtransl: "verb: mieć, posiadać, dać, miewać, spędzać, chorować, twierdzić, znieść, skosztować, oszukać, dostawać", ENPStransl: "لري", ENPTtransl: "verb: ter, possuir, haver, mandar, receber, produzir, ter de, manter, deixar, sofrer, alcançar, saber, aceitar, permitir, compreender, obrigar, tolerar, entreter, reclamar, afirmar, enganar, reputar", ENROtransl: "verb: avea, trebui, dispune de, face, prezenta, poseda, suferi, cere, solicita, mânca, păstra, şti, stăpâni, zice, exprima, se agăţa, se arunca, ţine minte, adăposti, avea avantaj faţă de, necesita, formula, lua, prinde, a-şi procura", ENRUtransl: "verb: иметь, обладать, получать, содержать, испытывать, проводить, знать, родить, говорить, подвергаться, добиваться, терпеть, понимать, утверждать, позволять, иметь в составе, допускать, обманывать, побеждать, разочаровывать, брать верх, приносить потомство; noun: обман, мошенничество", ENRWtransl: "kugira", ENSDtransl: "وٽ", ENSItransl: "ඇති", ENSKtransl: "verb: mať, vlastniť, byť majiteľom, obsluhovať, prežívať, byť nútený, musieť, pociťovať, dostať, prijímať hosťa, mať hosťa, pozvať, dovoliť, porodiť, prikázať, zapríčiniť, spôsobiť, dať si, vrátiť, usporiadať, oklamať, dobehnúť, rozdať si", ENSLtransl: "verb: imeti", ENSMtransl: "maua", ENSNtransl: "have", ENSOtransl: "verb: haysasho", ENSQtransl: "verb: kam, marr, bëj, mbaj, zotëroj, lind, kam në dorë, di, zë, detyroj, pohoj, kap, hedh", ENSRtransl: "verb: имати, поседовати, носити, бавити се", ENSTtransl: "na le", ENSUtransl: "verb: ngabogaan", ENSVtransl: "verb: ha, få, äga, besitta, hysa, äta, dricka, kunna, förstå, ha fast, lura, tillåta, vilja, ta sig, göra", ENSWtransl: "verb: -wa na/-pata", ENTAtransl: "verb: கொள்; : கொண்டிரு", ENTEtransl: ": కలిగియుండు, పొందియుండు", ENTGtransl: "verb: доштан", ENTHtransl: "verb: มี, ได้, เป็น, ใช้, เอา, กล่าว, ประกอบด้วย, ประสบการณ์, รับประทาน, ยืนยัน, ชนะ, กอปร, ดื่ม, ได้รับ, เอาได้, กินข้าว", ENTKtransl: "bar", ENTLtransl: "verb: may, magkaroon, mayroon, kailanganin, tanggapin, payagan, maunawaan, pumayag, pahintulutan, maintindihan, mangailangan, magpahintulot, tulutan, itulot, magka-, magmay-ari", ENTRtransl: "verb: olmak, sahip olmak, yapmak, etmek, bulunmak, almak, elde etmek, zorunda olmak, kabul etmek, göz yummak, aldatmak, dolandırmak; noun: hile, varlıklı kimse, üçkâğıt, kumpas", ENTTtransl: "бар", ENUGtransl: "have", ENUKtransl: "verb: володіти, мати, приходитися, складатися з, споживати", ENURtransl: "verb: مالک هونا", ENUZtransl: "verb: ega bo'lmoq", ENVItransl: "noun: sự gian lận; verb: có, lường gạt, nhận chắc, qủa quyết", ENXHtransl: "babe", ENYItransl: "verb: האָבן", ENYOtransl: "verb: ni", ENZHCNtransl: "verb: 有, 具有, 拥有, 具备, 有着, 带有, 抱有, 含有, 所有, 占有, 拥, 喝", ENZHTWtransl: "verb: 有, 具有, 擁有, 具備, 有著, 帶有, 抱有, 含有, 所有, 占有, 佔有, 擁, 喝", ENZUtransl: "verb: -ba, -na", id: 8, phonetics: "[hæv]", pos: 2, posalt: 2, posaltspoken: 2, word: "have")
//        return Don_tKnowSection(bottomWords: .constant([wordItem]), selectedWordItem: .constant(wordItem))
    }
}

