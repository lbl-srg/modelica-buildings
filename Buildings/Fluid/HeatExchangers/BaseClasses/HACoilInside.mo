within Buildings.Fluid.HeatExchangers.BaseClasses;
model HACoilInside "Calculates the hA value for water inside a coil"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal "Water mass flow rate"
    annotation(Dialog(tab="General", group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput m_flow(unit="kg/s") "Mass flow rate"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealInput T(unit="K") "Temperature"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));

  Modelica.Blocks.Interfaces.RealOutput hA(unit="W/K")
    "Inside convective heat transfer" annotation (Placement(transformation(
          extent={{100,-10},{120,10}})));

  parameter Modelica.SIunits.ThermalConductance hA_nominal(min=0)
    "Convective heat transfer coefficient"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real n(min=0, max=1)=0.85
    "Water-side exponent for convective heat transfer coefficient, h proportional to m_flow^n";
  parameter Modelica.SIunits.Temperature T_nominal=
          Modelica.SIunits.Conversions.from_degC(20)
    "Nominal water temperature"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean flowDependent=true
    "Set to false to make hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean temperatureDependent = true
    "Set to false to make hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);

protected
  Real x(min=0)
    "Factor for temperature dependent variation of heat transfer coefficient";
  parameter Real s(min=0, fixed=false)
    "Coefficient for temperature dependence of heat transfer coefficient";
  Real fm "Fraction of actual to nominal mass flow rate";

initial equation
  s =  if temperatureDependent then
            0.014/(1+0.014*Modelica.SIunits.Conversions.to_degC(T_nominal)) else
              1;
equation
  fm = if flowDependent then m_flow / m_flow_nominal else 1;
  x = if temperatureDependent then 1 + s * (T-T_nominal) else 1;
  if flowDependent and temperatureDependent then
    hA = x * hA_nominal * Buildings.Utilities.Math.Functions.regNonZeroPower(fm, n, 0.1);
  elseif flowDependent then
    hA = hA_nominal * Buildings.Utilities.Math.Functions.regNonZeroPower(fm, n, 0.1);
  elseif temperatureDependent then
    hA = x * hA_nominal;
  else
    hA = hA_nominal;
  end if;

annotation (                    defaultComponentName="HASin",
Documentation(info="<html>
<p>
Model for convective heat transfer coefficients inside a coil.
Optionally, the convective heat transfer coefficient can
be computed as a function of temperature and mass flow rate.
</p>
</html>",
revisions="<html>
<ul>
<li>
May 10, 2013, by Michael Wetter:<br/>
Revised and simplified the implementation.
</li>
<li>
February 26, 2013, by Peter Grant:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={            Text(
          extent={{-66,88},{60,-2}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="hA"),
        Rectangle(
          extent={{-74,-12},{76,-72}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-74,-24},{76,-56}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-52,-40},{56,-40},{44,-32}}, color={175,175,175}),
        Line(points={{56,-40},{44,-48}}, color={175,175,175})}),
              Icon(
      Rectangle(extent={{-36,-36},{-24,-72}},   style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Line(points=[-12,-52; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[-4,-40; -4,-68],    style(color=69, fillColor=47)),
      Line(points=[-4,-68; -10,-58],    style(color=69, fillColor=47)),
      Line(points=[-4,-68; 2,-58],      style(color=69, fillColor=47)),
      Line(points=[14,-58; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[14,-46; 26,-52],    style(color=42, fillColor=45)),
      Line(points=[16,-40; 16,-68],    style(color=69, fillColor=47)),
      Line(points=[16,-68; 10,-58],     style(color=69, fillColor=47)),
      Line(points=[16,-68; 22,-58],     style(color=69, fillColor=47)),
      Rectangle(extent={{-36,66},{-24,30}},     style(
          color=0,
          fillColor=8,
          fillPattern=8)),
      Line(points=[-12,50; 26,50],      style(color=42, fillColor=45)),
      Line(points=[-4,62; -4,34],      style(color=69, fillColor=47)),
      Line(points=[-4,34; -10,44],      style(color=69, fillColor=47)),
      Line(points=[-4,34; 2,44],        style(color=69, fillColor=47)),
      Line(points=[14,44; 26,50],      style(color=42, fillColor=45)),
      Line(points=[14,56; 26,50],      style(color=42, fillColor=45)),
      Line(points=[16,62; 16,34],      style(color=69, fillColor=47)),
      Line(points=[16,34; 10,44],       style(color=69, fillColor=47)),
      Line(points=[16,34; 22,44],       style(color=69, fillColor=47))));
end HACoilInside;
