within Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses;
model PartialCDU "Partial model for a CDU"
  extends Buildings.Applications.DataCenters.LiquidCooled.CDUs.BaseClasses.PartialFourPortInterface(
    final mPla_flow_nominal=dat.mPla_flow_nominal,
    final mRac_flow_nominal=dat.mRac_flow_nominal);

  parameter Buildings.Applications.DataCenters.LiquidCooled.CDUs.Data.Generic_epsNTU dat
    "Data record for performance characterization"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  parameter Boolean checkMedia=true
    "Set to false to disable media consistency check"
    annotation(Dialog(tab="Advanced", group="Diagnostics"));

  // Flow resistance parameters
  parameter Boolean computeFlowResistancePla=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));
  parameter Boolean from_dpPla=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=computeFlowResistancePla,
                tab="Flow resistance", group="Medium 1"));

  parameter Boolean linearizeFlowResistancePla=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=computeFlowResistancePla,
               tab="Flow resistance", group="Medium 1"));
  parameter Boolean computeFlowResistanceRac=true
    "=true, compute flow resistance. Set to false to assume no friction"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));

  parameter Boolean from_dpRac=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(enable=computeFlowResistanceRac,
                tab="Flow resistance", group="Medium 2"));

  parameter Boolean linearizeFlowResistanceRac=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(enable=computeFlowResistanceRac,
      tab="Flow resistance", group="Medium 2"));

  // Valve
  parameter Boolean use_strokeTime=true
    "Set to true to continuously open and close valve using strokeTime from instance dat"
    annotation (Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.Blocks.Types.Init initVal=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation (Dialog(tab="Dynamics", group="Valve"));
  parameter Real yVal_start=1 "Initial position of actuator"
    annotation (Dialog(tab="Dynamics", group="Valve"));

  // Pump
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.Units.SI.Time tau=1
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Boolean use_riseTime=true
    "Set to true to continuously change motor speed using risetime from instance dat"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Real yPum_start=0 "Initial value of speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));

  // Valve controller parameters
  parameter Controls.OBC.CDL.Types.SimpleController controllerTypeVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for valve"
    annotation(Dialog(group="Valve controller"));
  parameter Real kVal=1 "Gain of controller for valve"
    annotation(Dialog(group="Valve controller"));
  parameter Real TiVal=120
    "Time constant of integrator block of valve controller"
    annotation(Dialog(group="Valve controller",
      enable=controllerTypeVal<>Buildings.Controls.OBC.CDL.Types.SimpleController.P));
  parameter Real TdVal=0.1
    "Time constant of derivative block for valve controller"
    annotation(Dialog(group="Valve controller",
      enable=controllerTypeVal==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // Pump controller parameters
  parameter Controls.OBC.CDL.Types.SimpleController controllerTypePum=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for pump"
    annotation(Dialog(group="Pump controller"));
  parameter Real kPum=1 "Gain of controller for pump"
    annotation(Dialog(group="Pump controller"));
  parameter Real TiPum=120
    "Time constant of integrator block of pump controller"
    annotation(Dialog(group="Pump controller",
      enable=controllerTypePum<>Buildings.Controls.OBC.CDL.Types.SimpleController.P));
  parameter Real TdPum=0.1
    "Time constant of derivative block for pump controller"
    annotation(Dialog(group="Pump controller",
      enable=controllerTypePum==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // Connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC")
    "Set point temperature for water leaving to the IT rack"
   annotation (Placement(transformation(
      extent={{-140,80},{-100,120}}),
     iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpSet(min=0, final unit="Pa")
    "Set point for static pressure provided by CDU" annotation (Placement(
        transformation(extent={{-140,-120},{-100,-80}}), iconTransformation(
          extent={{-140,-40},{-100,0}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W")
    "Electrical power consumed by pump"
    annotation (Placement(transformation(extent={{100,80},{120,100}}),
        iconTransformation(extent={{100,80},{120,100}})));

  // Components
  Controls.OBC.CDL.Reals.PID conVal(
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    final controllerType=controllerTypeVal,
    final k=kVal,
    final Ti=TiVal,
    final Td=TdVal,
    final reverseActing=false,
    r=10,
    xi_start=1)
    "Controller for valve"
    annotation (Placement(transformation(extent={{-80,90},{-60,110}})));
  Controls.OBC.CDL.Reals.PID conPum(
    u_s(final unit="Pa"),
    u_m(final unit="Pa"),
    final controllerType=controllerTypePum,
    final k=kPum,
    final Ti=TiPum,
    final Td=TdPum,
    final reverseActing=true,
    r=dat.dpHeaExt_nominal,
    xi_start=1)
    "Controller for pump"
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  replaceable Buildings.Fluid.Interfaces.PartialFourPortInterface hex
    constrainedby Buildings.Fluid.Interfaces.PartialFourPortInterface(
      redeclare final package Medium1 = MediumPla,
      redeclare final package Medium2 = MediumRac,
      final allowFlowReversal1=allowFlowReversalPla,
      final allowFlowReversal2=allowFlowReversalRac,
      final m1_flow_nominal=mPla_flow_nominal,
      final m2_flow_nominal=mRac_flow_nominal,
      final show_T=show_T) "Heat exchanger"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare final package Medium = MediumPla,
    final allowFlowReversal=allowFlowReversalPla,
    m_flow_nominal=dat.mPla_flow_nominal,
    final from_dp=from_dpPla,
    final linearized=linearizeFlowResistancePla,
    final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    dpValve_nominal=dat.dpValve_nominal,
    final use_strokeTime=use_strokeTime,
    final strokeTime=dat.strokeTime,
    final init=initVal,
    final y_start=yVal_start) "Control valve on chilled water side" annotation
    (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-50,60})));

  Fluid.Movers.Preconfigured.SpeedControlled_y pum(
    redeclare final package Medium = MediumRac,
    energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversalRac,
    addPowerToMedium=addPowerToMedium,
    final tau=tau,
    final use_riseTime=use_riseTime,
    final riseTime=dat.riseTime,
    final y_start=yPum_start,
    m_flow_nominal=dat.mRac_flow_nominal,
    dp_nominal=dat.dpHeaExt_nominal + dat.dpHexRac_nominal)
                                                 "Pump on IT side" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-40})));

  Fluid.Storage.ExpansionVessel exp(
    redeclare package Medium = MediumRac,
    final V_start=dat.VExp) "Expansion vessel"
    annotation (Placement(transformation(extent={{-60,-8},{-40,12}})));

  Fluid.Sensors.RelativePressure senRelPre(
    redeclare package Medium = MediumRac)
    "Differential pressure sensor"
    annotation (Placement(transformation(extent={{-10,-130},{10,-150}})));
  Fluid.Sensors.TemperatureTwoPort senTemRacSup(
    redeclare final package Medium = MediumRac,
    final allowFlowReversal=allowFlowReversalRac,
    final m_flow_nominal=mRac_flow_nominal)
    "Temperature sensor for medium leaving towards IT racks"
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));

  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power from the pump (=heat and flow work) being added to medium (may give simpler equations)";
initial equation
  if checkMedia then
    // Assert that the media are consistent with the medium types declared in the parameter record
    assert(
      (dat.medPla == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "Water") > 0) or
      (dat.medPla == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.EthyleneGlycol and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "EthyleneGlycol") > 0) or
      (dat.medPla == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.PropyleneGlycol and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "PropyleneGlycol") > 0),
      "In " + getInstanceName() + ": The plant-side medium '" + MediumPla.mediumName
      + "' does not match the medium type dat.medPla = "
      + String(dat.medPla) + " declared in the parameter record."
      + "\nSet the parameter checkMedia=false to avoid this check.");
    assert(
      (dat.medRac == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.Water and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "Water") > 0) or
      (dat.medRac == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.EthyleneGlycol and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "EthyleneGlycol") > 0) or
      (dat.medRac == Buildings.Applications.DataCenters.LiquidCooled.Types.Media.PropyleneGlycol and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "PropyleneGlycol") > 0),
      "In " + getInstanceName() + ": The rack-side medium '" + MediumRac.mediumName
      + "' does not match the medium type dat.medRac = "
      + String(dat.medRac) + " declared in the parameter record."
      + "\nSet the parameter checkMedia=false to avoid this check.");
   end if;
