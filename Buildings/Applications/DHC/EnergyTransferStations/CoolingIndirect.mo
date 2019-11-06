within Buildings.Applications.DHC.EnergyTransferStations;
model CoolingIndirect
  "Indirect cooling energy transfer station for district energy systems"
  extends Buildings.Fluid.Interfaces.PartialFourPort;

 package Medium = Buildings.Media.Water;

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  // mass flow rates
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0,start=0.5)
    "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(min=0,start=0.5)
    "Nominal mass flow rate of secondary (building) district cooling side";

  // Heat exchanger
  parameter Modelica.SIunits.PressureDifference dp1_nominal(min=0,start=500)
    "Nominal pressure difference on primary side"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal(min=0,start=500)
    "Nominal pressure difference on secondary side"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Boolean use_Q_flow_nominal=true
    "Set to true to specify Q_flow_nominal and temperatures, or to false to specify effectiveness"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(min=0,start=10000)
    "Nominal heat transfer"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a1_nominal(min=0,max=100,start=5)
    "Nominal temperature at port a1"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a2_nominal(min=0,max=100,start=7)
    "Nominal temperature at port a2"
    annotation(Dialog(tab="Heat exchanger"));
  parameter Modelica.SIunits.Efficiency eta(min=0,max=1,start=0.8)
    "Constant effectiveness"
    annotation(Dialog(tab="Heat exchanger"));

  // Primary supply control valve
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(min=0)=50
    "Control valve: Nominal pressure drop of fully open valve";

  // Secondary supply pump
  parameter Modelica.SIunits.PressureDifference dp_nominal(min=0)
    "Secondary pump: Nominal pressure raise, used for default pressure curve if not specified in record per";

  // Controller
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PID
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=0.5
    "Time constant of integrator block"
     annotation (Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Td(min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(tab="Controller"));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real wp(min=0) = 1
   "Set-point weight for Proportional block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real wd(min=0) = 0
   "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(tab="Controller"));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.Blocks.Types.InitPID initType=
    Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation(Dialog(group="Initialization",tab="Controller"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",tab="Controller"));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",tab="Controller"));
  parameter Real yCon_start=0
    "Initial value of output from the controller"
    annotation(Dialog(group="Initialization",tab="Controller"));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));

  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    m1_flow_nominal=m1_flow_nominal,
    m2_flow_nominal=m2_flow_nominal,
    dp1_nominal=dp1_nominal,
    dp2_nominal=dp2_nominal,
    configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    use_Q_flow_nominal=true,
    Q_flow_nominal=Q_flow_nominal,
    T_a1_nominal=T_a1_nominal,
    T_a2_nominal=T_a2_nominal) "Indirect cooling heat exchanger"
    annotation (Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(redeclare package Medium =
        Medium, m_flow_nominal=m2_flow_nominal)
    "Building-side (secondary) return temperature"
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));
    Buildings.Controls.Continuous.LimPID con(
    controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final k=k,
    Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final Ti=Ti,
    wp=wp,
    wd=wd,
    Ni=Ni,
    Nd=Nd,
    final initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    xi_start=xi_start,
    xd_start=xd_start,
    final y_start=0,
    final reverseAction=reverseAction) "Controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening val(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=dpValve_nominal,
    riseTime(displayUnit="s") = 60,
    y_start=0) "District-side (primary) control valve"
    annotation (Placement(transformation(extent={{-70,70},{-50,50}})));
  Modelica.Blocks.Interfaces.RealInput TSetCHWS
    "Setpoint temperature for building chilled water supply"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

equation
  connect(con.u_s,TSetCHWS)
    annotation (Line(points={{-92,0},{-120,0}}, color={0,0,127}));
  connect(hex.port_b2, TBuiRet.port_a) annotation (Line(points={{-10,-6},{-20,-6},
          {-20,-60},{-50,-60}}, color={0,127,255}));
  connect(port_a1, val.port_a)
    annotation (Line(points={{-100,60},{-70,60}}, color={0,127,255}));
  connect(con.y, val.y)
    annotation (Line(points={{-69,0},{-60,0},{-60,48}}, color={0,0,127}));
  connect(TBuiRet.T, con.u_m) annotation (Line(points={{-60,-49},{-60,-32},{-80,
          -32},{-80,-12}}, color={0,0,127}));

  connect(hex.port_b1, port_b1) annotation (Line(points={{10,6},{20,6},{20,60},
          {100,60}}, color={0,127,255}));
  connect(hex.port_a2, port_a2) annotation (Line(points={{10,-6},{20,-6},{20,
          -60},{100,-60}}, color={0,127,255}));
  connect(hex.port_a1, val.port_b) annotation (Line(points={{-10,6},{-20,6},{-20,
          60},{-50,60}}, color={0,127,255}));
  connect(TBuiRet.port_b, port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-56},{100,-64}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-100,64},{100,56}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-80,80},{80,-80}},
          lineColor={175,175,175},
          fillColor={35,138,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-52,40},{54,-40}},
          lineColor={0,0,0},
          fillColor={35,138,255},
          fillPattern=FillPattern.Solid,
          textStyle={TextStyle.Bold},
          textString="ETS")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Indirect cooling energy transfer station (ETS) model that controls the building chilled water supply temperature 
by modulating a primary control valve on the district supply side. The design is based on a typical district 
cooling ETS described in ASHRAE's 
<a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">
District Cooling Guide</a>.  
As shown in the figure below, the building pumping design (constant, variable) is specified on the building
side, not within the ETS. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/CoolingIndirect.PNG\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2013). Chapter 5: End User Interface. In <i>District Cooling Guide</i>. 1st Edition. 
</p>
</html>", revisions="<html>
<ul>
<li>November 1, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingIndirect;
