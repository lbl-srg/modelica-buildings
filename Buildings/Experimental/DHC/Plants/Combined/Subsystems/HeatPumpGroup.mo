within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model HeatPumpGroup
  "Model of multiple identical air-source heat pumps in parallel"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal(final min=Modelica.Constants.small)=mHeaWat_flow_nominal);

  replaceable package MediumAir=Buildings.Media.Air
    "Air medium";

  parameter Integer nUni(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation(Evaluate=true);
  final parameter Modelica.Units.SI.HeatFlowRate capUni_nominal(
    final min=0)=dat.hea.Q_flow
    "Heat pump design capacity (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWatUni_flow_nominal(
    final min=0)=dat.hea.mLoa_flow
    "HW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mAirUni_flow_nominal(
    final min=0)=dat.hea.mSou_flow
    "Air design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mHeaWat_flow_nominal(
    final min=0)=nUni * mHeaWatUni_flow_nominal
    "HW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpPumHeaWatUni_nominal(
    final min=0,
    displayUnit="Pa")=dat.dpHeaLoa_nominal
    "HW pump design head (each unit)"
    annotation(Dialog(group="Nominal condition"));

  replaceable parameter Buildings.Fluid.HeatPumps.Data.EquationFitReversible.Generic dat
    "Heat pump parameters (each unit)"
    annotation (Placement(transformation(extent={{-10,-88},{10,-68}})));
  replaceable parameter Fluid.Movers.Data.Generic datPum
    constrainedby Fluid.Movers.Data.Generic(
      pressure(V_flow={0,1,2}*mHeaWatUni_flow_nominal/rho_nominal,
      dp={1.14,1,0.42}*dpPumHeaWatUni_nominal),
      motorCooledByFluid=false)
    "Condenser pump parameters (each unit)"
    annotation (Placement(transformation(extent={{20,-88},{40,-68}})));

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tau=30
    "Time constant of fluid volume for nominal HW flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));

  // Pump speed filter parameters
  parameter Boolean use_inputFilter=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState
    "= true, if signal is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Filtered pump speed"));
  parameter Modelica.Units.SI.Time riseTime=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation (Dialog(
      tab="Dynamics",
      group="Filtered pump speed",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Filtered pump speed",enable=use_inputFilter));
  parameter Real y_start=1 "Initial position of actuator"
    annotation(Dialog(tab="Dynamics", group="Filtered pump speed",enable=use_inputFilter));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    "Heat pump On/Off command"
    annotation (Placement(transformation(extent={{-140,40},
            {-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P
    "Power drawn by heat pumps"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConInl(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulConOut(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_input=true)
    "Flow rate multiplier"
    annotation (Placement(transformation(extent={{30,-10},{50,10}})));
  BaseClasses.MultipleCommands com(final nUni=nUni)
    "Convert command signals"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale power"
    annotation (Placement(transformation(extent={{70,110},{90,90}})));
  Fluid.HeatPumps.EquationFitReversible heaPum(
    redeclare final package Medium1=Medium,
    redeclare final package Medium2=MediumAir,
    final per=dat,
    final tau1=tau,
    final show_T=show_T,
    final energyDynamics=energyDynamics,
    final allowFlowReversal1=allowFlowReversal,
    final allowFlowReversal2=false)
    "Heat pump"
    annotation (Placement(transformation(extent={{-10,-16},{10,4}})));
  Fluid.Movers.FlowControlled_m_flow pum(
    final m_flow_nominal=mHeaWatUni_flow_nominal,
    final dp_nominal=dpPumHeaWatUni_nominal,
    redeclare final package Medium = Medium,
    final tau=tau,
    final show_T=show_T,
    final allowFlowReversal=allowFlowReversal,
    final energyDynamics=energyDynamics,
    final use_inputFilter=use_inputFilter,
    final riseTime=riseTime,
    final init=init,
    final per=datPum,
    addPowerToMedium=false) "HW pump"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Fluid.Sources.MassFlowSource_WeatherData airSou(
    redeclare final package Medium=MediumAir,
    final use_m_flow_in=true,
    final nPorts=1)
    "Air flow source"
    annotation (Placement(transformation(extent={{50,-50},{30,-30}})));
  Fluid.Sources.Boundary_pT airSin(
    redeclare final package Medium=MediumAir,
    final nPorts=1)
    "Air flow sink"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt
    "Convert HP On/Off command to integer"
    annotation (Placement(transformation(extent={{-30,100},{-10,80}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay truDel(
    delayTime=pum.riseTime)
    "Delay HP On/Off command to allow for pump start time"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea(
    final realTrue=mHeaWatUni_flow_nominal)
    "Convert On/Off command to HW flow setpoint"
    annotation (Placement(transformation(extent={{-60,50},{-40,30}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal      booToRea1(realTrue=
        mAirUni_flow_nominal) "Convert On/Off command to air flow setpoint"
    annotation (Placement(transformation(extent={{30,80},{50,60}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{-20,80},{20,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP1
                                                      "Scale power"
    annotation (Placement(transformation(extent={{70,50},{90,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum
    "Power drawn by HW pumps" annotation (Placement(transformation(extent={{100,
            20},{140,60}}), iconTransformation(extent={{100,20},{140,60}})));
protected
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
    T=dat.hea.TRefLoa,
    p=3E5,
    X=Medium.X_default)
    "State of the medium at the medium default properties";
  parameter Modelica.Units.SI.Density rho_nominal=Medium.density(sta_nominal)
    "Density at the medium default properties";
equation
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{52,6},{56,6},{56,
          -20},{-86,-20},{-86,6},{-82,6}},     color={0,0,127}));
  connect(y1, com.y1) annotation (Line(points={{-120,60},{-94,60},{-94,65},{-92,
          65}},  color={255,0,255}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-68,65},{20,65},{20,106},
          {68,106}},        color={0,0,127}));

  connect(mulP.y, P)
    annotation (Line(points={{92,100},{120,100}},
                                                color={0,0,127}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-68,67},{16,67},
          {16,6},{28,6}},        color={0,0,127}));
  connect(pum.port_b, heaPum.port_a1)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(heaPum.port_b1, mulConOut.port_a) annotation (Line(points={{10,0},{30,
          0}},                 color={0,127,255}));
  connect(mulConInl.port_b, pum.port_a) annotation (Line(points={{-60,0},{-50,0}},
                            color={0,127,255}));
  connect(mulConOut.port_b, port_b)
    annotation (Line(points={{50,0},{100,0}}, color={0,127,255}));
  connect(heaPum.P, mulP.u1) annotation (Line(points={{11,-6.2},{22,-6.2},{22,94},
          {68,94}}, color={0,0,127}));
  connect(port_a, mulConInl.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(airSou.ports[1], heaPum.port_a2) annotation (Line(points={{30,-40},{20,
          -40},{20,-12},{10,-12}}, color={0,127,255}));
  connect(airSin.ports[1], heaPum.port_b2) annotation (Line(points={{-30,-40},{-20,
          -40},{-20,-12},{-10,-12}}, color={0,127,255}));
  connect(TSet, heaPum.TSet) annotation (Line(points={{-120,-60},{-16,-60},{-16,
          3},{-11.4,3}}, color={0,0,127}));
  connect(booToInt.y, heaPum.uMod) annotation (Line(points={{-8,90},{0,90},{0,
          40},{-14,40},{-14,-6},{-11,-6}},
                         color={255,127,0}));
  connect(booToInt.u, truDel.y)
    annotation (Line(points={{-32,90},{-38,90}}, color={255,0,255}));
  connect(com.y1One, truDel.u) annotation (Line(points={{-68,69},{-66,69},{-66,
          90},{-62,90}},
                     color={255,0,255}));
  connect(com.y1One, booToRea.u) annotation (Line(points={{-68,69},{-66,69},{-66,
          40},{-62,40}}, color={255,0,255}));
  connect(booToRea.y, pum.m_flow_in) annotation (Line(points={{-38,40},{-30,40},
          {-30,20},{-40,20},{-40,12}}, color={0,0,127}));
  connect(booToRea1.y, airSou.m_flow_in) annotation (Line(points={{52,70},{60,70},
          {60,-32},{50,-32}}, color={0,0,127}));
  connect(weaBus, airSou.weaBus) annotation (Line(
      points={{100,-40},{50,-40},{50,-39.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(com.y1One, booToRea1.u)
    annotation (Line(points={{-68,69},{28,69},{28,70}}, color={255,0,255}));
  connect(mulP1.y, PPum)
    annotation (Line(points={{92,40},{120,40}}, color={0,0,127}));
  connect(pum.P, mulP1.u1) annotation (Line(points={{-29,9},{-20,9},{-20,34},{68,
          34}}, color={0,0,127}));
  connect(com.nUniOn, mulP1.u2) annotation (Line(points={{-68,65},{20,65},{20,46},
          {68,46}}, color={0,0,127}));
  annotation (
    defaultComponentName="heaPum",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,60},{60,-60}},
          lineColor={27,0,55},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Documentation(info="<html>
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>
does not capture the sensitivity of the HP performance
to the HW supply temperature setpoint.
This means that a varying HW supply temperature setpoint
has no impact on the heat pump <i>COP</i> (all other variables
such as the HW return temperature being kept invariant).
This limitation is not an issue for the CW storage plant
where the heat pump supply temperature setpoint is not
to be reset.
</p>
</html>"));
end HeatPumpGroup;
