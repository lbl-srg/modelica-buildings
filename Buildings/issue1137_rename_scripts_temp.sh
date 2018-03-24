# fixme break into single model targetting renames
# *****************************************
# run from /modelica-buildings/Buildings

# Some of the variables cannot be changed throughout the Buildings package and apply only to their specific models,
# since their names are overly generic. For an extensive list of variable names changed for each model in G36_PR1
# see the comments below the script.

for ff in `find . \( -name '*OperationMode*.mo' -or -name '*OperationMode*.mos' -or -name '*OperationMode*.py' -or -name '*OperationMode*.txt' -or -name '*OperationMode*.svg'  \)`; do
    list=(\
          THeaSet TOccZonHeaSet \
          TCooSet TOccZonCooSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*ExhaustDamper*.mo' -or -name '*ExhaustDamper*.mos' -or -name '*ExhaustDamper*.py' -or -name '*ExhaustDamper*.txt' -or -name '*ExhaustDamper*.svg'  \)`; do
    list=(\
          uFan uSupFan \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*VAVSupply*.mo' -or -name '*VAVSupply*.mos' -or -name '*VAVSupply*.py' -or -name '*VAVSupply*.txt' -or -name '*VAVSupply*.svg'  \)`; do
    list=(\
          TMax TSupSetMax \
          TMin TSupSetMin \
          TCoo TSupCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*.mo' -or -name '*.mos' -or -name '*.py' -or -name '*.txt' -or -name '*.svg'  \)`; do
    list=(\
          TSupMin TSupSetMin \
          TSupMax TSupSetMax \
          TSupDes TSupSetDes \
          TSetZones TZonSetAve \
          TSetZon TZonSet \
          THeaEco TSupHeaEco \
          TUnoCooSet TUnoZonCooSet \
          TUnoHeaSet TUnoZonHeaSet \
          VBox_flow VDis_flow \
          sumVBox_flow sumVDis_flow \
          TSetSup TSupSet \
          TSupMin TSupSetMin \
          TSupMax TSupSetMax \
          TSupDes TSupSetDes \
          TSetZones TZonSetAve \
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
          dTDisMax dTDisZonSetMax \
          TDisSet TDisHeaSet \
          occCooSet TOccDisSet \
          TCooSet TZonCooSet \
          THeaSet TZonHeaSet \
          TCooOnMax TZonCooSetMaxOn \
          TCooOnMin TZonCooSetMinOn \
          THeaOnMax TZonHeaSetMaxOn \
          THeaOnMin TZonHeaSetMinOn \
          TCooWinOpe TZonCooSetWinOpe \
          THeaWinOpe TZonHeaSetWinOpe \
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

# checkout the following files after running the script
git checkout Buildings/Resources/ReferenceResults/Dymola/Buildings_Examples_Tutorial_Boiler_System6.txt
git checkout Buildings/Resources/ReferenceResults/Dymola/Buildings_Examples_Tutorial_Boiler_System7.txt

git checkout Buildings/Resources/Scripts/OpenModelica/compareVars/Buildings.Examples.Tutorial.Boiler.System7.mos
git checkout Buildings/Resources/Scripts/OpenModelica/compareVars/Buildings.Examples.Tutorial.Boiler.System6.mos

git checkout Buildings/Examples/Tutorial/
git checkout Buildings/Resources/Scripts/Dymola/Examples/Tutorial/Boiler/
git checkout Buildings/Air

#for ff in `find . \( -name '*.mo' -or -name '*.mos' -or -name '*.py' -or -name '*.txt' -or -name '*.svg'  \)`; do
#    list=(\
#
#    for ((i=0; i<${#list[@]}; i+=2)); do
#        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
#    done
#
#done
#
# # Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits
#
#     # in Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.SetPoints.ZoneTemperatures
#
#      occCooSet TOccDisSet \
#      TCooSet TZonCooSet \
#      THeaSet TZonHeaSet \
#      TCooOnMax TZonCooSetMaxOn \
#      TCooOnMin TZonCooSetMinOn \
#      THeaOnMax TZonHeaSetMaxOn \
#      THeaOnMin TZonHeaSetMinOn \
#      TCooWinOpe TZonCooSetWinOpe \
#      THeaWinOpe TZonHeaSetWinOpe \
#
#     # in Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SetPoints.ActiveAirFlow
#
#      VCooMax VDisCooSetMax_flow \
#      VMin VDisSetMin_flow \
#      VHeaMax VDisHeaSetMax_flow \
#      VMinCon VDisConMin_flow \
#      outAirPerAre VOutPerAre_flow \
#      outAirPerPer VOutPerPer_flow \
#      VOccMinAir VOccDisMin_flow \
#      VActCooMax VActCooMax_flow \
#      VActCooMin VActCooMin_flow \
#      VActMin VActMin_flow \
#      VActHeaMin VActHeaMin_flow \
#      VActHeaMax VActHeaMax_flow \
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.SystemRequests
#
#      VDis VDis_flow \
#      VDisSet VDisSet_flow \
#      cooSetDif_1 errTZonCoo_1 \
#      cooSetDif_2 errTZonCoo_2 \
#      disAirSetDif_1 errTDis_1 \
#      disAirSetDif_2 errTDis_2 \
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.Reheat.DamperValves
#
#      dTDisMax dTDisZonSetMax \
#      TDisSet TDisHeaSet \
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.TerminalUnits.ModeAndSetPoints
#      THeaOn TZonHeaOn \
#      TCooOn TZonCooOn \
#      THeaOff TZonHeaOff \
#      TCooOff TZonCooOff \
#      freProThrVal TZonFreProOn \
#      freProEndVal TZonFreProOff \
#      incSetDem_1 incTSetDem_1 \
#      incSetDem_2 incTSetDem_2 \
#      incSetDem_3 incTSetDem_3 \
#      decSetDem_1 decTSetDem_1 \
#      decSetDem_2 decTSetDem_2 \
#      decSetDem_3 decTSetDem_3 \
#
# # Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.OperationMode
#      THeaSet TOccZonHeaSet \     *mg run separately for this class
#      TCooSet TOccZonCooSet \    *mg run separately for this class
#      TUnoCooSet TUnoZonCooSet \
#      TUnoHeaSet TUnoZonHeaSet \
#
# # Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone
#
#     # SetPoints.ExhaustDamper
#      uFan uSupFan \     *mg run in this only
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.SingleZone.SetPoints.VAVSupply
#
#      TMax TSupSetMax \     *mg run in this only
#      TMin TSupSetMin \    *mg run in this only
#      TSetZon TZonSet \
#      THeaEco TSupHeaEco \
#      TCoo TSupCoo \    *mg run in this only
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone
#      TSupMin TSupSetMin \
#      TSupMax TSupSetMax \
#      TSupDes TSupSetDes \
#      TSetZones TZonSetAve \
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplySignals
#      TSetSup TSupSet \
#
#     # Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints.VAVSupplyFan
#      VBox_flow VDis_flow \
#      sumVBox_flow sumVDis_flow \
