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
    annotation (Placement(transformation(extent={{-200,90},{-160,130}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  CDL.Interfaces.RealInput ducStaPre(
    final unit="Pa",
    quantity="PressureDifference")
    "Measured duct static pressure"
    annotation (Placement(transformation(extent={{-200,-110},{-160,-70}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  CDL.Interfaces.RealInput boxFloRat[numZon](
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (duaDucBox or airFloMeaSta)
    "VAV box airflow rate"
    annotation (Placement(transformation(extent={{-200,-140},{-160,-100}}),
      iconTransformation(extent={{-140,10},{-100,50}})));
  CDL.Interfaces.IntegerInput uZonPreResReq
    "Zone static pressure reset requests"
    annotation (Placement(transformation(extent={{-200,-50},{-160,-10}}),
      iconTransformation(extent={{-140,-50},{-100,-10}})));
  CDL.Interfaces.BooleanOutput ySupFan "Supply fan ON/OFF status"
    annotation (Placement(transformation(extent={{140,70},{160,90}}),
      iconTransformation(extent={{100,60},{120,80}})));
  CDL.Interfaces.RealOutput yFanSpe(
    min=0, max=1, final unit="1")
    "Supply fan speed"
    annotation (Placement(transformation(extent={{140,-70},{160,-50}}),
      iconTransformation(extent={{100,-10},{120,10}})));
  CDL.Interfaces.RealOutput yFloRat(
    final unit="m3/s",
    quantity="VolumeFlowRate") if not (duaDucBox or airFloMeaSta)
    "Totalized current airflow rate from VAV boxes"
    annotation (Placement(transformation(extent={{140,-130},{160,-110}}),
      iconTransformation(extent={{100,-80},{120,-60}})));

  CDL.Continuous.Sum sum1(nin=numZon) if not (duaDucBox or airFloMeaSta)
    "Sum of box airflow rate"
    annotation (Placement(transformation(extent={{60,-130},{80,-110}})));
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
    annotation (Placement(transformation(extent={{-100,-40},{-80,-20}})));
  CDL.Continuous.LimPID supFanSpeCon(
    Ti=Ti,
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=k,
    Td=Td,
    yMax=yMax,
    yMin=yMin)
    "Supply fan speed control"
    annotation (Placement(transformation(extent={{-40,-80},{-20,-60}})));
  CDL.Continuous.Sources.Constant zerSpe(k=0)
    "Zero fan speed when it becomes OFF"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));
  CDL.Logical.Switch swi
    "If fan is OFF, fan speed outputs to zero"
    annotation (Placement(transformation(extent={{60,-60},{80,-80}})));

protected
  CDL.Conversions.IntegerToReal intToRea
    "Convert integer input to real output"
    annotation (Placement(transformation(extent={{-140,130},{-120,150}})));
  CDL.Logical.GreaterThreshold greThr(
    threshold=Constants.OperationModes.cooDowInd - 0.5)
    "Tests whether operation mode is cool down mode"
    annotation (Placement(transformation(extent={{-100,130},{-80,150}})));
  CDL.Logical.LessThreshold lesThr(
    threshold=Constants.OperationModes.cooDowInd + 0.5)
    "Tests whether operation mode is cool down mode"
    annotation (Placement(transformation(extent={{-60,130},{-40,150}})));
  CDL.Logical.GreaterThreshold greThr1(
    threshold=Constants.OperationModes.setUpInd - 0.5)
    "Tests whether operation mode is setup mode"
    annotation (Placement(transformation(extent={{-100,100},{-80,120}})));
  CDL.Logical.LessThreshold lesThr1(
    threshold=Constants.OperationModes.setUpInd + 0.5)
    "Tests whether operation mode is setup mode"
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  CDL.Logical.GreaterThreshold greThr2(
    threshold=Constants.OperationModes.occModInd - 0.5)
    "Tests whether operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));
  CDL.Logical.LessThreshold lesThr2(
    threshold=Constants.OperationModes.occModInd + 0.5)
    "Tests whether operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  CDL.Logical.GreaterThreshold greThr3(
    threshold=Constants.OperationModes.setBacInd - 0.5)
    "Tests whether operation mode is setback mode"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  CDL.Logical.LessThreshold lesThr3(
    threshold=Constants.OperationModes.setBacInd + 0.5)
    "Tests whether operation mode is setback mode"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));
  CDL.Logical.GreaterThreshold greThr4(
    threshold=Constants.OperationModes.warUpInd - 0.5)
    "Tests whether operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  CDL.Logical.LessThreshold lesThr4(
    threshold=Constants.OperationModes.warUpInd + 0.5)
    "Tests whether operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  CDL.Logical.And and1
    "Tests whether operation mode is cool down mode"
    annotation (Placement(transformation(extent={{-20,130},{0,150}})));
  CDL.Logical.And and2
    "Tests whether operation mode is setup mode"
    annotation (Placement(transformation(extent={{-20,100},{0,120}})));
  CDL.Logical.And and3
    "Tests whether operation mode is occupied mode"
    annotation (Placement(transformation(extent={{-20,70},{0,90}})));
  CDL.Logical.And and4
    "Tests whether operation mode is setback mode"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  CDL.Logical.And and5
    "Tests whether operation mode is warmup mode"
    annotation (Placement(transformation(extent={{-20,10},{0,30}})));
  CDL.Logical.Or or1
    "Check whether supply fan should be ON"
    annotation (Placement(transformation(extent={{60,120},{80,140}})));
  CDL.Logical.Or or2 if perZonRehBox
    "Setback or warmup mode"
    annotation (Placement(transformation(extent={{20,60},{40,80}})));
  CDL.Logical.Or3 or3
    "Cool-down or setup or occupied mode"
    annotation (Placement(transformation(extent={{20,120},{40,140}})));
  CDL.Logical.Sources.Constant con(k=false) if not perZonRehBox
    "Constant true"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
equation
  connect(intToRea.y, greThr.u)
    annotation (Line(points={{-119,140},{-110.5,140},{-102,140}}, color={0,0,127}));
  connect(intToRea.y, lesThr.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,160},{-68,160},
      {-68,140},{-62,140}}, color={0,0,127}));
  connect(intToRea.y, greThr1.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,110},{-102,110}},
      color={0,0,127}));
  connect(intToRea.y, greThr2.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,80},{-102,80}},
      color={0,0,127}));
  connect(intToRea.y, greThr3.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,50},{-102,50}},
      color={0,0,127}));
  connect(intToRea.y, lesThr1.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,160},{-68,160},
      {-68,110},{-62,110}}, color={0,0,127}));
  connect(intToRea.y, lesThr2.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,160},{-68,160},
      {-68,80},{-62,80}}, color={0,0,127}));
  connect(intToRea.y, lesThr3.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,160},{-68,160},
      {-68,50},{-62,50}}, color={0,0,127}));
  connect(intToRea.y, greThr4.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,20},{-102,20}},
      color={0,0,127}));
  connect(intToRea.y, lesThr4.u)
    annotation (Line(points={{-119,140},{-110,140},{-110,160},{-68,160},
      {-68,20},{-62,20}}, color={0,0,127}));
  connect(lesThr.y,and1. u1)
    annotation (Line(points={{-39,140},{-22,140}}, color={255,0,255}));
  connect(lesThr1.y, and2.u1)
    annotation (Line(points={{-39,110},{-22,110}}, color={255,0,255}));
  connect(lesThr2.y, and3.u1)
    annotation (Line(points={{-39,80},{-22,80}}, color={255,0,255}));
  connect(lesThr3.y, and4.u1)
    annotation (Line(points={{-39,50},{-22,50}}, color={255,0,255}));
  connect(lesThr4.y, and5.u1)
    annotation (Line(points={{-39,20},{-22,20}}, color={255,0,255}));
  connect(greThr.y,and1. u2)
    annotation (Line(points={{-79,140},{-72,140},{-72,126},{-32,126},
      {-32,132},{-22,132}}, color={255,0,255}));
  connect(greThr1.y, and2.u2)
    annotation (Line(points={{-79,110},{-72,110},{-72,96},{-32,96},{-32,102},
      {-22,102}}, color={255,0,255}));
  connect(greThr2.y, and3.u2)
    annotation (Line(points={{-79,80},{-72,80},{-72,66},{-32,66},{-32,72},
      {-22,72}}, color={255,0,255}));
  connect(greThr3.y, and4.u2)
    annotation (Line(points={{-79,50},{-72,50},{-72,36},{-32,36},{-32,42},
      {-22,42}}, color={255,0,255}));
  connect(greThr4.y, and5.u2)
    annotation (Line(points={{-79,20},{-72,20},{-72,6},{-32,6},{-32,12},
      {-22,12}}, color={255,0,255}));
  connect(and1.y, or3.u1)
    annotation (Line(points={{1,140},{8,140},{8,138},{18,138}},
      color={255,0,255}));
  connect(and2.y, or3.u2)
    annotation (Line(points={{1,110},{8,110},{8,130},{18,130}},
      color={255,0,255}));
  connect(and3.y, or3.u3)
    annotation (Line(points={{1,80},{12,80},{12,122},{18,122}},
      color={255,0,255}));
  connect(and4.y, or2.u1)
    annotation (Line(points={{1,50},{8,50},{8,70},{18,70}},
      color={255,0,255}));
  connect(and5.y, or2.u2)
    annotation (Line(points={{1,20},{12,20},{12,62},{18,62}},
      color={255,0,255}));
  connect(or3.y, or1.u1)
    annotation (Line(points={{41,130},{49.5,130},{58,130}},
      color={255,0,255}));
  connect(or2.y, or1.u2)
    annotation (Line(points={{41,70},{50,70},{50,122},{58,122}},
      color={255,0,255}));
  connect(or1.y, ySupFan)
    annotation (Line(points={{81,130},{100,130},{120,130},{120,80},{150,80}},
      color={255,0,255}));
  connect(boxFloRat, sum1.u)
    annotation (Line(points={{-180,-120},{58,-120}}, color={0,0,127}));
  connect(sum1.y, yFloRat)
    annotation (Line(points={{81,-120},{150,-120}},
      color={0,0,127}));
  connect(or1.y, staPreSetRes.uDevSta)
    annotation (Line(points={{81,130},{100,130},{100,0},{-120,0},{-120,-22},
      {-102,-22}}, color={255,0,255}));
  connect(staPreSetRes.y, supFanSpeCon.u_s)
    annotation (Line(points={{-79,-30},{-70,-30},{-60,-30},{-60,-70},
      {-42,-70}}, color={0,0,127}));
  connect(or1.y, swi.u2)
    annotation (Line(points={{81,130},{100,130},{100,0},{0,0},{0,-70},{58,-70}},
      color={255,0,255}));
  connect(supFanSpeCon.y, swi.u1)
    annotation (Line(points={{-19,-70},{-4,-70},{-4,-78},{58,-78}},
      color={0,0,127}));
  connect(zerSpe.y, swi.u3)
    annotation (Line(points={{41,-30},{46,-30},{46,-62},{58,-62}},
      color={0,0,127}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{81,-70},{90,-70},{100,-70},{100,-60},{150,-60}},
      color={0,0,127}));
  connect(uZonPreResReq, staPreSetRes.numOfReq)
    annotation (Line(points={{-180,-30},{-160,-30},{-140,-30},{-140,-38},
      {-102,-38}}, color={255,127,0}));
  connect(ducStaPre, supFanSpeCon.u_m)
    annotation (Line(points={{-180,-90},{-106,-90},{-30,-90},{-30,-82}},
      color={0,0,127}));
  connect(uOpeMod, intToRea.u)
    annotation (Line(points={{-180,110},{-150,110},{-150,140},{-142,140}},
      color={255,127,0}));
  connect(con.y, or1.u2)
    annotation (Line(points={{41,40},{50,40},{50,122},{58,122}},
      color={255,0,255}));

  annotation (Dialog(tab="Advanced",group="Fan control PID parameters"),
defaultComponentName="vAVMulSupFan",
Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{140,160}}),
        graphics={
        Rectangle(
          extent={{-154,158},{86,2}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{10,36},{86,-4}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Check current 
operation mode"),
        Rectangle(
          extent={{-154,0},{-4,-98}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{-88,-2},{-18,-34}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Reset pressure 
setpoint 
"),     Text(
          extent={{-98,-68},{-44,-98}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          textString="Control fan speed 
")}),
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
