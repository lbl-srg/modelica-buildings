within Buildings.Examples.ChillerPlant;
model StrangeIniT
  "fixme: remove model for release. Model to find why we get high T at t = 0"
  extends Modelica.Icons.Example;
  //package MediumAir = Buildings.Media.GasesPTDecoupled.SimpleAir "Medium model";
  package MediumAir = Buildings.Media.GasesPTDecoupled.MoistAir "Medium model";
  package MediumCHW = Buildings.Media.ConstantPropertyLiquidWater
    "Medium model";
  package MediumCW = Buildings.Media.ConstantPropertyLiquidWater "Medium model";
  parameter Modelica.SIunits.MassFlowRate mAir_flow_nominal=1
    "Nominal mass flow rate at fan";
  parameter Modelica.SIunits.Power P_nominal=80E3
    "Nominal compressor power (at y=1)";
  parameter Modelica.SIunits.TemperatureDifference dTEva_nominal=10
    "Temperature difference evaporator inlet-outlet";
  parameter Modelica.SIunits.TemperatureDifference dTCon_nominal=10
    "Temperature difference condenser outlet-inlet";
  parameter Real COPc_nominal=3 "Chiller COP";
  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=mAir_flow_nominal*
      1000/4200*18/23 "Nominal mass flow rate at chilled water";
  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=4*mCHW_flow_nominal/
      COPc_nominal*(COPc_nominal + 1)
    "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.Pressure dp_nominal=500
    "Nominal pressure difference";
  Buildings.Fluid.Movers.FlowMachine_m_flow fan(
    m_flow_nominal=mAir_flow_nominal,
    m_flow_max=mAir_flow_nominal,
    dp(start=0),
    m_flow(start=0),
    addPowerToMedium=true,
    redeclare package Medium = MediumAir)
    annotation (Placement(transformation(extent={{52,-99},{32,-79}})));
  Buildings.Fluid.HeatExchangers.DryCoilCounterFlow cooCoi(
    redeclare package Medium1 = MediumCHW,
    m2_flow_nominal=mAir_flow_nominal,
    m1_flow_nominal=mCHW_flow_nominal,
    dp1_nominal(displayUnit="Pa") = 100,
    UA_nominal=1e6,
    m1_flow(start=mCHW_flow_nominal),
    m2_flow(start=mAir_flow_nominal),
    dp2_nominal=249,
    redeclare package Medium2 = MediumAir) "Cooling coil"
    annotation (Placement(transformation(extent={{2,-49},{-18,-29}})));
  Modelica.Blocks.Sources.Constant mFanFlo(k=mAir_flow_nominal)
    "Mass flow rate of fan" annotation (Placement(transformation(extent={{22,-75},
            {42,-55}},   rotation=0)));
  Buildings.Fluid.Storage.ExpansionVessel expVesCHW(redeclare package Medium =
        MediumCHW, VTot=1) "Expansion vessel"
    annotation (Placement(transformation(extent={{-38,-11},{-18,9}})));
  Buildings.Fluid.FixedResistances.FixedResistanceDpM res5(
    redeclare package Medium = MediumCHW,
    dp_nominal=1000,
    m_flow_nominal=mCHW_flow_nominal,
    m_flow(fixed=true, start=mCHW_flow_nominal)) "Fixed resistance in CHW loop"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={-73,-31})));
    Modelica.Blocks.Sources.Ramp TWat(
    height=10,
    offset=273.15 + 30,
    startTime=60,
    duration=0) "Water temperature"
                 annotation (Placement(transformation(extent={{-182,86},{-162,106}},
          rotation=0)));
  Fluid.Sources.Boundary_pT           sou_1(
    p=300000 + 5000,
    T=273.15 + 25,
    use_T_in=true,
    nPorts=1,
    redeclare package Medium = MediumCHW)
                          annotation (Placement(transformation(extent={{-142,82},
            {-122,102}},
                       rotation=0)));
  Fluid.Sources.Boundary_pT           sin_1(
    use_p_in=true,
    nPorts=1,
    T=273.15 + 5,
    redeclare package Medium = MediumCHW,
    p=300000)             annotation (Placement(transformation(extent={{66,20},{
            46,40}}, rotation=0)));
  Modelica.Blocks.Sources.Trapezoid trapezoid(
    amplitude=5000,
    rising=10,
    width=100,
    falling=10,
    period=3600,
    offset=300000)
    annotation (Placement(transformation(extent={{22,80},{42,100}})));
