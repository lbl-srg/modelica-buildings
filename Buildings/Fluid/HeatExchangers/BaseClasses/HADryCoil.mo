within Buildings.Fluid.HeatExchangers.BaseClasses;
model HADryCoil
  "Sensible convective heat transfer model for air to water coil"
  extends Modelica.Blocks.Icons.Block;

  parameter Modelica.Units.SI.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow"
    annotation (Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_w
    "Water mass flow rate"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal_a
    "Air mass flow rate"
    annotation (Dialog(tab="General", group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput m1_flow(final unit="kg/s") "Mass flow rate medium 1"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Modelica.Blocks.Interfaces.RealInput m2_flow(final unit="kg/s") "Mass flow rate medium 2"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealInput T_1(final unit="K") "Temperature medium 1"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Interfaces.RealInput T_2(final unit="K") "Temperature medium 2"
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}})));

  Modelica.Blocks.Interfaces.RealOutput hA_1(final unit="W/K")
    "Convective heat transfer medium 1" annotation (Placement(transformation(
          extent={{100,60},{120,80}})));
  Modelica.Blocks.Interfaces.RealOutput hA_2(final unit="W/K")
    "Convective heat transfer medium 2" annotation (Placement(transformation(
          extent={{100,-80},{120,-60}})));

  parameter Real r_nominal(min=0)=0.5
    "Ratio between air-side and water-side convective heat transfer coefficient"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.ThermalConductance hA_nominal_w(min=0) =
    UA_nominal*(r_nominal + 1)/r_nominal
    "Water side convective heat transfer coefficient"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.ThermalConductance hA_nominal_a(min=0) =
    r_nominal*hA_nominal_w
    "Air side convective heat transfer coefficient, including fin resistance"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Real n_w(min=0, max=1)=0.85
    "Water-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Real n_a(min=0, max=1)=0.8
    "Air-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Modelica.Units.SI.Temperature T0_w=
      Modelica.Units.Conversions.from_degC(20) "Water temperature"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature T0_a=
      Modelica.Units.Conversions.from_degC(20) "Air temperature"
    annotation (Dialog(tab="General", group="Nominal condition"));
  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean airSideFlowDependent = true
    "Set to false to make air-side hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean waterSideTemperatureDependent = true
    "Set to false to make water-side hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean airSideTemperatureDependent = true
    "Set to false to make air-side hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
protected
  Real x_a(min=0)
    "Factor for air side temperature dependent variation of heat transfer coefficient";
  Real x_w(min=0)
    "Factor for water side temperature dependent variation of heat transfer coefficient";
  parameter Real s_w(min=0, fixed=false)
    "Coefficient for temperature dependence of water side heat transfer coefficient";
  Real fm_w "Fraction of actual to nominal mass flow rate";
  Real fm_a "Fraction of actual to nominal mass flow rate";
initial equation
  s_w =if waterSideTemperatureDependent then 0.014/(1 + 0.014*
    Modelica.Units.Conversions.to_degC(T0_w)) else 1;
equation
  fm_w = if waterSideFlowDependent then
              m1_flow / m_flow_nominal_w else 1;
  fm_a = if airSideFlowDependent then
              m2_flow / m_flow_nominal_a else 1;
  x_w = if waterSideTemperatureDependent then
         1 + s_w * (T_1-T0_w) else
              1;
  x_a = if airSideTemperatureDependent then
         1 + 7.8532E-4 * (T_2-T0_a) else
              1;
  if waterSideFlowDependent then
    hA_1 = x_w * hA_nominal_w
               * Buildings.Utilities.Math.Functions.regNonZeroPower(fm_w, n_w, 0.1);
  else
    hA_1 = x_w * hA_nominal_w;
  end if;

  if airSideFlowDependent then
    hA_2 = x_a * hA_nominal_a
               * Buildings.Utilities.Math.Functions.regNonZeroPower(fm_a, n_a, 0.1);
  else
    hA_2 = x_a * hA_nominal_a;
  end if;
annotation (Documentation(info="<html>
<p>
Model for sensible convective heat transfer coefficients for an air to water coil.
</p>
<p>
This model computes the convective heat transfer coefficient
for an air to water coil.
The parameters allow a user to enable or disable, individually
for each medium, the mass flow and/or the temperature dependence
of the convective heat transfer coefficients.
For a detailed explanation of the equation, see
the references below.
</p>
<h4>References</h4>
<ul>
<li>
Wetter Michael,
<a href=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7353\">
Simulation model finned water-air-coil without condensation</a>,
LBNL-42355,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
<li>
Wetter Michael,
<a href=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7352\">
Simulation model air-to-air plate heat exchanger</a>,
LBNL-42354,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
</ul>
</html>",
revisions="<html>
<ul>
<li>
April 9, 2017, by Michael Wetter:<br/>
Corrected coefficient in Taylor expansion of <code>x_a</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/698\">#698</a>.
</li>
<li>
June 8, 2010, by Michael Wetter:<br/>
Fixed bug in computation of <code>s_w</code>.
The old implementation used the current inlet water temperature instead
of the design condition that corresponds to <code>UA_nominal</code>.
</li>
<li>
April 16, 2008, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={            Text(
          extent={{-60,90},{66,0}},
          textColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="hA"),
        Ellipse(
          extent={{-32,-10},{-12,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{34,-10},{54,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,-10},{20,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-64,-10},{-44,-32}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,-40},{-28,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-16,-40},{4,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{16,-40},{36,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{50,-40},{70,-62}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-68,-66},{-48,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-66},{-16,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-4,-66},{16,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{30,-66},{50,-88}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}));
end HADryCoil;
