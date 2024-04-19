within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model FiltrationEfficiency
  "Validation model for the calculation of the filtration efficiency"
  extends Modelica.Icons.Example;
  Buildings.Fluid.AirFilters.BaseClasses.FiltrationEfficiency eps(
    mCon_nominal=1,
    epsFun={0.98,-0.1})
    "Filtration efficiency"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp mCon(
    duration=1,
    height=1.2,
    offset=0)
    "Mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(mCon.y, eps.mCon)
  annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));

annotation (experiment(Tolerance=1e-6, StopTime=1.0),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/FiltrationEfficiency.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
The input mass of the contaminant captured by the filter <code>mCon</code> 
changes from <i>0</i> to <i>1.2kg/s</i> from 0 to 1 second.
</p>
<p>
The filtration efficiency, <code>eps.y</code>, changes from 0.98 to 0.88 during the period from
0 to 0.85 seconds.
After 0.85 seconds, the <code>eps.y</code> remains unchanged when <code>mCon</code> changes.
This is because the relative mass of contaminant captured by the filter already
reaches the maximum value.          
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FiltrationEfficiency;
