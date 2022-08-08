within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Win670 =
    Buildings.HeatTransfer.Data.GlazingSystems.Generic (
    final glass={Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Glass600()},
    UFra=1.4) "Single pane, clear glass 3.048mm"
annotation (defaultComponentPrefixes="parameter", defaultComponentName="datThePro",
Documentation(info="<html>
<p>
This record declares the parameters for the window system
for the BESTEST Case 670.
</p>
</html>", revisions="<html>
<ul>
<li>
May 18, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
