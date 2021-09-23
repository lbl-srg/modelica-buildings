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
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

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
     nitFluSig uNigFlu \
     htgSigNitFlu yNigFluHea \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done

for ff in `find . \( -name '*AirTemperatureLockout.mo' -or -name '*AirTemperatureLockout.mos' -or -name '*AirTemperatureLockout.txt' -or -name '*AirTemperatureLockout.svg'  \)`; do
    list=(\
     TAirHiLim TAirHigLim \
     TAirLoLim TAirLowLim \
     THiRoo THigRoo \
     TLoRoo TLowRoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*ChilledWaterReturnLockout.mo' -or -name '*ChilledWaterReturnLockout.mos' -or -name '*ChilledWaterReturnLockout.txt' -or -name '*ChilledWaterReturnLockout.svg'  \)`; do
    list=(\
     TWaLoSet TWaLowSet \
     TiCHW CooLocDurWatTem \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*HysteresisLockout.mo' -or -name '*HysteresisLockout.mos' -or -name '*HysteresisLockout.txt' -or -name '*HysteresisLockout.svg'  \)`; do
    list=(\
     TiCoo CooLocAftHea \
     TiHea HeaLocAftCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*NightFlushLockout.mo' -or -name '*NightFlushLockout.mos' -or -name '*NightFlushLockout.txt' -or -name '*NightFlushLockout.svg'  \)`; do
    list=(\
     nitFluLoc nigFluLoc \
     TiHea HeaLocAftCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*AllLockout.mo' -or -name '*AllLockout.mos' -or -name '*AllLockout.txt' -or -name '*AllLockout.svg'  \)`; do
    list=(\
     TAirHiLim TAirHigLim \
     TAirLoLim TAirLowLim \
     TAirHiSet TAirHigSet \
     TAirLoSet TAirLowSet \
     TimeCHW LocDurCHW \
     TimHea LocDurHea \
     TimCoo LocDurCoo \
     TWaLoSet TWatLowSet \
     TiCHW CooLocDurWatTem \
     TiCoo CooLocAftHea \
     TiHea HeaLocAftCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done


for ff in `find . \( -name '*DeadbandControl.mo' -or -name '*DeadbandControl.mos' -or -name '*DeadbandControl.txt' -or -name '*DeadbandControl.svg'  \)`; do
    list=(\
     nitFluLoc nigFluLoc \
     TiHea HeaLocAftCoo \
          )

    for ((i=0; i<${#list[@]}; i+=2)); do
        sed -e s/${list[i]}/${list[i+1]}/g -i $ff
    done
done