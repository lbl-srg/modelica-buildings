within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant;
block TowerFan "Sequences to control cooling tower fan"
  parameter Integer num = 2
    "Total number of CW pumps";
  parameter Modelica.SIunits.TemperatureDifference dTAboSet = 0.55
    "Threshold value of CWRT above its setpoint";
  parameter Real minFanSpe
    "Minimum fan speed";
  parameter Modelica.SIunits.Time tMinFanSpe = 300
    "Threshold duration time of fan at minimum speed";
  parameter Modelica.SIunits.Time tFanOffMin = 180
    "Minimum fan cycle off time";
  parameter Buildings.Controls.OBC.CDL.Types.SimpleController controllerTypeFan=
    Buildings.Controls.OBC.CDL.Types.SimpleController.PI
    "Type of controller"
    annotation(Dialog(group="Fan controller"));
  parameter Real kFan(final unit="1")=0.5
    "Gain of controller for fan control"
    annotation(Dialog(group="Fan controller"));
  parameter Modelica.SIunits.Time TiFan=300
    "Time constant of integrator block for fan control"
    annotation(Dialog(group="Fan controller",
    enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PI
        or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));
  parameter Modelica.SIunits.Time TdFan=0.1
    "Time constant of derivative block for fan control"
    annotation (Dialog(group="Fan controller",
      enable=controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PD
          or controllerTypeFan == Buildings.Controls.OBC.CDL.Types.SimpleController.PID));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TChiWatSup(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured chilled water supply temperature"
    annotation (Placement(transformation(extent={{-220,20},{-180,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput TConWatRet(
    final unit="K",
    final quantity="ThermodynamicTemperature")
    "Measured condenser water return temperature"
    annotation (Placement(transformation(extent={{-220,50},{-180,90}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[num]
    "Condenser water pumps status"
    annotation (Placement(transformation(extent={{-220,80},{-180,120}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput uFanSpe(
    final unit="1",
    final min=0,
    final max=1) "Current tower fan speed"
    annotation (Placement(transformation(extent={{-220,-70},{-180,-30}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealInput dTRef(
    final unit="K",
    final quantity="TemperatureDifference")
    "Chiller LIFT"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yFanSpe(
     final unit="1",
     final min=0,
     final max=1) "Fan speed"
    annotation (Placement(transformation(extent={{180,-100},{200,-80}}),
      iconTransformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yFan "Fan status"
    annotation (Placement(transformation(extent={{180,50},{200,70}}),
      iconTransformation(extent={{100,40},{120,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not CWPumSta
    "Check if there is any CW pump is ON"
    annotation (Placement(transformation(extent={{-20,90},{0,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add CWRT_Set
    "Condenser water return temperature setpoint"
    annotation (Placement(transformation(extent={{-140,10},{-120,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis risCWRT(
    final uLow=dTAboSet - 0.25,
    final uHigh=dTAboSet + 0.25)
    "CWRT rises above setpoint by 0.55 degC (1 degF) with 0.25 degC band"
    annotation (Placement(transformation(extent={{-20,40},{0,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis droCWRT(
    final uLow=-0.25,
    final uHigh=0.25)
    "CWRT drops below setpoint with 0.25 degC band"
    annotation (Placement(transformation(extent={{-20,-30},{0,-10}})));
  Buildings.Controls.OBC.CDL.Logical.And fanOn "Enable tower fans"
    annotation (Placement(transformation(extent={{20,50},{40,70}})));
  Buildings.Controls.OBC.CDL.Continuous.Hysteresis minSpe(
    final uLow=minFanSpe - 0.1,
    final uHigh=minFanSpe + 0.1)
    "Fans at minimum speed with 0.1 band"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Timer tim
    "Time the status of fan at minimum speed"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=tMinFanSpe)
    "Check if fans have been at minimum speed for 5 minutes"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
  Buildings.Controls.OBC.CDL.Logical.And fanOff "Cycle off fans"
    annotation (Placement(transformation(extent={{20,-30},{40,-10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueHoldWithReset truHol(
    final duration=tFanOffMin)
    "Fans hold OFF for at least 3 minuts"
    annotation (Placement(transformation(extent={{60,-30},{80,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPID(
    final controllerType=controllerTypeFan,
    final k=kFan,
    final Ti=TiFan,
    final Td=TdFan,
    final yMax=1,
    final yMin=0,
    u_s(final unit="K", displayUnit="degC"),
    u_m(final unit="K", displayUnit="degC"),
    final reverseAction=true)
    "Fan speed controller"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));
  Buildings.Controls.OBC.CDL.Logical.Switch swi
    "Fan speed switch according to fan status"
    annotation (Placement(transformation(extent={{140,-100},{160,-80}})));
  Buildings.Controls.OBC.CDL.Logical.LogicalSwitch logSwi
    "Switch fan on and off"
    annotation (Placement(transformation(extent={{120,50},{140,70}})));

protected
  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(final nu=num)
    "Logical and"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1[num] "Logical not"
    annotation (Placement(transformation(extent={{-140,90},{-120,110}})));
  Buildings.Controls.OBC.CDL.Continuous.Add difCWRT(final k2=-1)
    "Difference from CWRT and its setpoint"
    annotation (Placement(transformation(extent={{-100,40},{-80,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai(final k=-1)
    "Gain with factor -1"
    annotation (Placement(transformation(extent={{-60,-30},{-40,-10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(final k=0)
    "Fan speed when fan off"
    annotation (Placement(transformation(extent={{80,-120},{100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con1(final k=false)
    "Fan OFF status"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));

equation
  connect(not1.y, mulAnd.u)
    annotation (Line(points={{-119,100},{-102,100}},color={255,0,255}));
  connect(uConWatPum, not1.u)
    annotation (Line(points={{-200,100},{-142,100}}, color={255,0,255}));
  connect(TChiWatSup, CWRT_Set.u1)
    annotation (Line(points={{-200,40},{-160,40},{-160,26},{-142,26}},
      color={0,0,127}));
  connect(dTRef, CWRT_Set.u2)
    annotation (Line(points={{-200,0},{-160,0},{-160,14},{-142,14}},
      color={0,0,127}));
  connect(difCWRT.y, risCWRT.u)
    annotation (Line(points={{-79,50},{-22,50}}, color={0,0,127}));
  connect(TConWatRet, difCWRT.u1)
    annotation (Line(points={{-200,70},{-170,70},{-170,56},{-102,56}},
      color={0,0,127}));
  connect(CWRT_Set.y, difCWRT.u2)
    annotation (Line(points={{-119,20},{-110,20},{-110,44},{-102,44}},
      color={0,0,127}));
  connect(difCWRT.y, gai.u)
    annotation (Line(points={{-79,50},{-70,50},{-70,-20},{-62,-20}},
      color={0,0,127}));
  connect(gai.y, droCWRT.u)
    annotation (Line(points={{-39,-20},{-22,-20}}, color={0,0,127}));
  connect(CWPumSta.y, fanOn.u1)
    annotation (Line(points={{1,100},{10,100},{10,60},{18,60}},
      color={255,0,255}));
  connect(risCWRT.y, fanOn.u2)
    annotation (Line(points={{1,50},{10,50},{10,52},{18,52}},
      color={255,0,255}));
  connect(uFanSpe, minSpe.u)
    annotation (Line(points={{-200,-50},{-142,-50}}, color={0,0,127}));
  connect(minSpe.y, tim.u)
    annotation (Line(points={{-119,-50},{-102,-50}}, color={255,0,255}));
  connect(tim.y, greEquThr.u)
    annotation (Line(points={{-79,-50},{-62,-50}}, color={0,0,127}));
  connect(droCWRT.y, fanOff.u1)
    annotation (Line(points={{1,-20},{18,-20}},
      color={255,0,255}));
  connect(greEquThr.y, fanOff.u2)
    annotation (Line(points={{-39,-50},{10,-50},{10,-28},{18,-28}},
      color={255,0,255}));
  connect(fanOff.y, truHol.u)
    annotation (Line(points={{41,-20},{59,-20}}, color={255,0,255}));
  connect(TConWatRet, conPID.u_m)
    annotation (Line(points={{-200,70},{-170,70},{-170,-110},{30,-110},{30,-102}},
      color={0,0,127}));
  connect(CWRT_Set.y, conPID.u_s)
    annotation (Line(points={{-119,20},{-110,20},{-110,-90},{18,-90}},
      color={0,0,127}));
  connect(conPID.y, swi.u1)
    annotation (Line(points={{41,-90},{80,-90},{80,-82},{138,-82}},
      color={0,0,127}));
  connect(con.y, swi.u3)
    annotation (Line(points={{101,-110},{120,-110},{120,-98},{138,-98}},
      color={0,0,127}));
  connect(swi.y, yFanSpe)
    annotation (Line(points={{161,-90},{190,-90}}, color={0,0,127}));
  connect(mulAnd.y, CWPumSta.u)
    annotation (Line(points={{-78.3,100},{-22,100}}, color={255,0,255}));
  connect(truHol.y, logSwi.u2)
    annotation (Line(points={{81,-20},{100,-20},{100,60},{118,60}},
      color={255,0,255}));
  connect(fanOn.y, logSwi.u3)
    annotation (Line(points={{41,60},{60,60},{60,52},{118,52}},
      color={255,0,255}));
  connect(con1.y, logSwi.u1)
    annotation (Line(points={{81,90},{100,90},{100,68},{118,68}},
      color={255,0,255}));
  connect(logSwi.y, yFan)
    annotation (Line(points={{141,60},{190,60}}, color={255,0,255}));
  connect(logSwi.y, swi.u2)
    annotation (Line(points={{141,60},{160,60},{160,-40},{120,-40},{120,-90},
      {138,-90}}, color={255,0,255}));

annotation (
  defaultComponentName = "towFan",
  Diagram(coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-120},{180,120}}), graphics={
        Rectangle(
          extent={{-178,118},{58,2}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Rectangle(
          extent={{-178,-2},{98,-58}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{26,116},{56,104}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Enable fan"),
        Text(
          extent={{-156,-6},{-120,-18}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Cycle off fan"),
        Rectangle(
          extent={{2,-62},{178,-118}},
          lineColor={0,0,0},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{4,-62},{56,-76}},
          lineColor={0,0,255},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          horizontalAlignment=TextAlignment.Right,
          textString="Modulate fan speed")}),
    Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name"),
        Text(
          extent={{-96,88},{-36,74}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uConWatPum"),
        Text(
          extent={{-104,48},{-64,36}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="LIFT"),
        Text(
          extent={{-96,14},{-38,-10}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TChiWatSup"),
        Text(
          extent={{-96,-26},{-42,-48}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="TConWatRet"),
        Text(
          extent={{-98,-70},{-48,-84}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="uFanSpe"),
        Text(
          extent={{68,58},{102,46}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFan"),
        Text(
          extent={{56,-42},{96,-54}},
          lineColor={0,0,127},
          pattern=LinePattern.Dash,
          textString="yFanSpe")}),
Documentation(info="<html>
<p>
Block that output cooling tower fan status <code>yFan</code> and speed 
<code>yFanSpe</code> according to ASHRAE Fundamentals of Chilled Water Plant 
Design and Control SDL, Chapter 7, Appendix B, 1.01.B.11.
</p>
<p>
a. Fans are controlled off of CW return temperature (leaving chiller) 
<code>TConWatRet</code>.
</p>
<p>
b. Tower fans are enabled when any CW pump is proven on and <code>TConWatRet</code>
rises above setpoint by 1 &deg;F (0.55  &deg;C).
</p>
<p>
c. If <code>TConWatRet</code> drops below setpoint and fans have been at minimum
speed <code>minFanSpe</code> for 5 minuntes (<code>tMinFanSpe</code>), fans
shall cycle off for at least 3 minutes (<code>tFanOffMin</code>) and until 
<code>TConWatRet</code> rises above setpoint by 1 &deg;F (0.55  &deg;C).
</p>
<p>
d. Condenser water return temperature setpoint shall be sum of <code>TChiWatSup</code>
and <code>dTRef</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
March 05, 2018, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end TowerFan;
