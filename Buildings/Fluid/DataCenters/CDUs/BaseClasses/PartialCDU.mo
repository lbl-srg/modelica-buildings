within Buildings.Fluid.DataCenters.CDUs.BaseClasses;
model PartialCDU "Partial model for a CDU"
  extends Buildings.Fluid.DataCenters.CDUs.BaseClasses.PartialFourPortInterface(
    final mPla_flow_nominal=dat.mPla_flow_nominal,
    final mRac_flow_nominal=dat.mRac_flow_nominal);

  parameter Buildings.Fluid.DataCenters.CDUs.LiquidToLiquid.Data.Generic_epsNTU dat
    "Data record for performance characterization"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));

  parameter Boolean checkMedia=true
    "Set to false to disable media consistency check"
    annotation(Dialog(tab="Advanced", group="Diagnostics"));

  // Flow resistance parameters
  parameter Boolean from_dpPla=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean linearizeFlowResistancePla=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Medium 1"));

  parameter Boolean from_dpRac=false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Flow resistance", group="Medium 2"));

  parameter Boolean linearizeFlowResistanceRac=false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation (Dialog(tab="Flow resistance", group="Medium 2"));

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
    "Set to true to continuously change motor speed using riseTime from instance dat"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Real yPum_start=0 "Initial value of speed"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power from the pump (=heat and flow work) being added to medium (may give simpler equations)";

  parameter Boolean use_yPum_in=false
    "Set to true to enable an input connector for the pump speed, which replaces the internal pump controller"
    annotation(Evaluate=true, Dialog(group="Pump controller"));
  parameter Boolean use_yVal_in=false
    "Set to true to enable an input connector for the valve position, which replaces the internal valve controller"
    annotation(Evaluate=true, Dialog(group="Valve controller"));

  // Valve controller parameters
  parameter Controls.OBC.CDL.Types.SimpleController controllerTypeVal=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for valve"
    annotation(Dialog(group="Valve controller", enable=not use_yVal_in));
  parameter Real kVal=1 "Gain of controller for valve"
    annotation(Dialog(group="Valve controller", enable=not use_yVal_in));
  parameter Real TiVal=120
    "Time constant of integrator block of valve controller"
    annotation(Dialog(group="Valve controller",
      enable=not use_yVal_in and controllerTypeVal<>Buildings.Controls.OBC.CDL.Types.SimpleController.P));
  parameter Real TdVal=0.1
    "Time constant of derivative block for valve controller"
    annotation(Dialog(group="Valve controller",
      enable=not use_yVal_in and controllerTypeVal==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // Pump controller parameters
  parameter Controls.OBC.CDL.Types.SimpleController controllerTypePum=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for pump"
    annotation(Dialog(group="Pump controller", enable=not use_yPum_in));
  parameter Real kPum=1 "Gain of controller for pump"
    annotation(Dialog(group="Pump controller", enable=not use_yPum_in));
  parameter Real TiPum=120
    "Time constant of integrator block of pump controller"
    annotation(Dialog(group="Pump controller",
      enable=not use_yPum_in and controllerTypePum<>Buildings.Controls.OBC.CDL.Types.SimpleController.P));
  parameter Real TdPum=0.1
    "Time constant of derivative block for pump controller"
    annotation(Dialog(group="Pump controller",
      enable=not use_yPum_in and controllerTypePum==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  // Connectors
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K",
    displayUnit="degC") if not use_yVal_in
    "Set point temperature for water leaving to the IT rack (removed if use_yVal_in = true)"
   annotation (Placement(transformation(
      extent={{-140,100},{-100,140}}),
     iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yVal_in(
    min=0, max=1, final unit="1") if use_yVal_in
    "Valve position command (enabled if use_yVal_in = true)"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput yPum_in(
    min=0, max=1, final unit="1") if use_yPum_in
    "Pump speed command (enabled if use_yPum_in = true)"
    annotation (Placement(transformation(extent={{-140,-160},{-100,-120}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpSet(min=0, final unit="Pa")
    if not use_yPum_in
    "Set point for static pressure provided by CDU (removed if use_yPum_in = true)" annotation (Placement(
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
    xi_start=yVal_start) if not use_yVal_in
    "Controller for valve"
    annotation (Placement(transformation(extent={{-80,110},{-60,130}})));
  Controls.OBC.CDL.Reals.PID conPum(
    u_s(final unit="Pa"),
    u_m(final unit="Pa"),
    final controllerType=controllerTypePum,
    final k=kPum,
    final Ti=TiPum,
    final Td=TdPum,
    final reverseActing=true,
    r=dat.dpPumpExt_nominal,
    xi_start=yPum_start) if not use_yPum_in
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
      final m1_flow_small=mPla_flow_small,
      final m2_flow_small=mRac_flow_small,
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

  // Use sqrt for efficiency because input is the total efficiency, but this is split up into a
  // motor and a hydraulic efficiency which are then multiplied with each other.
  Fluid.Movers.SpeedControlled_y pum(
    redeclare final package Medium = MediumRac,
    energyDynamics=energyDynamics,
    final allowFlowReversal=allowFlowReversalRac,
    addPowerToMedium=addPowerToMedium,
    final tau=tau,
    final use_riseTime=use_riseTime,
    final riseTime=dat.riseTime,
    final y_start=yPum_start,
    per(
      pressure=pumpHeadMonotone,
      powerOrEfficiencyIsHydraulic=true,
      etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.HydraulicEfficiencyMethod.Efficiency_VolumeFlowRate,
      etaMotMet=Buildings.Fluid.Movers.BaseClasses.Types.MotorEfficiencyMethod.Efficiency_VolumeFlowRate,
      efficiency(
        V_flow=dat.pumpEfficiency.V_flow,
        eta={sqrt(dat.pumpEfficiency.eta[i]) for i in 1:size(dat.pumpEfficiency.eta, 1)}),
      motorEfficiency(
        V_flow=dat.pumpEfficiency.V_flow,
        eta={sqrt(dat.pumpEfficiency.eta[i]) for i in 1:size(dat.pumpEfficiency.eta, 1)})),
    final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final init=Modelica.Blocks.Types.Init.InitialOutput)
    "Pump on IT side" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=90,
        origin={-20,-40})));

  Fluid.FixedResistances.PressureDrop fil(
    redeclare final package Medium = MediumRac,
    final allowFlowReversal=allowFlowReversalRac,
    final m_flow_nominal=mRac_flow_nominal,
    final dp_nominal=dat.dpFilRac_nominal,
    final from_dp=from_dpRac,
    final linearized=linearizeFlowResistanceRac,
    final deltaM=dat.deltaMRac,
    final n=dat.nFilRac)
    "Filter"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
      origin={-40,-60})));

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
    final m_flow_nominal=mRac_flow_nominal,
    final tau=0)
    "Temperature sensor for medium leaving towards IT racks"
    annotation (Placement(transformation(extent={{-60,-70},{-80,-50}})));

  parameter Buildings.Fluid.Movers.BaseClasses.Characteristics.flowParameters pumpHeadMonotone(
    V_flow=dat.pumpHead.V_flow,
    dp=if pumpDP_isMonotonicDecreasing then dat.pumpHead.dp
       else
        cat(1,
          {max(dat.pumpHead.dp[i], (1 + (nPumpDat-i)/nPumpDat/100) * max(dat.pumpHead.dp[i+1:nPumpDat])) for i in 1:nPumpDat-1},
           {dat.pumpHead.dp[nPumpDat]}))
    "Actual head of the pump, corrected to impose a minimum descent of the pump curve";

protected
  final parameter Integer nPumpDat = size(dat.pumpHead.dp, 1)
    "Number of support points for pump data";

  final parameter Boolean pumpDP_isMonotonicDecreasing = (dat.pumpHead.dp[1] > dat.pumpHead.dp[end]) and
    Buildings.Utilities.Math.Functions.isMonotonic(
      x=dat.pumpHead.dp,
      strict=true)
    "Flag, true if the pump pressure rise is monotonically decreasing";
initial equation
  if checkMedia then
    // Assert that the media are consistent with the medium types declared in the parameter record
    assert(
      (dat.medPla == Buildings.Fluid.DataCenters.CDUs.Types.Media.Water and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "Water") > 0) or
      (dat.medPla == Buildings.Fluid.DataCenters.CDUs.Types.Media.EthyleneGlycol and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "EthyleneGlycol") > 0) or
      (dat.medPla == Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol and
        Modelica.Utilities.Strings.find(MediumPla.mediumName, "PropyleneGlycol") > 0),
      "In " + getInstanceName() + ": The plant-side medium '" + MediumPla.mediumName
      + "' does not match the medium type dat.medPla = "
      + String(dat.medPla) + " declared in the parameter record."
      + "\nSet the parameter checkMedia=false to avoid this check.");
    assert(
      (dat.medRac == Buildings.Fluid.DataCenters.CDUs.Types.Media.Water and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "Water") > 0) or
      (dat.medRac == Buildings.Fluid.DataCenters.CDUs.Types.Media.EthyleneGlycol and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "EthyleneGlycol") > 0) or
      (dat.medRac == Buildings.Fluid.DataCenters.CDUs.Types.Media.PropyleneGlycol and
        Modelica.Utilities.Strings.find(MediumRac.mediumName, "PropyleneGlycol") > 0),
      "In " + getInstanceName() + ": The rack-side medium '" + MediumRac.mediumName
      + "' does not match the medium type dat.medRac = "
      + String(dat.medRac) + " declared in the parameter record."
      + "\nSet the parameter checkMedia=false to avoid this check.");
  end if;
  assert(pumpDP_isMonotonicDecreasing,
    "In " + getInstanceName() + ": Parameter dat.pumpHead is not monotonically decreasing.
This usually occurs if dat.dpHexRac_nominal + dat.dpFilRac_nominal is too large compared to the decrease in dat.pumpExtHead.
The model will use pumpHeadMonotone instead of dat.pumpHead. Please check your data to avoid this warning.
Model has the following parameters:
  dat.dpHexRac_nominal + dat.dpFilRac_nominal = " + String(dat.dpHexRac_nominal) + " + " + String(dat.dpFilRac_nominal) + " = " + String(dat.dpHexRac_nominal + dat.dpFilRac_nominal) + " Pa
  dat.pumpExtHead.dp[1] - dat.pumpExtHead.dp[end] =          " + String(dat.pumpExtHead.dp[1] - dat.pumpExtHead.dp[end]) + " Pa.",
    level=AssertionLevel.warning);
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
  connect(pum.P, P) annotation (Line(points={{-11,-51},{-11,-80},{68,-80},{68,90},
          {110,90}}, color={0,0,127}));
  connect(pum.port_a, exp.port_a)
    annotation (Line(points={{-20,-30},{-20,-20},{-50,-20},{-50,-8}},
                                                         color={0,127,255}));
  connect(senRelPre.port_b, port_aRac) annotation (Line(points={{10,-140},{40,-140},
          {40,-60},{100,-60}}, color={0,127,255}));
  connect(senRelPre.port_a, port_bRac) annotation (Line(points={{-10,-140},{-88,
          -140},{-88,-60},{-100,-60}}, color={0,127,255}));
  connect(dpSet, conPum.u_s)
    annotation (Line(points={{-120,-100},{-12,-100}}, color={0,0,127}));
  connect(senRelPre.p_rel, conPum.u_m) annotation (Line(points={{0,-131},{0,-112}},
                                  color={0,0,127}));
  connect(TSet, conVal.u_s)
    annotation (Line(points={{-120,120},{-82,120}}, color={0,0,127}));
  connect(senTemRacSup.T, conVal.u_m)
    annotation (Line(points={{-70,-49},{-70,108}},color={0,0,127}));
  connect(yVal_in, val.y);
  connect(yPum_in, pum.y);
  connect(conVal.y, val.y)
    annotation (Line(points={{-58,120},{-50,120},{-50,72}}, color={0,0,127}));
  connect(conPum.y, pum.y) annotation (Line(points={{12,-100},{20,-100},{20,-40},
          {-8,-40}}, color={0,0,127}));
  connect(senTemRacSup.port_b, port_bRac)
    annotation (Line(points={{-80,-60},{-100,-60}}, color={0,127,255}));
  connect(senTemRacSup.port_a, fil.port_b)
    annotation (Line(points={{-60,-60},{-50,-60}}, color={0,127,255}));
  connect(fil.port_a, pum.port_b) annotation (Line(points={{-30,-60},{-20,-60},
          {-20,-50}}, color={0,127,255}));
  connect(hex.port_a2, port_aRac) annotation (Line(points={{10,-6},{40,-6},{40,
          -60},{100,-60}}, color={0,127,255}));
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
          points={{-10,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,50},
          rotation=270),
        Rectangle(
          extent={{-10,10},{10,-10}},
          lineColor={0,0,0},
          lineThickness=0.5,
          origin={-60,40},
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
          extent={{-76,-46},{-40,-80}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          startAngle=0,
          endAngle=360),
        Polygon(
          points={{-76,-62},{-56,-46},{-56,-80},{-76,-62}},
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
          visible=not use_yVal_in,
          points={{-40,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,20},
          rotation=360),
        Line(
          visible=not use_yPum_in,
          points={{-44,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-56,-20},
          rotation=360),
        Line(
          visible=not use_yPum_in,
          points={{-26,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-56,-46},
          rotation=270),
        Line(
          visible=not use_yVal_in,
          points={{-10,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-60,20},
          rotation=270),
        Line(
          visible=use_yVal_in,
          points={{-30,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-70,40},
          rotation=360),
        Line(
          visible=use_yPum_in,
          points={{-44,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-56,-40},
          rotation=360),
        Line(
          visible=use_yPum_in,
          points={{-6,0},{0,0}},
          color={0,0,0},
          thickness=0.5,
          origin={-56,-46},
          rotation=270)}),
  defaultComponentName="cdu",
  Documentation(
    info="<html>
<p>
Model of a coolant distribution unit (CDU) with built-in two-way valve on the chilled
water side and pump on the IT side as shown in the figure below.
</p>
<p align=\"center\">
    <img src=\"modelica://Buildings/Resources/Images/Fluid/DataCenters/CDUs/LiquidToLiquid/CDU_epsNTU.png\"
         alt=\"Schematic diagram of the CDU.\"
         style=\"width: 100%; height: auto;\">
</p>
<p>
The two fluid streams are separated by a heat exchanger.
</p>
<p>
On the chilled water side is a two-way valve that controls the mass flow rate
to track the set point for the leaving fluid temperature that goes to the IT racks.
By default, the controller is configured as a PI controller.
The valve has an equal-percentage
opening characteristic. By default, the valve pressure drop is set to the same value
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
The controller for the pump is configured by default as a PI controller.
</p>
<p>
If <code>use_yVal_in = true</code>, the valve controller is removed, the input
<code>yVal_in</code> sets the valve position and the input <code>TSet</code> is removed.
If <code>use_yPum_in = true</code>, the pump controller is removed, the input
<code>yPum_in</code> sets the pump speed and the input <code>dpSet</code> is removed.
This allows, for example, the valve or the pump of several CDUs to be controlled
by a common controller.
The parameters of a removed controller have no effect.
By default, both parameters are <code>false</code> and the CDU uses its own controllers.
</p>
<p>
Note that the head, specified through the parameter <code>dat.dpPumpExt_nominal</code>,
is the external head available at the fluid ports of the CDU.
To compute the pump head <code>dat.pumpHead</code>, the data record adds the flow resistance
of the heat exchanger <code>dat.dpHexRac_nominal</code> and the filter
<code>dat.dpFilRac_nominal</code> to the external head curve <code>dat.pumpExtHead</code>.
</p>
<p>
The pump is modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Movers.SpeedControlled_y\">
Buildings.Fluid.Movers.SpeedControlled_y</a>.
</p>
<p>
On the IT side, there is also an expansion vessel, modeled using an instance of
<a href=\"modelica://Buildings.Fluid.Storage.ExpansionVessel\">
Buildings.Fluid.Storage.ExpansionVessel</a>.
This component sets a reference static pressure, and if the medium model computes
density as a function of temperature during the simulation, it provides a volume for the
medium's thermal expansion.
Note, however, that to improve computing performance, the medium
<a href=\"modelica://Buildings.Media.Antifreeze.PropyleneGlycolWater\">
Buildings.Media.Antifreeze.PropyleneGlycolWater</a>
assumes density as constant during the simulation.
</p>
</html>", revisions="<html>
<ul>
<li>
November 18, 2026, by Nauman Rafique:<br/>
Added the parameters <code>use_yPum_in</code> and <code>use_yVal_in</code> and the
corresponding inputs <code>yPum_in</code> and <code>yVal_in</code> to drive the
pump speed and the valve position from an input instead of the internal controllers.
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4905\">Buildings, #4905</a>.
</li>
<li>
November 13, 2026, by Michael Wetter:<br/>
Removed unused parameters <code>computeFlowResistancePla</code> and
<code>computeFlowResistanceRac</code>. This change is not backward compatible.<br/>
Propagated <code>mPla_flow_small</code> and <code>mRac_flow_small</code> to <code>hex</code>,
and <code>from_dpRac</code>, <code>linearizeFlowResistanceRac</code>, and
<code>dat.deltaMRac</code> to <code>fil</code>.<br/>
Aligned controller integrator initial values with <code>yVal_start</code> and
<code>yPum_start</code>, set <code>senTemRacSup.tau=0</code>, and enforced strict
monotonicity in <code>pumpDP_isMonotonicDecreasing</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4926\">Buildings, #4926</a>.
</li>
<li>
December 23, 2025, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-160},{100,140}})));
end PartialCDU;
