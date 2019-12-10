within Buildings.Applications.DHC.EnergyTransferStations;
model CoolingDirectControlledReturn
  "Direct cooling ETS model for district energy systems with in-building pumping and controlled district return temperature"
  extends Buildings.Fluid.Interfaces.PartialFourPort(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium);

 replaceable package Medium =
   Modelica.Media.Interfaces.PartialMedium "Medium in the component";

  // mass flow rates
  parameter Modelica.SIunits.MassFlowRate mDis_flow_nominal(
    final min=0,
    start=0.5)
    "Nominal mass flow rate of district cooling side";

  parameter Modelica.SIunits.MassFlowRate mBui_flow_nominal(
    final min=0,
    start=0.5)
    "Nominal mass flow rate of building cooling side";

  parameter Modelica.SIunits.MassFlowRate mByp_flow_nominal(
    final min=0,
    start=0.5)
    "Nominal mass flow rate through the bypass segment";

  // pressure drops
  parameter Modelica.SIunits.PressureDifference dpSup_nominal(
    displayUnit="Pa")=500
  "Nominal pressure drop in the ETS supply side (piping, valves, etc.)";

  parameter Modelica.SIunits.PressureDifference dpRet_nominal(
    displayUnit="Pa")=500
  "Nominal pressure drop in the ETS return side (piping, valves, etc.)";

  parameter Modelica.SIunits.PressureDifference dpByp_nominal(
    displayUnit="Pa")=100
  "Nominal pressure drop in the bypass line (piping, valves, etc.)";

  parameter Modelica.SIunits.PressureDifference dpVal_nominal(
    displayUnit="Pa")=6000
  "Nominal pressure drop in the control valve";

  // Controller parameters
  parameter Modelica.Blocks.Types.SimpleController controllerType=
    Modelica.Blocks.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(tab="Controller"));

  parameter Real k(min=0, unit="1") = 1
    "Gain of controller"
    annotation(Dialog(tab="Controller"));

  parameter Modelica.SIunits.Time Ti(min=Modelica.Constants.small)=120
    "Time constant of integrator block"
     annotation (Dialog(tab="Controller", enable=
       controllerType == Modelica.Blocks.Types.SimpleController.PI or
       controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Modelica.SIunits.Time Td(min=0)=0.1
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

  parameter Real wp(min=0) = 1
   "Set-point weight for Proportional block (0..1)"
    annotation(Dialog(tab="Controller"));

  parameter Real wd(min=0) = 0
   "Set-point weight for Derivative block (0..1)"
    annotation(Dialog(tab="Controller", enable=
       controllerType == Modelica.Blocks.Types.SimpleController.PD or
       controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Real Ni(min=100*Modelica.Constants.eps) = 0.9
    "Ni*Ti is time constant of anti-windup compensation"
    annotation(Dialog(tab="Controller", enable=
       controllerType == Modelica.Blocks.Types.SimpleController.PI or
       controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Real Nd(min=100*Modelica.Constants.eps) = 10
    "The higher Nd, the more ideal the derivative block"
    annotation(Dialog(tab="Controller", enable=
       controllerType == Modelica.Blocks.Types.SimpleController.PD or
       controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Modelica.Blocks.Types.InitPID initType=
    Modelica.Blocks.Types.InitPID.DoNotUse_InitialIntegratorState
    "Type of initialization (1: no init, 2: steady state, 3: initial state, 4: initial output)"
    annotation(Dialog(group="Initialization",tab="Controller"));

  parameter Real xi_start=0
    "Initial or guess value value for integrator output (= integrator state)"
    annotation (Dialog(group="Initialization",
      tab="Controller", enable=
        controllerType == Modelica.Blocks.Types.SimpleController.PI or
        controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Real xd_start=0
    "Initial or guess value for state of derivative block"
    annotation (Dialog(group="Initialization",
      tab="Controller", enable=
        controllerType == Modelica.Blocks.Types.SimpleController.PD or
        controllerType == Modelica.Blocks.Types.SimpleController.PID));

  parameter Real yCon_start=0
    "Initial value of output from the controller"
    annotation(Dialog(group="Initialization",
      tab="Controller",
      enable=initType == Modelica.Blocks.Types.InitPID.InitialOutput));

  parameter Boolean reverseAction = true
    "Set to true for throttling the water flow rate through a cooling coil controller"
    annotation(Dialog(tab="Controller"));

  Modelica.Blocks.Interfaces.RealInput TSetDisRet
    "Setpoint temperature for district return"
    annotation (Placement(transformation(extent={{-140,-120},{-100,-80}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipSup(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mDis_flow_nominal,
    final dp_nominal=dpSup_nominal)
    "Supply pipe"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipRet(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mDis_flow_nominal,
    final dp_nominal=dpRet_nominal)
    "Return pipe"
    annotation (Placement(transformation(extent={{0,-50},{-20,-70}})));

  Buildings.Fluid.FixedResistances.PressureDrop pipByp(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mByp_flow_nominal,
    final dp_nominal=dpByp_nominal)
    "Bypass pipe"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},
        rotation=-90,
        origin={30,0})));

  Buildings.Fluid.Actuators.Valves.ThreeWayEqualPercentageLinear val(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mBui_flow_nominal,
    final dpValve_nominal=dpVal_nominal)
    "Control valve"
    annotation (Placement(transformation(extent={{40,-50},{20,-70}})));

  Buildings.Fluid.FixedResistances.Junction jun(
    redeclare final package Medium = Medium,
    m_flow_nominal={mDis_flow_nominal,-mBui_flow_nominal,mByp_flow_nominal},
    dp_nominal=500*{1,-1,1})
    "Bypass junction"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));

  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(
    redeclare final package Medium = Medium)
    "District supply mass flow rate sensor"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisSup(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mDis_flow_nominal)
    "District supply temperature sensor"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTDisRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mDis_flow_nominal)
    "District return temperature sensor"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTBuiRet(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mBui_flow_nominal)
    "Building return temperature sensor"
    annotation (Placement(transformation(extent={{80,-70},{60,-50}})));

  Modelica.Blocks.Continuous.Integrator int(k=1) "Integration"
    annotation (Placement(transformation(extent={{70,100},{90,120}})));
  Modelica.Blocks.Math.Add dTDis(k1=-1, k2=+1)
    "Temperature difference on the district side"
    annotation (Placement(transformation(extent={{-48,106},{-28,126}})));
  Modelica.Blocks.Math.Product pro "Product"
    annotation (Placement(transformation(extent={{-10,100},{10,120}})));
  Modelica.Blocks.Math.Gain cp(k=cp_default)
    "Specific heat multiplier to calculate heat flow rate"
    annotation (Placement(transformation(extent={{30,100},{50,120}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final quantity="Power",
    final unit="W",
    displayUnit="kW")
    "Measured power demand at the ETS"
    annotation (Placement(transformation(extent={{100,140},{120,160}})));
  Modelica.Blocks.Interfaces.RealOutput Q(
    final quantity="Energy",
    final unit="J",
    displayUnit="kWh")
    "Measured energy consumption at the ETS"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));

  Modelica.Blocks.Logical.LessThreshold TDisRet_min(threshold=273.15 + 16)
    "Minimum district return temperature"
    annotation (Placement(transformation(extent={{-60,-140},{-40,-120}})));
  Modelica.Blocks.Logical.Switch swi "Control valve switch"
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));
  Modelica.Blocks.Sources.Constant clo(k=0) "Closed valve"
    annotation (Placement(transformation(extent={{-60,-180},{-40,-160}})));
  Modelica.Blocks.Sources.Constant ope(k=1) "Open valve"
    annotation (Placement(transformation(extent={{-60,-110},{-40,-90}})));
protected
  final parameter Medium.ThermodynamicState sta_default = Medium.setState_pTX(
    T=Medium.T_default,
    p=Medium.p_default,
    X=Medium.X_default) "Medium state at default properties";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp_default=
    Medium.specificHeatCapacityCp(sta_default)
    "Specific heat capacity of the fluid";

equation
  connect(port_a1, senTDisSup.port_a)
    annotation (Line(points={{-100,60},{-90,60}}, color={0,127,255}));
  connect(senTDisSup.port_b, senMasFlo.port_a)
    annotation (Line(points={{-70,60},{-50,60}}, color={0,127,255}));
  connect(senMasFlo.port_b, pipSup.port_a)
    annotation (Line(points={{-30,60},{-20,60}}, color={0,127,255}));
  connect(pipSup.port_b, jun.port_1)
    annotation (Line(points={{0,60},{20,60}}, color={0,127,255}));
  connect(jun.port_2, port_b1)
    annotation (Line(points={{40,60},{100,60}}, color={0,127,255}));
  connect(val.port_2, pipRet.port_a)
    annotation (Line(points={{20,-60},{0,-60}}, color={0,127,255}));
  connect(pipRet.port_b, senTDisRet.port_b)
    annotation (Line(points={{-20,-60},{-50,-60}}, color={0,127,255}));
  connect(senTDisRet.port_a, port_b2)
    annotation (Line(points={{-70,-60},{-100,-60}}, color={0,127,255}));
  connect(jun.port_3, pipByp.port_b)
    annotation (Line(points={{30,50},{30,10},{30,10}}, color={0,127,255}));
  connect(pipByp.port_a, val.port_3)
    annotation (Line(points={{30,-10},{30,-50}}, color={0,127,255}));
  connect(val.port_1, senTBuiRet.port_b)
    annotation (Line(points={{40,-60},{60,-60}}, color={0,127,255}));
  connect(senTBuiRet.port_a, port_a2)
    annotation (Line(points={{80,-60},{100,-60}}, color={0,127,255}));
  connect(int.y,Q)
    annotation (Line(points={{91,110},{110,110}}, color={0,0,127}));
  connect(dTDis.y,pro. u1)
    annotation (Line(points={{-27,116},{-12,116}}, color={0,0,127}));
  connect(pro.y,cp. u)
    annotation (Line(points={{11,110},{28,110}}, color={0,0,127}));
  connect(cp.y,int. u)
    annotation (Line(points={{51,110},{68,110}}, color={0,0,127}));
  connect(cp.y,Q_flow)
    annotation (Line(points={{51,110},{60,110},{60,150},{110,150}}, color={0,0,127}));
  connect(senMasFlo.m_flow, pro.u2)
    annotation (Line(points={{-40,71},{-40,104},{-12,104}}, color={0,0,127}));
  connect(senTDisSup.T, dTDis.u1)
    annotation (Line(points={{-80,71},{-80,122},{-50,122}}, color={0,0,127}));
  connect(senTDisRet.T, dTDis.u2)
    annotation (Line(points={{-60,-49},{-60,110},{-50,110}}, color={0,0,127}));

  connect(senTDisRet.T, TDisRet_min.u) annotation (Line(points={{-60,-49},{-60,
          -40},{-80,-40},{-80,-130},{-62,-130}}, color={0,0,127}));
  connect(swi.y, val.y)
    annotation (Line(points={{21,-130},{30,-130},{30,-72}}, color={0,0,127}));
  connect(ope.y, swi.u1) annotation (Line(points={{-39,-100},{-20,-100},{-20,
          -122},{-2,-122}}, color={0,0,127}));
  connect(clo.y, swi.u3) annotation (Line(points={{-39,-170},{-20,-170},{-20,
          -138},{-2,-138}}, color={0,0,127}));
  connect(TDisRet_min.y, swi.u2)
    annotation (Line(points={{-39,-130},{-2,-130}}, color={255,0,255}));
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
            false, extent={{-100,-200},{100,160}})),
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
