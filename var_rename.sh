for ff in `find . \( -name '*ControlPlusLockouts.mo' -or -name '*ControlPlusLockouts.mos' -or -name '*ControlPlusLockouts.txt' -or -name '*ControlPlusLockouts.svg'  \)`; do
    list=(\
     nitFluSig uNigFlu \
     TWaRet TSlaWaRet \
     htgSig yHea \
     clgSig yCoo \
     htgSigL yHea \
     clgSigL yCoo \
     TChwRet TSlaWaRet \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
     TChwRet TSlaWaRet \
     TWaLoSet TWatLowSet \
     TiCHW CooLocDurWatTem \
     TiCoo CooLocAftHea \
     TiHea HeaLocAftCoo \
     off_within_deadband offWitDea \
     TChwRet TSlaWatRet \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AllLockouts.mo' -or -name '*AllLockouts.mos' -or -name '*AllLockouts.txt' -or -name '*AllLockouts.svg'  \)`; do
    list=(\
     nitFluSig uNigFlu \
     TWaRet TSlaWaRet \
     htgSig yHea \
     clgSig yCoo \
     htgSigL yHea \
     clgSigL yCoo \
     TChwRet TSlaWaRet \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
     TChwRet TSlaWaRet \
     TWaLoSet TWatLowSet \
     TiCHW CooLocDurWatTem \
     TiCoo CooLocAftHea \
     TiHea HeaLocAftCoo \
     off_within_deadband offWitDea \
     TWaLoSet TWatLowSet \
     TChwRet TSlaWatRet \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \ 
     TChwRet TSlaWaRet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AirTemperatureLimit.mo' -or -name '*AirTemperatureLimit.mos' -or -name '*AirTemperatureLimit.txt' -or -name '*AirTemperatureLimit.svg'  \)`; do
    list=(\
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
     htgSigAirTem heaSigAirTem \
     clgSigAirTem cooSigAirTem \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \

          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


ChilledWaterReturnLimit

for ff in `find . \( -name '*ChilledWaterReturnLimit.mo' -or -name '*ChilledWaterReturnLimit.mos' -or -name '*ChilledWaterReturnLimit.txt' -or -name '*ChilledWaterReturnLimit.svg'  \)`; do
    list=(\
     TWaLoSet TWatLowSet \
     TiCHW CooLocDurWatTem \
     TWa TSlaWaRet \ 
     cooSigChwRet yCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*HysteresisLimit.mo' -or -name '*HysteresisLimit.mos' -or -name '*HysteresisLimit.txt' -or -name '*HysteresisLimit.svg'  \)`; do
    list=(\
     TiCoo CooLocAftHea \
     TiHea HeaLocAftCoo \
     heaSig uHea \
     cooSig uCoo \
     htgSigHys uHeaHys \

          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*NightFlush.mo' -or -name '*NightFlush.mos' -or -name '*NightFlush.txt' -or -name '*NightFlush.svg'  \)`; do
    list=(\
     

          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done



