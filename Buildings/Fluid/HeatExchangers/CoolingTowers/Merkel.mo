within Buildings.Fluid.HeatExchangers.CoolingTowers;
model Merkel "Cooling tower model based on Merkel's theory"
  extends Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.CoolingTower;

  import cha =
    Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Characteristics;

  final parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=
    m_flow_nominal/ratWatAir_nominal
    "Nominal mass flow rate of air"
    annotation (Dialog(group="Fan"));

  parameter Real ratWatAir_nominal(min=0, unit="1") = 1.2
    "Water-to-air mass flow rate ratio at design condition"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.SIunits.Temperature TAirInWB_nominal
    "Nominal outdoor (air inlet) wetbulb temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Temperature TWatIn_nominal
    "Nominal water inlet temperature"
    annotation (Dialog(group="Heat transfer"));
  parameter Modelica.SIunits.Temperature TWatOut_nominal
    "Nominal water outlet temperature"
    annotation (Dialog(group="Heat transfer"));

  parameter Real fraFreCon(min=0, max=1, final unit="1") = 0.125
    "Fraction of tower capacity in free convection regime"
    annotation (Dialog(group="Heat transfer"));

  replaceable parameter Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel UACor
    constrainedby Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel
    "Coefficients for UA correction"
    annotation (
      Dialog(group="Heat transfer"),
      choicesAllMatching=true,
      Placement(transformation(extent={{18,70},{38,90}})));

  parameter Real fraPFan_nominal(unit="W/(kg/s)") = 275/0.15
    "Fan power divided by water mass flow rate at design condition"
    annotation (Dialog(group="Fan"));
  parameter Modelica.SIunits.Power PFan_nominal = fraPFan_nominal*m_flow_nominal
    "Fan power"
    annotation (Dialog(group="Fan"));

  parameter Real yMin(min=0.01, max=1, final unit="1") = 0.3
    "Minimum control signal until fan is switched off (used for smoothing
    between forced and free convection regime)"
    annotation (Dialog(group="Fan"));

  replaceable parameter cha.fan fanRelPow(
       r_V = {0, 0.1,   0.3,   0.6,   1},
       r_P = {0, 0.1^3, 0.3^3, 0.6^3, 1})
    constrainedby cha.fan
    "Fan relative power consumption as a function of control signal, fanRelPow=P(y)/P(y=1)"
    annotation (
    choicesAllMatching=true,
    Placement(transformation(extent={{58,70},{78,90}})),
    Dialog(group="Fan"));

  final parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(max=0)=per.Q_flow_nominal
    "Nominal heat transfer, (negative)";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal=per.UA_nominal
    "Thermal conductance at nominal flow, used to compute heat capacity";
  final parameter Real eps_nominal=per.eps_nominal
    "Nominal heat transfer effectiveness";
  final parameter Real NTU_nominal(min=0)=per.NTU_nominal
    "Nominal number of transfer units";

  Modelica.Blocks.Interfaces.RealInput TAir(
    final min=0,
    final unit="K",
    displayUnit="degC")
    "Entering air wet bulb temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}})));

  Modelica.Blocks.Interfaces.RealInput y(unit="1") "Fan control signal"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));

  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W")=
    Buildings.Utilities.Math.Functions.spliceFunction(
        pos=cha.normalizedPower(per=fanRelPow, r_V=y, d=fanRelPowDer) * PFan_nominal,
        neg=0,
        x=y-yMin+yMin/20,
        deltax=yMin/20)
    "Electric power consumed by fan"
    annotation (Placement(transformation(extent={{100,70},{120,90}}),
        iconTransformation(extent={{100,70},{120,90}})));

protected
  final parameter Real fanRelPowDer[size(fanRelPow.r_V,1)]=
    Buildings.Utilities.Math.Functions.splineDerivatives(
      x=fanRelPow.r_V,
      y=fanRelPow.r_P,
      ensureMonotonicity=Buildings.Utilities.Math.Functions.isMonotonic(
        x=fanRelPow.r_P,
        strict=false))
    "Coefficients for fan relative power consumption as a function
    of control signal";

  Modelica.Blocks.Sources.RealExpression TWatIn(
    final y=Medium.temperature(
      Medium.setState_phX(
        p=port_a.p,
        h=inStream(port_a.h_outflow),
        X=inStream(port_a.Xi_outflow))))
    "Water inlet temperature"
    annotation (Placement(transformation(extent={{-70,36},{-50,54}})));
  Modelica.Blocks.Sources.RealExpression mWat_flow(final y=port_a.m_flow)
    "Water mass flow rate"
    annotation (Placement(transformation(extent={{-70,20},{-50,38}})));

  Buildings.Fluid.HeatExchangers.CoolingTowers.BaseClasses.Merkel per(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final ratWatAir_nominal=ratWatAir_nominal,
    final TAirInWB_nominal=TAirInWB_nominal,
    final TWatIn_nominal=TWatIn_nominal,
    final TWatOut_nominal=TWatOut_nominal,
    final fraFreCon=fraFreCon,
    final UACor = UACor,
    final yMin=yMin) "Model for thermal performance"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));

