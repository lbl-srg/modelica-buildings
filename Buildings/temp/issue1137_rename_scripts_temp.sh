for ff in `find . \( -path '*G36_PR1*ZoneTemperatures*.mo' -or -path '*G36_PR1*ZoneTemperatures*.mos' -or -path '*G36_PR1*ZoneTemperatures*.py' -or -path '*G36_PR1*ZoneTemperatures*.txt' -or -path '*G36_PR1*ZoneTemperatures*.svg'  \)`; do
    list=(\
      incSetDem_1 incTSetDem_1 \
      incSetDem_2 incTSetDem_2 \
      incSetDem_3 incTSetDem_3 \
      decSetDem_1 decTSetDem_1 \
      decSetDem_2 decTSetDem_2 \
      decSetDem_3 decTSetDem_3 \
      occCooSet TZonCooSetOcc \
      occHeaSet TZonHeaSetOcc \
      unoCooSet TZonCooSetUno \
      unoHeaSet TZonHeaSetUno \
      TCooSet TZonCooSet \
      THeaSet TZonHeaSet \
      TCooOnMax TZonCooOnMax \
      TCooOnMin TZonCooOnMin \
      THeaOnMax TZonHeaOnMax \
      THeaOnMin TZonHeaOnMin \
      TCooWinOpe TZonCooSetWinOpe \
      THeaWinOpe TZonHeaSetWinOpe \
      TSetZon TZonSet \
    )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*ActiveAirFlow*.mo' -or -path '*G36_PR1*ActiveAirFlow*.mos' -or -path '*G36_PR1*ActiveAirFlow*.py' -or -path '*G36_PR1*ActiveAirFlow*.txt' -or -path '*G36_PR1*ActiveAirFlow*.svg'  \)`; do
    list=(\
     VCooMax VDisCooSetMax_flow \
     VHeaMax VDisHeaSetMax_flow \
     VMinCon VDisConMin_flow \
     VMin VDisSetMin_flow \
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


for ff in `find . \( -path '*G36_PR1*OutsideAirFlow*.mo' -or -path '*G36_PR1*OutsideAirFlow*.mos' -or -path '*G36_PR1*OutsideAirFlow*.py' -or -path '*G36_PR1*OutsideAirFlow*.txt' -or -path '*G36_PR1*OutsideAirFlow*.svg'  \)`; do
    list=(\
     outAirPerAre VOutPerAre_flow \
     outAirPerPer VOutPerPer_flow \
     VBox_flow VDis_flow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*SystemRequests*.mo' -or -path '*G36_PR1*SystemRequests*.mos' -or -path '*G36_PR1*SystemRequests*.py' -or -path '*G36_PR1*SystemRequests*.txt' -or -path '*G36_PR1*SystemRequests*.svg'  \)`; do
    list=(\
     TCooSet TZonCooSet \
     VDisSet VDisSet_flow \
     VDis VDis_flow \
     cooSetDif_1 errTZonCoo_1 \
     cooSetDif_2 errTZonCoo_2 \
     disAirSetDif_1 errTDis_1 \
     disAirSetDif_2 errTDis_2 \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*DamperValves*.mo' -or -path '*G36_PR1*DamperValves*.mos' -or -path '*G36_PR1*DamperValves*.py' -or -path '*G36_PR1*DamperValves*.txt' -or -path '*G36_PR1*DamperValves*.svg'  \)`; do
    list=(\
     dTDisMax dTDisZonSetMax \
     TDisSet TDisHeaSet \
     VActCooMin VActCooMin_flow \
     VActMin VActMin_flow \
     VActCooMax VActCooMax_flow \
     VActHeaMin VActHeaMin_flow \
     VActHeaMax VActHeaMax_flow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*ModeAndSetPoints*.mo' -or -path '*G36_PR1*ModeAndSetPoints*.mos' -or -path '*G36_PR1*ModeAndSetPoints*.py' -or -path '*G36_PR1*ModeAndSetPoints*.txt' -or -path '*G36_PR1*ModeAndSetPoints*.svg'  \)`; do
    list=(\
      incSetDem_1 incTSetDem_1 \
      incSetDem_2 incTSetDem_2 \
      incSetDem_3 incTSetDem_3 \
      decSetDem_1 decTSetDem_1 \
      decSetDem_2 decTSetDem_2 \
      decSetDem_3 decTSetDem_3 \
    THeaOn TZonHeaOn \
    TCooOn TZonCooOn \
    THeaOff TZonHeaOff \
    TCooOff TZonCooOff \
    freProThrVal TZonFreProOn \
    freProEndVal TZonFreProOff \
    TCooOnMax TZonCooOnMax \
    TCooOnMin TZonCooOnMin \
    THeaOnMax TZonHeaSetMaxOff \
    THeaOnMin TZonHeaSetMinOff \
    TCooWinOpe TZonCooSetWinOpe \
    THeaWinOpe TZonHeaSetWinOpe \
    THeaSet TZonHeaSetOcc \
    TCooSet TZonCooSetOcc \
    TUnoCooSet TZonCooSetUno \
    TUnoHeaSet TZonHeaSetUno \
      occCooSet TZonCooSetOcc \
      occHeaSet TZonHeaSetOcc \
      unoCooSet TZonCooSetUno \
      unoHeaSet TZonHeaSetUno \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*OperationMode*.mo' -or -path '*G36_PR1*OperationMode*.mos' -or -path '*G36_PR1*OperationMode*.py' -or -path '*G36_PR1*OperationMode*.txt' -or -path '*G36_PR1*OperationMode*.svg'  \)`; do
    list=(\
    THeaSet TZonHeaSetOcc \
    TCooSet TZonCooSetOcc \
    TUnoCooSet TZonCooSetUno \
    TUnoHeaSet TZonHeaSetUno \
    freProThrVal TZonFreProOn \
    freProEndVal TZonFreProOff \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*ExhaustDamper*.mo' -or -path '*G36_PR1*ExhaustDamper*.mos' -or -path '*G36_PR1*ExhaustDamper*.py' -or -path '*G36_PR1*ExhaustDamper*.txt' -or -path '*G36_PR1*ExhaustDamper*.svg'  \)`; do
    list=(\
     uFan uSupFan \
     yExhDam yExhDamPos \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*SingleZone*VAV*Supply*.mo' -or -path '*G36_PR1*SingleZone*VAV*Supply*.mos' -or -path '*G36_PR1*SingleZone*VAV*Supply*.py' -or -path '*G36_PR1*SingleZone*VAV*Supply*.txt' -or -path '*G36_PR1*SingleZone*VAV*Supply*.svg'  \)`; do
    list=(\
     TMax TSupSetMax \
     TMin TSupSetMin \
     TSetZon TZonSet \
     THeaEco TSupHeaEco \
     TCoo TSupCoo \
     TSetZon TZonSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*VAV*SupplyTemperature*.mo' -or -path '*G36_PR1*VAV*SupplyTemperature*.mos' -or -path '*G36_PR1*VAV*SupplyTemperature*.py' -or -path '*G36_PR1*VAV*SupplyTemperature*.txt' -or -path '*G36_PR1*VAV*SupplyTemperature*.svg'  \)`; do
    list=(\
    TSupMin TSupSetMin \
    TSupMax TSupSetMax \
    TSupDes TSupSetDes \
    TSetZones TZonSetAve \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*MultiZone*Controller*.mo' -or -path '*G36_PR1*MultiZone*Controller*.mos' -or -path '*G36_PR1*MultiZone*Controller*.py' -or -path '*G36_PR1*MultiZone*Controller*.txt' -or -path '*G36_PR1*MultiZone*Controller*.svg'  \)`; do
    list=(\
    TSupMin TSupSetMin \
    TSupMax TSupSetMax \
    TSupDes TSupSetDes \
    TSetZones TZonSetAve \
    outAirPerAre VOutPerAre_flow \
    outAirPerPer VOutPerPer_flow \
    TCooSet TZonCooSet \
    THeaSet TZonHeaSet \
     VBox_flow VDis_flow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*TerminalUnits*Controller*.mo' -or -path '*G36_PR1*TerminalUnits*Controller*.mos' -or -path '*G36_PR1*TerminalUnits*Controller*.py' -or -path '*G36_PR1*TerminalUnits*Controller*.txt' -or -path '*G36_PR1*TerminalUnits*Controller*.svg'  \)`; do
    list=(\
    TRooHeaSet TZooHeaSet \
     VDisSet VDisSet_flow \
    outAirPerAre VOutPerAre_flow \
    outAirPerPer VOutPerPer_flow \
    VCooMax VDisCooSetMax_flow \
    VMin VDisSetMin_flow \
    VHeaMax VDisHeaSetMax_flow \
    VMinCon VDisConMin_flow \
    dTDisMax dTDisZonSetMax \
    TCooSet TZonCooSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*VAV*SupplySignals*.mo' -or -path '*G36_PR1*VAV*SupplySignals*.mos' -or -path '*G36_PR1*VAV*SupplySignals*.py' -or -path '*G36_PR1*VAV*SupplySignals*.txt' -or -path '*G36_PR1*VAV*SupplySignals*.svg'  \)`; do
    list=(\
     TSetSup TSupSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -path '*G36_PR1*VAV*SupplyFan*.mo' -or -path '*G36_PR1*VAV*SupplyFan*.mos' -or -path '*G36_PR1*VAV*SupplyFan*.py' -or -path '*G36_PR1*VAV*SupplyFan*.txt' -or -path '*G36_PR1*VAV*SupplyFan*.svg'  \)`; do
    list=(\
     sumVBox_flow sumVDis_flow \
     VBox_flow VDis_flow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

# the last 4 rename rows in this group are due to the issue with the *.mos script (it does not perform element renames for folders # above)
for ff in `find . \( -path '*G36_PR1*.mo' -or -path '*G36_PR1*.mos' -or -path '*G36_PR1*.py' -or -path '*G36_PR1*.txt' -or -path '*G36_PR1*.svg'  \)`; do
    list=(\
     TSetSup TSupSet \
     _flow_flow _flow \
     _flowSet_flow _flow \
     TSetZon TZonSet \
     cooSetDif_1 errTZonCoo_1 \
     cooSetDif_2 errTZonCoo_2 \
     disAirSetDif_1 errTDis_1 \
     disAirSetDif_2 errTDis_2 \
     VDisSetMin_flowCon VDisConMin_flow \
     VDisSet_flowMin_flow VDisSetMin_flow \
     VDis_flowSet VDisSet_flow \
     VBox_flow VDis_flow \
         occCooSet TZonCooSetOcc \
         occHeaSet TZonHeaSetOcc \
         unoCooSet TZonCooSetUno \
         unoHeaSet TZonHeaSetUno \
     resultFile=\"AHUvalve\" resultFile=\"SupplySignals_Valve\" \
     AHUValve supSig \
     SupplySignals_SupplySignals_Valve SupplySignals_Valve
     AHUSupplySignals_Valve supSig \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done
