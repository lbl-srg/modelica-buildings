within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block MultispeedFan_ConstantWaterFlowrate
  "Controller for fan coil system with constant water flow rates and variable speed fan"

  parameter Integer nSpe(
    final min=2) = 2
    "Number of fan speeds";

  parameter Real fanSpe[nSpe](
    final unit="s") = {0,1}
    "Fan speed values";

  parameter Real tSpe(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 180
    "Minimum amount of time for which calculated speed exceeds preset value for speed to be changed";

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for cooling mode"
    annotation (Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real kCoo(
    final unit="1",
    displayUnit="1")=1
    "Gain of controller for cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real TiCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for cooling mode"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller for heating mode"
    annotation (Dialog(group="Fan control parameters - Heating mode"));

  parameter Real kHea(
    final unit="1",
    displayUnit="1")=1
    "Gain of controller for heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode"));

  parameter Real TiHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.5
    "Time constant of integrator block for heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea(
    final unit="s",
    displayUnit="s",
    final quantity="Time")=0.1
    "Time constant of derivative block for heating mode"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Integer nRowOccSch = 4
    "Number of rows in the occupancy schedule table"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real tableOcc[nRowOccSch,2](
    final unit=fill("s",nRowOccSch,2),
    displayUnit=fill("s",nRowOccSch,2),
    final quantity=fill("Time",nRowOccSch,2)) = [0, 0; 6, 1; 18, 0; 24, 0]
    "Table matrix (time = first column) for the occupancy schedule"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real timeScaleOcc(
    final unit="s",
    displayUnit="s",
    final quantity="Time") = 3600
    "Time scale of first table column. Set to 3600 if time in table is in hours"
    annotation(Dialog(group="Occupancy schedule parameters"));

  parameter Real tDeaModOff(
    final unit="s",
    displayUnit="s",
    final quantity="Time",
    final min = 0) = 30
    "Time period for delay between switching from deadband mode to heating/cooling mode"
    annotation(Dialog(group="System parameters"));

  parameter Real dTHys(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference") = 0.2
    "Temperature difference used for enabling cooling and heating mode"
    annotation(Dialog(tab="Advanced"));

  parameter Real dFanSpe(
    final unit="1",
    displayUnit="1") = 0.05
    "Fan speed difference used for cycling fan speed"
    annotation(Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
    final unit="1",
    displayUnit="1")
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo(
    final unit="1",
    displayUnit="1")
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea(
    final unit="1",
    displayUnit="1")
    "Heating signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,0},{140,40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.TimeTable timTabOccSch(
    final table=tableOcc,
    final smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    final timeScale=timeScaleOcc)
    "Table with occupancy schedule for the zone"
    annotation (Placement(transformation(extent={{-120,-150},{-100,-130}})));

