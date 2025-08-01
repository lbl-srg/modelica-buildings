for ff in `find . \( -name '*ControlPlusLockouts.mo' -or -name '*ControlPlusLockouts.mos' -or -name '*ControlPlusLockouts.txt' -or -name '*ControlPlusLockouts.svg'  \)`; do
    list=(\
     nitFluSig uNigFlu \
     TWaRet TSlaWatRet \
     htgSig yHea \
     clgSig yCoo \
     htgSigL yHea \
     clgSigL yCoo \
     TAirHiSet TZonHigSet \
     TAirLoSet TZonLowSet \
     TWaLoSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     off_within_deadband offWitDea \
     TChwRet TSlaWatRet \

          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AllLockouts.mo' -or -name '*AllLockouts.mos' -or -name '*AllLockouts.txt' -or -name '*AllLockouts.svg'  \)`; do
    list=(\
     nitFluSig uNigFlu \
     TWaRet TSlaWatRet \
     htgSig uHea \
     clgSig uCoo \
     htgSigL yHea \
     clgSigL yCoo \
     heaSig uHea \
     cooSig uCoo \
     TChwRet TSlaWatRet \
     TAirHiSet TZonHigSet \
     TAirLoSet TZonLowSet \
     TWaLoSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     off_within_deadband offWitDea \
     hysLim.uHeaHys hysLim.uHea \
     hysLim.uCooHys hysLim.uCoo \
     airTemLim.uHeaAirTem airTemLim.yHeaTZon \
     airTemLim.uCooAirTem airTemLim.yCooTZon \
     nitFluLoc.uHeaNitFlu nitFluLoc.uNigFlu \
     chwRetLim.cooSigChwRet chwRetLim.yCooTChiWatRetLim \
     chwRetLim.TWa chwRetLim.TSlaRet \

          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AirTemperatureLimit.mo' -or -name '*AirTemperatureLimit.mos' -or -name '*AirTemperatureLimit.txt' -or -name '*AirTemperatureLimit.svg'  \)`; do
    list=(\
     TAirHiSet TZonHigSet \
     TAirLoSet TZonLowSet \
     htgSigAirTem yHeaTZon \
     clgSigAirTem yCooTZon \ 
     TRoo TZon \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ChilledWaterReturnLimit.mo' -or -name '*ChilledWaterReturnLimit.mos' -or -name '*ChilledWaterReturnLimit.txt' -or -name '*ChilledWaterReturnLimit.svg'  \)`; do
    list=(\
     TWaLoSet TWatSetLow \
     TWaLowSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     TWa TSlaRet \
     cooSigChwRet yCooTChiWatRetLim \
     TSlaRettSetLow TWatSetLow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*HysteresisLimit.mo' -or -name '*HysteresisLimit.mos' -or -name '*HysteresisLimit.txt' -or -name '*HysteresisLimit.svg'  \)`; do
    list=(\
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     heaSig uHea \
     cooSig uCoo \
     htgSigHys yHeaNotLoc \
     clgSigHys yCooNotLoc \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*NightFlush.mo' -or -name '*NightFlush.mos' -or -name '*NightFlush.txt' -or -name '*NightFlush.svg'  \)`; do
    list=(\
     nitFluSig uNigFlu \
     htgSigNitFlu yNigFluHea \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AirTemperatureLockout.mo' -or -name '*AirTemperatureLockout.mos' -or -name '*AirTemperatureLockout.txt' -or -name '*AirTemperatureLockout.svg'  \)`; do
    list=(\
     TAirHiLim TZonHigLim \
     TAirLoLim TZonLowLim \
     THiRoo THigRoo \
     TLoRoo TLowRoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*ChilledWaterReturnLockout.mo' -or -name '*ChilledWaterReturnLockout.mos' -or -name '*ChilledWaterReturnLockout.txt' -or -name '*ChilledWaterReturnLockout.svg'  \)`; do
    list=(\
     TWaLoSet TWatSetLow \
     TWaLowSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     cooSigChwRet yCooTChiWatRetLim \
     TWa TSlaRet \
     TSlaRettSetLow TWatSetLow \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*HysteresisLockout.mo' -or -name '*HysteresisLockout.mos' -or -name '*HysteresisLockout.txt' -or -name '*HysteresisLockout.svg'  \)`; do
    list=(\
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     heaSig uHea \
     cooSig uCoo \
     htgSigHys yHeaNotLoc \
     clgSigHys yCooNotLoc \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*NightFlushLockout.mo' -or -name '*NightFlushLockout.mos' -or -name '*NightFlushLockout.txt' -or -name '*NightFlushLockout.svg'  \)`; do
    list=(\
     nitFluLoc nigFluLoc \
     TiHea heaLocDurAftCoo \
     nigFluLoc.nitFluSig nigFluLoc.uNigFlu \
     nigFluLoc.htgSigNitFlu nigFluLoc.yNigFluHea
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*AllLockout.mo' -or -name '*AllLockout.mos' -or -name '*AllLockout.txt' -or -name '*AllLockout.svg'  \)`; do
    list=(\
     TAirHiLim TZonHigLim \
     TAirLoLim TZonLowLim \
     TAirHiSet TZonHigSet \
     TAirLoSet TZonLowSet \
     TimeCHW LocDurCHW \
     TimHea LocDurHea \
     TimCoo LocDurCoo \
     TWaLoSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     allLoc.clgSig hysLim.uCoo \
     allLoc.clgSig hysLim.uCoo \
     allLoc.TChwRet allLoc.TSlaWatRet
     allLoc.clgSig allLoc.uCoo \
     allLoc.htgSig allLoc.uHea \
     allLoc.nitFluSig allLoc.uNigFlu
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*DeadbandControl.mo' -or -name '*DeadbandControl.mos' -or -name '*DeadbandControl.txt' -or -name '*DeadbandControl.svg'  \)`; do
    list=(\
     htgCal uHea \
     clgCal uCoo \
     off_within_deadband offWitDea \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ForecastHighChicago.mo' -or -name '*ForecastHighChicago.mos' -or -name '*ForecastHighChicago.txt' -or -name '*ForecastHighChicago.svg'  \)`; do
    list=(\
     TForHiChi TForHigChi \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ChicagoForecastHigh.mo' -or -name '*ChicagoForecastHigh.mos' -or -name '*ChicagoForecastHigh.txt' -or -name '*ChicagoForecastHigh.svg'  \)`; do
    list=(\
     TForHiChi TForHigChi \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ControlPlusLockout.mo' -or -name '*ControlPlusLockout.mos' -or -name '*ControlPlusLockout.txt' -or -name '*ControlPlusLockout.svg'  \)`; do
    list=(\
     TAirHiLim TZonHigLim \
     TempWaLoSet WatTemLowSet \
     nitFluSig uNigFlu \
     TWaRet TSlaWatRet \
     htgSig yHea \
     clgSig yCoo \
     htgSigL yHea \
     clgSigL yCoo \
     TAirHiSet TZonHigSet \
     TAirLoSet TZonLowSet \
     TWaLoSet TWatSetLow \
     TiCHW cooLocDurWatTem \
     TiCoo cooLocDurAftHea \
     TiHea heaLocDurAftCoo \
     off_within_deadband offWitDea \
     TChwRet TSlaWatRet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ControlPlusLockoutPerimeter.mo' -or -name '*ControlPlusLockoutPerimeter.mos' -or -name '*ControlPlusLockoutPerimeter.txt' -or -name '*ControlPlusLockoutPerimeter.svg'  \)`; do
    list=(\
     TAirHiLim TZonHigLim \
     TAirLoLim TZonLowLim \
     TempWaLoSet WatTemLowSet \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*ControlPlusLockoutCore.mo' -or -name '*ControlPlusLockoutCore.mos' -or -name '*ControlPlusLockoutCore.txt' -or -name '*ControlPlusLockoutCore.svg'  \)`; do
    list=(\
     TAirHiLim TZonHigLim \
     TAirLoLim TZonLowLim \
     TempWaLoSet WatTemLowSet \
     TimCHW cooLocDurWatTem \
     TimCoo cooLocDurAftHea \
     TimHea heaLocDurAftCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

