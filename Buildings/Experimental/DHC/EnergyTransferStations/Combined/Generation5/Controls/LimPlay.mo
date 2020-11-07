within Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls;
block LimPlay
  "Play hysteresis controller with limited output"
  extends Modelica.Blocks.Icons.Block;
  parameter Boolean have_enaSig=false
    "Set to true for conditionnally enabled controller"
    annotation (Evaluate=true);
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P
    "Type of controller (P or PI)"
    annotation (choices(choice=Buildings.Controls.OBC.CDL.Types.SimpleController.P,choice=Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real yMax=1
    "Upper limit of output";
  parameter Real yMin=0
    "Lower limit of output";
  parameter Real k(
    min=0)=1
    "Gain of controller";
  parameter Modelica.SIunits.Time Ti(
    min=Buildings.Controls.OBC.CDL.Constants.small)=0.5
    "Time constant of integrator block"
    annotation (Dialog(enable=controllerType == Buildings.Controls.OBC.CDL.Types.SimpleController.PI));
  parameter Real hys
    "Hysteresis (full width, absolute value)";
  parameter Boolean reverseActing=false
    "Set to true for control output increasing with decreasing measurement value";
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uEna if have_enaSig
    "Enable signal"
    annotation (Placement(transformation(extent={{-20,-20},{20,20}},rotation=90,origin={-100,-160}),iconTransformation(extent={{-20,-20},{20,20}},rotation=90,origin={-60,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_s
    "Connector of setpoint input signal"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u_m
    "Connector of measurement input signal"
    annotation (Placement(transformation(origin={0,-160},extent={{20,-20},{-20,20}},rotation=270),iconTransformation(extent={{20,-20},{-20,20}},rotation=270,origin={0,-120})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y
    "Connector of actuator output signal"
    annotation (Placement(transformation(extent={{220,-20},{260,20}}),iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset resConHig(
    final controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing) if have_enaSig
    "Controller with high offset set point"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conHig(
    final controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing) if not have_enaSig
    "Controller with high offset set point"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset resConLow(
    controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing) if have_enaSig
    "Controller with low offset set point"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.PID conLow(
    controllerType=controllerType,
    final yMin=yMin,
    final yMax=yMax,
    final k=k,
    final Ti=Ti,
    final reverseActing=reverseActing) if not have_enaSig
    "Controller with low offset set point"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hysBlo(
    final uLow=2*yMin+Modelica.Constants.eps,
    final uHigh=2*yMax-Modelica.Constants.eps)
    "Hysteresis"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addHig(
    final p=hys/2,
    final k=1)
    "Positive set point offset"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Continuous.AddParameter addLow(
    final p=-hys/2,
    final k=1)
    "Negative set point offset"
    annotation (Placement(transformation(extent={{-90,-50},{-70,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Switch between high and low controller"
    annotation (Placement(transformation(extent={{140,10},{160,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Min min1
    "Minimum value of controller outputs"
    annotation (Placement(transformation(extent={{-10,-30},{10,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum value of controller outputs"
    annotation (Placement(transformation(extent={{-10,10},{10,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Add add2
    "Sum of min and max values of controller outputs"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    annotation (Placement(transformation(extent={{100,-11},{120,11}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    final k=reverseActing)
    "True if reverse acting"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    annotation (Placement(transformation(extent={{90,50},{110,70}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi1
    "Switch to measurement instead of set point if disabled"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-130,0})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch to off if disabled"
    annotation (Placement(transformation(extent={{190,10},{210,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Zero"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant tru(
    final k=true) if not have_enaSig
    "Always true (for the case where no enable signal is used)"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=90,origin={-82,-120})));
protected
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant cheYMinMax(
    final k=yMin < yMax)
    "Check for values of yMin and yMax"
    annotation (Placement(transformation(extent={{60,100},{80,120}})));
  Buildings.Controls.OBC.CDL.Utilities.Assert assMesYMinMax(
    final message="LimPID: Limits must be yMin < yMax")
    "Assertion on yMin and yMax"
    annotation (Placement(transformation(extent={{100,100},{120,120}})));
equation
  connect(resConLow.y,swi.u1)
    annotation (Line(points={{-38,-40},{130,-40},{130,-8},{138,-8}},color={0,0,127}));
  connect(resConHig.y,swi.u3)
    annotation (Line(points={{-38,40},{130,40},{130,8},{138,8}},color={0,0,127}));
  connect(resConHig.y,max1.u1)
    annotation (Line(points={{-38,40},{-20,40},{-20,26},{-12,26}},color={0,0,127}));
  connect(resConLow.y,max1.u2)
    annotation (Line(points={{-38,-40},{-16,-40},{-16,14},{-12,14}},color={0,0,127}));
  connect(resConHig.y,min1.u1)
    annotation (Line(points={{-38,40},{-20,40},{-20,-14},{-12,-14}},color={0,0,127}));
  connect(resConLow.y,min1.u2)
    annotation (Line(points={{-38,-40},{-16,-40},{-16,-26},{-12,-26}},color={0,0,127}));
  connect(max1.y,add2.u1)
    annotation (Line(points={{12,20},{14,20},{14,6},{18,6}},color={0,0,127}));
  connect(min1.y,add2.u2)
    annotation (Line(points={{12,-20},{14,-20},{14,-6},{18,-6}},color={0,0,127}));
  connect(add2.y,hysBlo.u)
    annotation (Line(points={{42,0},{48,0}},color={0,0,127}));
  connect(addHig.y,resConHig.u_s)
    annotation (Line(points={{-68,40},{-62,40}},color={0,0,127}));
  connect(addLow.y,resConLow.u_s)
    annotation (Line(points={{-68,-40},{-62,-40}},color={0,0,127}));
  connect(swi.u2,logSwi.y)
    annotation (Line(points={{138,0},{122,0}},color={255,0,255}));
  connect(hysBlo.y,logSwi.u3)
    annotation (Line(points={{72,0},{80,0},{80,-8.8},{98,-8.8}},color={255,0,255}));
  connect(hysBlo.y,not1.u)
    annotation (Line(points={{72,0},{80,0},{80,60},{88,60}},color={255,0,255}));
  connect(not1.y,logSwi.u1)
    annotation (Line(points={{112,60},{150,60},{150,20},{90,20},{90,8.8},{98,8.8}},color={255,0,255}));
  connect(con.y,logSwi.u2)
    annotation (Line(points={{82,-60},{90,-60},{90,0},{98,0}},color={255,0,255}));
  connect(cheYMinMax.y,assMesYMinMax.u)
    annotation (Line(points={{82,110},{98,110}},color={255,0,255}));
  connect(u_s,swi1.u1)
    annotation (Line(points={{-200,0},{-170,0},{-170,8},{-142,8}},color={0,0,127}));
  connect(swi1.y,addHig.u)
    annotation (Line(points={{-118,0},{-110,0},{-110,40},{-92,40}},color={0,0,127}));
  connect(swi1.y,addLow.u)
    annotation (Line(points={{-118,0},{-110,0},{-110,-40},{-92,-40}},color={0,0,127}));
  connect(uEna,swi1.u2)
    annotation (Line(points={{-100,-160},{-100,-80},{-160,-80},{-160,0},{-142,0}},color={255,0,255}));
  connect(u_m,resConLow.u_m)
    annotation (Line(points={{0,-160},{0,-60},{-50,-60},{-50,-52}},color={0,0,127}));
  connect(u_m,swi1.u3)
    annotation (Line(points={{0,-160},{0,-60},{-150,-60},{-150,-8},{-142,-8}},color={0,0,127}));
  connect(u_m,resConHig.u_m)
    annotation (Line(points={{-0,-160},{-0,-60},{-32,-60},{-32,20},{-50,20},{-50,28}},color={0,0,127}));
  connect(uEna,resConLow.trigger)
    annotation (Line(points={{-100,-160},{-100,-80},{-56,-80},{-56,-52}},color={255,0,255}));
  connect(uEna,resConHig.trigger)
    annotation (Line(points={{-100,-160},{-100,20},{-56,20},{-56,28}},color={255,0,255}));
  connect(swi2.y,y)
    annotation (Line(points={{212,0},{240,0}},color={0,0,127}));
  connect(swi.y,swi2.u1)
    annotation (Line(points={{162,0},{170,0},{170,-8},{188,-8}},color={0,0,127}));
  connect(zer.y,swi2.u3)
    annotation (Line(points={{182,40},{184,40},{184,8},{188,8}},color={0,0,127}));
  connect(uEna,swi2.u2)
    annotation (Line(points={{-100,-160},{-100,-80},{180,-80},{180,0},{188,0}},color={255,0,255}));
  connect(tru.y,swi2.u2)
    annotation (Line(points={{-82,-108},{-82,-100},{180,-100},{180,0},{188,0}},color={255,0,255}));
  connect(tru.y,swi1.u2)
    annotation (Line(points={{-82,-108},{-82,-100},{-160,-100},{-160,0},{-142,0}},color={255,0,255}));
  connect(u_m,conLow.u_m)
    annotation (Line(points={{0,-160},{0,-60},{-32,-60},{-32,-20},{-50,-20},{-50,-12}},color={0,0,127}));
  connect(u_m,conHig.u_m)
    annotation (Line(points={{0,-160},{0,-60},{-32,-60},{-32,60},{-50,60},{-50,68}},color={0,0,127}));
  connect(addHig.y,conHig.u_s)
    annotation (Line(points={{-68,40},{-66,40},{-66,80},{-62,80}},color={0,0,127}));
  connect(addLow.y,conLow.u_s)
    annotation (Line(points={{-68,-40},{-66,-40},{-66,0},{-62,0}},color={0,0,127}));
  connect(conHig.y,max1.u1)
    annotation (Line(points={{-38,80},{-20,80},{-20,26},{-12,26}},color={0,0,127}));
  connect(conHig.y,min1.u1)
    annotation (Line(points={{-38,80},{-20,80},{-20,-14},{-12,-14}},color={0,0,127}));
  connect(conHig.y,swi.u3)
    annotation (Line(points={{-38,80},{-20,80},{-20,40},{130,40},{130,8},{138,8}},color={0,0,127}));
  connect(conLow.y,max1.u2)
    annotation (Line(points={{-38,0},{-16,0},{-16,14},{-12,14}},color={0,0,127}));
  connect(conLow.y,min1.u2)
    annotation (Line(points={{-38,0},{-16,0},{-16,-26},{-12,-26}},color={0,0,127}));
  connect(conLow.y,swi.u1)
    annotation (Line(points={{-38,0},{-16,0},{-16,-40},{130,-40},{130,-8},{138,-8}},color={0,0,127}));
  annotation (
    defaultComponentName="conPla",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-180,-140},{220,140}})),
    Documentation(
      revisions="<html>
<ul>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation
</li>
</ul>
</html>",
      info="<html>
<p>
This is a controller composed of two P or PI controllers and a hysteresis block.
The width of the hysteresis <code>hys</code>, together with the set point input
signal <code>u_s</code> defines the set point tracked by each controller.
</p>
<ul>
<li>
The \"low\" controller tracks <code>u_s-hys/2</code>.
</li>
<li>
The \"high\" controller tracks <code>u_s+hys/2</code>.
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
high controller output.
</li>
<li>
In between, the output is equal to the output of the previously active controller.
</li>
<li>
This logic is illustrated below, and is reversed if <code>reverseActing</code> is
<code>true</code>.
</li>
</ul>
<p>
Optionally, a Boolean input signal can be used as an enable signal.
</p>
<ul>
<li>
When the enable signal is <code>false</code>, the controller output is zero.
</li>
<li>
When the enable signal is <code>true</code>, the controller output is as described above.
</li>
</ul>
<p>
<img alt=\"Sequence chart\"
src=\"modelica://Buildings/Resources/Images/Experimental/DHC/EnergyTransferStations/Combined/Generation5/Controls/LimPlay.png\"/>
</p>
<p>
See
<a href=\"modelica://Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlay\">
Buildings.Experimental.DHC.EnergyTransferStations.Combined.Generation5.Controls.Validation.LimPlay</a>
for an illustration of the control response.
</p>
</html>"));
end LimPlay;
