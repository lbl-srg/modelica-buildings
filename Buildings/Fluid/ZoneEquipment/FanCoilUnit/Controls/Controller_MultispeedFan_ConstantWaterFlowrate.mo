within Buildings.Fluid.ZoneEquipment.FanCoilUnit.Controls;
block Controller_MultispeedFan_ConstantWaterFlowrate
  "Controller for fan coil system with constant water flow rates and variable speed fan"

  parameter Integer nSpe(
    final min=2) = 2
    "Number of fan speeds";

  parameter Real fanSpe[nSpe](
    final unit="s") = {0,1}
    "Fan speed values";

  parameter Real tSpe = 180
    "Minimum amount of time for which calculated speed exceeds preset value for speed to be changed";

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeCoo=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real kCoo=1 "Gain of controller"
    annotation(Dialog(group="Fan control parameters - Cooling mode"));

  parameter Real TiCoo=0.5 "Time constant of integrator block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdCoo=0.1 "Time constant of derivative block"
    annotation(Dialog(group="Fan control parameters - Cooling mode",
      enable = controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeCoo == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter .Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeHea=Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation (Dialog(group="Fan control parameters - Heating mode"));

  parameter Real kHea=1 "Gain of controller"
    annotation(Dialog(group="Fan control parameters - Heating mode"));

  parameter Real TiHea=0.5 "Time constant of integrator block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  parameter Real TdHea=0.1 "Time constant of derivative block"
    annotation(Dialog(group="Fan control parameters - Heating mode",
      enable = controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerTypeHea == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

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

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TZon
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{-180,20},{-140,60}}),
        iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TCooSet
    "Zone cooling temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THeaSet
    "Zone heating temperature setpoint"
    annotation (Placement(transformation(extent={{-180,-60},{-140,-20}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan
    "Fan enable signal"
    annotation (Placement(transformation(extent={{140,-140},{180,-100}}),
      iconTransformation(extent={{100,-80},{140,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe
    "Fan speed signal"
    annotation (Placement(transformation(extent={{140,-100},{180,-60}}),
      iconTransformation(extent={{100,-40},{140,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yCoo
    "Cooling signal"
    annotation (Placement(transformation(extent={{140,40},{180,80}}),
      iconTransformation(extent={{100,40},{140,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHea
    "Heating signal"
    annotation (Placement(transformation(extent={{140,0},{180,40}}),
      iconTransformation(extent={{100,0},{140,40}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Greater gre[nSpe]
    "Check if calculated fan speed signal "
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant fanSpeVal[nSpe](
    final k=fanSpe)
    "Fan speed values"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(
    final nout=nSpe) "Replicate fan speed signal for staging"
    annotation (Placement(transformation(extent={{30,-40},{50,-20}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger booToInt[nSpe]
    "Find integer index based on calculated fan speed"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Integers.MultiSum mulSumInt(
    final nin=nSpe) "Find fan speed stage"
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
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1
    "Boolean to Real conversion"
    annotation (Placement(transformation(extent={{0,10},{20,30}})));

  Buildings.Controls.OBC.CDL.Logical.Or or2
    "Enable fan in heating mode and cooling mode"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID(
    final controllerType=controllerTypeCoo,
    final k=kCoo,
    final Ti=TiCoo,
    final Td=TdCoo,
    final reverseActing=false)
    "PI controller for fan speed in cooling mode"
    annotation (Placement(transformation(extent={{-40,-20},{-20,0}})));

  Buildings.Controls.OBC.CDL.Continuous.PID conPID1(
    final controllerType=controllerTypeHea,
    final k=kHea,
    final Ti=TiHea,
    final Td=TdHea,
    final reverseActing=false)
    "PI controller for fan speed in heating mode"
    annotation (Placement(transformation(extent={{-40,-60},{-20,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0)
    "Constant zero signal"
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add3
    "Pass sum of fan speed from heating and cooling controllers, one of which is always zero"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Provide fan speed signal only when fan is enabled"
    annotation (Placement(transformation(extent={{110,-90},{130,-70}})));

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
    annotation (Line(points={{-78,20},{-42,20}}, color={0,0,127}));

  connect(hys2.y, booToRea1.u)
    annotation (Line(points={{-18,20},{-2,20}}, color={255,0,255}));

  connect(TZon,sub1. u2) annotation (Line(points={{-160,40},{-130,40},{-130,14},
          {-102,14}},
                    color={0,0,127}));

  connect(THeaSet,sub1. u1) annotation (Line(points={{-160,-40},{-110,-40},{-110,
          26},{-102,26}},color={0,0,127}));

  connect(booToRea1.y, yHea)
    annotation (Line(points={{22,20},{160,20}}, color={0,0,127}));

  connect(hys1.y, or2.u1) annotation (Line(points={{-18,70},{-10,70},{-10,-120},
          {58,-120}},color={255,0,255}));

  connect(hys2.y, or2.u2) annotation (Line(points={{-18,20},{-14,20},{-14,-128},
          {58,-128}},color={255,0,255}));

  connect(or2.y, yFan)
    annotation (Line(points={{82,-120},{160,-120}},
                                                  color={255,0,255}));

  connect(sub2.y, conPID.u_m) annotation (Line(points={{-78,70},{-70,70},{-70,-26},
          {-30,-26},{-30,-22}},    color={0,0,127}));

  connect(sub1.y, conPID1.u_m) annotation (Line(points={{-78,20},{-60,20},{-60,-68},
          {-30,-68},{-30,-62}},    color={0,0,127}));

  connect(con.y, conPID.u_s) annotation (Line(points={{-78,-30},{-46,-30},{-46,-10},
          {-42,-10}},     color={0,0,127}));

  connect(con.y, conPID1.u_s) annotation (Line(points={{-78,-30},{-46,-30},{-46,
          -50},{-42,-50}},color={0,0,127}));

  connect(conPID.y, add3.u1) annotation (Line(points={{-18,-10},{-6,-10},{-6,-24},
          {-2,-24}}, color={0,0,127}));

  connect(conPID1.y, add3.u2) annotation (Line(points={{-18,-50},{-6,-50},{-6,-36},
          {-2,-36}},      color={0,0,127}));

  connect(gre.u1, reaScaRep.y)
    annotation (Line(points={{58,-30},{52,-30}}, color={0,0,127}));
  connect(add3.y, reaScaRep.u)
    annotation (Line(points={{22,-30},{28,-30}}, color={0,0,127}));
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
  connect(or2.y, swi.u2) annotation (Line(points={{82,-120},{100,-120},{100,-80},
          {108,-80}}, color={255,0,255}));
  connect(extIndSig.y, swi.u1) annotation (Line(points={{92,-60},{100,-60},{100,
          -72},{108,-72}}, color={0,0,127}));
  connect(con.y, swi.u3) annotation (Line(points={{-78,-30},{-46,-30},{-46,-104},
          {104,-104},{104,-88},{108,-88}}, color={0,0,127}));
  annotation (defaultComponentName="conMulSpeFanConWat",
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
                                                      graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end Controller_MultispeedFan_ConstantWaterFlowrate;