equation
  connect(port_aPla, val.port_a)
    annotation (Line(points={{-100,60},{-60,60}},          color={0,127,255}));
  connect(val.port_b, hex.port_a1)
    annotation (Line(points={{-40,60},{-20,60},{-20,6},{-10,6}},
                                                        color={0,127,255}));
  connect(hex.port_b1, port_bPla) annotation (Line(points={{10,6},{40,6},{40,60},{
          100,60}}, color={0,127,255}));
  connect(pum.port_a, hex.port_b2)
    annotation (Line(points={{-20,-30},{-20,-6},{-10,-6}}, color={0,127,255}));
  connect(hex.port_a2, port_aRac) annotation (Line(points={{10,-6},{40,-6},{40,-60},
          {100,-60}}, color={0,127,255}));
  connect(pum.P, P) annotation (Line(points={{-11,-51},{-11,-80},{68,-80},{68,90},
          {110,90}}, color={0,0,127}));
  connect(pum.port_a, exp.port_a)
    annotation (Line(points={{-20,-30},{-20,-20},{-50,-20},{-50,-8}},
                                                         color={0,127,255}));
  connect(senRelPre.port_b, port_aRac) annotation (Line(points={{10,-140},{80,-140},
          {80,-60},{100,-60}}, color={0,127,255}));
  connect(senRelPre.port_a, port_bRac) annotation (Line(points={{-10,-140},{-88,
          -140},{-88,-60},{-100,-60}}, color={0,127,255}));
  connect(dpSet, conPum.u_s)
    annotation (Line(points={{-120,-100},{-12,-100}}, color={0,0,127}));
  connect(senRelPre.p_rel, conPum.u_m) annotation (Line(points={{0,-131},{0,-112}},
                                  color={0,0,127}));
  connect(TSet, conVal.u_s)
    annotation (Line(points={{-120,100},{-82,100}}, color={0,0,127}));
  connect(senTemRacSup.T, conVal.u_m)
    annotation (Line(points={{-70,-49},{-70,88}}, color={0,0,127}));
  connect(conVal.y, val.y)
    annotation (Line(points={{-58,100},{-50,100},{-50,72}}, color={0,0,127}));
  connect(conPum.y, pum.y) annotation (Line(points={{12,-100},{20,-100},{20,-40},
          {-8,-40}}, color={0,0,127}));
  connect(pum.port_b, senTemRacSup.port_a) annotation (Line(points={{-20,-50},{
          -20,-60},{-60,-60}}, color={0,127,255}));
  connect(senTemRacSup.port_b, port_bRac)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  annotation (Icon(
    coordinateSystem(
      extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-34,30},{34,-30}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-96,65},{-80,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-94,-57},{-22,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-14,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,46},
          rotation=270),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-60,36},
          rotation=90),
        Polygon(
          points={{-20,10},{-20,-10},{0,0},{20,-10},{20,10},{0,0},{-20,10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          origin={-60,60},
          rotation=180),
        Rectangle(
          extent={{-40,65},{-22,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{30,64},{100,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-17,4},{17,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={26,47},
          rotation=90),
        Rectangle(
          extent={{-17,4},{17,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-26,47},
          rotation=90),
        Ellipse(
          extent={{-80,-40},{-40,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-80,-60},{-60,-40},{-60,-80},{-80,-60}},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-17.5,3.5},{17.5,-3.5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={-25.5,-47.5},
          rotation=90),
        Rectangle(
          extent={{-17,3},{17,-3}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid,
          origin={27,-47},
          rotation=90),
        Rectangle(
          extent={{24,-55},{96,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-40,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,20},
          rotation=360),
        Line(
          points={{-40,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,-20},
          rotation=360),
        Line(
          points={{-20,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,-40},
          rotation=270),
        Line(
          points={{-6,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,20},
          rotation=270)}),
  defaultComponentName="cdu",
  Documentation(
    info="<html>
<p>
Model of a coolant distribution unit (CDU) with built in two-way valve on the chilled
water side and pump on the IT side as shown in the figure below.
</p>
<p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Applications/DataCenters/LiquidCooled/CDUs/CDU_epsNTU.png\"
         alt=\"Schematic diagram of the CDU.\"
         style=\"width: 100%; height: auto;\">
</p>
<p>
The two fluid streams are separated by a heat exchanger.
</p>
<p>
On the chilled water side is a two-way valve that controls the mass flow rate
to track to set point for the leaving fluid temperature that goes to the IT racks.
By default, the controller is configured as a PI-controller.
The valve has an equal-percentage
opening characteristics. By default, the valve pressure drop is set to the same value
as the heat exchanger pressure drop, achieving a valve authority of <i>0.5</i>.
The valve is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage\">
Buildings.Fluid.Actuators.Valves.TwoWayEqualPercentage</a>.
</p>
<p>
On the IT side is a circulation pump that is controlled to track a set point for
the head between the two fluid ports.
Note that this head is not the pump head, but rather the head between the fluid ports
of the CDU, and hence it takes into account the flow resistance of the heat exchanger.
The controller for the pump is configured by default as a PI-controller.
</p>
<p>
Note that the head, specified through the parameter <code>dpPum_nominal</code>,
is the head of the CDU.
To properly size the pump, set <code>dpPum_nominal</code> to the flow resistance that is
external to the CDU, plus the flow resistance of the heat exchanger <code>dpHex_nominal</code>
and the filter.
</p>
<p>
The pump is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y\">
Buildings.Fluid.Movers.Preconfigured.SpeedControlled_y</a>.
</p>
<p>
On the IT side, there is also an expansion vessel, modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
This component sets a reference static pressure, and if the medium model computes
density as a function of temperature during the simulation, it provides a volume for the
medium's thermal expansion.
Note however that to improve computing performance, the medium
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>
assumes density as constant during the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-160},{100,140}})));
end PartialCDU;
