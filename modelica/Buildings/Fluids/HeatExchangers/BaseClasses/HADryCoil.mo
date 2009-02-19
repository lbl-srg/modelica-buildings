within Buildings.Fluids.HeatExchangers.BaseClasses;
model HADryCoil "Sensible convective heat transfer model for air to water coil"
  extends Buildings.BaseClasses.BaseIcon;
annotation (Diagram(graphics),
Documentation(info="<html>
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
<h3>References</h3>
<p>
<ul>
<li>
Wetter Michael,
<A HREF=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7353\">
Simulation model finned water-air-coil without condensation</a>,
LBNL-42355,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
<li>
Wetter Michael,
<A HREF=\"http://www.osti.gov/energycitations/product.biblio.jsp?osti_id=7352\">
Simulation model air-to-air plate heat exchanger</A>,
LBNL-42354,
Lawrence Berkeley National Laboratory,
Berkeley, CA, 1999.
</li>
</ul>
</p>
</html>",
revisions="<html>
<ul>
<li>
April 16, 2008, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-66,74},{92,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString=
               "hA")}));
  parameter Modelica.SIunits.ThermalConductance UA0(min=0)
    "Thermal conductance at nominal flow" 
          annotation(Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m0_flow_w "Water mass flow rate" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m0_flow_a "Air mass flow rate" 
          annotation(Dialog(tab="General", group="Nominal condition"));

  ObsoleteModelica3.Blocks.Interfaces.RealSignal m_flow_1
    "Mass flow rate medium 1" 
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}, rotation=
           0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal m_flow_2
    "Mass flow rate medium 2" 
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}},
          rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal hA_1
    "Convective heat transfer medium 1" annotation (Placement(transformation(
          extent={{100,60},{120,80}}, rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal hA_2
    "Convective heat transfer medium 2" annotation (Placement(transformation(
          extent={{100,-80},{120,-60}}, rotation=0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal T_1 "Temperature medium 1" 
    annotation (Placement(transformation(extent={{-120,20},{-100,40}}, rotation=
           0)));
  ObsoleteModelica3.Blocks.Interfaces.RealSignal T_2 "Temperature medium 2" 
    annotation (Placement(transformation(extent={{-120,-40},{-100,-20}},
          rotation=0)));
  annotation (Icon(
      Rectangle(extent=[-36,-36; -24,-72],   style(
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
      Rectangle(extent=[-36,66; -24,30],     style(
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

  parameter Real r(min=0, max=1)=0.5
    "Ratio between air-side and water-side convective heat transfer coefficient";
  parameter Modelica.SIunits.ThermalConductance hA0_w(min=0)=UA0 * (r+1)/r
    "Water side convective heat transfer coefficient" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.ThermalConductance hA0_a(min=0)=r * hA0_w
    "Air side convective heat transfer coefficient, including fin resistance" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real n_w(min=0, max=1)=0.85
    "Water-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Real n_a(min=0, max=1)=0.8
    "Air-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Modelica.SIunits.Temperature T0_w=
          Modelica.SIunits.Conversions.from_degC(20) "Water temperature" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.Temperature T0_a=
          Modelica.SIunits.Conversions.from_degC(20) "Air temperature" 
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean waterSideFlowDependent = true
    "Set to false to make water-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean airSideFlowDependent = true
    "Set to false to make air-side hA independent of mass flow rate" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean waterSideTemperatureDependent = true
    "Set to false to make water-side hA independent of temperature" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
  parameter Boolean airSideTemperatureDependent = true
    "Set to false to make air-side hA independent of temperature" 
    annotation(Dialog(tab="Advanced", group="Modeling detail"));
protected
  Real x_a(min=0)
    "Factor for air side temperature dependent variation of heat transfer coefficient";
  Real x_w(min=0)
    "Factor for water side temperature dependent variation of heat transfer coefficient";
  Real s_w(min=0, nominal=0.01)
    "Coefficient for temperature dependence of water side heat transfer coefficient";
  Real fm_w "Fraction of actual to nominal mass flow rate";
  Real fm_a "Fraction of actual to nominal mass flow rate";
equation
  fm_w = if waterSideFlowDependent then 
              m_flow_1 / m0_flow_w else 1;
  fm_a = if airSideFlowDependent then 
              m_flow_2 / m0_flow_a else 1;
  s_w =  if waterSideTemperatureDependent then 
            0.014/(1+0.014*Modelica.SIunits.Conversions.to_degC(T_1)) else 
              1;
  x_w = if waterSideTemperatureDependent then 
         1 + s_w * (T_1-T0_w) else 
              1;
  x_a = if airSideTemperatureDependent then 
         1 + 4.769E-3 * (T_2-T0_a) else 
              1;
  if ( waterSideFlowDependent == true) then
    hA_1 = x_w * Buildings.Utilities.Math.regNonZeroPower(fm_w, n_w, 0.1) * hA0_w;
  else
    hA_1 = x_w * hA0_w;
  end if;

  if ( airSideFlowDependent == true) then
    hA_2 = x_a * Buildings.Utilities.Math.regNonZeroPower(fm_a, n_a, 0.1) * hA0_a;
  else
    hA_2 = x_a * hA0_a;
  end if;
end HADryCoil;
