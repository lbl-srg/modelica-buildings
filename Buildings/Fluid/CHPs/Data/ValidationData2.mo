within Buildings.Fluid.CHPs.Data;
record ValidationData2 "Validation data set 2"
  extends CHPs.Data.Generic(
    coeEtaQ={0.66,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    coeEtaE={0.27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    coolingWaterControl=true,
    coeMasWat={0.4,0,0,0,0,0},
    coeMasAir={0,2,-10000},
    UAhx=741,
    UAlos=13.7,
    MCeng=63605.6,
    MCcw=1000.7,
    warmUpByTimeDelay=false,
    timeDelayStart=0,
    coolDownOptional=true,
    timeDelayCool=60,
    TEngNom=273.15 + 100,
    PEleMax=5500,
    PEleMin=0,
    mWatMin=0.1,
    TWatMax=(273.15 + 80),
    dPEleLim=true,
    dmFueLim=true,
    dPEleMax=200,
    dmFueMax=2,
    PStaBy=100,
    PCooDow=200,
    LHVFue=47.614e6);

  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(revisions="<html>
<ul>
<li>
March 08, 2019 by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValidationData2;
