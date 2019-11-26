within Buildings.Applications.DHC.EnergyTransferStations;
model CoolingIndirect
  "Indirect cooling energy transfer station for district energy systems"
  extends Buildings.Fluid.Interfaces.PartialFourPort(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium);

  replaceable package Medium =
    Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  // mass flow rates
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(
    final min=0,
    start=0.5)
    "Nominal mass flow rate of primary (district) district cooling side";
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal(
    final min=0,
    start=0.5)
    "Nominal mass flow rate of secondary (building) district cooling side";

  // Primary supply control valve
  parameter Modelica.SIunits.PressureDifference dpValve_nominal(
    final min=0,
    final displayUnit="Pa")=6000
    "Nominal pressure drop of fully open control valve";

  // Heat exchanger
  parameter Modelica.SIunits.PressureDifference dp1_nominal(
    final min=0,
    start=500,
    final displayUnit="Pa")
    "Nominal pressure difference on primary side"
    annotation(Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.PressureDifference dp2_nominal(
    final min=0,
    start=500,
    final displayUnit="Pa")
    "Nominal pressure difference on secondary side"
    annotation(Dialog(group="Heat exchanger"));
  parameter Boolean use_Q_flow_nominal=true
    "Set to true to specify Q_flow_nominal and temperatures, or to false to specify effectiveness"
    annotation(Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal(
    final min=0,
    start=10000)
    "Nominal heat transfer"
    annotation(Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a1_nominal(
    min=0+273,
    max=100+273.15,
    start=5+273.15,
    final displayUnit="K")
    "Nominal temperature at port a1"
    annotation(Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.Temperature T_a2_nominal(
    min=0+273,
    max=100+273.15,
    start=7+273.15,
    final displayUnit="K")
    "Nominal temperature at port a2"
    annotation(Dialog(group="Heat exchanger"));
  parameter Modelica.SIunits.Efficiency eta(
    final min=0,
    final max=1)=0.8
    "Constant effectiveness"
    annotation(Dialog(group="Heat exchanger"));

  // Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Controller"));
  parameter Real k(final min=0, final unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));
  parameter Modelica.SIunits.Time Ti(
    min=Modelica.Constants.small)=120
    "Time constant of integrator block"
     annotation (Dialog(tab="Controller", enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PI or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(final min=0)=0.1
    "Time constant of derivative block"
     annotation (Dialog(tab="Controller", enable=
          controllerType == Modelica.Blocks.Types.SimpleController.PD or
          controllerType == Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yMax(start=1)=1
   "Upper limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real yMin=0
   "Lower limit of output"
    annotation(Dialog(tab="Controller"));
  parameter Real wp(final min=0) = 1
   "Set-point weight for Proportional block (0..1)"
    annotation(Dialog(tab="Controller"));
  parameter Real wd(final min=0) = 0
   "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(tab="Controller", enable=
          controllerType==Modelica.Blocks.Types.SimpleController.PD or
          controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(tab="Controller", enable=
          controllerType==Modelica.Blocks.Types.SimpleController.PI or
          controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(tab="Controller", enable=
          controllerType==Modelica.Blocks.Types.SimpleController.PD or
          controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Modelica.Blocks.Types.InitPID initType=
    Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation(Evaluate=true, Dialog(group="Initialization", tab="Controller"));
  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization", tab="Controller",
                       enable=controllerType==Modelica.Blocks.Types.SimpleController.PI or
                              controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization", tab="Controller",
                       enable=controllerType==Modelica.Blocks.Types.SimpleController.PD or
                              controllerType==Modelica.Blocks.Types.SimpleController.PID));
  parameter Real yCon_start=0
    "Initial value of output from the controller"
    annotation(Dialog(group="Initialization", tab="Controller",
                      enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput));
  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));

  Modelica.Blocks.Interfaces.RealInput TSet(
    final quantity="ThermodynamicTemperature",
    final unit="K")
    "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    final displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));

  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    final displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Buildings.Fluid.HeatExchangers.PlateHeatExchangerEffectivenessNTU hex(
    redeclare final package Medium1 = Medium,
    redeclare final package Medium2 = Medium,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=dp1_nominal,
    final dp2_nominal=dp2_nominal,
    final configuration=Buildings.Fluid.Types.HeatExchangerConfiguration.CounterFlow,
    final use_Q_flow_nominal=true,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a1_nominal=T_a1_nominal,
    final T_a2_nominal=T_a2_nominal) "Indirect cooling heat exchanger"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));

  Buildings.Controls.Continuous.LimPID con(
    final controllerType=Modelica.Blocks.Types.SimpleController.PID,
    final k=k,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final Ti=Ti,
    final wp=wp,
    final wd=wd,
    final Ni=Ni,
    final Nd=Nd,
    final initType=Modelica.Blocks.Types.InitPID.InitialOutput,
    final xi_start=xi_start,
    final xd_start=xd_start,
    final y_start=yCon_start,
    final reverseAction=reverseAction) "Controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m1_flow_nominal)
    "District-side (primary) supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m1_flow_nominal)
    "District-side (primary) return temperature sensor"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));

  Modelica.Blocks.Continuous.Integrator int(k=1) "Integration"
    annotation (Placement(transformation(extent={{60,120},{80,100}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare package Medium = Medium)
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TBuiRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m2_flow_nominal)
    "Building-side (secondary) return temperature"
    annotation (Placement(transformation(extent={{-70,-70},{-90,-50}})));

  Buildings.Fluid.Actuators.Valves.TwoWayQuickOpening val(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m1_flow_nominal,
    final dpValve_nominal=dpValve_nominal,
    riseTime(displayUnit="s") = 60,
    y_start=0) "District-side (primary) control valve"
    annotation (Placement(transformation(extent={{-30,70},{-10,50}})));

  Modelica.Blocks.Math.Gain cp(final k=cp_default)
    "Specifc heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{20,100},{40,120}})));

  Modelica.Blocks.Math.Product pro "Product"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));

  Modelica.Blocks.Math.Add dTDis(k1=-1, k2=+1)
    "Temperatur difference on the district side"
    annotation (Placement(transformation(extent={{-60,106},{-40,126}})));

protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

equation

  connect(hex.port_a2, port_a2) annotation (Line(points={{40,-6},{60,-6},{60,-60},
          {100,-60}}, color={0,127,255}));
  connect(hex.port_b1, senTDisRet.port_a) annotation (Line(points={{40,6},{60,6},
          {60,60},{70,60}}, color={0,127,255}));
  connect(val.port_b, hex.port_a1) annotation (Line(points={{-10,60},{0,60},{0,6},
          {20,6}},     color={0,127,255}));
  connect(senMasFlo.port_b, val.port_a)
    annotation (Line(points={{-40,60},{-30,60}}, color={0,127,255}));
  connect(port_a1, senTDisSup.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-70,60},{-60,60}}, color={0,127,255}));
  connect(port_b2, TBuiRet.port_b)
    annotation (Line(points={{-100,-60},{-90,-60}}, color={0,127,255}));
  connect(senTDisRet.port_b, port_b1)
    annotation (Line(points={{90,60},{100,60}}, color={0,127,255}));
  connect(TSet, con.u_s)
    annotation (Line(points={{-120,0},{-106,0},{-106,0},{-92,0}},
                                                color={0,0,127}));
  connect(con.u_m, TBuiRet.T)
    annotation (Line(points={{-80,-12},{-80,-49}}, color={0,0,127}));
  connect(con.y, val.y)
    annotation (Line(points={{-69,0},{-20,0},{-20,48}}, color={0,0,127}));
  connect(TBuiRet.port_a, hex.port_b2) annotation (Line(points={{-70,-60},{0,-60},
          {0,-6},{20,-6}}, color={0,127,255}));
  connect(pro.y, cp.u)
    annotation (Line(points={{1,110},{18,110}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-50,71},{-50,104},{-22,104}}, color={0,0,127}));
  connect(senTDisSup.T, dTDis.u1)
    annotation (Line(points={{-80,71},{-80,122},{-62,122}}, color={0,0,127}));
  connect(senTDisRet.T, dTDis.u2) annotation (Line(points={{80,71},{80,80},{-70,
          80},{-70,110},{-62,110}}, color={0,0,127}));
  connect(dTDis.y, pro.u1)
    annotation (Line(points={{-39,116},{-22,116}}, color={0,0,127}));
  connect(cp.y, int.u)
    annotation (Line(points={{41,110},{58,110}}, color={0,0,127}));
  connect(int.y, Q)
    annotation (Line(points={{81,110},{110,110}}, color={0,0,127}));
  connect(Q_flow, cp.y) annotation (Line(points={{110,150},{50,150},{50,110},{41,
          110}}, color={0,0,127}));

annotation (defaultComponentName="coo",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
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
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,160}})),
    Documentation(info="<html>
<p>
Indirect cooling energy transfer station (ETS) model that controls 
the building chilled water supply temperature by modulating a 
primary control valve on the district supply side. The design is 
based on a typical district cooling ETS described in ASHRAE's 
<a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">
District Cooling Guide</a>.  
As shown in the figure below, the building pumping design (constant, 
variable) is specified on the building side, not within the ETS. 
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/CoolingIndirect.png\" alt=\"DHC.ETS.CoolingIndirect\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning 
Engineers. (2013). Chapter 5: End User Interface. In 
<i>District Cooling Guide</i>. 1st Edition. 
</p>
</html>", revisions="<html>
<ul>
<li>
November 1, 2019, by Kathryn Hinkelman:<br/>
First implementation. </li>
</ul>
</html>"));
end CoolingIndirect;
