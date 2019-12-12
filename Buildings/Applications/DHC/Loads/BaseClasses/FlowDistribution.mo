within Buildings.Applications.DHC.Loads.BaseClasses;
model FlowDistribution
  "Model for computing secondary flow distribution based on terminal units demand"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow1_nominal,
    final allowFlowReversal=false);
  replaceable package Medium1 =
    Buildings.Media.Water
    "Source side medium"
      annotation (choices(
        choice(redeclare package Medium1 = Buildings.Media.Water "Water"),
        choice(redeclare package Medium1 =
            Buildings.Media.Antifreeze.PropyleneGlycolWater (
              property_T=293.15,
              X_a=0.40)
              "Propylene glycol water, 40% mass fraction")));
  parameter Integer nLoa = 1
    "Number of connected loads"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.MassFlowRate m_flow1_nominal
    "Source side total mass flow rate at nominal conditions"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa") = 0
    "Source side total pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T_b1_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics = energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  // IO connectors
  Modelica.Blocks.Interfaces.RealInput m_flow1Req_i[nLoa](
    each quantity="MassFlowRate")
    "Heating or chilled water flow required to meet the load" annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,220}), iconTransformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-110,-80})));
  Modelica.Blocks.Interfaces.RealOutput m_flow1Req(
    quantity="MassFlowRate") "Heating or chilled water flow required to meet the load"
    annotation (Placement(transformation(extent={{100,200},
            {140,240}}),iconTransformation(extent={{100,-70},{120,-50}})));
  // Building blocks
  Buildings.Fluid.Sensors.TemperatureTwoPort T_aMes(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m_flow1_nominal,
    final allowFlowReversal=allowFlowReversal) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flow1Mes(
    redeclare final package Medium=Medium1,
    final allowFlowReversal=allowFlowReversal)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T_aMesVec(nout=nLoa) annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,50})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m_flow1_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    T_start=T_a1_nominal,
    final Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{68,-10},{88,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    k=fill(1, nLoa), nin=nLoa)
    "Total required water mass flow rate"
    annotation (Placement(transformation(extent={{-10,210}, {10,230}})));
  Buildings.Fluid.Sources.MassFlowSource_T m_flow1Sou_i[nLoa](
    redeclare each final package Medium = Medium1,
    each final use_m_flow_in=true,
    each final use_T_in=true,
    each final nPorts=1)
    annotation (Placement(transformation(extent={{32,150},{52,170}})));
  Modelica.Fluid.Interfaces.FluidPorts_a ports_a1[nLoa](
    redeclare each final package Medium = Medium1,
    each m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{-110,120},{-90,200}}),
      iconTransformation(extent={{90,20},{110,100}})));
  Modelica.Fluid.Interfaces.FluidPorts_b ports_b1[nLoa](
    redeclare each final package Medium = Medium1,
    each m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    each h_outflow(start=Medium1.h_default, nominal=Medium1.h_default))
    "Fluid connectors b (positive design flow direction is from port_a to ports_b)"
    annotation (Placement(transformation(extent={{90,120},{110,200}}),
      iconTransformation(extent={{-110,20},{-90,100}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium1, final nPorts=nLoa)
    annotation (Placement(transformation(extent={{-40,150},{-60,170}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flow1Sum(
    final nin=nLoa)
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow1Act(
    each quantity="HeatFlowRate")
    "Heat flow rate transferred to the source (<0 for heating)"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,-90},{120,-70}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Act_i[nLoa](
    y=m_flow1Req_i .*
        Buildings.Utilities.Math.Functions.smoothMin(
          1,
          m_flow1Mes.m_flow / Buildings.Utilities.Math.Functions.smoothMax(
            m_flow1Req,
            m_flow_small,
            m_flow_small),
          1E-2))
    "Actual mass flow rate (constrained by sum(m_flow1Act_i)=m_flow1Mes)"
    annotation (Placement(transformation(extent={{-10,158},{10,178}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort hSupMes_i[nLoa](
    redeclare each final package Medium = Medium1,
    each final m_flow_nominal=m_flow1_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Specific enthalpy of fluid in supply pipe"
    annotation (Placement(transformation(extent={{70,150},{90,170}})));
  Fluid.Sensors.SpecificEnthalpyTwoPort hRetMes_i[nLoa](
    redeclare each final package Medium = Medium1,
    each final m_flow_nominal=m_flow1_nominal,
    each final allowFlowReversal=allowFlowReversal)
    "Specific enthalpy of fluid in return pipe" annotation (Placement(transformation(extent={{-90,150},
            {-70,170}})));
  Modelica.Blocks.Sources.RealExpression Q_flow1Act_i[nLoa](y=m_flow1Act_i.y .* (hRetMes_i.h_out - hSupMes_i.h_out))
    "Actual heat flow rate transferred to the source"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
equation
  connect(port_a, T_aMes.port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(T_aMes.port_b, m_flow1Mes.port_a) annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(T_aMes.T, T_aMesVec.u)
    annotation (Line(points={{-70,11},{-70,38}}, color={0,0,127}));
  connect(m_flow1Mes.port_b, heaCoo.port_a)
    annotation (Line(points={{-20,0},{
          68,0}}, color={0,127,255}));
  connect(heaCoo.port_b, port_b)
    annotation (Line(points={{88,0},{100,0}}, color={0,127,255}));
  connect(mulSum.y, m_flow1Req)
    annotation (Line(points={{12,220},{120,220}},                color={0,0,127}));
  connect(Q_flow1Sum.y, heaCoo.u)
    annotation (Line(points={{52,80},{60,80},{60,
          6},{66,6}}, color={0,0,127}));
  connect(T_aMesVec.y, m_flow1Sou_i.T_in)
    annotation (Line(points={{-70,62},{-70,120},{20,120},{20,164},{30,164}}, color={0,0,127}));
  connect(m_flow1Req_i, mulSum.u)
    annotation (Line(points={{-120,220},{-12,
          220}}, color={0,0,127}));
  connect(m_flow1Act_i.y, m_flow1Sou_i.m_flow_in)
    annotation (Line(points={{11,168},{30,168}}, color={0,0,127}));
  connect(Q_flow1Sum.y, Q_flow1Act)
    annotation (Line(points={{52,80},{120,80}},                                   color={0,0,127}));
  connect(ports_a1, hRetMes_i.port_a)
    annotation (Line(points={{-100,160},{-90, 160}}, color={0,127,255}));
  connect(hRetMes_i.port_b, sin.ports)
    annotation (Line(points={{-70,160},
          {-60,160}},                                                                      color={0,127,255}));
  connect(Q_flow1Act_i.y, Q_flow1Sum.u)
    annotation (Line(points={{11,80},{28,80}},                                                                         color={0,0,127}));
  connect(m_flow1Sou_i.ports[1], hSupMes_i.port_a)
    annotation (Line(points={{52,160},
          {70,160}},                                                                            color={0,127,255}));
  connect(hSupMes_i.port_b, ports_b1)
    annotation (Line(points={{90,160},{100,
          160}},                                                                    color={0,127,255}));
annotation (
defaultComponentName="disFlo",
Documentation(
info="<html>
<p>
This model computes the steady-state, sensible heat transfer between a circulating liquid and idealized
thermal loads at uniform temperature.
</p>
<p>
The heat flow rate transferred to each load is computed using the effectiveness method, see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessDirect</a>.
As the effectiveness depends on the mass flow rate, this requires to assess a representative distribution of
the main liquid stream between the connected loads.
This is achieved by:
<ul>
<li> computing the mass flow rate needed to transfer the required heat flow rate to each load,
see
<a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl\">
Buildings.DistrictEnergySystem.Loads.BaseClasses.EffectivenessControl</a>,
</li>
<li> normalizing this mass flow rate to the actual flow rate of the main liquid stream.</li>
</ul>
</p>
<p>
The nominal UA-value (W/K) is calculated for each load <i>i</i> from the cooling or
heating power and the temperature difference between the liquid and the load, see
<a href=\"modelica://Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ\">
Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ</a>.
It is split between an internal (liquid side) and an external (load side) UA-value based on the ratio
<i>UA<sub>int, nom, i</sub> / UA<sub>ext, nom, i</sub> </i> provided as a parameter. The influence of
the liquid flow rate on the internal UA-value is derived from a forced convection
correlation, expressing the Nusselt number as a power of the Reynolds number, under the assumption that the
physical characteristics of the liquid do not vary significantly from their value at nominal conditions.
</p>
<p align=\"center\" style=\"font-style:italic;\">
UA<sub>int, i</sub> = UA<sub>int, nom, i</sub> * (m&#775;<sub>i</sub> /
m&#775;<sub>nom, i</sub>)<sup>expUAi</sup>
</p>
<p>
where thedefault value of <i>expUA<sub>i</sub></i> stems from the Dittus and Boelter correlation for turbulent
flow.
</p>

<h4>References</h4>
<p>
Dittus and Boelter. 1930. Heat transfer in automobile radiators of the tubular type. University of California
Engineering Publication 13.443.
</p>
</html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95})}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,240}}), graphics={Text(
          extent={{-124,276},{104,252}},
          lineColor={28,108,200},
          horizontalAlignment=TextAlignment.Left,
          textString="Implement different
distribution temperatures e.g. use return temperature to compute the flow demand from terminal at source temperature.

Implement optional main distribution pump.

Implement piping heat loss.")}));
end FlowDistribution;
