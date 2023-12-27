within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model SimpleCharacterization
  "Validation model for the calculation of the filter efficiency and the flow coefficient correction factor"
  extends Modelica.Icons.Example;
  Buildings.Fluid.AirFilters.BaseClasses.SimpleCharacterization simCha(
    mCon_nominal=1,
    epsFun={0.98,-0.1},
    b=1.2) "filter characterization"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
   Modelica.Blocks.Sources.Ramp mCon(
    duration=1,
    height=1.2,
    offset=0) "mass of the contaminant held by the filter"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
equation
  connect(mCon.y, simCha.mCon)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/SimpleCharacterization.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
The input mass of the contaminant held by the filter <code>mCon</code> 
changes from <i>0</i> to <i>1.2</i> from 0 to 1 sencond.
</p>
<p>
The <code>eps</code> changes from 0.98 to 0.88 during the period from
0 second to 0.85 seconds.
After 0.85 seconds, the <code>eps</code> keeps unchanged when <code>mCon</code> changes.
This is because the <code>Phi<code> already reaches the maximum value.          
</p>
<p>
Likewise, the <code>kCor</code> changes from 1 to 1.2 during the period from
0 second to 0.85 seconds and then keeps constant afterward.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SimpleCharacterization;
