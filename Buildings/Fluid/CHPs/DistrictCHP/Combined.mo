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
  parameter Real a[3]={-0.23380344533,0.220477944738,-0.01476897980}
    "Coefficients for calculating steam turbine exhaust exergy efficiency"
    annotation (Dialog(group="Steam turbine"));
  parameter Real a_SteMas[3]={0.153, 0.018, 0.002}
    "Coefficients for calculating steam turbine steam to exhaust mass flow ratio"
    annotation (Dialog(group="Steam turbine"));

  // Parameters for the fluid systems
  parameter Real TSta(
    unit="K",
    displayUnit="degC")=411.15
    "HRSG stack temperature"
    annotation (Dialog(group="Heat recovery steam generator"));
  parameter Modelica.Units.SI.Volume VWat_set=V*0.8
    "Water volume setpoint in the steam volume"
    annotation (Dialog(group="Heat recovery steam generator"));
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
    "Nominal mass flow rate in fluid ports"
    annotation (Dialog(group="Heat recovery steam generator"));
  parameter Modelica.Units.SI.Volume V=12.4
    "Total volume of HRSG evaporator"
    annotation (Dialog(group="Heat recovery steam generator"));

  // Advanced tab
  parameter Real TSte(
    unit="K",
    displayUnit="degC")=823.15
    "Temperature of the superheated steam out of the HRSG"
    annotation (Dialog(group="Heat recovery steam generator",tab="Advanced"));
  parameter Controls.OBC.CDL.Types.SimpleController pumCon=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));
  parameter Real k(min=0)=0.5
    "Gain of controller"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));
  parameter Modelica.Units.SI.Time Ti(min=Modelica.Constants.small)=5
    "Time constant of Integrator block"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced",
                       enable=pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
                              or pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.Units.SI.Time Td(min=0)=1
    "Time constant of Derivative block"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced",
                       enable=pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
                              or pumCon == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
    "Upper limit of output"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));
  parameter Real yMin=0
    "Lower limit of output"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));
  parameter Real Ni(min=100*Modelica.Constants.eps)=1
    "Ni*Ti is time constant of anti-windup compensation"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));
  parameter Real Nd(min=100*Modelica.Constants.eps)=1
    "The higher Nd, the more ideal the derivative block"
    annotation (Dialog(group="HRSG water feeding pump controller", tab="Advanced"));

  // Assumptions tab
  parameter Boolean allowFlowReversal = false
    "= false to simplify equations, assuming, but not enforcing, no flow reversal. Used only if model has two ports."
    annotation(Dialog(tab="Assumptions"), Evaluate=true);

  //Dynamics tab for evaporator energy and mass balance
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics"));

  // Initialization tab
  parameter Modelica.Units.SI.AbsolutePressure p_start(displayUnit="Pa")=3000000
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization",group="Fluid system"));
  parameter Modelica.Units.SI.Volume VWat_start=VWat_set
    "Start value of liquid volume in the evaporator"
    annotation (Dialog(tab="Initialization",group="Fluid system"));
  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_start=0.055
    "Start value of volumetric flow rate of liquid water"
    annotation (Dialog(tab="Initialization",group="Fluid system"));

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
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
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
    final VWat_set=VWat_set,
    final m_flow_nominal=m_flow_nominal,
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
    final VWat_flow_start=VWat_flow_start) "Bottom cycle"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

equation
  connect(topCycTab.PEle, PEle) annotation (Line(points={{-38,58},{20,58},{20,90},
          {120,90}}, color={0,0,127}));
  connect(topCycTab.mFue_flow, mFue_flow) annotation (Line(points={{-38,53},{40,
          53},{40,60},{120,60}}, color={0,0,127}));
  connect(y, topCycTab.y) annotation (Line(points={{-120,80},{-80,80},{-80,54},{
          -62,54}},  color={0,0,127}));
  connect(TAmb, topCycTab.TSet) annotation (Line(points={{-120,40},{-80,40},{-80,
          46},{-62,46}}, color={0,0,127}));
  connect(port_b, botCycExp.port_b)
    annotation (Line(points={{100,0},{40,0}}, color={0,127,255}));
  connect(port_a, botCycExp.port_a) annotation (Line(points={{-100,0},{20,0}},
          color={0,127,255}));
  connect(botCycExp.TAmb, TAmb) annotation (Line(points={{18,5},{-80,5},{-80,40},
          {-120,40}}, color={0,0,127}));
  connect(topCycTab.mExh_flow, botCycExp.mExh_flow) annotation (Line(points={{-38,42},
          {-10,42},{-10,2},{18,2}},     color={0,0,127}));
  connect(botCycExp.PEle_ST, PEle_ST) annotation (Line(points={{42,8},{60,8},{60,
          30},{120,30}}, color={0,0,127}));
  connect(topCycTab.TExh, botCycExp.TExh) annotation (Line(points={{-38,47},{0,47},
          {0,8},{18,8}}, color={0,0,127}));

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
