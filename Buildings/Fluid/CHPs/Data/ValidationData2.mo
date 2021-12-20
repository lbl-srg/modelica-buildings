within Buildings.Fluid.CHPs.Data;
record ValidationData2 "Validation data set 2"
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
    warmUpByTimeDelay=false,
    timeDelayStart=0,
    coolDownOptional=true,
    timeDelayCool=60,
    TEngNom=273.15 + 100,
    PEleMax=5500,
    PEleMin=0,
    mWatMin_flow=0.1,
    TWatMax=273.15 + 80,
    use_powerRateLimit=true,
    use_fuelRateLimit=true,
    dPEleMax=200,
    dmFueMax_flow=2,
    PStaBy=100,
    PCooDow=200,
    LHVFue=47.614e6);
  annotation (
  defaultComponentPrefixes = "parameter",
  defaultComponentName = "per",
  Documentation(preferredView="info",
  info="<html>
<p>
This is the record of parameters for CHP models derived from the parameters of
EnergyPlus example <code>MicroCogeneration</code>, with following changes:
</p>
<ul>
<li>
changed the minimum cooling water flow rate <code>mWatMin_flow</code> from 0 to 0.1 kg/s.
</li>
<li>
limited the maximum net electrical power rate of change <code>dPEleMax</code> and
the maximum fuel flow rate of change <code>dmFueMax_flow</code>, by reducing from 1e+9 to
200 and from 1e+9 to 2 respectively.
</li>
<li>
changed electric power consumptions during standby <code>PStaBy</code> and cool-down
<code>PCooDow</code> mode from 0 W to 100 W and 200 W respectively.
</li>
</ul>
</html>",revisions="<html>
<ul>
<li>
March 08, 2019, by Tea Zakula:<br/>
First implementation.
</li>
</ul>
</html>"));
end ValidationData2;
