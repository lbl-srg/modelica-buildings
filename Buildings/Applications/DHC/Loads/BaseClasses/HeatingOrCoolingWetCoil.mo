within Buildings.Applications.DHC.Loads.BaseClasses;
model HeatingOrCoolingWetCoil
  "Model for steady-state, sensible heat transfer between a circulating liquid and thermal loads"
  // Suffix _i is to distinguish vector variable from (total) scalar variable on the source side (1) only.
  // Each variable related to load side (2) quantities is a vector by default.
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow1_nominal,
    final  allowFlowReversal=false);
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
  replaceable package Medium2 =
    Buildings.Media.Air
    "Load side medium"
    annotation(choices(
      choice(redeclare package Medium2 = Buildings.Media.Air "Moist air"),
      choice(redeclare package Medium2 = Buildings.Media.Water "Water"),
      choice(redeclare package Medium2 =
        Buildings.Media.Antifreeze.PropyleneGlycolWater(property_T=293.15, X_a=0.40)
          "Propylene glycol water, 40% mass fraction")));
  parameter Integer nLoa = 1
    "Number of connected loads";
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    min=0, displayUnit="Pa") = 0
    "Source side total pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal[nLoa](
    each min=0, each displayUnit="Pa") = fill(0, nLoa)
    "Load side pressure drop at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Buildings.Fluid.Types.HeatExchangerConfiguration hexCon[nLoa]=
    fill(Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow, nLoa)
    "Heat exchanger configuration";
  parameter Modelica.SIunits.Temperature T1_a_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side supply temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T1_b_nominal(
    min=Modelica.SIunits.Conversions.from_degC(0), displayUnit="degC")
    "Source side return temperature at nominal conditions"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal[nLoa](
    each min=0)
    "Sensible thermal power exchanged with the load i at nominal conditions (always positive)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.Temperature T2_nominal[nLoa](
    each min=Modelica.SIunits.Conversions.from_degC(0), each displayUnit="degC")
    "Load side temperature at nominal conditions (at inlet if it applies)"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.MassFlowRate m_flow2_nominal[nLoa] = fill(0, nLoa)
    "Load side mass flow rate at nominal conditions"
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
  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium1.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium1.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium1.nX](
    final quantity=Medium1.substanceNames) = Medium1.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium1.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium1.nC](
    final quantity=Medium1.extraPropertiesNames)=fill(0, Medium1.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  // Advanced
  parameter Boolean homotopyInitialization = true
    "If true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));
  parameter Real ratUAIntToUAExt[nLoa](each min=1) = fill(2, nLoa)
    "Ratio of UA internal to UA external values at nominal conditions"
    annotation(Dialog(tab="Advanced", group="Nominal condition"));
  parameter Real expUA[nLoa] = fill(4/5, nLoa)
    "Exponent of Reynolds number in the flow correlation used for computing UA internal value"
    annotation(Dialog(tab="Advanced"));
  // Computed parameters
  final parameter Modelica.SIunits.MassFlowRate m_flow1_nominal = sum(m_flow1_i_nominal)
    "Source side total mass flow rate at nominal conditions";
  final parameter Modelica.SIunits.MassFlowRate m_flow1_i_nominal[nLoa] = abs(
    Q_flow_nominal / cp1_nominal / (T1_a_nominal - T1_b_nominal))
    "Source side mass flow rate at nominal conditions, as distributed to each load i";
  final parameter Modelica.SIunits.ThermalConductance UA_nominal[nLoa](each fixed=false)
    "Thermal conductance at nominal conditions";
  // IO connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yHeaCoo[nLoa](each final unit="1")
    "Heating or cooling control loop output"
    annotation (Placement(transformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,220}), iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=0,
        origin={-120,80})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput m_flow1Req(
    quantity="MassFlowRate", unit="kg/s")
    "Total mass flow rate to provide the required heat flow rates" annotation (Placement(transformation(extent={{100,200},
            {140,240}}),iconTransformation(extent={{100,60},{140,100}})));
  // Building blocks
  Buildings.Fluid.Sensors.TemperatureTwoPort T1InlMes(
    redeclare final package Medium=Medium1,
    final m_flow_nominal=m_flow_nominal)
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.MassFlowRate m_flow1Mes(redeclare final package Medium = Medium1)
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealReplicator T1InlVec(nout=nLoa)
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={-70,30})));
  Buildings.Fluid.HeatExchangers.HeaterCooler_u heaCoo(
    redeclare final package Medium=Medium1,
    final dp_nominal=dp1_nominal,
    final m_flow_nominal=m_flow1_nominal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final tau=tau,
    T_start=T1_a_nominal,
    final Q_flow_nominal=1,
    final allowFlowReversal=allowFlowReversal)
    "Heat exchange with water stream"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(k=fill(1, nLoa), nin=nLoa)
    "Total required water mass flow rate" annotation (Placement(transformation(extent={{-40,210},{-20,230}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain m_flow1Req_i[nLoa](k=m_flow1_i_nominal)
    annotation (Placement(transformation(extent={{-80,210},{-60,230}})));
  Modelica.Blocks.Sources.RealExpression m_flow1Act_i[nLoa](y=m_flow1Req_i.y .*
    Buildings.Utilities.Math.Functions.smoothMin(1, m_flow1Mes.m_flow /
      Buildings.Utilities.Math.Functions.smoothMax(m_flow1Req, m_flow_small, m_flow_small),
      1E-2))
    "Actual mass flow rate (constrained by sum(m_flow1Act_i)=m_flow1Mes)"
    annotation (Placement(transformation(extent={{-80,150},{-60,170}})));
  Buildings.Fluid.HeatExchangers.WetEffectivenessNTU_Fuzzy hexWetNtu[nLoa](
    redeclare each final package Medium1=Medium1,
    redeclare each final package Medium2=Medium2,
    final configuration=hexCon,
    final m1_flow_nominal=m_flow1_i_nominal,
    final m2_flow_nominal=m_flow2_nominal,
    each final dp1_nominal=0,
    final dp2_nominal=dp2_nominal,
    final UA_nominal=UA_nominal,
    each final allowFlowReversal1=allowFlowReversal,
    each final allowFlowReversal2=allowFlowReversal)
    annotation (Placement(transformation(extent={{20,184},{40,164}})));
  Buildings.Fluid.Sources.MassFlowSource_T m_flow1Sou_i[nLoa](
    redeclare each final package Medium = Medium,
    each use_m_flow_in=true,
    each use_T_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-40,130},{-20,150}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a2[nLoa](
    redeclare each final package Medium=Medium2,
    p(each start=Medium2.p_default),
    m_flow(each min=0),
    h_outflow(each start=Medium2.h_default, each nominal=Medium2.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)" annotation (Placement(transformation(
          extent={{90,170},{110,190}}),   iconTransformation(extent={{90,30},{110,50}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b2[nLoa](
    redeclare each final package Medium=Medium2,
    p(each start=Medium2.p_default),
    m_flow(each max=0),
    h_outflow(each start=Medium2.h_default, each nominal=Medium2.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,170},{-110,190}}),
    iconTransformation(extent={{-90,30},{-110,50}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium=Medium1,
    nPorts=nLoa) annotation (Placement(transformation(extent={{100,130},{80,150}})));
  Modelica.Blocks.Sources.RealExpression Q_flowTot_i[nLoa](
    y=hexWetNtu.dryWetCalcs.QTot_flow)
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-30,110})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum Q_flowTotSum(nin=nLoa)
    annotation (Placement(transformation(extent={{0,100},{20,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput Q_flowTot[nLoa](
    each quantity="HeatFlowRate", each unit="W")
    "Total heat flow rate transferred to the loads" annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,-100},{140,-60}})));
protected
  parameter Boolean cooMod = (T1_b_nominal > T1_a_nominal)
    "Cooling mode flag"
    annotation(Evaluate=true);
  parameter Modelica.SIunits.ThermalConductance CMin_nominal[nLoa](each fixed=false, each min=0)
    "Minimum capacity flow rate at nominal conditions";
  parameter Modelica.SIunits.ThermalConductance CMax_nominal[nLoa](each fixed=false, each min=0)
    "Maximum capacity flow rate at nominal conditions";
  parameter Real Z[nLoa](each fixed=false, each min=0, each max=1)
    "Ratio of capacity flow rates (CMin/CMax) at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp1_nominal = Medium.specificHeatCapacityCp(
    Medium.setState_pTX(Medium1.p_default, T1_a_nominal))
    "Source side specific heat capacity at nominal conditions";
  parameter Modelica.SIunits.SpecificHeatCapacity cp2_nominal[nLoa] = Medium2.specificHeatCapacityCp(
    Medium2.setState_pTX(Medium2.p_default, T2_nominal))
    "Load side specific heat capacity at nominal conditions";
initial equation
  for i in 1:nLoa loop
    CMin_nominal[i] = if abs(m_flow2_nominal[i]) < Modelica.Constants.eps then
      m_flow1_i_nominal[i] * cp1_nominal else
      min(m_flow1_i_nominal[i] * cp1_nominal, m_flow2_nominal[i] * cp2_nominal[i]);
    CMax_nominal[i] = if abs(m_flow2_nominal[i]) < Modelica.Constants.eps then
      Modelica.Constants.inf else
      max(m_flow1_i_nominal[i] * cp1_nominal, m_flow2_nominal[i] * cp2_nominal[i]);
    Z[i] = if abs(m_flow2_nominal[i]) < Modelica.Constants.eps then 0 else
      CMin_nominal[i] / CMax_nominal[i];
  end for;
  UA_nominal = Buildings.Fluid.HeatExchangers.BaseClasses.ntu_epsilonZ(
    eps=Q_flow_nominal ./ abs(CMin_nominal .* (T1_a_nominal .- T2_nominal)),
    Z=Z,
    flowRegime=Integer(hexWetNtu.flowRegime_nominal)) .* CMin_nominal;
equation
  connect(port_a,T1InlMes. port_a) annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(T1InlMes.port_b, m_flow1Mes.port_a) annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(T1InlMes.T, T1InlVec.u) annotation (Line(points={{-70,11},{-70,18}}, color={0,0,127}));
  if cooMod then
  else
  end if;
  connect(m_flow1Mes.port_b, heaCoo.port_a) annotation (Line(points={{-20,0},{60,0}}, color={0,127,255}));
  connect(heaCoo.port_b, port_b) annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(m_flow1Req_i.y, mulSum.u) annotation (Line(points={{-58,220},{-42,220}}, color={0,0,127}));
  connect(yHeaCoo, m_flow1Req_i.u) annotation (Line(points={{-120,220},{-82,220}}, color={0,0,127}));
  connect(mulSum.y, m_flow1Req) annotation (Line(points={{-18,220},{120,220}},               color={0,0,127}));
  connect(m_flow1Act_i.y, m_flow1Sou_i.m_flow_in)
    annotation (Line(points={{-59,160},{-48,160},{-48,148},{-42,148}}, color={0,0,127}));
  connect(m_flow1Sou_i.ports[1], hexWetNtu.port_a1)
    annotation (Line(points={{-20,140},{0,140},{0,168},{20,168}}, color={0,127,255}));
  connect(T1InlVec.y, m_flow1Sou_i.T_in) annotation (Line(points={{-70,42},{-70,144},{-42,144}}, color={0,0,127}));
  connect(hexWetNtu.port_b1, sin.ports)
    annotation (Line(points={{40,168},{60,168},{60,140},{80,140}}, color={0,127,255}));
  connect(Q_flowTot_i.y, Q_flowTotSum.u[1:1]) annotation (Line(points={{-19,110},{-2,110}}, color={0,0,127}));
  connect(Q_flowTotSum.y, heaCoo.u) annotation (Line(points={{22,110},{40,110},{40,6},{58,6}}, color={0,0,127}));
  connect(port_a2, hexWetNtu.port_a2)
    annotation (Line(points={{100,180},{40,180}},                   color={0,127,255}));
  connect(hexWetNtu.port_b2, port_b2)
    annotation (Line(points={{20,180},{-100,180}},                     color={0,127,255}));
  connect(Q_flowTot_i.y, Q_flowTot) annotation (Line(points={{-19,110},{-10,110},{-10,90},{120,90}}, color={0,0,127}));
annotation (
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
          extent={{-70,70},{70,-70}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={95,95,95}),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),
        Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-40},{100,240}})));
end HeatingOrCoolingWetCoil;
