within Buildings.Fluid.CHPs.DistrictCHP;
model BottomingCycle "Bottoming cycle subsystem model"
  extends Modelica.Blocks.Icons.Block;

  // Medium declarations
  package MediumS = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumW = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

  // Parameters for the calculation blocks
  parameter Real a[:]={-0.23380344533,0.220477944738,-0.01476897980}
    "Coefficients for bottoming cycle exergy efficiency function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
    "Coefficients for bottoming cycle steam mass flow function"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real TSta(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature") = 138+273.15
    "HRSG stack temperature in Celsius";
  parameter Modelica.Units.SI.Volume watLevSet=V*0.8
    "Water level setpoint in the steam volume";

  // Advanced tab: parameters for the fluid systems
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
    "Nominal mass flow rate in fluid ports"
    annotation (Dialog(group="Fluid systems"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal(
    displayUnit="Pa")=30000
    "Nominal inlet pressure for predefined pump characteristics"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal(
    displayUnit="Pa")=3000000
    "Nominal outlet pressure, fixed if not control_m_flow and not use_p_set"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Units.SI.Volume V=12.4
    "Total volume of evaporator"
    annotation (Dialog(group="Evaporator"));

  // Advanced tab: parameters for PI controller
  parameter Controls.OBC.CDL.Types.SimpleController pumCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real k(min=0) = 0.5
    "Gain of controller"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Modelica.Units.SI.Time Ti(
    min=Modelica.Constants.small) = 5
    "Time constant of Integrator block"
    annotation (Dialog(group="Pump controller", tab="Advanced",
                       enable=pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0) = 1
    "Time constant of Derivative block"
    annotation (Dialog(group="Pump controller", tab="Advanced",
                       enable=pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                              or pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 1
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 1
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(group="Pump controller", tab="Advanced"));

  parameter Real TSte(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")=550+273.15
    "Superheated steam temperature in Celsius used for "
    annotation (Dialog(group="RealExpression block",tab="Advanced"));

  // Assumptions tab
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  //Dynamics tab for evaporator energy and mass balance
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Evaporator dynamic balance"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Evaporator dynamic balance"));

  // Initialization tab
  parameter Modelica.Units.SI.AbsolutePressure p_start(
    displayUnit="Pa") = 3000000
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization",group="Fluid system"));
  parameter Modelica.Units.SI.Volume VWat_start=V*0.8
    "Start value of liquid volume in the evaporator"
    annotation (Dialog(tab="Initialization",group="Fluid system"));
  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_start=0.055
    "Start value of volumetric flow rate of liquid water"
    annotation (Dialog(tab="Initialization",group="Fluid system"));
  parameter Modelica.Blocks.Types.Init initType=Modelica.Blocks.Types.Init.InitialState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Pump controller"));
  parameter Real y_start=1 "Initial value of output in PI controller"
    annotation (Evaluate=true, Dialog(tab="Initialization", group="Pump controller"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_start(
    displayUnit="Pa")=30000
    "Start value of inlet pressure for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start(
    displayUnit="Pa")=3000000
    "Start value of outlet pressure for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=55
    "Start value of mass flow rate for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Boolean use_T_start=false
    "Boolean to indicate if T_start is used"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Real T_start(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")=504.475+273.15
    "Start value of temperature for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=1e5
    "Start value of specific enthalpy for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));

  // Inputs
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Exhaust temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mExh
    "Exhaust mass flow rate"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
   "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,30},{-100,70}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}})));

  // Outputs
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle_ST
    "Steam turbine electricity generation"
    annotation (Placement(transformation(extent={{100,60},{140,100}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium =MediumS)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}})));

  // Calculation blocks
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGSteam steHeaFlo(
    final TSta=TSta)
    "Superheated steam heat flow produced from HRSG"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamTurbineGeneration powGen(
    final a=a)
    "Power generation from steam turbine"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HeatInput heaInp(
    final a_SteMas = a_SteMas)
    annotation (Placement(transformation(extent={{-40,-14},{-20,6}})));

  // PI controller to adjust the pump mass flow rate
  Buildings.Controls.OBC.CDL.Reals.PID conPID(
    final Td=Td,
    final k=k,
    final Ti=Ti,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final controllerType=pumCon,
    final reverseActing=true)
    "Pump speed controller"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));

  // Feedwater pump
  Modelica.Fluid.Machines.ControlledPump pump(
    redeclare package Medium = MediumW,
    final p_a_nominal=p_a_nominal,
    final p_b_nominal=p_b_nominal,
    final m_flow_nominal=m_flow_nominal,
    final p_a_start=p_a_start,
    final p_b_start=p_b_start,
    final m_flow_start=m_flow_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start,
    use_m_flow_set=true)
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));

  // Evaporator
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.DHC.Plants.Steam.BaseClasses.ControlVolumeEvaporation steBoi(
    redeclare package MediumWat = MediumW,
    redeclare package MediumSte = MediumS,
    final m_flow_nominal=m_flow_nominal,
    final V=V,
    final p_start=p_start,
    final massDynamics=massDynamics,
    final energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversal,
    final VWat_start=VWat_start,
    fixed_p_start=true,
    VWat_flow(start=VWat_flow_start))
       "Dynamic volume"
    annotation (Placement(transformation(extent={{40,-70},{60,-90}})));

  // A group of RealExpression
  Modelica.Blocks.Sources.RealExpression fixSteEnt(
    final y=steBoi.port_b.h_outflow)
    annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Modelica.Blocks.Sources.RealExpression fixWatEnt(
    final y=pump.port_b.h_outflow)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Modelica.Blocks.Sources.RealExpression pumNomFlo(
    final y=pump.m_flow_nominal)
    "Nominal mass flow rate for feedwater pump"
    annotation (Placement(transformation(extent={{-40,-44},{-20,-24}})));
  Modelica.Blocks.Sources.RealExpression supSteTem(final y=TSte)
    "Superheated steam temperature in Celsius"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.RealExpression watLev(final y=watLevSet)
    "Water level setpoint"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));

 // Others
  Modelica.Blocks.Math.Product product1
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    annotation (Placement(transformation(extent={{40,50},{60,70}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert AssertHeatingDemand(
    message= "The heating demand is larger than the available heat")
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  inner Modelica.Fluid.System system(
    T_ambient=288.15,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    annotation (Placement(transformation(extent={{70,-62},{90,-42}})));

equation
  connect(preHeaFlo.port, steBoi.heatPort)
    annotation (Line(points={{40,10},{50,10},{50,-70}},   color={191,0,0}));
  connect(gre.y, AssertHeatingDemand.u)
    annotation (Line(points={{62,60},{68,60}},   color={255,0,255}));
  connect(gre.u2, heaInp.QFlo) annotation (Line(points={{38,52},{36,52},{36,38},
          {0,38},{0,0},{-18,0}},   color={0,0,127}));
  connect(steHeaFlo.mExh, mExh) annotation (Line(points={{-42,66},{-60,66},{-60,
          20},{-120,20}}, color={0,0,127}));
  connect(heaInp.mExh, mExh) annotation (Line(points={{-42,0},{-60,0},{-60,20},{
          -120,20}},  color={0,0,127}));
  connect(fixSteEnt.y, heaInp.steEnt) annotation (Line(points={{-59,-30},{-50,-30},
          {-50,-8},{-42,-8}},   color={0,0,127}));
  connect(fixWatEnt.y, heaInp.watEnt) annotation (Line(points={{-59,-50},{-46,-50},
          {-46,-12},{-42,-12}},    color={0,0,127}));
  connect(steHeaFlo.TAmb, TAmb) annotation (Line(points={{-42,70},{-80,70},{-80,
          50},{-120,50}}, color={0,0,127}));
  connect(steHeaFlo.TExh, TExh) annotation (Line(points={{-42,74},{-70,74},{-70,
          80},{-120,80}}, color={0,0,127}));
  connect(supSteTem.y, heaInp.TSte) annotation (Line(points={{-59,-10},{-54,-10},
          {-54,-4},{-42,-4}}, color={0,0,127}));
  connect(pumNomFlo.y, product1.u1)
    annotation (Line(points={{-19,-34},{-2,-34}},color={0,0,127}));
  connect(product1.y, pump.m_flow_set) annotation (Line(points={{21,-40},{30,-40},
          {30,-60},{5,-60},{5,-71.8}}, color={0,0,127}));
  connect(pump.port_b, steBoi.port_a)
    annotation (Line(points={{20,-80},{40,-80}}, color={0,127,255}));
  connect(pump.port_a, port_a)
    annotation (Line(points={{0,-80},{-100,-80},{-100,0}}, color={0,127,255}));
  connect(port_b, steBoi.port_b)
    annotation (Line(points={{100,0},{100,-80},{60,-80}}, color={0,127,255}));
  connect(preHeaFlo.Q_flow, heaInp.QFlo) annotation (Line(points={{20,10},{0,10},
          {0,0},{-18,0}},     color={0,0,127}));
  connect(watLev.y, conPID.u_s) annotation (Line(points={{-59,-70},{-50,-70},{-50,
          -60},{-42,-60}}, color={0,0,127}));
  connect(powGen.TExh, TExh) annotation (Line(points={{-42,34},{-70,34},{-70,80},
          {-120,80}}, color={0,0,127}));
  connect(powGen.mExh, mExh) annotation (Line(points={{-42,26},{-60,26},{-60,20},
          {-120,20}}, color={0,0,127}));
  connect(powGen.PEle_ST, PEle_ST) annotation (Line(points={{-18,30},{-10,30},{
          -10,80},{120,80}}, color={0,0,127}));
  connect(steHeaFlo.supSte, sub.u1) annotation (Line(points={{-18,70},{0,70},{0,
          66},{8,66}},   color={0,0,127}));
  connect(sub.u2, powGen.PEle_ST) annotation (Line(points={{8,54},{-10,54},{-10,
          30},{-18,30}}, color={0,0,127}));
  connect(sub.y, gre.u1)
    annotation (Line(points={{32,60},{38,60}}, color={0,0,127}));
  connect(heaInp.TExh, TExh) annotation (Line(points={{-42,4},{-70,4},{-70,80},{
          -120,80}},  color={0,0,127}));
  connect(steBoi.VLiq, conPID.u_m) annotation (Line(points={{61,-87},{64,-87},{64,
          -98},{-30,-98},{-30,-72}},color={0,0,127}));
  connect(conPID.y, product1.u2) annotation (Line(points={{-18,-60},{-10,-60},{-10,
          -46},{-2,-46}}, color={0,0,127}));
annotation (
  defaultComponentName="botCyc",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,80}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
Documentation(revisions="<html>
<ul>
<li>
March 18, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
In the bottoming cycle, waste heat from the exhaust gas is utilized to produce
electricity through a steam turbine, and saturated steam is used for heating purposes. 
The energy inputs to the bottoming-cycle system consist of the exhaust gas and the
feedwater, and the energy outputs include the electricity generated by the steam
turbine and the heating energy provided by the saturated steam. 
Throughout the process, there are heat losses when the exhaust gas is released into
the atmosphere and when steam is lost during desuperheating. The energy balance
equation for the bottoming cycle is:
</p>
<p align=\"center\">
<i>
Q&#775;<sub>exhaust</sub> + Q&#775;<sub>water</sub> = Q&#775;<sub>exhaust,loss</sub>
+ Q&#775;<sub>steam,loss</sub> + Q&#775;<sub>steam,sat</sub> + P<sub>STG</sub>
</i>
</p>
<p>
where <i>Q&#775;<sub>water</sub></i> is the energy flow of the feedwater,
<i>Q&#775;<sub>exhaust,loss</sub></i> denotes the heat losses in the exhaust gas
stack, <i>Q&#775;<sub>steam,loss</sub></i> represents the losses in steam energy
during the conversion from superheated steam to saturated steam,
and <i>P<sub>STG</sub></i> means the electric power production of the steam turbine generator.
</p>
<p>
In the model, there are base-class models used to handle this energy balance equation.
</p>
<p>
- <code>BaseClasses.HeatInput</code> determines the value of
<i>Q&#775;<sub>steam,sat</sub> - Q&#775;<sub>water</sub></i>.
</p>
<p>
- <code>BaseClasses.HRSGSteam</code> calculates the value of
<i>Q&#775;<sub>exhaust</sub> - Q&#775;<sub>exhaust,loss</sub></i>.
</p>
<p>
- <code>BaseClasses.SteamTurbineGeneration</code> calculates the value of
<i>P<sub>STG</sub></i>. 
</p>
<p>
- There is no need to calculate the value of <i>Q&#775;<sub>steam,loss</sub></i>; 
instead, a constraint is applied to ensure that this value is not negative.
</p>      
</html>"));
end BottomingCycle;
