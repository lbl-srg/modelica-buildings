within Buildings.Fluid.FixedResistances.Functions.Validation;
model ChurchillFrictionFactorRe2
  "Validation of the modified Churchill friction coefficient lambda2 = f*Re^2"
  extends Modelica.Icons.Example;

  // Pipe geometry
  parameter Modelica.Units.SI.Radius rTub = 0.02
    "Tube outer radius";
  parameter Modelica.Units.SI.Length eTub = 0.002
    "Tube wall thickness";
  parameter Modelica.Units.SI.Radius rTub_in = rTub - eTub
    "Tube inner radius";

  // Pipe roughness
  parameter Modelica.Units.SI.Length eps_smooth = 0.001e-3
    "Absolute roughness — smooth HDPE pipe (0.001 mm)";
  parameter Modelica.Units.SI.Length eps_rough = 0.046e-3
    "Absolute roughness — commercial steel pipe (0.046 mm)";

  parameter Real eps_D_smooth = eps_smooth / (2*rTub_in)
    "Relative roughness smooth pipe (eps/D)";
  parameter Real eps_D_rough = eps_rough / (2*rTub_in)
    "Relative roughness rough pipe (eps/D)";

  Real Re
    "Reynolds number = time";
  Real lambda2_smooth
    "Modified friction coefficient — smooth HDPE pipe";
  Real lambda2_rough
    "Modified friction coefficient — commercial steel pipe";
  Real lambda2_lam
    "Laminar reference: lambda2 = 64*Re";

equation
  Re = time;

  lambda2_smooth =
    Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2(
      Re=Re,
      eps_D=eps_D_smooth);

  lambda2_rough =
    Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2(
      Re=Re,
      eps_D=eps_D_rough);

  lambda2_lam = 64*Re;

  annotation (
    experiment(Tolerance=1e-6, StopTime=30000.0),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Functions/Validation/ChurchillFrictionFactorRe2.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2\">
Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactorRe2</a>.
</p>
<p>
The Reynolds number is prescribed as <code>Re = time</code>, sweeping the range
from zero to 30000. This includes the zero-flow point, which is intentionally
allowed for the modified coefficient
<i>&lambda;<sub>2</sub> = f Re<sup>2</sup></i>.
</p>
<p>
Two cases are compared using the same pipe geometry
(<i>r<sub>tub</sub></i> = 0.02 m, <i>e<sub>tub</sub></i> = 0.002 m,
<i>D<sub>in</sub></i> = 0.036 m):
</p>
<ul>
<li>
Smooth HDPE pipe: <i>&epsilon;</i> = 0.001 mm
(&epsilon;/D = 2.78 &times; 10<sup>-5</sup>).
</li>
<li>
Commercial steel pipe: <i>&epsilon;</i> = 0.046 mm
(&epsilon;/D = 1.28 &times; 10<sup>-3</sup>).
</li>
</ul>
<p>
The laminar reference
<i>&lambda;<sub>2</sub> = 64 Re</i> is also output for comparison. Near zero
flow, both Churchill-based curves follow this laminar limit.
</p>
</html>", revisions="<html>
<ul>
<li>
July 22, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));
end ChurchillFrictionFactorRe2;
