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
    annotation (Placement(transformation(extent={{-140,40},
            {-100,80}}), iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput y(
    final unit="1", final min=0)
    "Cooling tower speed (common to all tower cells)"
    annotation (Placement(
        transformation(extent={{-140,-80},{-100,-40}}), iconTransformation(
          extent={{-140,-80},{-100,-40}})));
  BoundaryConditions.WeatherData.Bus weaBus
    "Bus with weather data"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}}),
        iconTransformation(extent={{-20,80},{20,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput P(final unit="W")
    "Power drawn by tower fans"
    annotation (Placement(transformation(extent={{100,80},{140,120}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSup(
    final unit="K", displayUnit="degC")
    "CW supply temperature (tower leaving)"
    annotation (Placement(
        transformation(extent={{100,40},{140,80}}), iconTransformation(extent={{100,20},
            {140,60}})));

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
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulP "Scale power"
    annotation (Placement(transformation(extent={{70,110},{90,90}})));

  Fluid.HeatExchangers.CoolingTowers.Merkel coo(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mConWatUni_flow_nominal,
    final dp_nominal=dpConWatFriUni_nominal,
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

equation
  connect(mulConOut.uInv, mulConInl.u) annotation (Line(points={{82,6},{86,6},{86,
          -20},{-86,-20},{-86,6},{-82,6}},     color={0,0,127}));
  connect(y1, com.y1) annotation (Line(points={{-120,60},{-94,60},{-94,60},{-92,
          60}},  color={255,0,255}));
  connect(com.nUniOn, mulP.u2) annotation (Line(points={{-68,60},{18,60},{18,
          106},{68,106}},   color={0,0,127}));

  connect(mulP.y, P)
    annotation (Line(points={{92,100},{120,100}},
                                                color={0,0,127}));
  connect(com.nUniOnBou, mulConOut.u) annotation (Line(points={{-68,54},{16,54},
          {16,6},{58,6}},        color={0,0,127}));
  connect(mulConOut.port_b, port_b)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, mulConInl.port_a)
    annotation (Line(points={{-100,0},{-80,0}}, color={0,127,255}));
  connect(mulConInl.port_b, coo.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(coo.port_b, mulConOut.port_a)
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
    annotation (Line(points={{11,8},{20,8},{20,94},{68,94}}, color={0,0,127}));
  connect(y, coo.y) annotation (Line(points={{-120,-60},{-40,-60},{-40,8},{-12,8}},
        color={0,0,127}));
  connect(coo.TLvg, TConWatSup) annotation (Line(points={{11,-6},{40,-6},{40,60},
          {120,60}}, color={0,0,127}));
  annotation (
    defaultComponentName="coo",
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
end CoolingTowerGroup;
