within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Pumps.PrimaryPumps.Subsequences;
block Speed_temperature
  "Pump speed control for primary-secondary plants where temperature sensors are available in the hot water circuit"

  parameter Boolean use_priSen = true
    "True: Use temperature sensors in primary and secondary circuits for speed control;
    False: Use temperature sensors at boiler supply and in secondary circuit for speed control";

  parameter Integer nBoi
    "Total number of boilers";

  parameter Integer nPum
    "Total number of hot water pumps"
    annotation(Dialog(group="Pump parameters"));

  parameter Integer numIgnReq=0
    "Number of ignored requests"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real boiDesFlo[nBoi]
    "Vector of design flowrates for all boilers in plant";

  parameter Real minPumSpe(
    final unit="1",
    displayUnit="1",
    final min=0,
    final max=maxPumSpe) = 0.1
    "Minimum pump speed"
    annotation(Dialog(group="Pump parameters"));

  parameter Real maxPumSpe(
    final unit="1",
    displayUnit="1",
    final min=minPumSpe,
    final max=1) = 1
    "Maximum pump speed"
    annotation(Dialog(group="Pump parameters"));

  parameter Real delTim(
    final unit="s",
    displayUnit="s",
    final quantity="time")=900
    "Delay time"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real samPer(
    final unit="s",
    displayUnit="s",
    final quantity="time")=120
    "Sample period of component"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real triAmo(
    final unit="1",
    displayUnit="1")=-0.02
    "Trim amount"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real resAmo(
    final unit="1",
    displayUnit="1")=0.03
    "Respond amount"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real maxRes(
    final unit="1",
    displayUnit="1")=0.06
    "Maximum response per time interval"
    annotation(Dialog(group="Trim-and-Respond parameters"));

  parameter Real twoReqLimLow(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1.2
    "Lower limit of hysteresis loop sending two requests"
    annotation(Dialog(group="Hysteresis loop parameters for request generation"));

  parameter Real twoReqLimHig(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=2
    "Higher limit of hysteresis loop sending two requests"
    annotation(Dialog(group="Hysteresis loop parameters for request generation"));

  parameter Real oneReqLimLow(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=0.2
    "Lower limit of hysteresis loop sending one request"
    annotation(Dialog(group="Hysteresis loop parameters for request generation"));

  parameter Real oneReqLimHig(
    final unit="K",
    displayUnit="K",
    final quantity="TemperatureDifference")=1
    "Higher limit of hysteresis loop sending one request"
    annotation(Dialog(group="Hysteresis loop parameters for request generation"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uBoiSta[nBoi] if not use_priSen
    "Boiler status vector"
    annotation (Placement(transformation(extent={{-160,-70},{-120,-30}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHotWatPum[nPum]
    "Hot water pump status"
    annotation (Placement(transformation(extent={{-160,80},{-120,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatPri(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature") if use_priSen
    "Measured hot water temperature in primary circuit"
    annotation (Placement(transformation(extent={{-160,30},{-120,70}}),
      iconTransformation(extent={{-140,20},{-100,60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatSec(
    final unit="K",
    displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured hot water temperature in secondary circuit"
    annotation (Placement(transformation(extent={{-160,-20},{-120,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput THotWatBoiSup[nBoi](
    final unit=fill("K",nBoi),
    displayUnit=fill("K",nBoi),
    final quantity=fill("ThermodynamicTemperature",nBoi)) if not use_priSen
    "Measured hot water temperature at boiler supply"
    annotation (Placement(transformation(extent={{-160,-130},{-120,-90}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yHotWatPumSpe(
    final min=minPumSpe,
    final max=maxPumSpe,
    final unit="1",
    displayUnit="1")
    "Hot water pump speed"
    annotation (Placement(transformation(extent={{120,80},{160,120}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi1
    "Integer switch"
    annotation (Placement(transformation(extent={{40,40},{60,60}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(
    final k=fill(1, nBoi),
    final nin=nBoi) if not use_priSen
    "Weighted average of boiler supply temperatures"
    annotation (Placement(transformation(extent={{80,-90},{100,-70}})));

protected
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys(
    final uLow=twoReqLimLow,
    final uHigh=twoReqLimHig)
    "Hysteresis loop for sending two requests"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Continuous.Hysteresis hys1(
    final uLow=oneReqLimLow,
    final uHigh=oneReqLimHig)
    "Hysteresis loop for sending one request"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));

  Buildings.Controls.OBC.CDL.Integers.Switch intSwi
    "Integer switch"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-30,20},{-10,40}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt1(
    final k=0)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-30,-20},{-10,0}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt2(
    final k=2)
    "Constant integer source"
    annotation (Placement(transformation(extent={{-30,60},{-10,80}})));

  Buildings.Controls.OBC.ASHRAE.G36.Generic.TrimAndRespond triRes(
    final iniSet=maxPumSpe,
    final minSet=minPumSpe,
    final maxSet=maxPumSpe,
    final delTim=delTim,
    final samplePeriod=samPer,
    final numIgnReq=numIgnReq,
    final triAmo=triAmo,
    final resAmo=resAmo,
    final maxRes=maxRes)
    "Pump speed calculator"
    annotation (Placement(transformation(extent={{80,40},{100,60}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nBoi] if not
    use_priSen
    "Boolean to Real converter"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con[nBoi](
    final k=boiDesFlo) if not use_priSen
    "Vector of boiler design flowrates"
    annotation (Placement(transformation(extent={{-100,-90},{-80,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro1[nBoi] if not
    use_priSen
    "Vector of design flowrates only for enabled boilers; Zero for disabled boilers"
    annotation (Placement(transformation(extent={{-70,-70},{-50,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(
    final k=fill(1, nBoi),
    final nin=nBoi) if not use_priSen
    "Sum of flowrates of all enabled boilers"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Subtract sub2
    "Compare measured temperature in primary and secondary loops"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nPum)
    "Check if any hot water primary pumps are enabled"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zer(
    final k=0)
    "Constant zero"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi
    "Logical switch"
    annotation (Placement(transformation(extent={{80,90},{100,110}})));

  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaRep(
    final nout=nBoi) if not use_priSen
    "Real replicator"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Continuous.Divide div[nBoi] if not use_priSen
    "Calculate weights for average based on design flowrate"
    annotation (Placement(transformation(extent={{20,-70},{40,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.Multiply pro[nBoi] if not use_priSen
    "Calculate weighted boiler supply temperatures"
    annotation (Placement(transformation(extent={{50,-90},{70,-70}})));

  Buildings.Controls.OBC.CDL.Continuous.AddParameter addPar(
    final p=1e-6) if not use_priSen
    "Pass non-zero divisor in case sum is zero"
    annotation (Placement(transformation(extent={{-10,-100},{10,-80}})));

equation
  connect(zer.y, swi.u3)
    annotation (Line(points={{-38,80},{-34,80},{-34,92},{78,92}},
      color={0,0,127}));

  connect(swi.y,yHotWatPumSpe)
    annotation (Line(points={{102,100},{140,100}}, color={0,0,127}));

  connect(uHotWatPum, mulOr.u[1:nPum]) annotation (Line(points={{-140,100},{-102,
          100}},                   color={255,0,255}));

  connect(mulOr.y, swi.u2) annotation (Line(points={{-78,100},{78,100}},
                 color={255,0,255}));

  connect(THotWatPri,sub2. u1) annotation (Line(points={{-140,50},{-114,50},{-114,
          36},{-102,36}},   color={0,0,127}));

  connect(THotWatSec,sub2. u2) annotation (Line(points={{-140,0},{-110,0},{-110,
          24},{-102,24}},   color={0,0,127}));

  connect(sub2.y, hys.u) annotation (Line(points={{-78,30},{-70,30},{-70,50},{-62,
          50}}, color={0,0,127}));

  connect(sub2.y, hys1.u) annotation (Line(points={{-78,30},{-70,30},{-70,10},{-62,
          10}}, color={0,0,127}));

  connect(hys1.y, intSwi.u2)
    annotation (Line(points={{-38,10},{8,10}},  color={255,0,255}));

  connect(conInt.y, intSwi.u1) annotation (Line(points={{-8,30},{-4,30},{-4,18},
          {8,18}},      color={255,127,0}));

  connect(conInt1.y, intSwi.u3) annotation (Line(points={{-8,-10},{-4,-10},{-4,2},
          {8,2}},  color={255,127,0}));

  connect(hys.y, intSwi1.u2)
    annotation (Line(points={{-38,50},{38,50}}, color={255,0,255}));

  connect(intSwi.y, intSwi1.u3) annotation (Line(points={{32,10},{36,10},{36,42},
          {38,42}}, color={255,127,0}));

  connect(conInt2.y, intSwi1.u1) annotation (Line(points={{-8,70},{36,70},{36,58},
          {38,58}}, color={255,127,0}));

  connect(intSwi1.y, triRes.numOfReq) annotation (Line(points={{62,50},{68,50},{
          68,42},{78,42}}, color={255,127,0}));

  connect(mulOr.y, triRes.uDevSta) annotation (Line(points={{-78,100},{68,100},{
          68,58},{78,58}}, color={255,0,255}));

  connect(triRes.y, swi.u1) annotation (Line(points={{102,50},{110,50},{110,80},
          {70,80},{70,108},{78,108}},color={0,0,127}));

  connect(uBoiSta, booToRea.u)
    annotation (Line(points={{-140,-50},{-102,-50}}, color={255,0,255}));

  connect(booToRea.y, pro1.u1) annotation (Line(points={{-78,-50},{-74,-50},{-74,
          -54},{-72,-54}}, color={0,0,127}));

  connect(con.y, pro1.u2) annotation (Line(points={{-78,-80},{-74,-80},{-74,-66},
          {-72,-66}}, color={0,0,127}));

  connect(reaRep.y, div.u2) annotation (Line(points={{42,-90},{44,-90},{44,-74},
          {16,-74},{16,-66},{18,-66}},
                     color={0,0,127}));

  connect(pro1.y, div.u1) annotation (Line(points={{-48,-60},{-46,-60},{-46,-54},
          {18,-54}}, color={0,0,127}));

  connect(div.y, pro.u1) annotation (Line(points={{42,-60},{46,-60},{46,-74},{48,
          -74}}, color={0,0,127}));

  connect(THotWatBoiSup, pro.u2) annotation (Line(points={{-140,-110},{46,-110},
          {46,-86},{48,-86}}, color={0,0,127}));

  connect(mulSum1.u[1:nBoi], pro.y) annotation (Line(points={{78,-80},{76,-80},{76,
          -80},{72,-80}}, color={0,0,127}));

  connect(mulSum1.y,sub2. u1) annotation (Line(points={{102,-80},{110,-80},{110,
          -30},{-114,-30},{-114,36},{-102,36}}, color={0,0,127}));

  connect(mulSum.y, addPar.u)
    annotation (Line(points={{-18,-90},{-12,-90}}, color={0,0,127}));
  connect(reaRep.u, addPar.y)
    annotation (Line(points={{18,-90},{12,-90}}, color={0,0,127}));
  connect(pro1.y, mulSum.u[1:nBoi]) annotation (Line(points={{-48,-60},{-46,-60},
          {-46,-90},{-42,-90}},
                           color={0,0,127}));

annotation (
  defaultComponentName="hotPumSpe",
  Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
  graphics={
    Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,127},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(
      extent={{-100,150},{100,110}},
      textColor={0,0,255},
      textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
Documentation(info="<html>
<p>
Block that outputs hot water pump speed setpoint for primary-secondary plants with
variable-speed primary pumps where the temperature sensors are present in the primary
and secondary loops, or in the secondary loop and at the boiler supply, according
to ASHRAE RP-1711, March, 2020 draft, sections 5.3.6.14, 5.3.6.15 and 5.3.6.16.
</p>
<p>
When any hot water pump is proven on, <code>uHotWatPum = true</code>, 
pump speed will be controlled by a Trim-and-Respond logic controller. The number
of requests to the controller is calculated as follows:
</p>
<ul>
<li>
When the difference between the primary loop temperature <code>THotWatPri</code>
and the secondary loop temperature <code>THotWatSec</code> is greater than
<code>twoReqLimHig</code>, 2 requests are sent to the controller until the difference
is less than <code>twoReqLimLow</code>.
</li>
<li>
When the difference between <code>THotWatPri</code> and <code>THotWatSec</code> 
is greater than <code>oneReqLimHig</code>, 1 request is sent to the controller
until the difference is less than <code>oneReqLimLow</code>.
</li>
</ul>
<p>
When there is no single temperature sensor in the primary loop and instead there
are temperature sensors at each boiler supply outlet <code>THotWatBoiSup</code>,
<code>use_priSen = false</code>, the primary loop temperature is
calculated as the weighted average of <code>THotWatBoiSup</code>, weighted by the
boiler design flowrates <code>boiDesFlo</code> of the enabled boilers
<code>uBoiSta</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 4, 2020, by Karthik Devaprasad:<br/>
First implementation.
</li>
</ul>
</html>"));
end Speed_temperature;
