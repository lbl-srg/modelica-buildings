within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialCarnot_T
  "Partial model for chiller with performance curve adjusted based on Carnot efficiency"
  extends Carnot;
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
    m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal);

  parameter Modelica.SIunits.Pressure dp1_nominal(displayUnit="Pa")
    "Pressure difference over condenser"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.SIunits.Pressure dp2_nominal(displayUnit="Pa")
    "Pressure difference over evaporator"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean homotopyInitialization=true "= true, use homotopy method"
    annotation (Dialog(tab="Advanced"));

  parameter Boolean from_dp1=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean from_dp2=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Boolean linearizeFlowResistance1=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Boolean linearizeFlowResistance2=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Real deltaM1(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Condenser"));
  parameter Real deltaM2(final unit="1")=0.1
    "Fraction of nominal flow rate where flow transitions to laminar"
    annotation (Dialog(tab="Flow resistance", group="Evaporator"));

  parameter Modelica.SIunits.Time tau1=60
    "Time constant at nominal flow rate (used if energyDynamics1 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Time tau2=60
    "Time constant at nominal flow rate (used if energyDynamics2 <> Modelica.Fluid.Types.Dynamics.SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.SIunits.Temperature T1_start=Medium1.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.SIunits.Temperature T2_start=Medium2.T_default
    "Initial or guess value of set point"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics1=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Condenser"));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics2=Modelica.Fluid.Types.Dynamics.SteadyState
    "Formulation of energy balance"
    annotation (Dialog(tab="Dynamics", group="Evaporator"));
protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      p=  Medium1.p_default,
      T=  Medium1.T_default,
      X=  Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      p=  Medium2.p_default,
      T=  Medium2.T_default,
      X=  Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

  Medium1.ThermodynamicState staA1 = Medium1.setState_phX(
    port_a1.p,
    inStream(port_a1.h_outflow),
    inStream(port_a1.Xi_outflow)) "Medium properties in port_a1";
  Medium1.ThermodynamicState staB1 = Medium1.setState_phX(
    port_b1.p,
    port_b1.h_outflow,
    port_b1.Xi_outflow) "Medium properties in port_b1";
  Medium2.ThermodynamicState staA2 = Medium2.setState_phX(
    port_a2.p,
    inStream(port_a2.h_outflow),
    inStream(port_a2.Xi_outflow)) "Medium properties in port_a2";
  Medium2.ThermodynamicState staB2 = Medium2.setState_phX(
    port_b2.p,
    port_b2.h_outflow,
    port_b2.Xi_outflow) "Medium properties in port_b2";

  Modelica.Blocks.Sources.RealExpression PEle "Electrical power consumption"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  replaceable Interfaces.PartialTwoPortInterface con
    constrainedby Interfaces.PartialTwoPortInterface(
      redeclare final package Medium = Medium1,
      final allowFlowReversal=allowFlowReversal1,
      final m_flow_nominal=m1_flow_nominal,
      final m_flow_small=m1_flow_small,
      final show_T=false) "Condenser"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  replaceable Interfaces.PartialTwoPortInterface eva
    constrainedby Interfaces.PartialTwoPortInterface(
      redeclare final package Medium = Medium2,
      final allowFlowReversal=allowFlowReversal2,
      final m_flow_nominal=m2_flow_nominal,
      final m_flow_small=m2_flow_small,
      final show_T=false) "Evaporator"
  annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));

equation
  // Set temperatures that will be used to compute Carnot efficiency
  if effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(staA1);
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_b or
         effInpCon == Buildings.Fluid.Types.EfficiencyInput.volume then
    TCon = Medium1.temperature(staB1);
  else
    TCon = 0.5 * (Medium1.temperature(staA1)+Medium1.temperature(staB1));
  end if;

  if effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(staA2);
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_b or
         effInpEva == Buildings.Fluid.Types.EfficiencyInput.volume then
    TEva = Medium2.temperature(staB2);
  else
    TEva = 0.5 * (Medium2.temperature(staA2)+Medium2.temperature(staB2));
  end if;

  connect(port_a2, eva.port_a)
    annotation (Line(points={{100,-60},{56,-60},{10,-60}}, color={0,127,255}));
  connect(eva.port_b, port_b2) annotation (Line(points={{-10,-60},{-100,-60}},
                 color={0,127,255}));
  connect(port_a1, con.port_a)
    annotation (Line(points={{-100,60},{-56,60},{-10,60}}, color={0,127,255}));
  connect(con.port_b, port_b1)
    annotation (Line(points={{10,60},{56,60},{100,60}}, color={0,127,255}));
  connect(PEle.y, P)
    annotation (Line(points={{61,0},{110,0},{110,0}}, color={0,0,127}));
  annotation (
Documentation(info="<html>
<p>
This is a partial model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
This base class is used for the Carnot chiller and Carnot heat pump
that uses the compressor part load ratio as the control signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
First implementation of this base class.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end PartialCarnot_T;
