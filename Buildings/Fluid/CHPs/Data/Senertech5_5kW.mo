within Buildings.Fluid.CHPs.Data;
record Senertech5_5kW "SENERTECH5_5kW"
  extends Buildings.Fluid.CHPs.Data.Generic(
    coeEtaQ={0.66,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    coeEtaE={0.27,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0},
    compute_coolingWaterFlowRate=true,
    coeMasWat={0.4,0,0,0,0,0},
    coeMasAir={0,2,-10000},
    UAHex=741,
    UALos=13.7,
    capEng=63605.6,
    capHeaRec=1000.7,
    warmUpByTimeDelay=true,
    timeDelayStart=60,
    coolDownOptional=true,
    timeDelayCool=60,
    PEleMax=5500,
    PEleMin=0,
    mWatMin_flow=0,
    TWatMax=273.15 + 80,
    use_powerRateLimit=true,
    use_fuelRateLimit=true,
    dPEleMax=1000000000,
    dmFueMax_flow=1000000000,
    PStaBy=0,
    PCooDow=0,
    LHVFue=47.614e6);
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for CHP models from EnergyPlus example
<code>MicroCogeneration</code>.
</p>
</html>",revisions="<html>
<ul>
<li>
March 08, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end Senertech5_5kW;
