within Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data;
record PipeDataULg151204_1
  "Experimental data from ULg's pipe test bench from December 4, 2015 (1);
  increase followed by a decrease in temperature"
  extends Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg(
    T_start_out=14.0,
    T_start_in=14.0,
    m_flowIni=1.618,
    final nCol = 6,
    final filNam = Modelica.Utilities.Files.loadResource(
  "modelica://Buildings/Resources/Data/Fluid/FixedResistances/Validation/PlugFlowPipes/PipeDataULg151204_1.mos"));
  annotation (Documentation(revisions="<html>
<ul>
<li>
March 7, 2020, by Michael Wetter:<br/>
Replaced measured data from specification in Modelica file to external table,
as this reduces the computing time.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1289\"> #1289</a>.
</li>
<li>
October 14, 2015 by Kevin Sartor:<br/>
Add some information about the test.
</li>
<li>
October 12, 2015 by Marcus Fuchs:<br/>
Add rudimentary documentation and integrate into experimental pipe package
</li>
<li>
October 7, 2015 by Kevin Sartor:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This data record contains the experimental data from the
long test bench carried out at the University of Liège.
See <a href=\"modelica://Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg\">
Buildings.Fluid.FixedResistances.Validation.PlugFlowPipes.Data.BaseClasses.PipeDataULg</a>
for more information.
</p>
</html>"));
end PipeDataULg151204_1;
