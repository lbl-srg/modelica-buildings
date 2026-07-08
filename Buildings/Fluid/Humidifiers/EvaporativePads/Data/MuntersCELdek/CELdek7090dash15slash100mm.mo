within Buildings.Fluid.Humidifiers.EvaporativePads.Data.MuntersCELdek;
record CELdek7090dash15slash100mm
  "Data for CELdek EnergyPlus typical 12-inch evaporative pad"
  extends Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic (
    final efficiency(
      v={0,0.5,1,1.5,2,2.5,3,3.5,4,5,10},
      eta={0.836,0.815,0.768,0.73,0.699,0.672,0.649,0.628,0.61,0.551,0.364}),
    final dp_nominal=173.84,
    final v_nominal=4.5,
    final n=1.9259);

  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for a 12-inch evaporative pad. 
The data points are digitised from
<a href=\"https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf\">
https://content.greenheck.com/public/DAMProd/Original/10002/CentrifugalDWPerfSuppl_catalog.pdf</a>.
The highest available speeds on the graphs were selected as nominal.
The volumetric flow rates and static pressures were extracted by plot digitiser
(<a href=\"https://apps.automeris.io/wpd/\">https://apps.automeris.io/wpd/</a>).
The powers were read from the graphs approximately using
<a href=\"https://eleif.net/photo_measure.html\">
https://eleif.net/photo_measure.html</a>.
For each pressure-flow rate curve, the points to the left of the highest point
were abandoned to ensure convergence.
See <a href=\"modelica://Buildings.Fluid.Movers.UsersGuide\">Buildings.Fluid.Movers.UsersGuide</a>
and <a href=\"modelica://Buildings/Resources/Images/Fluid/Movers/UsersGuide/2013-IBPSA-Wetter.pdf\">Wetter (2013)</a>
for more information on the convergence considerations.
Also note that in the actual names of each fan,
the number precedes the letters (e.g. \"12 BIDW\").
They had to be reversed in class names of the records.
</p>
</html>", revisions="<html>
<ul>
<li>
July 08, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end CELdek7090dash15slash100mm;
