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
    annotation (Placement(transformation(extent={{-10,-110},{10,-90}})));
  replaceable parameter Fluid.Movers.Data.Generic datPum
    constrainedby Fluid.Movers.Data.Generic(
      pressure(V_flow={0,1,2}*mHeaWatUni_flow_nominal/rho_nominal,
      dp={1.14,1,0.42}*dpPumHeaWatUni_nominal),
      motorCooledByFluid=false)
    "Condenser pump parameters (each unit)"
    annotation (Placement(transformation(extent={{20,-110},{40,-90}})));

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
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
                         iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TSet(
    final unit="K", displayUnit="degC")
    "Supply temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{-20,80},{20,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput PPum(
    final unit="W")
    "Power drawn by HW pumps"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
                     iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(
    final unit="W")
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
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.MultipleCommands com(final nUni=nUni)
    "Convert command signals"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
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
  Fluid.Movers.SpeedControlled_y pum(
    redeclare final package Medium = Medium,
    inputType=Buildings.Fluid.Types.InputType.Continuous,
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
    annotation (Placement(transformation(extent={{42,-50},{22,-30}})));
  Fluid.Sources.Boundary_pT airSin(
    redeclare final package Medium=MediumAir,
    final nPorts=1)
    "Air flow sink"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter comFan(
    final k=mAirUni_flow_nominal)
    "Convert On/Off command to air flow setpoint"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},
        rotation=-90,
        origin={46,30})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP1 "Scale power"
    annotation (Placement(transformation(extent={{70,70},{90,50}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preY1[nUni]
    "Left limit of signal avoiding direct feedback of status to controller"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert to real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,80})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply inp
    "Compute pump input signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-40,30})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant cst(final k=1)
    "Constant"
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Conversions.RealToInteger reaToInt
    "Convert to integer"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-14,30})));
protected
  parameter Medium.ThermodynamicState sta_nominal=Medium.setState_pTX(
    T=dat.hea.TRefLoa,
    p=3E5,
    X=Medium.X_default)
    "State of the medium at the medium default properties";
  parameter Modelica.Units.SI.Density rho_nominal=Medium.density(sta_nominal)
    "Density at the medium default properties";
equation
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{81,6},{86,6},{86,
          -20},{-86,-20},{-86,6},{-82,6}},     color={0,0,127}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-38,100},{60,100},{60,
          106},{68,106}},   color={0,0,127}));

  connect(mulP.y, P)
    annotation (Line(points={{92,100},{120,100}},
                                                color={0,0,127}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-38,94},{16,94},
          {16,6},{58,6}},        color={0,0,127}));
  connect(pum.port_b, heaPum.port_a1)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(heaPum.port_b1, mulConOut.port_a) annotation (Line(points={{10,0},{60,
          0}},                 color={0,127,255}));
  connect(mulConInl.port_b, pum.port_a) annotation (Line(points={{-60,0},{-50,0}},
                            color={0,127,255}));
  connect(mulConOut.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(heaPum.P, mulP.u1) annotation (Line(points={{11,-6.2},{18,-6.2},{18,
          94},{68,94}},
                    color={0,0,127}));
  connect(port_a, mulConInl.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(airSou.ports[1], heaPum.port_a2) annotation (Line(points={{22,-40},{
          16,-40},{16,-12},{10,-12}},
                                   color={0,127,255}));
  connect(airSin.ports[1], heaPum.port_b2) annotation (Line(points={{-30,-40},{-20,
          -40},{-20,-12},{-10,-12}}, color={0,127,255}));
  connect(TSet, heaPum.TSet) annotation (Line(points={{-120,-60},{-16,-60},{-16,
          3},{-11.4,3}}, color={0,0,127}));
  connect(comFan.y, airSou.m_flow_in) annotation (Line(points={{46,18},{46,-32},
          {42,-32}},         color={0,0,127}));
  connect(weaBus, airSou.weaBus) annotation (Line(
      points={{100,-40},{42,-40},{42,-39.8}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{6,3},{6,3}},
      horizontalAlignment=TextAlignment.Left));
  connect(mulP1.y, PPum)
    annotation (Line(points={{92,60},{120,60}}, color={0,0,127}));
  connect(pum.P, mulP1.u1) annotation (Line(points={{-29,9},{60,9},{60,54},{68,
          54}}, color={0,0,127}));
  connect(com.nUniOn, mulP1.u2) annotation (Line(points={{-38,100},{60,100},{60,
          66},{68,66}},
                    color={0,0,127}));
  connect(y1, preY1.u)
    annotation (Line(points={{-120,100},{-92,100}}, color={255,0,255}));
  connect(preY1.y, com.y1)
    annotation (Line(points={{-68,100},{-62,100}}, color={255,0,255}));
  connect(com.y1One, booToRea.u) annotation (Line(points={{-38,106},{-20,106},{
          -20,92}},      color={255,0,255}));
  connect(inp.y, pum.y)
    annotation (Line(points={{-40,18},{-40,12}}, color={0,0,127}));
  connect(booToRea.y, comFan.u)
    annotation (Line(points={{-20,68},{-20,60},{46,60},{46,42}},
                                                      color={0,0,127}));
  connect(booToRea.y, inp.u2) annotation (Line(points={{-20,68},{-20,60},{-34,
          60},{-34,42}}, color={0,0,127}));
  connect(cst.y, inp.u1)
    annotation (Line(points={{-68,60},{-46,60},{-46,42}}, color={0,0,127}));
  connect(booToRea.y, reaToInt.u) annotation (Line(points={{-20,68},{-20,60},{
          -14,60},{-14,42}}, color={0,0,127}));
  connect(reaToInt.y, heaPum.uMod)
    annotation (Line(points={{-14,18},{-14,-6},{-11,-6}}, color={255,127,0}));
  annotation (
    defaultComponentName="heaPum",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid,
          lineThickness=0.5),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Documentation(info="<html>
<p>
This model represents a set of identical air-to-water heat pumps
that are piped in parallel.
Dedicated constant-speed condenser pumps are included.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
On/Off command <code>y1</code>:
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Supply temperature setpoint <code>TSet</code>:
AO signal common to all units, with a dimensionality of zero
</li>
<li>
CW supply temperature <code>TConWatSup</code>:
AI signal common to all units, with a dimensionality of zero
</li>
</ul>
<h4>Details</h4>
<h5>Modeling approach</h5>
<p>
In a parallel arrangement, all operating units have the same operating point.
This allows modeling the heat transfer from outdoor air to condenser water
with a single instance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>.
Hydronics are resolved with mass flow rate multiplier components.
<p>
The model
<a href=\"modelica://Buildings.Fluid.HeatPumps.EquationFitReversible\">
Buildings.Fluid.HeatPumps.EquationFitReversible</a>
does not capture the sensitivity of the heat pump performance
to the HW supply temperature setpoint.
This means that a varying HW supply temperature setpoint
has no impact on the heat pump <i>COP</i> (all other variables
such as the HW return temperature being kept invariant).
This is a limitation of the model.
</p>
</html>"));
end HeatPumpGroup;
