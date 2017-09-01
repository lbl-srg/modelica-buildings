within Buildings.Controls.OBC.ASHRAE.G36.Atomic;
block VAVMultiZoneSupFan  "Block to control multizone VAV AHU supply fan"

  parameter Integer numZon
    "Total number of served zones/VAV boxes"
    annotation(Dialog(group="System configuration"));
  parameter Boolean perZonRehBox = false
    "Check if there is any VAV-reheat boxes on perimeter zones"
    annotation(Dialog(group="System configuration"));
  parameter Boolean duaDucBox = false
    "Check if the AHU serves dual duct boxes"
    annotation(Dialog(group="System configuration"));
  parameter Boolean airFloMeaSta = false
    "Check if the AHU has AFMS (Airflow measurement statation)"
    annotation(Dialog(group="System configuration"));
  parameter Modelica.SIunits.PressureDifference maxDesPre(displayUnit="Pa")
    "Duct design maximum static pressure"
    annotation(Dialog(group="System configuration"));
  parameter Modelica.SIunits.PressureDifference iniSet(displayUnit="Pa") = 120
    "Initial setpoint"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.PressureDifference minSet(displayUnit="Pa") = 25
    "Minimum setpoint"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.PressureDifference maxSet(displayUnit="Pa") = maxDesPre
    "Maximum setpoint"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.Time delTim = 600  "Delay time"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.Time timSte = 120  "Time step"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Integer numIgnReq = 2
    "Number of ignored requests"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.PressureDifference triAmo(displayUnit="Pa") = -12.0
    "Trim amount"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.PressureDifference resAmo(displayUnit="Pa") = 15
    "Respond amount (must be opposite in to triAmo)"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Modelica.SIunits.PressureDifference maxRes(displayUnit="Pa") = 32
    "Maximum response per time interval (same sign as resAmo)"
    annotation (Dialog(tab="Advanced",group="Trim&Respond parameter"));
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController
    controllerType=CDL.Types.SimpleController.PID "Type of controller"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters"));
  parameter Real k=1 "Gain of controller"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters"));
  parameter Modelica.SIunits.Time Ti(min=0)=30 "Time constant of Integrator block"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters",
      enable=
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PI or
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time Td(min=0) "Time constant of Derivative block"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters",
      enable=
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PD or
        controllerType==Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Real yMax=1 "Upper limit of output"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters"));
  parameter Real yMin=0 "Lower limit of output"
    annotation (Dialog(tab="Advanced",group="Fan control PID parameters"));

  CDL.Interfaces.IntegerInput uOpeMod
   "System operation mode"
    annotation (Placement(transformation(extent={{-200,100},{-160,140}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    quantity="PressureDifference")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-200,-100},{-160,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput boxFloRat[numZon](
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (duaDucBox or airFloMeaSta)
    "VAV box airflow rate"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-200,-60},{-160,-20}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Interfaces.BooleanOutput ySupFan "Supply fan ON/OFF status"
    annotation (Placement(transformation(extent={{140,60},{160,80}}),
      iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.RealOutput yFanSpe(
    min=0, max=1, final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{140,-60},{160,-40}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealOutput yFloRat(
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (duaDucBox or airFloMeaSta)
    "Totalized current airflow rate from VAV boxes"
    annotation (Placement(transformation(extent={{140,-120},{160,-100}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  CDL.Continuous.Sum sum1(nin=numZon) if not (duaDucBox or airFloMeaSta)
    "Sum of box airflow rate"
    annotation (Placement(transformation(extent={{60,-120},{80,-100}})));
  TrimRespondLogic staPreSetRes(
    iniSet=iniSet,
    minSet=minSet,
    maxSet=maxSet,
    delTim=delTim,
    timSte=timSte,
    numIgnReq=numIgnReq,
    triAmo=triAmo,
    resAmo=resAmo,
    maxRes=maxRes)
    "Static pressure setpoint reset using trim&respond logic"
    annotation (Placement(transformation(extent={{-100,-50},{-80,-30}})));
  CDL.Continuous.LimPID supFanSpeCon(
    Ti=Ti,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Td=Td,
    yMax=yMax,
    yMin=yMin)
    "Supply fan speed control"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  CDL.Continuous.Sources.Constant zerSpe(k=0)
    "Zero fan speed when it becomes OFF"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  CDL.Logical.Switch swi
    "If fan is OFF, fan speed outputs to zero"
    annotation (Placement(transformation(extent={{80,-50},{100,-70}})));

protected
  CDL.Logical.Or or1
    "Check whether supply fan should be ON"
    annotation (Placement(transformation(extent={{80,60},{100,80}})));
  CDL.Logical.Or or2 if perZonRehBox
    "Setback or warmup mode"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  CDL.Logical.Or3 or3
    "Cool-down or setup or occupied mode"
    annotation (Placement(transformation(extent={{20,90},{40,110}})));
  CDL.Logical.Sources.Constant con(k=false) if not perZonRehBox
    "Constant true"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  CDL.Integers.Sources.Constant conInt(k=Constants.OperationModes.cooDowInd)
    "Cool down mode index"
    annotation (Placement(transformation(extent={{-120,120},{-100,140}})));
  CDL.Integers.Sources.Constant conInt4(k=Constants.OperationModes.warUpInd)
    "Warm-up model index"
    annotation (Placement(transformation(extent={{-120,0},{-100,20}})));
  CDL.Integers.Sources.Constant conInt1(k=Constants.OperationModes.setUpInd)
    "Set up mode index"
    annotation (Placement(transformation(extent={{-120,90},{-100,110}})));
  CDL.Integers.Sources.Constant conInt2(k=Constants.OperationModes.occModInd)
    "Occupied mode index"
    annotation (Placement(transformation(extent={{-120,60},{-100,80}})));
  CDL.Integers.Sources.Constant conInt3(k=Constants.OperationModes.setBacInd)
    "Set back mode index"
    annotation (Placement(transformation(extent={{-120,30},{-100,50}})));
  CDL.Integers.Equal intEqu "Check if current operation mode is cool-down mode"
    annotation (Placement(transformation(extent={{-60,120},{-40,140}})));
  CDL.Integers.Equal intEqu1 "Check if current operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  CDL.Integers.Equal intEqu2 "Check if current operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  CDL.Integers.Equal intEqu3 "Check if current operation mode is setback mode"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  CDL.Integers.Equal intEqu4 "Check if current operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

equation
  connect(or2.y, or1.u2)
    annotation (Line(points={{41,40},{60,40},{60,62},{78,62}},
      color={255,0,255}));
  connect(or1.y, ySupFan)
    annotation (Line(points={{101,70},{150,70}},
      color={255,0,255}));
  connect(boxFloRat, sum1.u)
    annotation (Line(points={{-180,-110},{58,-110}}, color={0,0,127}));
  connect(sum1.y, yFloRat)
    annotation (Line(points={{81,-110},{150,-110}},
      color={0,0,127}));
  connect(or1.y, staPreSetRes.uDevSta)
    annotation (Line(points={{101,70},{120,70},{120,-8},{-120,-8},{-120,-32},
      {-102,-32}},  color={255,0,255}));
  connect(staPreSetRes.y, supFanSpeCon.u_s)
    annotation (Line(points={{-79,-40},{-60,-40},{-60,-60},{-42,-60}},
      color={0,0,127}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{101,70},{120,70},{120,-8},{0,-8},{0,-60},{78,-60}},
      color={255,0,255}));
  connect(supFanSpeCon.y, swi.u1)
    annotation (Line(points={{-19,-60},{-4,-60},{-4,-68},{78,-68}},
      color={0,0,127}));
  connect(zerSpe.y, swi.u3)
    annotation (Line(points={{41,-40},{60,-40},{60,-52},{78,-52}},
      color={0,0,127}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{101,-60},{120,-60},{120,-50},{150,-50}},
      color={0,0,127}));
  connect(uZonPreResReq, staPreSetRes.numOfReq)
    annotation (Line(points={{-180,-40},{-142,-40},{-142,-48},{-102,-48}},
      color={255,127,0}));
  connect(ducStaPre, supFanSpeCon.u_m)
    annotation (Line(points={{-180,-80},{-30,-80},{-30,-72}},
      color={0,0,127}));
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

annotation (Dialog(tab="Advanced",group="Fan control PID parameters"),
  defaultComponentName="vAVMulSupFan",
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
          extent={{-86,-12},{-16,-24}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Left,
          textString="Reset pressure setpoint"),
        Text(
          extent={{-98,-58},{-44,-88}},
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
          textString="Check fan ON/OFF"),
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
          extent={{-100,124},{98,102}},
          lineColor={0,0,255},
          textString="%name"),
               Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={210,210,210},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-96,90},{-54,70}},
          lineColor={0,0,127},
          textString="uOpeMod"),
        Text(
          extent={{-96,42},{-54,22}},
          lineColor={0,0,127},
          textString="boxFloRat"),
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
          textString="yFloRat"),
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
This block implements supply fan control of multizone VAV AHU according to 
ASHRAE guideline G36, PART5.N.1 (Supply fan control).
</p>
<p>a. Supply fan start/stop</p>
<ul>
<li>Supply fan shall run when system is in the Cool-down, Setup, or Occupied mode</li>
<li>If there are any VAV-reheat boxes on perimeter zones, supply fan shall also 
run when system is in Setback or Warmup mode;</li>
<li>If the AHU does not serve dual duct boxes (<code>duaDucBox=true</code>) or the AHU
does not have airflow measurement station (<code>airFloMeaSta=false</code>),
totallize current airflow rate from VAV boxes to a software point.</li>
</ul>
<p>b. Static pressure setpoint reset</p>
Static pressure setpoint shall be reset using Trim-respond logic using following
parameters as a starting place:
<table summary=\"summary\" border=\"1\">
<tr><th> Variable </th> <th> Value </th> <th> Definition </th> </tr>
<tr><td>Device</td><td>AHU Supply Fan</td> <td>Associated device</td></tr>
<tr><td><code>SP0</code></td><td><code>120 Pa (0.5 inches)</code></td><td>Initial setpoint</td></tr>
<tr><td><code>SPmin</code></td><td><code>25 Pa (0.1 inches)</code></td><td>Minimum setpoint</td></tr>
<tr><td><code>SPmax</code></td><td><code>maxDesPre</code></td><td>Maximum setpoint</td></tr>
<tr><td><code>Td</code></td><td><code>10 minutes</code></td><td>Delay timer</td></tr>
<tr><td><code>T</code></td><td><code>2 minutes</code></td><td>Time step</td></tr>
<tr><td><code>I</code></td><td><code>2</code></td><td>Number of ignored requests</td></tr>
<tr><td><code>R</code></td><td>Zone static pressure reset requests</td><td>Number of requests</td></tr>
<tr><td><code>SPtrim</code></td><td><code>-12 Pa (-0.05 inches)</code></td><td>Trim amount</td></tr>
<tr><td><code>SPres</code></td><td><code>15 Pa (+0.06 inches)</code></td><td>Respond amount</td></tr>
<tr><td><code>SPres_max</code></td><td><code>32 Pa (+0.13 inches)</code></td><td>Maximum response per time interval</td></tr>
</table>
<br/>
<p>c. Static pressure control</p>
Supply fan speed is controlled to maintain duct static pressure at setpoint 
when the fan is proven on. Where the Zone groups served by the system are 
small, provided multiple sets of gains that are used in the control loop as a 
function of a load indicator (such as supply fan airflow rate, the area of the 
Zone groups that are occupied, etc.).

<h4>References</h4>
<p>
<a href=\"http://gpc36.savemyenergy.com/public-files/\">BSR (ANSI Board of 
Standards Review)/ASHRAE Guideline 36P, 
<i>High Performance Sequences of Operation for HVAC systems</i>. 
First Public Review Draft (June 2016)</a>
</p>
</html>", revisions="<html>
<ul>
<li>
August 15, 2017, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end VAVMultiZoneSupFan;
