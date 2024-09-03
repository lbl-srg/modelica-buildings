within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Glass600 = Buildings.HeatTransfer.Data.Glasses.Generic (
    x=0.003048,
    k=1.0,
    tauSol={0.834},
    rhoSol_a={0.075},
    rhoSol_b={0.075},
    tauIR=0,
    absIR_a=0.84,
    absIR_b=0.84) "Thermal properties of window glass"
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="datGla",
Documentation(info="<html>
<p>
This record declares the glass properties for the BESTEST model.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 12, 2022, by Jianjun Hu:<br/>
Changed the glass thickness (3.175 to 3.048 mm), thermal conductivity (1.06 to 1 W/m.K),
solar transmittance (0.86156 to 0.834), solar reflectance (0.0434 to 0.075) and
infrared absorptivity (0.9 to 0.84).<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>
<li>
August 7, 2015, by Michael Wetter:<br/>
Reimplemented the record by extending its base class, rather
than newly redefining the record.
This was needed as the record definition changed when implementing
electrochromic windows.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
