within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Glass660 = Buildings.HeatTransfer.Data.Glasses.Generic (
    x=0.003180,
    k=1.0,
    tauSol={0.452},
    rhoSol_a={0.359},
    rhoSol_b={0.397},
    tauIR=0,
    absIR_a=0.84,
    absIR_b=0.047) "Thermal properties of low-e window glass"
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
May 17, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
