within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block CoupledSpeed
  "Sequence of defining cooling tower fan speed when the plant is close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Real minTowSpe = 0.1 "Minimum cooling tower fan speed";
  parameter Real pumSpeChe = 0.005
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Controller"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Ti=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Controller"));
  parameter Modelica.SIunits.Time Td=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Controller", enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(group="Controller"));
  parameter Real yMin=0 "Lower limit of output"
    annotation (Dialog(group="Controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRetSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,-10},{-100,30}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    each final min=0,
    each final max=1,
    each final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,-40},{-100,0}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1") "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yMax,
    final yMin=yMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=yMin) "Condenser water return temperature controller"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minSpe(
    final k=minTowSpe) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Line CWRTSpd
    "Fan speed calculated based on return water temperature control loop"
    annotation (Placement(transformation(extent={{60,30},{80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(k=1) "Constant one"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis proOn[nConWatPum](
    each final uLow=pumSpeChe,
    each final uHigh=pumSpeChe + 0.005)
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(final nu=nConWatPum)
    "Check if there is any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Logical.Not noProOn
    "No condenser water pump is proven on "
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin maxSpe(final nin=nChi)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

equation
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-120,10},{-50,10},{-50,28}}, color={0,0,127}));
  connect(TConWatRetSet, conPID.u_s)
    annotation (Line(points={{-120,40},{-62,40}}, color={0,0,127}));
  connect(conPID.y, CWRTSpd.u)
    annotation (Line(points={{-38,40},{58,40}}, color={0,0,127}));
  connect(zer.y, CWRTSpd.x1) annotation (Line(points={{22,80},{40,80},{40,48},{
          58,48}},
                color={0,0,127}));
  connect(minSpe.y, CWRTSpd.f1) annotation (Line(points={{-38,80},{-20,80},{-20,
          44},{58,44}}, color={0,0,127}));
  connect(one.y, CWRTSpd.x2) annotation (Line(points={{22,20},{40,20},{40,36},{
          58,36}},
                color={0,0,127}));
  connect(one.y, CWRTSpd.f2) annotation (Line(points={{22,20},{40,20},{40,32},{
          58,32}},
                color={0,0,127}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-120,-20},{-82,-20}}, color={0,0,127}));
  connect(anyProOn.y, noProOn.u)
    annotation (Line(points={{-18,-20},{-2,-20}},   color={255,0,255}));
  connect(noProOn.y, conPID.trigger)
    annotation (Line(points={{22,-20},{40,-20},{40,0},{-58,0},{-58,28}},
      color={255,0,255}));
  connect(proOn.y, anyProOn.u)
    annotation (Line(points={{-58,-20},{-42,-20}}, color={255,0,255}));
  connect(CWRTSpd.y, fanSpe.u[1]) annotation (Line(points={{82,40},{90,40},{90,
          -40},{40,-40},{40,-58.6667},{58,-58.6667}},
                                                 color={0,0,127}));
  connect(fanSpe.y, yTowSpe)
    annotation (Line(points={{82,-60},{120,-60}}, color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{-58,-60},{58,-60}}, color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3])
    annotation (Line(points={{-120,-90},{40,-90},{40,-61.3333},{58,-61.3333}},
      color={0,0,127}));
  connect(uMaxTowSpeSet, maxSpe.u)
    annotation (Line(points={{-120,-60},{-82,-60}}, color={0,0,127}));

annotation (
  defaultComponentName="couTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false)),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}));
end CoupledSpeed;
