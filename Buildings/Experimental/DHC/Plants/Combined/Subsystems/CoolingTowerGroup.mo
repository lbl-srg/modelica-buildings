within Buildings.Experimental.DHC.Plants.Combined.Subsystems;
model CoolingTowerGroup "Model of multiple identical cooling towers in parallel"
  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface(
    final m_flow_nominal(final min=Modelica.Constants.small)=mConWat_flow_nominal);

  parameter Integer nUni(final min=1, start=1)
    "Number of units operating at design conditions"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mConWatUni_flow_nominal(
    final min=0)
    "CW design mass flow rate (each unit)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate mConWat_flow_nominal(
    final min=0)=nUni * mConWatUni_flow_nominal
    "CW design mass flow rate (all units)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpConWatFriUni_nominal(
      displayUnit="Pa")
    "CW flow-friction losses through tower and piping only (without elevation head or valve)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.MassFlowRate mAirUni_flow_nominal(
    final min=0,
    start=mConWatUni_flow_nominal / 1.45)
    "Air mass flow rate (each unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TWetBulEnt_nominal(
    final min=273.15)
    "Entering air wetbulb temperature"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatRet_nominal(
    final min=273.15)
    "CW return temperature (tower entering)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Temperature TConWatSup_nominal(
    final min=273.15)
    "CW supply temperature (tower leaving)"
    annotation (Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.Power PFanUni_nominal(
    final min=0,
    start=340 * mConWatUni_flow_nominal)
    "Fan power (each unit)"
    annotation (Dialog(group="Nominal condition"));
  parameter Real yFan_min(unit="1")=0.1
    "CT fan minimum speed";

  // Assumptions
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  parameter Modelica.Units.SI.Time tau=30
    "Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(
      tab="Dynamics",
      group="Nominal condition",
      enable=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    "Cooling tower Start command"
    annotation (Placement(transformation(extent={{-140,80},{-100,120}}),
                         iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    final unit="1", final min=0)
    "Cooling tower speed (common to all tower cells)"
    annotation (Placement(
        transformation(extent={{-140,40},{-100,80}}),   iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{-20,80},{20,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
    "Power drawn by tower fans"
    annotation (Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSup(
    final unit="K", displayUnit="degC")
    "CW supply temperature (tower leaving)"
    annotation (Placement(
        transformation(extent={{100,20},{140,60}}), iconTransformation(extent={{100,20},
            {140,60}})));

  Fluid.BaseClasses.MassFlowRateMultiplier mulInl(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_input=false,
    final k=1/nUni)       "Flow rate multiplier"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Fluid.BaseClasses.MassFlowRateMultiplier mulOut(
    redeclare final package Medium = Medium,
    final allowFlowReversal=allowFlowReversal,
    final use_input=false,
    final k=nUni)         "Flow rate multiplier"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
  BaseClasses.MultipleCommands com(final nUni=nUni)
    "Convert command signals"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale power"
    annotation (Placement(transformation(extent={{60,90},{80,70}})));

  Fluid.HeatExchangers.CoolingTowers.Merkel coo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatUni_flow_nominal,
    final dp_nominal=dpConWatFriUni_nominal,
    final yMin=yFan_min,
    final ratWatAir_nominal=mConWatUni_flow_nominal/mAirUni_flow_nominal,
    final TAirInWB_nominal=TWetBulEnt_nominal,
    final TWatIn_nominal=TConWatRet_nominal,
    final TWatOut_nominal=TConWatSup_nominal,
    final PFan_nominal=PFanUni_nominal,
    final tau=tau,
    final allowFlowReversal=allowFlowReversal,
    final show_T=show_T,
    final energyDynamics=energyDynamics)
    "Cooling tower"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre preY1[nUni]
    "Left limit of signal avoiding direct feedback of status to controller"
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert to real"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-14,80})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply inp
    "Compute pump input signal"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={-20,30})));
equation
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-38,100},{40,100},{40,
          86},{58,86}},     color={0,0,127}));

  connect(mulP.y, P)
    annotation (Line(points={{82,80},{120,80}}, color={0,0,127}));
  connect(mulOut.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(mulInl.port_b, coo.port_a)
    annotation (Line(points={{-60,0},{-10,0}},
                                             color={0,127,255}));
  connect(coo.port_b, mulOut.port_a)
    annotation (Line(points={{10,0},{60,0}}, color={0,127,255}));
  connect(weaBus.TWetBul, coo.TAir) annotation (Line(
      points={{100,-40},{-20,-40},{-20,4},{-12,4}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(coo.PFan, mulP.u1)
    annotation (Line(points={{11,8},{40,8},{40,74},{58,74}}, color={0,0,127}));
  connect(coo.TLvg, TConWatSup) annotation (Line(points={{11,-6},{50,-6},{50,40},
          {120,40}}, color={0,0,127}));
  connect(y1, preY1.u)
    annotation (Line(points={{-120,100},{-92,100}},
                                                  color={255,0,255}));
  connect(preY1.y, com.y1)
    annotation (Line(points={{-68,100},{-62,100}},
                                                 color={255,0,255}));
  connect(com.y1One, booToRea.u) annotation (Line(points={{-38,106},{-14,106},{
          -14,92}}, color={255,0,255}));
  connect(inp.y, coo.y)
    annotation (Line(points={{-20,18},{-20,8},{-12,8}}, color={0,0,127}));
  connect(y, inp.u1)
    annotation (Line(points={{-120,60},{-26,60},{-26,42}}, color={0,0,127}));
  connect(booToRea.y, inp.u2)
    annotation (Line(points={{-14,68},{-14,42}}, color={0,0,127}));
  connect(port_a, mulInl.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  annotation (
    defaultComponentName="coo",
    Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,80},{70,-80}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Text(
         extent={{190,-12},{70,-62}},
          textColor={0,0,0},
          textString=DynamicSelect("", String(TLvg-273.15, format=".1f"))),
        Ellipse(
          extent={{-54,56},{0,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,56},{54,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{0,56},{54,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-54,56},{0,44}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-120},{100,120}})),
    Documentation(info="<html>
<p>
This model represents a set of identical cooling towers
that are piped in parallel.
No actuated isolation valves are included.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>
Start command (VFD Run) <code>y1</code>: 
DO signal dedicated to each unit, with a dimensionality of one
</li>
<li>
Speed command <code>y</code>:
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
<a href=\"modelica://Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel\">
Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel</a>.
Hydronics are resolved with mass flow rate multiplier components.
Note that the elevation head of open-circuit cooling towers is not modeled,
which is an inherent limitation of the cooling tower component model.
</p>
<p>
The fan cycling On and Off is implicitly modeled
in the cooling tower component which uses a low limit of the control signal
to switch to a free convection regime at zero fan power.
</p>
</html>"));
end CoolingTowerGroup;
