#!/bin/bash

identifiers=("ar.jalalayn" "ar.muyassar" "az.mammadaliyev" "az.musayev" "bg.theophanov" "bn.bengali" "bs.korkut" "bs.mlivo" "cs.hrbek" "cs.nykl" "de.aburida" "de.bubenheim" "de.khoury" "de.zaidan" "dv.divehi" "en.ahmedali" "en.ahmedraza" "en.arberry" "en.asad" "en.daryabadi" "en.hilali" "en.maududi" "en.pickthall" "en.qaribullah" "en.sahih" "en.sarwar" "en.shakir" "en.yusufali" "es.asad" "es.cortes" "fa.ansarian" "fa.ayati" "fa.bahrampour" "fa.fooladvand" "fa.ghomshei" "fa.khorramdel" "fa.khorramshahi" "fa.makarem" "fa.moezzi" "fa.mojtabavi" "fr.hamidullah" "ha.gumi" "hi.farooq" "hi.hindi" "id.indonesian" "id.muntakhab" "it.piccardo" "ja.japanese" "ko.korean" "ku.asan" "ml.abdulhameed" "ms.basmeih" "nl.keyzer" "no.berg" "pl.bielawskiego" "pt.elhayek" "ro.grigore" "ru.abuadel" "ru.krachkovsky" "ru.kuliev" "ru.muntahab" "ru.osmanov" "ru.porokhova" "ru.sablukov" "sd.amroti" "so.abduh" "sq.ahmeti" "sq.mehdiu" "sq.nahi" "sv.bernstrom" "sw.barwani" "ta.tamil" "tg.ayati" "th.thai" "tr.ates" "tr.bulac" "tr.diyanet" "tr.golpinarli" "tr.ozturk" "tr.transliteration" "tr.vakfi" "tr.yazir" "tr.yildirim" "tr.yuksel" "tt.nugman" "ug.saleh" "ur.ahmedali" "ur.jalandhry" "ur.jawadi" "ur.junagarhi" "ur.kanzuliman" "ur.maududi" "ur.qadri" "uz.sodik" "zh.jian" "zh.majian")

for identifier in ${identifiers[@]}; do
    bgpath="$(pwd)/${identifier}"
    idpath="$(cd ../ && pwd)/fixtures/${identifier/.//}"
    source="${idpath}/source.json"
    chapter_translations=0
    verse_translation=0

    ########## CHAPTERS ##########
    if [ -f "$source" ]; then
        while read i;
        do
            if [[ $i != 'null' ]]; then
                ((chapter_translations++))
            fi
        done < <(jq -c '.[].translation' "$source")
    fi

    percent=$(jq -n $chapter_translations/114*100 | awk '{printf("%.0f",$1)}')
    color=$([ "$percent" -gt "50" ] && echo "brightgreen" || echo "red")

    jq -n --arg percent "$percent%" --arg color "$color" '{schemaVersion: 1, label: "Chapters", message: $percent, color: $color}' > "${bgpath}-chapters.json"

    ########## VERSES ##########
    if [ -f "$source" ]; then
        while read i;
        do
            if [[ $i != 'null' ]]; then
                ((verse_translation++))
            fi
        done < <(jq -c '.[].verses[].translation' "$source")
    fi

    percent=$(jq -n $verse_translation/6236*100 | awk '{printf("%.0f",$1)}')
    color=$([ "$percent" -gt "50" ] && echo "brightgreen" || echo "red")

    jq -n --arg percent "$percent%" --arg color "$color" '{schemaVersion: 1, label: "Verses", message: $percent, color: $color}' > "${bgpath}-verses.json"
done
