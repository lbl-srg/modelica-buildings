within Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPlay "Play hysteresis controller with limited output"
  extends Modelica.Blocks.Icons.Block;

  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=
    Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller (P or PI)"
    annotation(choices(
     choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
     choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
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
      controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real hys
    "Hysteresis (full width, absolute value)";
  parameter Boolean reverseActing = false
    "Set to true for control output increasing with decreasing measurement value";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-180,-20},{-140,20}}),
      iconTransformation(extent={{-140,-20}, {-100,20}})));
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
    final reverseActing=reverseActing)
    "Controller with high offset set-point"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conLow(
    controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing)
    "Controller with low offset set-point"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysBlo(
    final uLow=2*yMin + Modelica.Constants.eps,
    final uHigh=2*yMax - Modelica.Constants.eps)
    "Hysteresis"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addHig(
    final p=hys / 2,
    final k=1)
    "Positive set-point offset"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addLow(
    final p=-hys / 2,
    final k=1)
    "Negative set-point offset"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between high and low controller"
    annotation (Placement(transformation(extent={{110,10},{130,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Minimum value of controller outputs"
    annotation (Placement(transformation(extent={{-40,-30},{-20,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum value of controller outputs"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Sum of min and max values of controller outputs"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{70,-11},{90,11}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(k=reverseActing)
    "True if reverse acting"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cheYMinMax(final k=yMin
         < yMax)
    "Check for values of yMin and yMax"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesYMinMax(message=
        "LimPID: Limits must be yMin < yMax")
    "Assertion on yMin and yMax"
    annotation (Placement(transformation(extent={{100,-120},{120,-100}})));
equation
  connect(conLow.y, swi.u1) annotation (Line(points={{-68,-40},{100,-40},{100,
          -8},{108,-8}},
                     color={0,0,127}));
  connect(conHig.y, swi.u3) annotation (Line(points={{-68,40},{100,40},{100,8},
          {108,8}},color={0,0,127}));
  connect(conHig.y, max1.u1) annotation (Line(points={{-68,40},{-50,40},{-50,26},
          {-42,26}},color={0,0,127}));
  connect(conLow.y, max1.u2) annotation (Line(points={{-68,-40},{-46,-40},{-46,
          14},{-42,14}},
                    color={0,0,127}));
  connect(conHig.y, min1.u1) annotation (Line(points={{-68,40},{-50,40},{-50,
          -14},{-42,-14}},
                     color={0,0,127}));
  connect(conLow.y, min1.u2) annotation (Line(points={{-68,-40},{-46,-40},{-46,
          -26},{-42,-26}},
                     color={0,0,127}));
  connect(max1.y, add2.u1)
    annotation (Line(points={{-18,20},{-16,20},{-16,6},{-12,6}},
                                                             color={0,0,127}));
  connect(min1.y, add2.u2) annotation (Line(points={{-18,-20},{-16,-20},{-16,-6},
          {-12,-6}},
                color={0,0,127}));
  connect(add2.y, hysBlo.u)
    annotation (Line(points={{12,0},{18,0}}, color={0,0,127}));
  connect(addHig.y, conHig.u_s)
    annotation (Line(points={{-98,40},{-92,40}}, color={0,0,127}));
  connect(addLow.y, conLow.u_s)
    annotation (Line(points={{-98,-40},{-92,-40}}, color={0,0,127}));
  connect(u_s, addHig.u) annotation (Line(points={{-160,0},{-130,0},{-130,40},{
          -122,40}},
                color={0,0,127}));
  connect(u_s, addLow.u) annotation (Line(points={{-160,0},{-130,0},{-130,-40},
          {-122,-40}},color={0,0,127}));
  connect(u_m, conLow.u_m) annotation (Line(points={{0,-160},{0,-80},{-80,-80},
          {-80,-52}},color={0,0,127}));
  connect(u_m, conHig.u_m) annotation (Line(points={{0,-160},{0,-80},{-60,-80},
          {-60,20},{-80,20},{-80,28}},color={0,0,127}));
  connect(swi.y, y)
    annotation (Line(points={{132,0},{160,0}}, color={0,0,127}));
  connect(swi.u2, logSwi.y)
    annotation (Line(points={{108,0},{92,0}},  color={255,0,255}));
  connect(hysBlo.y, logSwi.u3) annotation (Line(points={{42,0},{50,0},{50,-8.8},
          {68,-8.8}}, color={255,0,255}));
  connect(hysBlo.y, not1.u)
    annotation (Line(points={{42,0},{50,0},{50,60},{58,60}},
                                                      color={255,0,255}));
  connect(not1.y, logSwi.u1) annotation (Line(points={{82,60},{120,60},{120,20},
          {60,20},{60,8.8},{68,8.8}}, color={255,0,255}));
  connect(con.y, logSwi.u2) annotation (Line(points={{42,-60},{60,-60},{60,0},{
          68,0}}, color={255,0,255}));
  connect(cheYMinMax.y,assMesYMinMax. u)
    annotation (Line(points={{82,-110},{98,-110}},   color={255,0,255}));
  annotation (defaultComponentName="conPla",
  Icon(coordinateSystem(preserveAspectRatio=false)),
  Diagram(
    coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(
revisions="<html>
<ul>
<li>
July xx, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>", info="<html>
<p>
This is a controller composed of two P or PI controllers and a hysteresis block.
The width of the hysteresis <code>hys</code>, together with the set point input 
signal <code>u_s</code> defines the set point tracked by each controller.
</p>
<ul>
<li>
The \"low\" controller tracks <code>u_s - hys / 2</code>.
</li>
<li>
The \"high\" controller tracks <code>u_s + hys / 2</code>.
</li>
</ul>
<p>
The output of the main controller depends on the hysteresis operator applied to the
outputs of the high and low controllers.
</p>
<ul>
<li>
When the two outputs reach their maximum value, the output is equal to the
low controller output.
</li>
<li>
When the two outputs reach their minimum value, the output is equal to the
right controller output.
</li>
<li>
In between, the output is equal to the output of the previously active controller.
</li>
<li>
This logic is illustrated below and is reversed if <code>reverseActing</code> is true.
</li>
</ul>
<p>
<img alt=\"Sequence chart\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/Combined/Generation5/Controls/LimPlay.png\"/>
</p>
<p>
See
<a href=\"modelica://Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlay\">
Buildings.Applications.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlay</a>
for an illustration of the control response.
</p>
</html>"));
end LimPlay;
