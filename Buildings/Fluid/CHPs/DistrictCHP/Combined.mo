within Buildings.Fluid.CHPs.DistrictCHP;
model Combined "Combined-cycle CHP model"

  extends Modelica.Blocks.Icons.Block;

  package MediumS = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumW = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";
  parameter Buildings.Fluid.CHPs.DistrictCHP.Data.Generic per
    "Records of gas turbine performance data"
     annotation (choicesAllMatching= true, Placement(transformation(extent={{-80,-80},
            {-60,-60}})));

  // Parameters for the calculation blocks
  parameter Real a[:]={-0.23380344533,0.220477944738,-0.01476897980}
    "Coefficients for calculating exhaust exergy efficiency"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real a_SteMas[:]={0.153, 0.018, 0.002}
    "Coefficients for calculating steam to exhaust mass flow ratio"
    annotation (Dialog(group="Coefficients for functions"));
  parameter Real TSta(
    unit="K",
    displayUnit="degC")=411.15
    "HRSG stack temperature";
  parameter Modelica.Units.SI.Volume watLevSet=V*0.8
    "Water level setpoint in the steam volume";

  // Advanced tab: parameters for the fluid systems
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
    "Nominal mass flow rate in fluid ports"
    annotation (Dialog(group="Fluid systems"));
  parameter Modelica.Units.SI.AbsolutePressure p_a_nominal(displayUnit="Pa")=30000
    "Nominal inlet pressure for predefined pump characteristics"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_nominal(displayUnit="Pa")=3000000
    "Nominal outlet pressure, fixed if not control_m_flow and not use_p_set"
    annotation (Dialog(group="Feedwater pump"));
  parameter Integer nParallel=1 "Number of pumps in parallel"
    annotation (Dialog(group="Feedwater pump"));
  replaceable function flowCharacteristic =
        Modelica.Fluid.Machines.BaseClasses.PumpCharacteristics.quadraticFlow
    "Head vs. V_flow characteristic at nominal speed and density"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Units.NonSI.AngularVelocity_rpm N_nominal=1500
    "Nominal rotational speed for flow characteristic"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Media.Interfaces.Types.Density rho_nominal=
      Medium.density_pTX(
      Medium.p_default,
      Medium.T_default,
      Medium.X_default) "Nominal fluid density for characteristic"
    annotation (Dialog(group="Feedwater pump"));
  parameter Boolean use_powerCharacteristic=false
    "Use powerCharacteristic (vs. efficiencyCharacteristic)"
    annotation (Dialog(group="Feedwater pump"));
  parameter Modelica.Units.SI.Volume V=12.4
    "Total volume of evaporator"
    annotation (Dialog(group="Evaporator"));

  // Advanced tab
  parameter Real TSte(
    unit="K",
    displayUnit="degC")=823.15
    "Superheated steam temperature"
    annotation (Dialog(group="General",tab="Advanced"));
  parameter Controls.OBC.CDL.Types.SimpleController pumCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real k(min=0)=0.5
    "Gain of controller"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=5
    "Time constant of Integrator block"
    annotation (Dialog(group="Pump controller", tab="Advanced",
                       enable=pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0)=1
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
  parameter Real Ni(min=100*Modelica.Constants.eps)=1
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(group="Pump controller", tab="Advanced"));
  parameter Real Nd(min=100*Modelica.Constants.eps)=1
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(group="Pump controller", tab="Advanced"));

  // Assumptions tab
  parameter Boolean allowFlowReversal = true
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  //Dynamics tab for evaporator energy and mass balance
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Evaporator dynamic balance"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Evaporator dynamic balance"));

  // Initialization tab
  parameter Modelica.Units.SI.AbsolutePressure p_start(displayUnit="Pa")=3000000
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
  parameter Modelica.Units.SI.AbsolutePressure p_a_start(displayUnit="Pa")=30000
    "Start value of inlet pressure for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.AbsolutePressure p_b_start(displayUnit="Pa")=3000000
    "Start value of outlet pressure for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=55
    "Start value of mass flow rate for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Boolean use_T_start=false
    "Boolean to indicate if T_start is used"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Real T_start(
    unit="K",
    displayUnit="degC")=777.625
    "Start value of temperature for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));
  parameter Modelica.Units.SI.SpecificEnthalpy h_start=1e5
    "Start value of specific enthalpy for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput y
    "Part load ratio"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Ambient temperature"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle(
    final quantity= "Power",
    final unit = "W")
    "Gas turbine electricity generation"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput mFue_flow(
    final unit="kg/s",
    final quantity="MassFlowRate")
    "Fuel mass flow rate"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle_ST(
    final quantity= "Power",
    final unit = "W")
    "Steam turbine electricity generation"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
        iconTransformation(extent={{100,10},{140,50}})));

  Buildings.Fluid.CHPs.DistrictCHP.TopCycle topCycTab(
    final per=per) "Top cycle"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium =MediumW)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-10},{-110,10}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium =MediumS)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{110,-10},{90,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));
  Buildings.Fluid.CHPs.DistrictCHP.BottomCycle botCycExp(
    final a=a,
    final a_SteMas=a_SteMas,
    final TSta=TSta,
    final watLevSet=watLevSet,
    final m_flow_nominal=m_flow_nominal,
    final p_a_nominal=p_a_nominal,
    final p_b_nominal=p_b_nominal,
    final nParallel=nParallel,
    redeclare final function flowCharacteristic = flowCharacteristic,
    final N_nominal=N_nominal,
    final rho_nominal=rho_nominal,
    final use_powerCharacteristic=use_powerCharacteristic,
    final V=V,
    final pumCon=pumCon,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final Ni=Ni,
    final Nd=Nd,
    final TSte=TSte,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final massDynamics=massDynamics,
    final p_start=p_start,
    final VWat_start=VWat_start,
    final VWat_flow_start=VWat_flow_start,
    final initType=initType,
    final y_start=y_start,
    final p_a_start=p_a_start,
    final p_b_start=p_b_start,
    final m_flow_start=m_flow_start,
    final use_T_start=use_T_start,
    final T_start=T_start,
    final h_start=h_start)
    "Bottom cycle"
    annotation (Placement(transformation(extent={{14,-10},{34,8}})));

