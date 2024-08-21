within Buildings.ThermalZones.Detailed.Validation.BESTEST.Data;
record Win600 =
    Buildings.HeatTransfer.Data.GlazingSystems.Generic (
    final glass={Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Glass600(),
                            Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.Glass600()},
    final gas={Buildings.HeatTransfer.Data.Gases.Air(x=0.012)},
    UFra=1.4) "Double pane, clear glass 3.048mm, air 12mm, clear glass 3.048mm"
annotation (defaultComponentPrefixes="parameter", defaultComponentName="datThePro",
Documentation(info="<html>
<p>
This record declares the parameters for the window system
for the BESTEST.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2022, by Jianjun Hu:<br/>
Changed the air gap from 13 mm to 12 mm.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>
<li>
March 13, 2015, by Michael Wetter:<br/>
Removed assignment of <code>nLay</code> which no longer exists.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
