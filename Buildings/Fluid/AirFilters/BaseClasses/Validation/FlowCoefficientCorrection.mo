within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model FlowCoefficientCorrection
  "Validation model for the calculation of the flow coefficient correction factor"
  extends Modelica.Icons.Example;
   Modelica.Blocks.Sources.Ramp rat(
    duration=1,
    height=1,
    offset=0)
   "Relative mass of the contaminant captured by the filter"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
   Buildings.Fluid.AirFilters.BaseClasses.FlowCoefficientCorrection kCor(
    b=1.2)
    "Flow coefficient correction"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
equation
  connect(rat.y, kCor.rat)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StopTime=1.0),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/FlowCoefficientCorrection.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
The input relative mass of the contaminant captured by the filter <code>rat</code> 
changes from <i>0</i> to <i>1</i> from 0 to 1 second.
</p>
<p>
The <code>kCor.y</code> changes from 1 to 1.2 during the period from
0 to 1 second.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end FlowCoefficientCorrection;
