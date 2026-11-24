within Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data;
record Generic_2MW
  "Generic data record for a 2 MW CDU"
  extends Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU(
    Q_flow_nominal=-2E6,
    TApp_nominal=3,
    TRacOut_nominal=273.15 + 45,
    mPla_flow_nominal=32.30,
    mRac_flow_nominal=31.48,
    dpHexPla_nominal=80000,
    medPla=Buildings.Fluid.DataCenters.CDUs.Types.Media.Water,
    medRac=Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol,
    phiGlyRac=0.25,
    dpPumpExt_nominal=500000,
    pumpExtHead(
      V_flow=mRac_flow_nominal/rhoRac_default*{0.000, 0.250, 0.500, 0.750, 1.000},
      dp=(dpPumpExt_nominal + dpHexRac_nominal + dpFilRac_nominal)*{1.35, 1.32, 1.25, 1.15, 1.00}
        - {r^nRac*dpHexRac_nominal + r^nFilRac*dpFilRac_nominal
           for r in {0.000, 0.250, 0.500, 0.750, 1.000}}));

  annotation (
  defaultComponentName="datCDU",
  defaultComponentPrefixes="parameter",
  Documentation(info="<html>
<p>
Generic record for a 2 MW CDU.
</p>
</html>", revisions="<html>
<ul>
<li>
November 13, 2026, by Michael Wetter:<br/>
Added default values for <code>TApp_nominal</code>, <code>mPla_flow_nominal</code>,
<code>mRac_flow_nominal</code>, <code>medPla</code>, <code>medRac</code>, and
<code>phiGlyRac</code>, and updated <code>pumpExtHead</code> so that the total
pump head curve decreases monotonically with flow rate.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
October 17, 2026, by Nauman Rafique:<br/>
Corrected sign of <code>Q_flow_nominal</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4787\">Buildings, #4787</a>.
</li>
<li>
April 13, 2026, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Generic_2MW;
