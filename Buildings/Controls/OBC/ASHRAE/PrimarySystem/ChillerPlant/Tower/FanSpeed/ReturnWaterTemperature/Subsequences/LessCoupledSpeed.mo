within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Tower.FanSpeed.ReturnWaterTemperature.Subsequences;
block LessCoupledSpeed
    "Sequence of defining cooling tower fan speed when the plant is not close coupled"

  parameter Integer nChi = 2 "Total number of chillers";
  parameter Integer nConWatPum = 2 "Total number of condenser water pumps";
  parameter Modelica.SIunits.TemperatureDifference desTemDif = 8
    "Design condenser water temperature difference";
  parameter Real pumSpeChe = 0.005
    "Lower threshold value to check if condenser water pump is proven on";
  parameter Real minTowSpe = 0.1
    "Minimum cooling tower fan speed";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController retWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real kRetCon=1 "Gain of controller"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Modelica.SIunits.Time TiRetCon=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Modelica.SIunits.Time TdRetCon=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Return water temperature controller", enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yRetConMax=1 "Upper limit of output"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Real yRetConMin=0 "Lower limit of output"
    annotation (Dialog(group="Return water temperature controller"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController supWatCon=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real kSupCon=1 "Gain of controller"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Modelica.SIunits.Time TiSupCon=0.5 "Time constant of integrator block"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Modelica.SIunits.Time TdSupCon=0.1 "Time constant of derivative block"
    annotation (Dialog(group="Supply water temperature controller", enable=
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
          controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real ySupConMax=1 "Upper limit of output"
    annotation (Dialog(group="Supply water temperature controller"));
  parameter Real ySupConMin=0 "Lower limit of output"
    annotation (Dialog(group="Supply water temperature controller"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRetSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-140,90},{-100,130}}),
      iconTransformation(extent={{-140,80},{-100,120}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water return temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uConWatPumSpe[nConWatPum](
    each final min=0,
    each final max=1,
    each final unit="1") "Current condenser water pump speed"
    annotation (Placement(transformation(extent={{-140,0},{-100,40}}),
      iconTransformation(extent={{-140,0},{-100,40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature"
    annotation (Placement(transformation(extent={{-140,-110},{-100,-70}}),
      iconTransformation(extent={{-140,-40},{-100,0}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMaxTowSpeSet[nChi](
    each final min=0,
    each final max=1,
    each final unit="1")
    "Maximum cooling tower speed setpoint from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-140,-140},{-100,-100}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput plrTowMaxSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Tower maximum speed that reset based on plant partial load ratio"
    annotation (Placement(transformation(extent={{-140,-170},{-100,-130}}),
      iconTransformation(extent={{-140,-120},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TConWatSupSet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{100,90},{140,130}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yTowSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{100,-140},{140,-100}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=-2*5/9, final k=1)
    "Condenser water return temperature setpoint minus 2 degF"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar1(
    final p=-desTemDif, final k=1)
    "Condenser water return temperature setpoint minus design condenser water temperature difference"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis proOn[nConWatPum](
    each final uLow=pumSpeChe,
    each final uHigh=pumSpeChe + 0.005)
    "Check if the condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr anyProOn(final nu=nConWatPum)
    "Check if there is any condenser water pump is proven on"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=retWatCon,
    final k=kRetCon,
    final Ti=TiRetCon,
    final Td=TdRetCon,
    final yMax=yRetConMax,
    final yMin=yRetConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=0.5)  "Condenser water return temperature controller"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  Buildings.Controls.OBC.CDL.Logical.Not noProOn
    "No condenser water pump is proven on "
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Line supTemSet
    "Condenser water supply temperature setpoint"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(final k=0) "Zero constant"
    annotation (Placement(transformation(extent={{0,130},{20,150}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1) "Constant one"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID1(
    final controllerType=supWatCon,
    final k=kSupCon,
    final Ti=TiSupCon,
    final Td=TdSupCon,
    final yMax=ySupConMax,
    final yMin=ySupConMin,
    final reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    final y_reset=ySupConMin) "Condenser water supply temperature controller"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant  minSpe(
    final k=minTowSpe) "Minimum tower speed"
    annotation (Placement(transformation(extent={{-60,-40},{-40,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer1(final k=0)
    "Zero constant"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one1(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.Line CWSTSpd
    "Fan speed calculated based on supply water temperature control"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin maxSpe(final nin=nChi)
    "Lowest value of the maximum cooling tower speed from each chiller head pressure control loop"
    annotation (Placement(transformation(extent={{-80,-130},{-60,-110}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiMin fanSpe(final nin=3)
    "Cooling tower fan speed"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

equation
  connect(proOn.y,anyProOn. u)
    annotation (Line(points={{-58,20},{-42,20}},   color={255,0,255}));
  connect(anyProOn.y,noProOn. u)
    annotation (Line(points={{-18,20},{-2,20}},     color={255,0,255}));
  connect(TConWatRetSet, conPID.u_s)
    annotation (Line(points={{-120,110},{-62,110}}, color={0,0,127}));
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-120,80},{-50,80},{-50,98}}, color={0,0,127}));
  connect(TConWatRetSet, addPar1.u) annotation (Line(points={{-120,110},{-80,110},
          {-80,60},{-22,60}}, color={0,0,127}));
  connect(zer.y, supTemSet.x1) annotation (Line(points={{22,140},{40,140},{40,
          118},{58,118}},
                     color={0,0,127}));
  connect(TConWatRetSet, addPar.u) annotation (Line(points={{-120,110},{-80,110},
          {-80,140},{-62,140}}, color={0,0,127}));
  connect(addPar.y, supTemSet.f1) annotation (Line(points={{-38,140},{-20,140},
          {-20,114},{58,114}},color={0,0,127}));
  connect(conPID.y, supTemSet.u)
    annotation (Line(points={{-38,110},{58,110}}, color={0,0,127}));
  connect(one.y, supTemSet.x2) annotation (Line(points={{2,90},{20,90},{20,106},
          {58,106}}, color={0,0,127}));
  connect(addPar1.y, supTemSet.f2) annotation (Line(points={{2,60},{40,60},{40,
          102},{58,102}},
                     color={0,0,127}));
  connect(uConWatPumSpe, proOn.u)
    annotation (Line(points={{-120,20},{-82,20}}, color={0,0,127}));
  connect(noProOn.y, conPID.trigger) annotation (Line(points={{22,20},{40,20},{
          40,40},{-58,40},{-58,98}},
                                  color={255,0,255}));
  connect(supTemSet.y, conPID1.u_s) annotation (Line(points={{82,110},{90,110},
          {90,-10},{-80,-10},{-80,-60},{-62,-60}},color={0,0,127}));
  connect(zer1.y, CWSTSpd.x1) annotation (Line(points={{22,-30},{40,-30},{40,
          -52},{58,-52}},
                     color={0,0,127}));
  connect(minSpe.y, CWSTSpd.f1) annotation (Line(points={{-38,-30},{-20,-30},{
          -20,-56},{58,-56}},
                          color={0,0,127}));
  connect(conPID1.y, CWSTSpd.u)
    annotation (Line(points={{-38,-60},{58,-60}}, color={0,0,127}));
  connect(TConWatSup, conPID1.u_m) annotation (Line(points={{-120,-90},{-50,-90},
          {-50,-72}}, color={0,0,127}));
  connect(noProOn.y, conPID1.trigger) annotation (Line(points={{22,20},{40,20},
          {40,0},{-90,0},{-90,-80},{-58,-80},{-58,-72}},  color={255,0,255}));
  connect(one1.y, CWSTSpd.x2) annotation (Line(points={{22,-80},{40,-80},{40,
          -64},{58,-64}},
                     color={0,0,127}));
  connect(one1.y, CWSTSpd.f2) annotation (Line(points={{22,-80},{40,-80},{40,
          -68},{58,-68}},
                     color={0,0,127}));
  connect(uMaxTowSpeSet,maxSpe. u)
    annotation (Line(points={{-120,-120},{-82,-120}},
                                                    color={0,0,127}));
  connect(CWSTSpd.y, fanSpe.u[1]) annotation (Line(points={{82,-60},{90,-60},{
          90,-90},{40,-90},{40,-118.667},{58,-118.667}},
                                                      color={0,0,127}));
  connect(maxSpe.y, fanSpe.u[2])
    annotation (Line(points={{-58,-120},{58,-120}}, color={0,0,127}));
  connect(plrTowMaxSpe, fanSpe.u[3]) annotation (Line(points={{-120,-150},{40,
          -150},{40,-121.333},{58,-121.333}},
                                        color={0,0,127}));
  connect(fanSpe.y, yTowSpe)
    annotation (Line(points={{82,-120},{120,-120}}, color={0,0,127}));
  connect(supTemSet.y, TConWatSupSet)
    annotation (Line(points={{82,110},{120,110}}, color={0,0,127}));

annotation (
  defaultComponentName="lesCouTowSpe",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-160},{100,160}})),
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
end LessCoupledSpeed;
