within Buildings.Controls.OBC.ASHRAE.G36_PR1.AHUs.MultiZone.SetPoints;
block VAVSupplyFan  "Block to control multi zone VAV AHU supply fan"

  parameter Integer numZon(min=2)
    "Total number of served VAV boxes"
    annotation(Dialog(group="System configuration"));
  parameter Boolean have_perZonRehBox = false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation(Dialog(group="System configuration"));
  parameter Boolean have_duaDucBox = false
    "Check if the AHU serves dual duct boxes"
    annotation(Dialog(group="System configuration"));
  parameter Boolean have_airFloMeaSta = false
    "Check if the AHU has AFMS (Airflow measurement station)"
    annotation(Dialog(group="System configuration"));
  parameter Modelica.SIunits.PressureDifference iniSet(displayUnit="Pa") = 120
    "Initial setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference minSet(displayUnit="Pa") = 25
    "Minimum setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference maxSet(displayUnit="Pa")
    "Maximum setpoint"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.Time delTim = 600
   "Delay time after which trim and respond is activated"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.Time samplePeriod = 120  "Sample period"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference triAmo(displayUnit="Pa") = -12.0
    "Trim amount"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference resAmo(displayUnit="Pa") = 15
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Modelica.SIunits.PressureDifference maxRes(displayUnit="Pa") = 32
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (Dialog(group="Fan PID controller"));
  parameter Real k(final unit="1")=0.1
    "Gain of controller, normalized using maxSet"
    annotation (Dialog(group="Fan PID controller"));
  parameter Modelica.SIunits.Time Ti(min=0)=60
    "Time constant of integrator block"
    annotation (Dialog(group="Fan PID controller",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI
         or  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) = 0.1
    "Time constant of derivative block"
    annotation (Dialog(group="Fan PID controller",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yFanMax(min=0.1, max=1, unit="1") = 1
    "Maximum allowed fan speed"
    annotation (Dialog(group="Fan PID controller"));
  parameter Real yFanMin(min=0.1, max=1, unit="1") = 0.1
    "Lowest allowed fan speed if fan is on"
    annotation (Dialog(group="Fan PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
   "System operation mode"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    quantity="PressureDifference")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput VBox_flow[numZon](
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (have_duaDucBox or have_airFloMeaSta)
    "VAV box airflow rate"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput ySupFan "Supply fan on status"
    annotation (Placement(transformation(extent={{140,60},{160,80}}),
      iconTransformation(extent={{100,60},{120,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFanSpe(
    min=0,
    max=1,
    final unit="1") "Supply fan speed"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput sumVBox_flow(
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (have_duaDucBox or have_airFloMeaSta)
    "Sum of current airflow rates from VAV boxes"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.ASHRAE.G36_PR1.Generic.SetPoints.TrimAndRespond staPreSetRes(
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes) "Static pressure setpoint reset using trim and respond logic"
    annotation (Placement(transformation(extent={{-130,-50},{-110,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conSpe(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=yFanMax,
    final yMin=yFanMin,
    reset=Buildings.Controls.OBC.CDL.Types.Reset.Parameter,
    y_reset=yFanMin) "Supply fan speed control"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
protected
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zerSpe(k=0)
    "Zero fan speed when it becomes OFF"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "If fan is OFF, fan speed outputs to zero"
    annotation (Placement(transformation(extent={{80,-50},{100,-70}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum sum1(
    final nin=numZon) if not (have_duaDucBox or have_airFloMeaSta)
    "Sum of box airflow rate"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Or or1
    "Check whether supply fan should be ON"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  Buildings.Controls.OBC.CDL.Logical.Or or2 if have_perZonRehBox
    "Setback or warmup mode"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Logical.Or3 or3
    "Cool-down or setup or occupied mode"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(
    k=false) if not have_perZonRehBox
    "Constant true"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.warmUp)
    "Warm-up mode"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setUp)
    "Set up mode"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    k=Buildings.Controls.OBC.ASHRAE.G36_PR1.Types.OperationModes.setBack)
    "Set back mode"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu
    "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu4
    "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  CDL.Continuous.Gain norPSet(final k=1/maxSet)
    "Normalization for pressure set point"
    annotation (Placement(transformation(extent={{-70,-50},{-50,-30}})));
  CDL.Continuous.Gain norPMea(final k=1/maxSet)
    "Normalization of pressure measurement"
    annotation (Placement(transformation(extent={{-70,-82},{-50,-62}})));
  CDL.Discrete.FirstOrderHold firOrdHol(
    final samplePeriod=samplePeriod)
    "Extrapolation through the values of the last two sampled input signals"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));

equation
  connect(or2.y, or1.u2)
    annotation (Line(points={{41,40},{60,40},{60,62},{78,62}},
      color={255,0,255}));
  connect(or1.y, ySupFan)
    annotation (Line(points={{101,70},{150,70}},
      color={255,0,255}));
  connect(VBox_flow, sum1.u)
    annotation (Line(points={{-180,-110},{58,-110}}, color={0,0,127}));
  connect(sum1.y, sumVBox_flow)
    annotation (Line(points={{81.7,-110},{150,-110}},
      color={0,0,127}));
  connect(or1.y, staPreSetRes.uDevSta)
    annotation (Line(points={{101,70},{120,70},{120,-8},{-150,-8},{-150,-32},
      {-132,-32}}, color={255,0,255}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{101,70},{120,70},{120,-8},{0,-8},{0,-60},{78,-60}},
      color={255,0,255}));
  connect(conSpe.y, swi.u1)
    annotation (Line(points={{-19,-40},{-4,-40},{-4,-68},{78,-68}},
      color={0,0,127}));
  connect(zerSpe.y, swi.u3)
    annotation (Line(points={{41,-40},{60,-40},{60,-52},{78,-52}},
      color={0,0,127}));
  connect(swi.y, ySupFanSpe)
    annotation (Line(points={{101,-60},{120,-60},{120,-50},{150,-50}},
      color={0,0,127}));
  connect(uZonPreResReq, staPreSetRes.numOfReq)
    annotation (Line(points={{-180,-40},{-142,-40},{-142,-48},{-132,-48}},
      color={255,127,0}));
  connect(con.y, or1.u2)
    annotation (Line(points={{41,10},{60,10},{60,62},{78,62}},
      color={255,0,255}));
  connect(intEqu.y, or3.u1)
    annotation (Line(points={{-39,130},{0,130},{0,108},{18,108}},
      color={255,0,255}));
  connect(intEqu2.y, or3.u3)
    annotation (Line(points={{-39,70},{0,70},{0,92},{18,92}},
      color={255,0,255}));
  connect(intEqu1.y, or3.u2)
    annotation (Line(points={{-39,100},{18,100}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-99,130},{-90,130},{-90,122},{-62,122}},
      color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-99,100},{-90,100},{-90,92},{-62,92}},
      color={255,127,0}));
  connect(conInt2.y, intEqu2.u2)
    annotation (Line(points={{-99,70},{-90,70},{-90,62},{-62,62}},
      color={255,127,0}));
  connect(conInt3.y, intEqu3.u2)
    annotation (Line(points={{-99,40},{-90,40},{-90,32},{-62,32}},
      color={255,127,0}));
  connect(conInt4.y, intEqu4.u2)
    annotation (Line(points={{-99,10},{-90,10},{-90,2},{-62,2}},
      color={255,127,0}));
  connect(uOpeMod, intEqu.u1)
    annotation (Line(points={{-180,120},{-140,120},{-140,150},{-80,150},{-80,130},
      {-62,130}}, color={255,127,0}));
  connect(uOpeMod, intEqu1.u1)
    annotation (Line(points={{-180,120},{-140,120},{-140,150},{-80,150},{-80,100},
      {-62,100}}, color={255,127,0}));
  connect(uOpeMod, intEqu2.u1)
    annotation (Line(points={{-180,120},{-140,120},{-140,150},{-80,150},
      {-80,70},{-62,70}}, color={255,127,0}));
  connect(uOpeMod, intEqu3.u1)
    annotation (Line(points={{-180,120},{-140,120},{-140,150},{-80,150},
      {-80,40},{-62,40}}, color={255,127,0}));
  connect(uOpeMod, intEqu4.u1)
    annotation (Line(points={{-180,120},{-140,120},{-140,150},{-80,150},
      {-80,10},{-62,10}}, color={255,127,0}));
  connect(or3.y, or1.u1)
    annotation (Line(points={{41,100},{60,100},{60,70},{78,70}},
      color={255,0,255}));
  connect(intEqu3.y, or2.u1)
    annotation (Line(points={{-39,40},{18,40}}, color={255,0,255}));
  connect(intEqu4.y, or2.u2)
    annotation (Line(points={{-39,10},{0,10},{0,32},{18,32}},
      color={255,0,255}));
  connect(norPSet.y, conSpe.u_s)
    annotation (Line(points={{-49,-40},{-42,-40}}, color={0,0,127}));
  connect(ducStaPre, norPMea.u)
    annotation (Line(points={{-180,-80},{-132,-80},{-132,-72},{-72,-72}},
      color={0,0,127}));
  connect(norPMea.y, conSpe.u_m)
    annotation (Line(points={{-49,-72},{-30,-72},{-30,-52}}, color={0,0,127}));
  connect(norPSet.u, firOrdHol.y)
    annotation (Line(points={{-72,-40},{-76,-40},{-79,-40}}, color={0,0,127}));
  connect(staPreSetRes.y, firOrdHol.u)
    annotation (Line(points={{-109,-40},{-106,-40},{-102,-40}}, color={0,0,127}));
  connect(conSpe.trigger, or1.y)
    annotation (Line(points={{-38,-52},{-38,-60},{0,-60},{0,-8},{120,-8},
      {120,70},{101,70}}, color={255,0,255}));

annotation (
  defaultComponentName="conSupFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{140,160}}),
        graphics={
        Rectangle(
          extent={{-156,-10},{134,-88}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-156,156},{134,-6}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{42,156},{124,134}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check current operation mode"),
        Text(
          extent={{-134,-12},{-64,-24}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Reset pressure setpoint"),
        Text(
          extent={{-34,-66},{20,-96}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Control fan speed"),
        Text(
          extent={{42,142},{96,126}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check fan on or off"),
        Rectangle(
          extent={{-156,-92},{134,-138}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-132,-124},{-62,-136}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Sum of VAV box flow rate")}),
  Icon(graphics={
        Text(
          extent={{-102,140},{96,118}},
          lineColor={0,0,255},
          textString="%name"),
               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={223,211,169},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,90},{-54,70}},
          lineColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-96,42},{-54,22}},
          lineColor={0,0,127},
          textString="VBox_flow"),
        Text(
          extent={{-96,-16},{-44,-44}},
          lineColor={0,0,127},
          textString="uZonPreResReq"),
        Text(
          extent={{-96,-70},{-54,-90}},
          lineColor={0,0,127},
          textString="ducStaPre"),
        Text(
          extent={{54,-60},{96,-80}},
          lineColor={0,0,127},
          textString="sumVBox_flow"),
        Text(
          extent={{52,10},{94,-10}},
          lineColor={0,0,127},
          textString="yFanSpe"),
        Text(
          extent={{52,78},{94,58}},
          lineColor={0,0,127},
          textString="ySupFan")}),
  Documentation(info="<html>
<p>
Supply fan control for a multi zone VAV AHU according to
ASHRAE guideline G36, PART5.N.1 (Supply fan control).
</p>
<h4>Supply fan start/stop</h4>
<ul>
<li>Supply fan shall run when system is in the Cool-down, Setup, or Occupied mode</li>
<li>If there are any VAV-reheat boxes on perimeter zones, supply fan shall also
run when system is in Setback or Warmup mode;</li>
<li>If the AHU does not serve dual duct boxes (<code>have_duaDucBox=true</code>) or the AHU
does not have airflow measurement station (<code>have_airFloMeaSta=false</code>),
sum the current airflow rate from the VAV boxes and output to a software point.</li>
</ul>
<h4>Static pressure setpoint reset</h4>
<p>
Static pressure setpoint shall be reset using trim-respond logic using following
parameters as a starting point:
</p>
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td>SP0</td><td><code>iniSet</code></td><td>Initial setpoint</td></tr>
<tr><td>SPmin</td><td><code>minSet</code></td><td>Minimum setpoint</td></tr>
<tr><td>SPmax</td><td><code>maxSet</code></td><td>Maximum setpoint</td></tr>
<tr><td>Td</td><td><code>delTim</code></td><td>Delay timer</td></tr>
<tr><td>T</td><td><code>samplePeriod</code></td><td>Time step</td></tr>
<tr><td>I</td><td><code>numIgnReq</code></td><td>Number of ignored requests</td></tr>
<tr><td>R</td><td><code>uZonPreResReq</code></td><td>Number of requests</td></tr>
<tr><td>SPtrim</td><td><code>triAmo</code></td><td>Trim amount</td></tr>
<tr><td>SPres</td><td><code>resAmo</code></td><td>Respond amount</td></tr>
<tr><td>SPres_max</td><td><code>maxRes</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>
<h4>Static pressure control</h4>
<p>
Supply fan speed is controlled with a PI controller to maintain duct static pressure at setpoint
when the fan is proven on. The setpoint for the PI controller and the measured
duct static pressure are normalized with the maximum design static presssure
<code>maxSet</code>.
Where the zone groups served by the system are small,
provide multiple sets of gains that are used in the control loop as a function
of a load indicator (such as supply fan airflow rate, the area of the zone groups
that are occupied, etc.).
</p>
</html>", revisions="<html>
<ul>
<li>
October 14, 2017, by Michael Wetter:<br/>
Added normalization of pressure set point and measurement as the measured
quantity is a few hundred Pascal.
</li>
<li>
August 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVSupplyFan;
