within Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses;
record SandBox_Borefield
  "Borefield data record for the Beier et al. (2011) experiment"
  extends
    Buildings.Fluid.Geothermal.Borefields.Data.Borefield.Template(
      filDat=Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Filling(),
      soiDat=Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Soil(),
      conDat=Buildings.Fluid.Geothermal.Borefields.Validation.BaseClasses.SandBox_Configuration());

  annotation (
  defaultComponentPrefixes="parameter",
  defaultComponentName="borFieDat",
    Documentation(
info="<html>
<p>
This record contains the borefield data of the Beier et al. (2011) experiment.
</p>
<h4>References</h4>
<p>
Beier, R.A., Smith, M.D. and Spitler, J.D. 2011. <i>Reference data sets for
vertical borehole ground heat exchanger models and thermal response test
analysis</i>. Geothermics 40: 79-85.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 15, 2018, by Michael Wetter:<br/>
Revised implementation, added <code>defaultComponentPrefixes</code> and
<code>defaultComponentName</code>.
</li>
<li>
June 28, 2018, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end SandBox_Borefield;
