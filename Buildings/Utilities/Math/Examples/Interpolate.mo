within Buildings.Utilities.Math.Examples;
model Interpolate "Example model of the Interpolate block"
  extends Modelica.Icons.Example;

  parameter Real table[:,:]=[-50,-0.08709; -25,-0.06158; -10,-0.03895; -5,-0.02754;
    -3,-0.02133; -2,-0.01742; -1,-0.01232; 0,0; 1,0.01232; 2,0.01742; 3,0.02133;
    4.5,0.02613; 50,0.02614]
    "Table of mass flow rate in kg/s (second column) as a function of pressure difference in Pa (first column)";
  parameter Real[:] xd=table[:,1] "x-axis support points";
  parameter Real[size(xd, 1)] yd=table[:,2] "y-axis support points";
  parameter Real[size(xd, 1)] d =
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x=xd,
      y=yd,
      ensureMonotonicity=true) "Derivatives at the support points";

  Buildings.Utilities.Math.Interpolate int(
    xd=xd,
    yd=yd,
    d=d) "Interpolate block"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Blocks.Sources.Ramp ramp(
    duration=500,
    height=100,
    offset=-50) "Ramp from -50Pa to +50Pa"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

equation
  connect(ramp.y, int.u)
    annotation (Line(points={{-39,0},{-12,0}}, color={0,0,127}));
annotation (
experiment(
      StopTime=500,
      Tolerance=1e-06),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Utilities/Math/Examples/Interpolate.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This example is the same as
<a href=\"modelica://Buildings.Utilities.Math.Functions.Examples.Interpolate\">
Buildings.Utilities.Math.Functions.Examples.Interpolate</a>
except that the block is used in place of the function.
</p>
</html>", revisions="<html>
<ul>
<li>
February 29, 2024, by Hongxiang Fu:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1844\">IBPSA, #1844</a>.
</li>
</ul>
</html>
"));
end Interpolate;
