within Buildings.Fluid.HeatExchangers.BaseClasses;
model HASingleFlow
  "Calculates hA values for a heat exchanger with internal flow"
  extends Buildings.BaseClasses.BaseIcon;
  parameter Modelica.SIunits.ThermalConductance UA_nominal(min=0)
    "Thermal conductance at nominal flow"
          annotation(Dialog(tab="General", group="Nominal condition"));

  parameter Modelica.SIunits.MassFlowRate m_flow_nominal_w
    "Water mass flow rate"
          annotation(Dialog(tab="General", group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput m1_flow "Mass flow rate medium 1"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}}, rotation=
           0)));
  Modelica.Blocks.Interfaces.RealInput T_1 "Temperature medium 1"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}}, rotation=
           0)));

  Modelica.Blocks.Interfaces.RealOutput hA_1
    "Convective heat transfer medium 1" annotation (Placement(transformation(
          extent={{100,60},{120,80}}, rotation=0)));
  Modelica.Blocks.Interfaces.RealOutput hA_2
    "Convective heat transfer medium 2" annotation (Placement(transformation(
          extent={{100,-80},{120,-60}}, rotation=0)));

  parameter Modelica.SIunits.Area A_2
    "External surface area of one segment of the heat exchanger";

  parameter Real r_nominal(min=0, max=1)=0.5
    "Ratio between air-side and water-side convective heat transfer coefficient"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Modelica.SIunits.ThermalConductance hA_nominal_w(min=0)=UA_nominal * (r_nominal+1)/r_nominal
    "Water side convective heat transfer coefficient"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Real n_w(min=0, max=1)=0.85
    "Water-side exponent for convective heat transfer coefficient, h~m_flow^n";
  parameter Modelica.SIunits.Temperature T0_w=
          Modelica.SIunits.Conversions.from_degC(20) "Water temperature"
          annotation(Dialog(tab="General", group="Nominal condition"));
  parameter Boolean waterSideFlowDependent=true
    "Set to false to make water-side hA independent of mass flow rate"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
  parameter Boolean waterSideTemperatureDependent = true
    "Set to false to make water-side hA independent of temperature"
    annotation(Dialog(tab="Advanced", group="Modeling detail"), Evaluate=true);
protected
  Real x_w(min=0)
    "Factor for water side temperature dependent variation of heat transfer coefficient";
  parameter Real s_w(min=0, fixed=false)
    "Coefficient for temperature dependence of water side heat transfer coefficient";
  Real fm_w "Fraction of actual to nominal mass flow rate";
public
  Modelica.Blocks.Interfaces.RealInput h_2
    "Convection coefficient for the stagnant fluid"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Sources.RealExpression ASurHX(y=A_2)
    "External surface area of the heat exchanger"
    annotation (Placement(transformation(extent={{-66,-100},{-46,-80}})));
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{-2,-80},{18,-60}})));
initial equation
  s_w =  if waterSideTemperatureDependent then
            0.014/(1+0.014*Modelica.SIunits.Conversions.to_degC(T0_w)) else
              1;
equation
  fm_w = if waterSideFlowDependent then
              m1_flow / m_flow_nominal_w else 1;
  x_w = if waterSideTemperatureDependent then
         1 + s_w * (T_1-T0_w) else
              1;
  if waterSideFlowDependent then
    hA_1 = x_w * hA_nominal_w
               * Buildings.Utilities.Math.Functions.regNonZeroPower(fm_w, n_w, 0.1);
  else
    hA_1 = x_w * hA_nominal_w;
  end if;

  connect(ASurHX.y, product1.u2) annotation (Line(
      points={{-45,-90},{-22,-90},{-22,-76},{-4,-76}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(h_2, product1.u1) annotation (Line(
      points={{-110,-40},{-22,-40},{-22,-64},{-4,-64}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(product1.y, hA_2) annotation (Line(
      points={{19,-70},{110,-70}},
      color={0,0,127},
      smooth=Smooth.None));
annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},
            {100,100}}),
                    graphics),
Documentation(info="<html>
<p>
Model for sensible convective heat transfer coefficients for a fluid to fluid coil. This model assumes the heated fluid is in a cylinder submerged in water.
</p>
<p>
This model computes the convective heat transfer coefficient between a fluid in a submerged coil and the surrounding fluid. User inputs describe the nominal conditions
for the fluid inside the heat exchanger and the geometry dictating the behavior outside of the coil.
</p>

</html>",
revisions="<html>
<ul>
<li>
February 26, 2013, by Peter Grant<br>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,
            100}}), graphics={Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid), Text(
          extent={{-66,74},{92,-50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="hA")}),
              Icon(
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
end HASingleFlow;
