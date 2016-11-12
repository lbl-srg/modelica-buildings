within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Glass600 = Buildings.HeatTransfer.Data.Glasses.Generic (
    x=0.003175,
    k=1.06,
    tauSol={0.86156},
    rhoSol_a={0.0434},
    rhoSol_b={0.0434},
    tauIR=0,
    absIR_a=0.9,
    absIR_b=0.9) "Thermal properties of window glass"
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