equation
  connect(expVesCHW.port_a, cooCoi.port_b1) annotation (Line(
      points={{-28,-11},{-28,-33},{-18,-33}},
      color={0,127,255},
      smooth=Smooth.None));

  connect(cooCoi.port_b2, fan.port_a) annotation (Line(
      points={{2,-45},{78,-45},{78,-89},{52,-89}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(mFanFlo.y, fan.m_flow_in) annotation (Line(
      points={{43,-65},{47,-65},{47,-80.8}},
      color={0,0,127},
      smooth=Smooth.None));

  connect(res5.port_a, cooCoi.port_b1) annotation (Line(
      points={{-63,-31},{-26,-31},{-26,-33},{-18,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TWat.y,sou_1. T_in)
    annotation (Line(points={{-161,96},{-144,96}},
                                                 color={0,0,127}));
  connect(sou_1.ports[1], res5.port_b) annotation (Line(
      points={{-122,92},{-104,92},{-104,88},{-90,88},{-90,-31},{-83,-31}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sin_1.ports[1], cooCoi.port_a1) annotation (Line(
      points={{46,30},{20,30},{20,-33},{2,-33}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(trapezoid.y, sin_1.p_in) annotation (Line(
      points={{43,90},{90,90},{90,38},{68,38}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(cooCoi.port_a2, fan.port_b) annotation (Line(
      points={{-18,-45},{-130,-45},{-130,-89},{32,-89}},
      color={0,127,255},
      smooth=Smooth.None));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-400,-300},{400,
            300}}), graphics),
    Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/ChillerPlant/PrimaryOnlyWithEconomizer.mos"
        "Simulate and plot"),
    Icon(graphics),
    Documentation(info="<HTML>
<h4>System Configuration</h4>
<p>This example demonstrates the implementation of a chiller plant with water-side economizer for cooling of a data center.
The system has the following properties:</p>
<ul>
<li>This is a primary-only integrated water side economizer system.</li>
<li>The data center room is simplified as a mixed air volume with heat source. The only means to transfer heat out of the room is through the HVAC system. Heat conduction and air infiltration through building leakage is neglected since the heat exchange between the room and ambient environment is small compared to the heat released by the servers.</li>
<li>The control objective is to maintain the temperature of supply air into data center room and reduce energy consumption by maximizing the usage of WSE for free cooling.</li>  
<li>The current system only specifies the control of the chiller (on/off and set point reset) and the water-side economizer (WSE), which may be on or off.</li>
</ul>

<h4>Enabling/Disabling WSE</h4>
The WSE is enabled when
<ol>
<li>The WSE has been disabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWST</sub> &gt; 0.9 T<sub>WetBul</sub> + T<sub>TowApp</sub> + T<sub>WSEApp</sub> </li>
</ol>
<br>
The WSE is disabled when
<ol>
<li>The WSE has been enabled for at least 20 minutes, and</li>
<li align=\"left\" style=\"font-style:italic;\">
  T<sub>WSE_CHWRT</sub> &lt; 1 + T<sub>WSE_CWST</sub></li>
</li>
</ol>
where <code>T<sub>WSE_CHWST</sub></code> is chilled water supply temperature for water side economizer, <code>T<sub>WetBul</sub></code> is wet bulb temperature, <code>T<sub>TowApp</sub></code> is cooling tower approach, <code>T<sub>WSEApp</sub></code> is approach for water side economizer, <code>T<sub>WSE_CHWRT</sub></code> is chilled water return temperature for water side economizer, and <code>T<sub>WSE_CWST</sub></code> is condeser water return temperature for water side economizer 
<p>Note: The formulas use temperature in Fahrenheit. The input and output data for WSE control unit are in SI units. The WSE control component internally converts the data bewteen SI units and IP units.</p>

<h4>Enabling/Disabling Chiller</h4>
The control strategy is as follows:<ul>
<li>The chiller is enabled when 
<code align=\"left\" style=\"font-style:italic;\">
  T<sub>Chi_CHWST</sub> &gt; T<sub>ChiSet</sub> + T<sub>DeaBan</sub> </code>
<li>The chiller is disabled when 
<code align=\"left\" style=\"font-style:italic;\">
  T<sub>Chi_CHWST</sub> &le; T<sub>ChiSet</sub></code>
</li>
</ul>
where <code>T<sub>Chi_CHWST</sub></code> is chiller chilled water supply temperature, <code>T<sub>ChiSet</sub></code> is set temperature for chilled water leaving chiller, and <code>T<sub>DeaBan</sub></code> is dead band to prevent short cycling. 

<h4>Chiller Set Point Reset</h4>
The chiller set point reset strategy is to first increase the mass flow rate of the chiller chilled water, <code>m</code>. If <code>m</code> reaches the maximum value and further cooling is still needed, the return temperature set point of the chilled water will be reduced. 
If there is too much cooling, the set point will be changed in the reverse direction.
This strategy is realized by using a trim and respond logic as follows:
<ul>
<li>A cooling request is triggered if the input signal, <code>u[1]</code> is larger than <code>uTri</code>(=0.8). <code>u[1]</code> is the output from a PI controler which controls the temperature of the supply air for data center room.</li>
<li>The request is sampled every 4 minutes. If there is a cooling request, increase the set point, <code>u</code>, by 0.02, where <code align=\"left\" style=\"font-style:italic;\">0 &le; u &le; 1</code>. If there is no cooling request, decrease <code>u</code> by 0.01. </li>
</ul>
<br>
The chiller set point, <code>u</code>, is converted to control signals for mass flow rate, <code>m</code>, and chiller set temperature, <code>T</code>, as follows:
<ul align=\"left\" style=\"font-style:italic;\">
<li>
u is [0, x<sub>1</sub>]: m = m<sub>0</sub> + u*(m<sub>1</sub>-m<sub>0</sub>)/(x<sub>1</sub>-0); T = T<sub>0</sub>;</li>
<li>u is (x<sub>1</sub>, 1]: m = m<sub>1</sub>; T = T<sub>0</sub> + (u-x<sub>1</sub>)*(T<sub>1</sub>-T<sub>0</sub>)/(1-x<sub>1</sub>);</li>   
</ul>
where <code>m<sub>0</sub></code> and <code>m<sub>1</sub></code> are minimum and maximum flow rates, <code>T<sub>0</sub></code> and <code>T<sub>1</sub></code> are highest and lowest set values of CHWRT for the chiller.

<h4>Nomenclature</h4>
<table>
<tr><td>CW:<td>condenser water
<tr><td>CWST:<td>condenser water supply temperature
<tr><td>CWRT:<td>condenser water return temperature
<tr><td>CHW:<td>chilled water
<tr><td>CHWST:<td>chilled water supply temperature
<tr><td>CHWRT:<td>chilled water return temperature
<tr><td>WSE:<td>water side economizer
</table>
</p>
</HTML>
", revisions="<html>
<ul>
<li>
July 20, 2011, by Wangda Zuo:<br>
Add comments and merge to library.
</li>
<li>
January 18, 2011, by Wangda Zuo:<br>
First implementation.
</li>
</ul></HTML>"));
end StrangeIniT;