initial equation
  // Check validity of relative fan power consumption at y=yMin and y=1
  assert(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer) > -1E-4,
    "The fan relative power consumption must be non-negative for y=0."
  + "\n   Obtained fanRelPow(0) = "
  + String(cha.normalizedPower(per=fanRelPow, r_V=yMin, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow.");
  assert(abs(1-cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))<1E-4,
  "The fan relative power consumption must be one for y=1."
  + "\n   Obtained fanRelPow(1) = "
  + String(cha.normalizedPower(per=fanRelPow, r_V=1, d=fanRelPowDer))
  + "\n   You need to choose different values for the parameter fanRelPow."
  + "\n   To increase the fan power, change fraPFan_nominal or PFan_nominal.");

equation
  connect(per.y, y) annotation (Line(points={{-22,58},{-40,58},{-40,80},{-120,
          80}},
        color={0,0,127}));
  connect(per.TAir, TAir) annotation (Line(points={{-22,54},{-80,54},{-80,40},{
          -120,40}},
                color={0,0,127}));
  connect(per.Q_flow, preHea.Q_flow) annotation (Line(points={{1,50},{12,50},{
          12,12},{-80,12},{-80,-60},{-40,-60}},color={0,0,127}));
  connect(per.m_flow, mWat_flow.y) annotation (Line(points={{-22,42},{-34,42},{
          -34,29},{-49,29}},
                         color={0,0,127}));
  connect(TWatIn.y, per.TWatIn) annotation (Line(points={{-49,45},{-40,45},{-40,
          46},{-22,46}},        color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Text(
          extent={{-98,100},{-86,84}},
          lineColor={0,0,127},
          textString="y"),
        Text(
          extent={{-104,70},{-70,32}},
          lineColor={0,0,127},
          textString="TWB"),
        Rectangle(
          extent={{-100,81},{-70,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-54,6},{58,-114}},
          lineColor={255,255,255},
          fillColor={0,127,0},
          fillPattern=FillPattern.Solid,
          textString="Merkel"),
        Ellipse(
          extent={{-54,62},{0,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,62},{54,50}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,82},{100,78}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{70,56},{82,52}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{78,54},{82,80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{64,114},{98,76}},
          lineColor={0,0,127},
          textString="PFan"),
        Rectangle(
          extent={{78,-60},{82,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{70,-58},{104,-96}},
          lineColor={0,0,127},
          textString="TLvg"),
        Rectangle(
          extent={{78,-58},{102,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(preserveAspectRatio=false)),
    Documentation(
info="<html>
<p>
Model for a steady-state or dynamic cooling tower with a variable speed fan
using Merkel's calculation method.
</p>
<h4>Thermal performance</h4>
<p>
To compute the thermal performance, this model takes as parameters the nominal water
mass flow rate, the water-to-air mass flow ratio at nominal condition,
the nominal inlet air wetbulb temperature,
and the nominal water inlet and outlet temperatures. Cooling tower performance is
modeled using the effectiveness-NTU relationships for various heat exchanger flow regimes.
</p>
<p>
The total heat transfer between the air and water entering the tower is computed based
on Merkel's theory. The fundamental basis for Merkel's theory is that the steady-state
total heat transfer is proportional to the difference between the enthalpy of air and
the enthalpy of air saturated at the wetted-surface temperature. This is represented
by
</p>
<p align=\"center\" style=\"font-style:italic;\">
 dQ&#775;<sub>total</sub> = UdA/c<sub>p</sub> (h<sub>s</sub> - h<sub>a</sub>),
</p>
<p>
where
<i>h<sub>s</sub></i> is the enthalpy of saturated air at the wetted-surface temperature,
<i>h<sub>a</sub></i> is the enthalpy of air in the free stream,
<i>c<sub>p</sub></i> is the specific heat of moist air,
<i>U</i> is the cooling tower overall heat transfer coefficient, and
<i>A</i> is the heat transfer surface area.
</p>
<p>
The model also treats the moist air as an equivalent gas with a mean specific heat
<i>c<sub>pe</sub></i> defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
 c<sub>pe</sub> = &Delta;h / &Delta;T<sub>wb</sub>,
</p>
<p>
where
<i>&Delta;h</i> and <i>&Delta;T<sub>wb</sub></i> are the enthalpy difference and
wetbulb temperature difference, respectively, between the entering and leaving air.
</p>
<p>
For off-design conditions, Merkel's theory is modified to include Sheier's
adjustment factors that change the current <i>UA</i> value. The three adjustment factors, based
on the current wetbulb temperature, air flow rates, and water flow rates, are used to calculate the
<i>UA</i> value as
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>e</sub> = UA<sub>0</sub> &#183; f<sub>UA,wetbulb</sub> &#183; f<sub>UA,airflow</sub> &#183; f<sub>UA,waterflow</sub>,
</p>
<p>
where
<i>UA<sub>e</sub></i> and <i>UA<sub>0</sub></i> are the equivalent and design
overall heat transfer coefficent-area products, respectively.
The factors <i>f<sub>UA,wetbulb</sub></i>, <i>f<sub>UA,airflow</sub></i>, and <i>f<sub>UA,waterflow</sub></i>
adjust the current <i>UA</i> value for the current wetbulb temperature, air flow rate, and water
flow rate, respectively. These adjustment factors are third-order polynomial functions defined as
</p>
<p align=\"center\" style=\"font-style:italic;\">
f<sub>UA,x</sub> =
    c<sub>x,0</sub>&nbsp;
  + c<sub>x,1</sub> x
  + c<sub>x,2</sub> x<sup>2</sup>
  + c<sub>x,3</sub> x<sup>3</sup>,
</p>
<p>
where <i>x = {(T<sub>0,wetbulb</sub> - T<sub>wetbulb</sub>), &nbsp;
m&#775;<sub>air</sub> &frasl; m&#775;<sub>0,air</sub>, &nbsp;
m&#775;<sub>wat</sub> &frasl; m&#775;<sub>0,wat</sub>}
</i>
for the respective adjustment factor, and the
coefficients  <i>c<sub>x,0</sub></i>, <i>c<sub>x,1</sub></i>, <i>c<sub>x,2</sub></i>, and <i>c<sub>x,3</sub></i>
are the user-defined
values for the respective adjustment factor functions obtained from
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Data.UAMerkel</a>.
By changing the parameter <code>UACor</code>, the
user can update the values in this record based on the performance characteristics of
their specific cooling tower.
</p>
<h4>Comparison with the cooling tower model of EnergyPlus</h4>
<p>
This model is similar to the model <code>CoolingTower:VariableSpeed:Merkel</code>
that is implemented in the EnergyPlus building energy simulation program version 8.9.0.
The main differences are:
</p>
<ol>
<li>
Not implemented are the basin heater power consumption and the make-up water usage.
</li>
<li>
The model has no built-in control to switch individual cells of the tower on or off.
To switch cells on or off, use multiple instances of this model, and use your own control
law to compute the input signal <i>y</i>.
</li>
</ol>
<h4>Assumptions</h4>
<p>
The following assumptions are made with Merkel's theory and this implementation:
</p>
<ol>
<li>
The moist air enthalpy is a function of wetbulb temperature only.
</li>
<li>
The wetted surface temperature is equal to the water temperature.
</li>
<li>
Cycle losses are not taken into account.
</li>
</ol>
<h4>References</h4>
<p><a href=\"https://energyplus.net/sites/all/modules/custom/nrel_custom/pdfs/pdfs_v8.9.0/EngineeringReference.pdf\">
EnergyPlus 8.9.0 Engineering Reference</a>, March 23, 2018. </p>
</html>",
revisions="<html>
<ul>
<li>
January 16, 2020, by Michael Wetter:<br/>
Revised model to put the thermal performance in a separate block.
</li>
<li>
January 10, 2020, by Michael Wetter:<br/>
Revised model, changed parameters to make model easier to use with design data.
</li>
<li>
October 22, 2019, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end Merkel;
