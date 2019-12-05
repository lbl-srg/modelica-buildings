within Buildings.Applications.DHC.EnergyTransferStations;
model CoolingDirectControlledReturn
  "Direct cooling ETS model for district energy systems with in-building pumping and controlled district return temperature"
  extends Buildings.Fluid.Interfaces.PartialFourPort(redeclare package Medium2
      = Medium, redeclare package Medium1 = Medium);

 final package Medium = Buildings.Media.Water;

 parameter Modelica.SIunits.SpecificHeatCapacity cp=
   Medium.specificHeatCapacityCp(
      Medium.setState_pTX(Medium.p_default, Medium.T_default, Medium.X_default))
    "Default specific heat capacity of medium";

  // mass flow rate
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal(min=0,start=0.5)
    "Nominal mass flow rate of primary (district) district cooling side";

  // pressure drops
  parameter Modelica.SIunits.PressureDifference dpSup(displayUnit="Pa")=50
  "Pressure drop in the ETS supply side (piping, valves, etc.)";

  parameter Modelica.SIunits.PressureDifference dpRet(displayUnit="Pa")=50
  "Pressure drop in the ETS return side (piping, valves, etc.)";

  parameter Modelica.SIunits.PressureDifference dpByp(displayUnit="Pa")=10
  "Pressure drop in the bypass line (piping, valves, etc.)";

  // Controller parameters
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


  Modelica.Blocks.Interfaces.RealInput TSet "Setpoint temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    quantity="Power",
    unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(extent={{100,110},{120,130}})));

  Modelica.Blocks.Interfaces.RealOutput Q(
    quantity="Energy",
    unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,90},{120,110}})));

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
    final reverseAction=reverseAction)
    "Controller"
    annotation (Placement(transformation(extent={{-90,-10},{-70,10}})));

  Modelica.Blocks.Sources.RealExpression powCal(
    y=senMasFlo.m_flow*cp*(senTDisRet.T - senTDisSup.T))
    "Calculated power demand"
    annotation (Placement(transformation(extent={{-40,110},{40,130}})));

  Modelica.Blocks.Continuous.Integrator int(k=1)
  "Integration"
    annotation (Placement(transformation(extent={{60,90},{80,110}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dpSup)
    "Supply pipe"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dpRet)
    "Return pipe"
    annotation (Placement(transformation(extent={{0,-50},{-20,-70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipByp(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal,
    dp_nominal=dpSup)
    "Bypass pipe"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,0})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    m_flow_nominal=m1_flow_nominal,
    dpValve_nominal=50)
    "Control valve"
    annotation (Placement(transformation(extent={{40,-50},{20,-70}})));

  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare package Medium = Medium,
    m_flow_nominal={m1_flow_nominal,-m1_flow_nominal,0},
    dp_nominal=50*{1,-1,1})
    "Bypass junction"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(redeclare package
      Medium =
        Medium, m_flow_nominal=m1_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m1_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));

equation
  connect(port_a1, senTDisSup.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-70,60},{-60,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipSup.port_a)
    annotation (Line(points={{-40,60},{-20,60}}, color={0,127,255}));
  connect(pipSup.port_b, jun.port_1)
    annotation (Line(points={{0,60},{20,60}}, color={0,127,255}));
  connect(jun.port_2, port_b1)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(val.port_2, pipRet.port_a)
    annotation (Line(points={{20,-60},{0,-60}}, color={0,127,255}));
  connect(pipRet.port_b, senTDisRet.port_b)
    annotation (Line(points={{-20,-60},{-70,-60}}, color={0,127,255}));
  connect(senTDisRet.port_a, port_b2)
    annotation (Line(points={{-90,-60},{-100,-60}}, color={0,127,255}));
  connect(jun.port_3, pipByp.port_b)
    annotation (Line(points={{30,50},{30,10},{30,10}}, color={0,127,255}));
  connect(pipByp.port_a, val.port_3)
    annotation (Line(points={{30,-10},{30,-50}}, color={0,127,255}));
  connect(powCal.y, Q_flow)
    annotation (Line(points={{44,120},{110,120}}, color={0,0,127}));
  connect(powCal.y, int.u) annotation (Line(points={{44,120},{52,120},{52,100},{
          58,100}}, color={0,0,127}));
  connect(int.y, Q) annotation (Line(points={{81,100},{92,100},{92,100},{110,100}},
        color={0,0,127}));
  connect(TSet, con.u_s)
    annotation (Line(points={{-120,0},{-92,0}}, color={0,0,127}));
  connect(senTDisRet.T, con.u_m)
    annotation (Line(points={{-80,-49},{-80,-12}}, color={0,0,127}));
  connect(con.y, val.y) annotation (Line(points={{-69,0},{-40,0},{-40,-80},{30,-80},
          {30,-72}}, color={0,0,127}));
  connect(val.port_1, senTBuiRet.port_b)
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(senTBuiRet.port_a, port_a2)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
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
        Rectangle(
          extent={{-80,68},{80,52}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,-52},{80,-68}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-8,52},{8,18}},
          lineColor={0,0,0},
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,-18},{8,-52}},
          lineColor={0,0,0},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-8,18},{8,-18}},
          lineColor={0,0,0},
          fillColor={0,128,255},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(extent={{-8,52},{8,-52}}, lineColor={0,0,0})}),
                               Diagram(coordinateSystem(preserveAspectRatio=
            false, extent={{-100,-100},{100,140}})),
              Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
Direct cooling energy transfer station (ETS) model with in-building pumping and deltaT control.
The design is based on a typical district cooling ETS described in ASHRAE's 
<a href=\"https://www.ashrae.org/technical-resources/bookstore/district-heating-and-cooling-guides\">
District Cooling Guide</a>.  
As shown in the figure below, the district and building piping are hydronically coupled. The valve
on the district return controls the return temperature to the district cooling network.
</p>
<p align=\"center\">
<img src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/CoolingDirectControlledReturn.PNG\"/>
</p>
<h4>Reference</h4>
<p>
American Society of Heating, Refrigeration and Air-Conditioning Engineers. (2013). Chapter 5: End User Interface. In <i>District Cooling Guide</i>. 1st Edition. 
</p>
</html>", revisions="<html>
<ul>
<li>November 13, 2019, by Kathryn Hinkelman:<br>First implementation. </li>
</ul>
</html>"));
end CoolingDirectControlledReturn;
