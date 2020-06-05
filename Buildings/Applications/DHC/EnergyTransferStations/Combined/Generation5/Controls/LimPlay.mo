within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPlay "Play hysteresis controller with limited output"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller";
  parameter Real yMax = 1
    "Upper limit of output";
  parameter Real yMin = 0
    "Lower limit of output";
  parameter Real k(min=0) = 1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small) = 0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(enable=
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
      controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real uLow
    "Low set-point offset";
  parameter Real uHigh
    "High set-point offset";
  parameter Boolean reverseActing = false
    "Set to true for control output decreasing with measurement value";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal" annotation (Placement(transformation(
          extent={{-180,-20},{-140,20}}), iconTransformation(extent={{-140,-20},
            {-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-160}, extent={{20,-20},{-20,20}},
      rotation=270), iconTransformation(extent={{20,-20},{-20,20}},
        rotation=270, origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{140,-20},{180,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Continuous.LimPID conHig(
    final controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseAction=not reverseActing) "Controller with high offset set-point"
    annotation (Placement(transformation(extent={{-50,30},{-30,50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conLow(
    controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final reverseAction=not reverseActing) "Controller with low offset set-point"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(final uLow=2*yMin +
        Modelica.Constants.eps, final uHigh=2*yMax - Modelica.Constants.eps)
    "Hysteresis"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addHig(p=uHigh, k=1)
    "Add high offset"
    annotation (Placement(transformation(extent={{-100,30},{-80,50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addLow(p=uLow, k=1)
    "Add low offset"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    annotation (Placement(transformation(extent={{110,10},{130,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    annotation (Placement(transformation(extent={{0,-30},{20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    annotation (Placement(transformation(extent={{0,10},{20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
equation
  connect(hys.y, swi.u2)
    annotation (Line(points={{92,0},{108,0}}, color={255,0,255}));
  connect(conLow.y, swi.u1) annotation (Line(points={{-28,-40},{100,-40},{100,-8},
          {108,-8}}, color={0,0,127}));
  connect(conHig.y, swi.u3) annotation (Line(points={{-28,40},{100,40},{100,8},{
          108,8}}, color={0,0,127}));
  connect(conHig.y, max1.u1) annotation (Line(points={{-28,40},{-20,40},{-20,26},
          {-2,26}}, color={0,0,127}));
  connect(conLow.y, max1.u2) annotation (Line(points={{-28,-40},{-10,-40},{-10,14},
          {-2,14}}, color={0,0,127}));
  connect(conHig.y, min1.u1) annotation (Line(points={{-28,40},{-20,40},{-20,-14},
          {-2,-14}}, color={0,0,127}));
  connect(conLow.y, min1.u2) annotation (Line(points={{-28,-40},{-10,-40},{-10,-26},
          {-2,-26}}, color={0,0,127}));
  connect(max1.y, add2.u1)
    annotation (Line(points={{22,20},{30,20},{30,6},{38,6}}, color={0,0,127}));
  connect(min1.y, add2.u2) annotation (Line(points={{22,-20},{30,-20},{30,-6},{38,
          -6}}, color={0,0,127}));
  connect(add2.y, hys.u)
    annotation (Line(points={{62,0},{68,0}}, color={0,0,127}));
  connect(addHig.y, conHig.u_s)
    annotation (Line(points={{-78,40},{-52,40}}, color={0,0,127}));
  connect(addLow.y, conLow.u_s)
    annotation (Line(points={{-78,-40},{-52,-40}}, color={0,0,127}));
  connect(u_s, addHig.u) annotation (Line(points={{-160,0},{-120,0},{-120,40},{-102,
          40}}, color={0,0,127}));
  connect(u_s, addLow.u) annotation (Line(points={{-160,0},{-120,0},{-120,-40},{
          -102,-40}}, color={0,0,127}));
  connect(u_m, conLow.u_m) annotation (Line(points={{0,-160},{0,-80},{-40,-80},{
          -40,-52}}, color={0,0,127}));
  connect(u_m, conHig.u_m) annotation (Line(points={{0,-160},{0,-80},{-60,-80},{
          -60,20},{-40,20},{-40,28}}, color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{132,0},{160,0}}, color={0,0,127}));
  annotation (defaultComponentName="conPla",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})));
end LimPlay;
