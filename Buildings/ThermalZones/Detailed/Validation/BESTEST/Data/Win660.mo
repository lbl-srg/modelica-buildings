within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Win660 =
    Buildings.HeatTransfer.Data.GlazingSystems.Generic (
    final glass={Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Glass660(),
                 Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Glass600()},
    final gas={Buildings.HeatTransfer.Data.Gases.Argon(x=0.012)},
    UFra=1.4)
  "Double pane, outer low-e glass 3.180 mm, argon 12 mm, inner clear glass 3.048 mm"
annotation (defaultComponentPrefixes="parameter", defaultComponentName="datThePro",
Documentation(info="<html>
<p>
This record declares the parameters for the window system
for the BESTEST Case 660.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
