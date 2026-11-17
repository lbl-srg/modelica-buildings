within Buildings.Fluid.FixedResistances.Functions.Validation;
model ChurchillFrictionFactor
  "Validation of the Churchill friction factor function"
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
  parameter Real eps_D_rough  = eps_rough  / (2*rTub_in)
    "Relative roughness rough pipe (eps/D)";

  parameter Real Re_start(unit="1") = 100
  "Start value for Reynolds number";
  parameter Real Re_end(unit="1") = 30000
    "End value for Reynolds number";
  parameter Modelica.Units.SI.Time tEnd = 30
    "Time used to sweep the Reynolds number";
  parameter Real k(unit="1/s") = (Re_end - Re_start)/tEnd
    "Conversion factor from time to Reynolds number";

  Real Re(unit="1")
    "Reynolds number";

  Real f_smooth "Churchill friction factor — smooth HDPE pipe";
  Real f_rough  "Churchill friction factor — commercial steel pipe";
  Real f_lam    "Laminar reference: 64/Re";

equation
  Re = Re_start + k*time;

  f_smooth = Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
    Re=Re,
    eps_D=eps_D_smooth);

  f_rough = Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
    Re=Re,
    eps_D=eps_D_rough);

  f_lam = 64/Re;

  annotation (
    experiment(Tolerance=1e-6, StopTime=30),
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/FixedResistances/Functions/Validation/ChurchillFrictionFactor.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This example validates the implementation of
<a href=\"modelica://Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor\">
Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor</a>.
</p>
<p>
The Reynolds number is prescribed as a dimensionless ramp from
<i>100</i> to <i>30000</i> using an explicit conversion factor from
simulation time. This sweeps the laminar, transitional, and turbulent
range while avoiding the singularity of the raw Darcy friction factor at
<i>Re = 0</i>.
</p>
<p>
Two cases are compared using the same pipe geometry
(<i>r<sub>tub</sub> = 0.02</i> m, <i>e<sub>tub</sub> = 0.002</i> m,
<i>D<sub>in</sub> = 0.036</i> m):
</p>
<ul>
<li>
Smooth HDPE pipe: <i>&epsilon; = 0.001</i> mm
(&epsilon;/D = 2.78 &times; 10<sup>-5</sup>).
</li>
<li>
Commercial steel pipe: <i>&epsilon; = 0.046</i> mm
(&epsilon;/D = 1.28 &times; 10<sup>-3</sup>).
</li>
</ul>
<p>
The laminar reference <i>f = 64/Re</i> is also computed for comparison.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4655\">
Buildings, #4655</a>.
</li>
</ul>
</html>"));
end ChurchillFrictionFactor;
