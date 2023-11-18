within Buildings.Controls.OBC.ASHRAE.G36.AHUs.MultiZone.VAV.SetPoints;
block SupplyFan  "Block to control multi zone VAV AHU supply fan"

  parameter Boolean have_perZonRehBox = false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation(__cdl(ValueInReference=false),
                Dialog(group="System configuration"));
  parameter Real iniSet(
    final unit="Pa",
    final quantity="PressureDifference") = 120
    "Initial setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real minSet(
    final unit="Pa",
    final quantity="PressureDifference") = 25
    "Minimum setpoint"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real maxSet(
    final unit="Pa",
    final quantity="PressureDifference")
    "Duct design maximum static pressure. It is the Max_DSP shown in Section 3.2.1.1 of Guideline 36"
    annotation (Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real delTim(
    final unit="s",
    final quantity="Time")= 600
   "Delay time after which trim and respond is activated"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real samplePeriod(
    final unit="s",
    final quantity="Time") = 120  "Sample period"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real triAmo(
    final unit="Pa",
    final quantity="PressureDifference") = -12.0
    "Trim amount"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real resAmo(
    final unit="Pa",
    final quantity="PressureDifference") = 15
    "Respond amount (must be opposite in to triAmo)"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Real maxRes(
    final unit="Pa",
    final quantity="PressureDifference") = 32
    "Maximum response per time interval (same sign as resAmo)"
    annotation (__cdl(ValueInReference=true),
                Dialog(group="Trim and respond for pressure setpoint"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI "Type of controller"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Fan PID controller"));
  parameter Real k(final unit="1")=0.1
    "Gain of controller, normalized using maxSet"
    annotation (__cdl(ValueInReference=false, InstanceInReference=false),
                Dialog(group="Fan PID controller"));
  parameter Real Ti(
    final unit="s",
    final quantity="Time",
    min=0)=60
    "Time constant of integrator block"
    annotation (__cdl(ValueInReference=false, InstanceInReference=false),
                Dialog(group="Fan PID controller",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI
         or  controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real Td(
    final unit="s",
    final quantity="Time",
    final min=0) = 0.1
    "Time constant of derivative block"
    annotation (__cdl(ValueInReference=false, InstanceInReference=false),
                Dialog(group="Fan PID controller",
      enable=controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real maxSpe(min=0.1, max=1, unit="1") = 1
    "Maximum allowed fan speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Fan PID controller"));
  parameter Real minSpe(min=0.1, max=1, unit="1") = 0.1
    "Lowest allowed fan speed if fan is on"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Fan PID controller"));
  parameter Real iniSpe(min=minSpe, max=1, unit="1") = 0.1
    "Initial speed when fan is enabled. It has to be greater than the lowest allowed speed"
    annotation (__cdl(ValueInReference=false),
                Dialog(group="Fan PID controller"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uOpeMod
   "System operation mode"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dpDuc(
    final unit="Pa",
    final quantity="PressureDifference") "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1SupFan
    "Supply fan command on"
    annotation (Placement(transformation(extent={{140,50},{180,90}}),
        iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput ySupFan(
    min=0,
    max=1,
    final unit="1")
    "Supply fan commanded speed"
    annotation (Placement(transformation(extent={{140,-120},{180,-80}}),
        iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond staPreSetRes(
    final iniSet=iniSet,
    final minSet=minSet,
    final maxSet=maxSet,
    final delTim=delTim,
    final samplePeriod=samplePeriod,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes)
    "Static pressure setpoint reset using trim and respond logic"
    annotation (Placement(transformation(extent={{-130,-60},{-110,-40}})));
  Buildings.Controls.OBC.CDL.Reals.PIDWithReset conSpe(
    final controllerType=controllerType,
    final k=k,
    final Ti=Ti,
    final Td=Td,
    final yMax=maxSpe,
    final yMin=minSpe,
    final y_reset=iniSpe) "Supply fan speed control"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));

protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zerSpe(k=0)
    "Zero fan speed when it becomes OFF"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi
    "If fan is OFF, fan speed outputs to zero"
    annotation (Placement(transformation(extent={{80,-90},{100,-110}})));
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
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.coolDown)
    "Cool down mode"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt4(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.warmUp)
    "Warm-up mode"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setUp)
    "Set up mode"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.occupied)
    "Occupied mode"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt3(
    k=Buildings.Controls.OBC.ASHRAE.G36.Types.OperationModes.setBack)
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
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant gaiNor(
    final k=maxSet)
    "Gain for normalization of controller input"
    annotation (Placement(transformation(extent={{-130,-100},{-110,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Divide norPSet
    "Normalization for pressure set point"
    annotation (Placement(transformation(extent={{-70,-80},{-50,-60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide norPMea
    "Normalization of pressure measurement"
    annotation (Placement(transformation(extent={{-70,-120},{-50,-100}})));
  Buildings.Controls.OBC.CDL.Discrete.FirstOrderHold firOrdHol(
    final samplePeriod=samplePeriod)
    "Extrapolation through the values of the last two sampled input signals"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

equation
  connect(or2.y, or1.u2)
    annotation (Line(points={{42,40},{60,40},{60,62},{78,62}},
      color={255,0,255}));
  connect(or1.y, y1SupFan)
    annotation (Line(points={{102,70},{160,70}}, color={255,0,255}));
  connect(or1.y, staPreSetRes.uDevSta)
    annotation (Line(points={{102,70},{120,70},{120,-8},{-150,-8},{-150,-42},{-132,
          -42}},     color={255,0,255}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{102,70},{120,70},{120,-8},{0,-8},{0,-100},{78,-100}},
      color={255,0,255}));
  connect(conSpe.y, swi.u1)
    annotation (Line(points={{-18,-70},{-4,-70},{-4,-108},{78,-108}},
      color={0,0,127}));
  connect(zerSpe.y, swi.u3)
    annotation (Line(points={{42,-80},{60,-80},{60,-92},{78,-92}},
      color={0,0,127}));
  connect(swi.y, ySupFan)
    annotation (Line(points={{102,-100},{160,-100}}, color={0,0,127}));
  connect(uZonPreResReq, staPreSetRes.numOfReq)
    annotation (Line(points={{-180,-60},{-148,-60},{-148,-58},{-132,-58}},
      color={255,127,0}));
  connect(con.y, or1.u2)
    annotation (Line(points={{42,10},{60,10},{60,62},{78,62}},
      color={255,0,255}));
  connect(intEqu.y, or3.u1)
    annotation (Line(points={{-38,130},{0,130},{0,108},{18,108}},
      color={255,0,255}));
  connect(intEqu2.y, or3.u3)
    annotation (Line(points={{-38,70},{0,70},{0,92},{18,92}},
      color={255,0,255}));
  connect(intEqu1.y, or3.u2)
    annotation (Line(points={{-38,100},{18,100}}, color={255,0,255}));
  connect(conInt.y, intEqu.u2)
    annotation (Line(points={{-98,130},{-90,130},{-90,122},{-62,122}},
      color={255,127,0}));
  connect(conInt1.y, intEqu1.u2)
    annotation (Line(points={{-98,100},{-90,100},{-90,92},{-62,92}},
      color={255,127,0}));
  connect(conInt2.y, intEqu2.u2)
    annotation (Line(points={{-98,70},{-90,70},{-90,62},{-62,62}},
      color={255,127,0}));
  connect(conInt3.y, intEqu3.u2)
    annotation (Line(points={{-98,40},{-90,40},{-90,32},{-62,32}},
      color={255,127,0}));
  connect(conInt4.y, intEqu4.u2)
    annotation (Line(points={{-98,10},{-90,10},{-90,2},{-62,2}},
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
    annotation (Line(points={{42,100},{60,100},{60,70},{78,70}},
      color={255,0,255}));
  connect(intEqu3.y, or2.u1)
    annotation (Line(points={{-38,40},{18,40}}, color={255,0,255}));
  connect(intEqu4.y, or2.u2)
    annotation (Line(points={{-38,10},{0,10},{0,32},{18,32}},
      color={255,0,255}));
  connect(norPSet.y, conSpe.u_s)
    annotation (Line(points={{-48,-70},{-42,-70}}, color={0,0,127}));
  connect(norPMea.y, conSpe.u_m)
    annotation (Line(points={{-48,-110},{-30,-110},{-30,-82}}, color={0,0,127}));
  connect(staPreSetRes.y, firOrdHol.u)
    annotation (Line(points={{-108,-50},{-102,-50}}, color={0,0,127}));
  connect(conSpe.trigger, or1.y)
    annotation (Line(points={{-36,-82},{-36,-100},{0,-100},{0,-8},{120,-8},{120,
          70},{102,70}},  color={255,0,255}));
  connect(gaiNor.y, norPSet.u2) annotation (Line(points={{-108,-90},{-92,-90},{-92,
          -76},{-72,-76}}, color={0,0,127}));
  connect(dpDuc, norPMea.u1) annotation (Line(points={{-180,-110},{-80,-110},{-80,
          -104},{-72,-104}}, color={0,0,127}));
  connect(gaiNor.y, norPMea.u2) annotation (Line(points={{-108,-90},{-92,-90},{-92,
          -116},{-72,-116}}, color={0,0,127}));
  connect(firOrdHol.y, norPSet.u1) annotation (Line(points={{-78,-50},{-76,-50},
          {-76,-64},{-72,-64}}, color={0,0,127}));

annotation (
  defaultComponentName="conSupFan",
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{140,160}}),
        graphics={
        Rectangle(
          extent={{-156,-22},{134,-128}},
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
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check current operation mode"),
        Text(
          extent={{54,-26},{124,-38}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Reset pressure setpoint"),
        Text(
          extent={{-34,-106},{20,-136}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Control fan speed"),
        Text(
          extent={{42,142},{96,126}},
          textColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Check fan on or off")}),
  Icon(graphics={
        Text(
          extent={{-102,140},{96,118}},
          textColor={0,0,255},
          textString="%name"),
               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={223,211,169},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,90},{-54,70}},
          textColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-96,-16},{-44,-44}},
          textColor={0,0,127},
          textString="uZonPreResReq"),
        Text(
          extent={{-96,-70},{-60,-90}},
          textColor={0,0,127},
          textString="dpDuc"),
        Text(
          extent={{52,10},{94,-10}},
          textColor={0,0,127},
          textString="ySupFan"),
        Text(
          extent={{52,80},{94,60}},
          textColor={0,0,127},
          textString="y1SupFan")}),
  Documentation(info="<html>
<p>
Supply fan control for a multi zone VAV AHU according to Section 5.16.1 of 
ASHRAE Guideline G36, May 2020.
</p>
<h4>Supply fan start/stop</h4>
<ul>
<li>Supply fan shall run when system is in the Cool-down, Setup, or Occupied mode</li>
<li>If there are any VAV-reheat boxes on perimeter zones, supply fan shall also
run when system is in Setback or Warmup mode</li>
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
November 16, 2023, by Jianjun Hu:<br/>
Added vendor annotation <code>InstanceInReference</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2191\">issue 2191</a>.
</li>
<li>
August 23, 2023, by Jianjun Hu:<br/>
Added parameter to set the initial fan speed.
</li>
<li>
August 1, 2020, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end SupplyFan;
