# Steps to convert variable names in this PR:
# rename classes as required using refactor from BuildingsPy
# run the local convert element script to rename variables in instantiated classes
# run this script from /modelica-buildings/Buildings

for ff in `find . \( -name '*G36_PR1*ZoneTemperatures*.mo' -or -name '*G36_PR1*ZoneTemperatures*.mos' -or -name '*G36_PR1*ZoneTemperatures*.py' -or -name '*G36_PR1*ZoneTemperatures*.txt' -or -name '*G36_PR1*ZoneTemperatures*.svg'  \)`; do
    list=(\
     occCooSet TOccDisSet \
     TCooSet TZonCooSet \
     THeaSet TZonHeaSet \
     TCooOnMax TZonCooSetMaxOn \
     TCooOnMin TZonCooSetMinOn \
     THeaOnMax TZonHeaSetMaxOn \
     THeaOnMin TZonHeaSetMinOn \
     TCooWinOpe TZonCooSetWinOpe \
     THeaWinOpe TZonHeaSetWinOpe \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*ActiveAirFlow*.mo' -or -name '*G36_PR1*ActiveAirFlow*.mos' -or -name '*G36_PR1*ActiveAirFlow*.py' -or -name '*G36_PR1*ActiveAirFlow*.txt' -or -name '*G36_PR1*ActiveAirFlow*.svg'  \)`; do
    list=(\
     VCooMax VDisCooSetMax_flow \
     VMin VDisSetMin_flow \
     VHeaMax VDisHeaSetMax_flow \
     VMinCon VDisConMin_flow \
     outAirPerAre VOutPerAre_flow \
     outAirPerPer VOutPerPer_flow \
     VOccMinAir VOccDisMin_flow \
     VActCooMax VActCooMax_flow \
     VActCooMin VActCooMin_flow \
     VActMin VActMin_flow \
     VActHeaMin VActHeaMin_flow \
     VActHeaMax VActHeaMax_flow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*SystemRequests*.mo' -or -name '*G36_PR1*SystemRequests*.mos' -or -name '*G36_PR1*SystemRequests*.py' -or -name '*G36_PR1*SystemRequests*.txt' -or -name '*G36_PR1*SystemRequests*.svg'  \)`; do
    list=(\
     VDis VDis_flow \
     VDisSet VDisSet_flow \
     cooSetDif_1 errTZonCoo_1 \
     cooSetDif_2 errTZonCoo_2 \
     disAirSetDif_1 errTDis_1 \
     disAirSetDif_2 errTDis_2 \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*DamperValves*.mo' -or -name '*G36_PR1*DamperValves*.mos' -or -name '*G36_PR1*DamperValves*.py' -or -name '*G36_PR1*DamperValves*.txt' -or -name '*G36_PR1*DamperValves*.svg'  \)`; do
    list=(\
     dTDisMax dTDisZonSetMax \
     TDisSet TDisHeaSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*ModeAndSetPoints*.mo' -or -name '*G36_PR1*ModeAndSetPoints*.mos' -or -name '*G36_PR1*ModeAndSetPoints*.py' -or -name '*G36_PR1*ModeAndSetPoints*.txt' -or -name '*G36_PR1*ModeAndSetPoints*.svg'  \)`; do
    list=(\
     THeaOn TZonHeaOn \
     TCooOn TZonCooOn \
     THeaOff TZonHeaOff \
     TCooOff TZonCooOff \
     freProThrVal TZonFreProOn \
     freProEndVal TZonFreProOff \
     incSetDem_1 incTSetDem_1 \
     incSetDem_2 incTSetDem_2 \
     incSetDem_3 incTSetDem_3 \
     decSetDem_1 decTSetDem_1 \
     decSetDem_2 decTSetDem_2 \
     decSetDem_3 decTSetDem_3 \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*ExhaustDamper*.mo' -or -name '*G36_PR1*ExhaustDamper*.mos' -or -name '*G36_PR1*ExhaustDamper*.py' -or -name '*G36_PR1*ExhaustDamper*.txt' -or -name '*G36_PR1*ExhaustDamper*.svg'  \)`; do
    list=(\
     uFan uSupFan \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*VAVSupply*.mo' -or -name '*G36_PR1*VAVSupply*.mos' -or -name '*G36_PR1*VAVSupply*.py' -or -name '*G36_PR1*VAVSupply*.txt' -or -name '*G36_PR1*VAVSupply*.svg'  \)`; do
    list=(\
     TMax TSupSetMax \
     TMin TSupSetMin \
     TSetZon TZonSet \
     THeaEco TSupHeaEco \
     TCoo TSupCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*Controller*.mo' -or -name '*G36_PR1*Controller*.mos' -or -name '*G36_PR1*Controller*.py' -or -name '*G36_PR1*Controller*.txt' -or -name '*G36_PR1*Controller*.svg'  \)`; do
    list=(\
     TMax TSupSetMax \
     TMin TSupSetMin \
     TSetZon TZonSet \
     THeaEco TSupHeaEco \
     TCoo TSupCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*VAVSupplySignals*.mo' -or -name '*G36_PR1*VAVSupplySignals*.mos' -or -name '*G36_PR1*VAVSupplySignals*.py' -or -name '*G36_PR1*VAVSupplySignals*.txt' -or -name '*G36_PR1*VAVSupplySignals*.svg'  \)`; do
    list=(\
     TSetSup TSupSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*G36_PR1*VAVSupplyFan*.mo' -or -name '*G36_PR1*VAVSupplyFan*.mos' -or -name '*G36_PR1*VAVSupplyFan*.py' -or -name '*G36_PR1*VAVSupplyFan*.txt' -or -name '*G36_PR1*VAVSupplyFan*.svg'  \)`; do
    list=(\
     TSetSup TSupSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done
