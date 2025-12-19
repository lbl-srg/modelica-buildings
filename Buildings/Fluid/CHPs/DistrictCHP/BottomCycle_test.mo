within Buildings.Fluid.CHPs.DistrictCHP;
model BottomCycle_test "Bottoming cycle subsystem model"
  extends Modelica.Blocks.Icons.Block;

  // Medium declarations
  package MediumS = Buildings.Media.Steam
    "Steam medium - Medium model for port_b (outlet)";
  package MediumW = Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium - Medium model for port_a (inlet)";

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
  parameter Modelica.Units.SI.Volume VWat_set=V*0.8
    "Water volume setpoint in the steam volume";

  // Advanced tab: parameters for the fluid systems
  parameter Buildings.Fluid.Movers.Data.Generic per(pressure(
      V_flow={0,m_flow_nominal/rho_nominal,1.5*m_flow_nominal/rho_nominal},
      dp={2*dp_nominal,dp_nominal,0})) "Record with performance data";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=55
    "Nominal mass flow rate in fluid ports"
    annotation (Dialog(group="Fluid systems"));
  parameter Modelica.Units.SI.PressureDifference dp_nominal(displayUnit="Pa")=3000000
    "Nominal outlet pressure, fixed if not control_m_flow and not use_p_set"
    annotation (Dialog(group="Fluid systems"));
  final parameter Modelica.Media.Interfaces.Types.Density rho_nominal=
      MediumW.density_pTX(
      MediumW.p_default,
      MediumW.T_default,
      MediumW.X_default) "Nominal fluid density for characteristic"
    annotation (Dialog(group="Fluid systems"));
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
  parameter Modelica.Units.SI.Time Td(min=0)=0.1
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
  parameter Boolean allowFlowReversal = false
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
  parameter Modelica.Units.SI.MassFlowRate m_flow_start=55
    "Start value of mass flow rate for pump"
    annotation (Dialog(tab="Initialization", group="Feedwater pump"));

  // Inputs
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TExh(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
    "Exhaust temperature"
    annotation (Placement(transformation(extent={{-180,100},{-140,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput mExh_flow(
    final unit="kg/s")
    "Exhaust mass flow rate"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TAmb(
    displayUnit="degC",
    final unit="K",
    final quantity = "ThermodynamicTemperature")
   "Ambient temperature"
    annotation (Placement(transformation(extent={{-180,60},{-140,100}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PEle_ST(
    final quantity= "Power",
    final unit = "W")
    "Steam turbine electricity generation"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
        iconTransformation(extent={{100,60},{140,100}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare final package Medium = MediumW)
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-150,-10},{-130,10}}),
        iconTransformation(extent={{-110,-10},{-90,10}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare final package Medium =MediumS)
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{150,-10},{130,10}}),
        iconTransformation(extent={{110,-10},{90,10}})));

  // Calculation blocks
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGSteam steHeaFlo(
    final TSta=TSta)
    "Superheated steam heat flow produced from HRSG"
    annotation (Placement(transformation(extent={{-40,110},{-20,130}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamTurbineGeneration powGen(
    final a=a)
    "Power generation from steam turbine"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HeatInput heaInp(
    final a_SteMas = a_SteMas) "Required heat input"
    annotation (Placement(transformation(extent={{-40,26},{-20,46}})));

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
    annotation (Placement(transformation(extent={{-60,-120},{-40,-100}})));

  // Evaporator
  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{20,10},{40,30}})));
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
    annotation (Placement(transformation(extent={{50,-30},{70,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant pumNomFlo(
    final k=m_flow_nominal)
    "Nominal mass flow rate for feedwater pump"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant supSteTem(
    final k=TSte)
    "Superheated steam temperature"
    annotation (Placement(transformation(extent={{-100,0},{-80,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant watLev(
    final k=VWat_set)
    "Water volume setpoint"
    annotation (Placement(transformation(extent={{-120,-130},{-100,-110}})));

 // Others
  Modelica.Blocks.Math.Product masFlo
    "Prescribed mass flow rate to the pump"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract heaAva "Available heat"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Reals.Greater gre
    "Check if the available heat is greater than the required input"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert heaDemAss(
    final message="The heating demand is larger than the available heat")
    "Check if the demand is larger than the available heat"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort watSpeEnt(
    redeclare package Medium = MediumW,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.SteadyState)
    "Water flow specific enthalpy"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort steSpeEnt(
    redeclare package Medium = MediumS,
    final allowFlowReversal=allowFlowReversal,
    final m_flow_nominal=m_flow_nominal,
    final initType=Modelica.Blocks.Types.Init.SteadyState)
    "Steamspecific enthalpy"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium =MediumW,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal)
    annotation (Placement(transformation(extent={{0,-50},{20,-30}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pum(
    redeclare final package Medium =MediumW,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    final per=per,
    final addPowerToMedium=false,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=dp_nominal,
    final m_flow_start=m_flow_start) "Water feeding pump"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

equation
  connect(TExh, heaInp.TExh) annotation (Line(points={{-160,120},{-120,120},{-120,
          44},{-42,44}}, color={0,0,127}));
  connect(TExh, powGen.TExh) annotation (Line(points={{-160,120},{-120,120},{-120,
          74},{-42,74}}, color={0,0,127}));
  connect(TExh, steHeaFlo.TExh) annotation (Line(points={{-160,120},{-120,120},{
          -120,124},{-42,124}}, color={0,0,127}));
  connect(TAmb, steHeaFlo.TAmb) annotation (Line(points={{-160,80},{-110,80},{-110,
          120},{-42,120}},   color={0,0,127}));
  connect(mExh_flow, steHeaFlo.mExh_flow) annotation (Line(points={{-160,40},{-100,
          40},{-100,116},{-42,116}},  color={0,0,127}));
  connect(mExh_flow, powGen.mExh_flow) annotation (Line(points={{-160,40},{-100,
          40},{-100,66},{-42,66}},color={0,0,127}));
  connect(mExh_flow, heaInp.mExh_flow) annotation (Line(points={{-160,40},{-42,40}},
          color={0,0,127}));
  connect(supSteTem.y, heaInp.TSte) annotation (Line(points={{-78,10},{-70,10},{
          -70,36},{-42,36}},  color={0,0,127}));
  connect(watLev.y, conPID.u_s) annotation (Line(points={{-98,-120},{-80,-120},{
          -80,-110},{-62,-110}}, color={0,0,127}));
  connect(pumNomFlo.y, masFlo.u1)
    annotation (Line(points={{-98,-70},{-20,-70},{-20,-84},{-2,-84}},
          color={0,0,127}));
  connect(conPID.y, masFlo.u2) annotation (Line(points={{-38,-110},{-20,-110},{-20,
          -96},{-2,-96}},     color={0,0,127}));
  connect(steBoi.VLiq, conPID.u_m) annotation (Line(points={{71,-47},{80,-47},{80,
          -130},{-50,-130},{-50,-122}}, color={0,0,127}));
  connect(preHeaFlo.port, steBoi.heatPort)
    annotation (Line(points={{40,20},{60,20},{60,-30}},   color={191,0,0}));
  connect(heaInp.Q_flow, preHeaFlo.Q_flow) annotation (Line(points={{-18,40},{0,
          40},{0,20},{20,20}},   color={0,0,127}));
  connect(heaInp.Q_flow, gre.u2) annotation (Line(points={{-18,40},{50,40},{50,92},
          {58,92}},     color={0,0,127}));
  connect(powGen.PEle_ST, PEle_ST)
    annotation (Line(points={{-18,70},{160,70}}, color={0,0,127}));
  connect(powGen.PEle_ST, heaAva.u2) annotation (Line(points={{-18,70},{0,70},{0,
          94},{18,94}},      color={0,0,127}));
  connect(steHeaFlo.QSupSte_flow, heaAva.u1) annotation (Line(points={{-18,120},
          {0,120},{0,106},{18,106}},  color={0,0,127}));
  connect(heaAva.y, gre.u1)
    annotation (Line(points={{42,100},{58,100}}, color={0,0,127}));
  connect(gre.y, heaDemAss.u)
    annotation (Line(points={{82,100},{98,100}}, color={255,0,255}));
  connect(steBoi.port_b, steSpeEnt.port_a) annotation (Line(
      points={{70,-40},{90,-40}},
      color={0,127,255},
      thickness=0.5));
  connect(steSpeEnt.port_b, port_b) annotation (Line(
      points={{110,-40},{120,-40},{120,0},{140,0}},
      color={0,127,255},
      thickness=0.5));
  connect(watSpeEnt.h_out, heaInp.hWat_flow) annotation (Line(points={{-30,-29},
          {-30,0},{-50,0},{-50,28},{-42,28}}, color={0,0,127}));
  connect(steSpeEnt.h_out, heaInp.hSte_flow) annotation (Line(points={{100,-29},
          {100,-10},{-60,-10},{-60,32},{-42,32}}, color={0,0,127}));
  connect(steBoi.port_a, res.port_b)
    annotation (Line(points={{50,-40},{20,-40}}, color={0,127,255}));
  connect(res.port_a, watSpeEnt.port_b)
    annotation (Line(points={{0,-40},{-20,-40}}, color={0,127,255}));
  connect(port_a,pum. port_a) annotation (Line(points={{-140,0},{-120,0},{-120,-40},
          {-80,-40}}, color={0,127,255}));
  connect(pum.port_b, watSpeEnt.port_a)
    annotation (Line(points={{-60,-40},{-40,-40}}, color={0,127,255}));
  connect(masFlo.y,pum. m_flow_in) annotation (Line(points={{21,-90},{40,-90},{
          40,-18},{-70,-18},{-70,-28}}, color={0,0,127}));
annotation (
  defaultComponentName="botCyc",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
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
<ul>
<li>
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HeatInput\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HeatInput</a>
determines the value of
<i>Q&#775;<sub>steam,sat</sub> - Q&#775;<sub>water</sub></i>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGSteam\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.HRSGSteam</a>
calculates the value of
<i>Q&#775;<sub>exhaust</sub> - Q&#775;<sub>exhaust,loss</sub></i>.
</li>
<li>
<a href=\"modelica://Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamTurbineGeneration\">
Buildings.Fluid.CHPs.DistrictCHP.BaseClasses.SteamTurbineGeneration</a>
calculates the value of <i>P<sub>STG</sub></i>. 
</li>
<li>
There is no need to calculate the value of <i>Q&#775;<sub>steam,loss</sub></i>; 
instead, a constraint is applied to ensure that this value is not negative.
</li>      
</ul>
</html>"));
end BottomCycle_test;