// protected
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if zone is in deadband mode and occupied"
    annotation (Placement(transformation(extent={{80,-124},{100,-104}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Check if zone is in deadband mode"
    annotation (Placement(transformation(extent={{52,-140},{72,-120}})));

  Buildings.Controls.OBC.CDL.Logical.Timer timFan(
    final t=tDeaModOff)
    "Time delay for switching on fan"
    annotation (Placement(transformation(extent={{40,-190},{60,-170}})));

  Buildings.Controls.OBC.CDL.Continuous.Greater gre[nSpe]
    "Check if calculated fan speed signal "
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fanSpeVal[nSpe](
    final k=fanSpe)
    "Fan speed values"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nSpe)
    "Replicate fan speed signal for staging"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSpe]
    "Find integer index based on calculated fan speed"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nSpe)
    "Find fan speed stage"
    annotation (Placement(transformation(extent={{30,-100},{50,-80}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor extIndSig(
    final nin=nSpe)
    "Find fan speed value based on calculated stage"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim[nSpe](
    final t=fill(tSpe, nSpe))
    "Ensure fan speed signal exceeds preset for a minimum time duration"
    annotation (Placement(transformation(extent={{90,-40},{110,-20}})));

  Buildings.Controls.OBC.CDL.Integers.AddParameter addPar(
    final p=1)
    "Add 1 to calculated stage to switch to next speed signal"
    annotation (Placement(transformation(extent={{60,-100},{80,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable cooling when zone temperature is higher than cooling setpoint"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Find difference between zone temperature and cooling setpoint"
    annotation (Placement(transformation(extent={{-100,60},{-80,80}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub1
    "Find difference between zone temperature and heating setpoint"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys2(
    final uLow=-dTHys,
    final uHigh=0)
    "Enable heating when zone temperature is lower than heating setpoint"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{0,30},{20,50}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{-4,-170},{16,-150}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{-66,-20},{-46,0}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{-66,-60},{-46,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{-36,-40},{-16,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Provide fan speed signal only when fan is enabled"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr[1](
    final t=fill(0.5, 1))
    "Check if zone is occupied"
    annotation (Placement(transformation(extent={{-50,-150},{-30,-130}})));

  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Enable fan in heating mode and cooling mode or when zone is occupied"
    annotation (Placement(transformation(extent={{100,-160},{120,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply mul
    "Pass non-zero signal only when fan is enabled"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea2
    "Convert Boolean to Real"
    annotation (Placement(transformation(extent={{60,0},{80,20}})));
equation
  connect(TZon,sub2. u1) annotation (Line(points={{-160,40},{-130,40},{-130,76},
          {-102,76}},
                    color={0,0,127}));

  connect(TCooSet,sub2. u2) annotation (Line(points={{-160,0},{-120,0},{-120,64},
          {-102,64}},color={0,0,127}));

  connect(sub2.y, hys1.u)
    annotation (Line(points={{-78,70},{-42,70}}, color={0,0,127}));

  connect(hys1.y, booToRea.u)
    annotation (Line(points={{-18,70},{-2,70}}, color={255,0,255}));

  connect(booToRea.y, yCoo) annotation (Line(points={{22,70},{100,70},{100,60},{
          160,60}}, color={0,0,127}));

  connect(sub1.y, hys2.u)
    annotation (Line(points={{-78,20},{-74,20},{-74,40},{-42,40}},
                                                 color={0,0,127}));

  connect(hys2.y, booToRea1.u)
    annotation (Line(points={{-18,40},{-2,40}}, color={255,0,255}));

  connect(TZon,sub1. u2) annotation (Line(points={{-160,40},{-130,40},{-130,14},
          {-102,14}},
                    color={0,0,127}));

  connect(THeaSet,sub1. u1) annotation (Line(points={{-160,-40},{-110,-40},{-110,
          26},{-102,26}},color={0,0,127}));

  connect(booToRea1.y, yHea)
    annotation (Line(points={{22,40},{92,40},{92,20},{160,20}},
                                                color={0,0,127}));

  connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-160},
          {-6,-160}},color={255,0,255}));

  connect(hys2.y, or2.u2) annotation (Line(points={{-18,40},{-14,40},{-14,-168},
          {-6,-168}},color={255,0,255}));

  connect(sub2.y, conPID.u_m) annotation (Line(points={{-78,70},{-72,70},{-72,
          -26},{-56,-26},{-56,-22}},
                                   color={0,0,127}));

  connect(sub1.y, conPID1.u_m) annotation (Line(points={{-78,20},{-74,20},{-74,
          -72},{-56,-72},{-56,-62}},
                                   color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{-78,-30},{-76,-30},{-76,
          -10},{-68,-10}},color={0,0,127}));

  connect(con.y, conPID1.u_s) annotation (Line(points={{-78,-30},{-76,-30},{-76,
          -50},{-68,-50}},color={0,0,127}));

  connect(conPID.y, add3.u1) annotation (Line(points={{-44,-10},{-40,-10},{-40,
          -24},{-38,-24}},
                     color={0,0,127}));

  connect(conPID1.y, add3.u2) annotation (Line(points={{-44,-50},{-40,-50},{-40,
          -36},{-38,-36}},color={0,0,127}));

  connect(gre.u1, reaScaRep.y)
    annotation (Line(points={{58,-30},{52,-30}}, color={0,0,127}));
  connect(fanSpeVal.y, gre.u2) annotation (Line(points={{42,-60},{54,-60},{54,-38},
          {58,-38}}, color={0,0,127}));
  connect(booToInt.y, mulSumInt.u[1:nSpe]) annotation (Line(points={{22,-90},{28,
          -90}},                                          color={255,127,0}));
  connect(fanSpeVal.y, extIndSig.u) annotation (Line(points={{42,-60},{68,-60}},
                             color={0,0,127}));
  connect(gre.y, tim.u)
    annotation (Line(points={{82,-30},{88,-30}}, color={255,0,255}));
  connect(tim.passed, booToInt.u) annotation (Line(points={{112,-38},{120,-38},{
          120,-44},{-4,-44},{-4,-90},{-2,-90}}, color={255,0,255}));
  connect(mulSumInt.y, addPar.u)
    annotation (Line(points={{52,-90},{58,-90}}, color={255,127,0}));
  connect(addPar.y, extIndSig.index) annotation (Line(points={{82,-90},{90,-90},
          {90,-76},{80,-76},{80,-72}},     color={255,127,0}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{132,-80},{160,-80}}, color={0,0,127}));
  connect(timTabOccSch.y, greThr.u)
    annotation (Line(points={{-98,-140},{-52,-140}}, color={0,0,127}));
  connect(or1.y, yFan) annotation (Line(points={{122,-150},{136,-150},{136,-120},
          {160,-120}}, color={255,0,255}));
  connect(greThr[1].y, or1.u1) annotation (Line(points={{-28,-140},{24,-140},{24,
          -150},{98,-150}}, color={255,0,255}));
  connect(extIndSig.y, swi.u3) annotation (Line(points={{92,-60},{100,-60},{100,
          -88},{108,-88}}, color={0,0,127}));
  connect(and2.y, swi.u2) annotation (Line(points={{102,-114},{106,-114},{106,-80},
          {108,-80}}, color={255,0,255}));
  connect(greThr[1].y, and2.u1) annotation (Line(points={{-28,-140},{24,-140},{24,
          -114},{78,-114}}, color={255,0,255}));
  connect(not1.y, and2.u2) annotation (Line(points={{74,-130},{76,-130},{76,-122},
          {78,-122}}, color={255,0,255}));
  connect(or2.y, timFan.u) annotation (Line(points={{18,-160},{20,-160},{20,-180},
          {38,-180}}, color={255,0,255}));
  connect(timFan.passed, or1.u2) annotation (Line(points={{62,-188},{90,-188},{90,
          -158},{98,-158}}, color={255,0,255}));
  connect(timFan.passed, not1.u) annotation (Line(points={{62,-188},{90,-188},{90,
          -158},{40,-158},{40,-130},{50,-130}}, color={255,0,255}));
  connect(mul.y, reaScaRep.u)
    annotation (Line(points={{22,-30},{28,-30}}, color={0,0,127}));
  connect(add3.y, mul.u2) annotation (Line(points={{-14,-30},{-6,-30},{-6,-36},
          {-2,-36}}, color={0,0,127}));
  connect(fanSpeVal[2].y, swi.u1) annotation (Line(points={{42,-60},{54,-60},{
          54,-72},{108,-72}}, color={0,0,127}));
  connect(booToRea2.y, mul.u1) annotation (Line(points={{82,10},{90,10},{90,-10},
          {-6,-10},{-6,-24},{-2,-24}}, color={0,0,127}));
  connect(or1.y, booToRea2.u) annotation (Line(points={{122,-150},{136,-150},{
          136,30},{50,30},{50,10},{58,10}}, color={255,0,255}));
  annotation (defaultComponentName="conMulSpeFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{100,140}},
          textString="%name",
          textColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-200},{140,100}})));
end MultispeedFan_ConstantWaterFlowrate;
