within Buildings.Fluid.FixedResistances.Functions.Validation;
model ChurchillFrictionFactor
  "Validation of the Churchill (1977) friction factor function"
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

  Real Re(start=1) "Reynolds number = time";
  Real f_smooth "Churchill friction factor — smooth HDPE pipe";
  Real f_rough  "Churchill friction factor — commercial steel pipe";
  Real f_lam    "Laminar reference: 64/Re";

equation
  Re = time;

  f_smooth = Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
    Re=Re,
    eps_D=eps_D_smooth);

  f_rough = Buildings.Fluid.FixedResistances.Functions.churchillFrictionFactor(
    Re=Re,
    eps_D=eps_D_rough);

  f_lam = 64/Re;

  annotation (
    experiment(Tolerance=1e-6, StopTime=30000.0),
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
The Reynolds number increases with time so that <i>Re = t</i>,
sweeping the full laminar–transitional–turbulent range
over the simulation interval 0–30 000 s.
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
The laminar reference <i>f = 64/Re</i> is also output for comparison.
</p>
</html>", revisions="<html>
<ul>
<li>
July 14, 2026, by L. Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4655\">
Buildings, #4655</a>.
</li>
</ul>
</html>"));
end ChurchillFrictionFactor;