equation
  connect(topCycTab.PEle, PEle) annotation (Line(points={{-38,58},{20,58},{20,90},
          {120,90}}, color={0,0,127}));
  connect(topCycTab.mFue_flow, mFue_flow) annotation (Line(points={{-38,53},{40,
          53},{40,60},{120,60}}, color={0,0,127}));
  connect(port_b, port_b)
    annotation (Line(points={{100,0},{100,0}}, color={0,127,255}));
  connect(y, topCycTab.y) annotation (Line(points={{-120,80},{-80,80},{-80,54},{
          -62,54}},  color={0,0,127}));
  connect(TAmb, topCycTab.TSet) annotation (Line(points={{-120,40},{-80,40},{-80,
          46},{-62,46}}, color={0,0,127}));
  connect(port_b, botCycExp.port_b)
    annotation (Line(points={{100,0},{34,0}}, color={0,127,255}));
  connect(port_a, botCycExp.port_a) annotation (Line(points={{-100,0},{14,0}},
          color={0,127,255}));
  connect(botCycExp.TAmb, TAmb) annotation (Line(points={{12,5},{-80,5},{-80,40},
          {-120,40}}, color={0,0,127}));
  connect(topCycTab.mExh_flow, botCycExp.mExh_flow) annotation (Line(points={{-38,
          42},{-10,42},{-10,2},{12,2}}, color={0,0,127}));
  connect(PEle_ST, PEle_ST)
    annotation (Line(points={{120,30},{120,30}}, color={0,0,127}));
  connect(botCycExp.PEle_ST, PEle_ST) annotation (Line(points={{36,8},{60,8},{60,
          30},{120,30}}, color={0,0,127}));
  connect(topCycTab.TExh, botCycExp.TExh) annotation (Line(points={{-38,47},{0,47},
          {0,8},{12,8}}, color={0,0,127}));

annotation (
  defaultComponentName="disCHP",
  Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
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
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}),                      Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
March 28, 2023, by Zhanwei He:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
This is the combined-cycle CHP model including the topping cycle and the bottoming
cycle models.
</p>
</html>"));
end Combined;
