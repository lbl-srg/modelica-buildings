within Buildings.Fluid.FixedResistances.Functions.Validation;
model PressureLossPipe
  "Validation model for pressureLossCircularPipe"
  extends .Modelica.Icons.Example;

  parameter .Modelica.Units.SI.Length hSeg = 100
    "Length of the pipe";
  parameter .Modelica.Units.SI.Radius rTub = 0.02
    "Outer tube radius";
  parameter .Modelica.Units.SI.Length eTub = 0.002
    "Tube wall thickness";
  parameter .Modelica.Units.SI.Length roughness = 0.001e-3
    "Absolute pipe wall roughness";
  parameter .Modelica.Units.SI.Density rhoMed = 1000
    "Density of the fluid";
  parameter .Modelica.Units.SI.DynamicViscosity muMed = 1E-3
    "Dynamic viscosity of the fluid";
  final parameter .Modelica.Units.SI.Radius rTub_in = rTub - eTub
    "Inner tube radius";
  final parameter .Modelica.Units.SI.Diameter diameter = 2*rTub_in
    "Inner tube diameter";
  final parameter .Modelica.Units.SI.Area crossArea =
    .Modelica.Constants.pi*rTub_in^2
    "Inner cross-sectional area";
  parameter Real kMinor(unit="1", min=0) = 2
    "Total minor-loss coefficient";

  .Modelica.Units.SI.ReynoldsNumber Re
    "Reynolds number";
  .Modelica.Units.SI.MassFlowRate m_flow
    "Mass flow rate";
  .Modelica.Units.SI.PressureDifference dp
    "Pressure drop";
  .Modelica.Units.SI.PressureDifference dp_lam
    "Laminar pressure-drop reference";
  .Modelica.Units.SI.PressureDifference dp_noMinor
    "Pressure drop without minor losses";
  .Modelica.Units.SI.PressureDifference dp_minor
    "Minor-loss contribution";

equation
  Re = time;

  m_flow = Re*crossArea*muMed/diameter;

  dp =
    .Buildings.Fluid.FixedResistances.Functions.pressureLossPipe(
      length=hSeg,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=m_flow,
      kMinor=kMinor);

  dp_noMinor =
    .Buildings.Fluid.FixedResistances.Functions.pressureLossPipe(
      length=hSeg,
      rTub=rTub,
      eTub=eTub,
      roughness=roughness,
      rhoMed=rhoMed,
      muMed=muMed,
      m_flow=m_flow,
      kMinor=0);

  dp_minor = dp - dp_noMinor;
  
  dp_lam =
    hSeg*muMed^2/(2*rhoMed*diameter^3)*
    64*Re;

  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/BaseClasses/Boreholes/BaseClasses/Functions/Validation/PressureLossCircularPipe.mos"
      "Simulate and plot"),
    experiment(
      StopTime=10000.0,
      Tolerance=1E-6),
    Documentation(info="<html>
<p>
This validation model evaluates
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>
for Reynolds numbers between 0 and 10000.
</p>

<p>
The Reynolds number is prescribed as <code>Re = time</code>. The corresponding
mass flow rate is computed from the pipe geometry and fluid viscosity. This
allows plotting the pressure drop as a direct function of Reynolds number.
</p>

<p>
The validation checks that the pressure drop is finite at zero flow, increases
smoothly with Reynolds number, and follows the laminar pressure-loss limit for
small Reynolds numbers.
</p>

<p>
The validation also evaluates the pressure drop with and without the minor-loss
coefficient. The variable <code>dp_minor</code> is the added minor-loss
contribution. It is zero at zero flow and increases with the square of the
Reynolds number.
</p>

<p>
The pressure-loss equations are documented in
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe\">
Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.Functions.pressureLossCircularPipe</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
Added validation of the minor-loss contribution.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
<li>
July 2026, by Lone Meertens:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"));
end PressureLossPipe;
