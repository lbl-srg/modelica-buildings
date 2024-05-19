within Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic;
block PlantEnable
  "Sequence to enable/disable boiler plant based on heating hot-water requirements"

  parameter Integer nIgnReq(
    final min=0) = 0
    "Number of hot-water requests to be ignored before enablng boiler plant loop";

  parameter Real TOutLoc(
    final unit="K",
    final displayUnit="K") = 300
    "Boiler lock-out temperature for outdoor air";

  parameter Real plaOffThrTim(
    final unit="s",
    final displayUnit="s") = 900
    "Minimum time for which the plant has to stay off once it has been disabled";

  parameter Real plaOnThrTim(
    final unit="s",
    final displayUnit="s") = plaOffThrTim
    "Minimum time for which the boiler plant has to stay on once it has been enabled";

  parameter Real staOnReqTim(
    final unit="s",
    final displayUnit="s") = 180
    "Time-limit for receiving hot-water requests to maintain enabled plant on";

  parameter Real locDt(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature") = 1
    "Temperature deadband for boiler lockout"
    annotation (Dialog(tab="Advanced"));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uSchEna
    "Signal indicating if schedule allows plant to be enabled"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput supResReq
    "Number of heating hot-water requests"
    annotation (Placement(transformation(extent={{-200,30},{-160,70}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput TOut(
    final unit="K",
    final displayUnit="K",
    final quantity="ThermodynamicTemperature")
    "Measured outdoor air temperature"
    annotation (Placement(transformation(extent={{-200,-40},{-160,0}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim(t=plaOnThrTim)
    "Time since plant has been enabled"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim2(t=plaOffThrTim)
    "Time since plant has been disabled"
    annotation (Placement(transformation(extent={{10,60},{30,80}})));

protected
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai(
    final k=-1)
    "Invert signal for subtraction"
    annotation (Placement(transformation(extent={{-152,-30},{-132,-10}})));

  Buildings.Controls.OBC.CDL.Integers.GreaterThreshold intGreThr(
    final t=nIgnReq)
    "Check if number of requests is greater than number of requests to be ignored"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));

  Buildings.Controls.OBC.CDL.Logical.Latch lat
    "Maintain plant status till the conditions to change it are met"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));

  Buildings.Controls.OBC.CDL.Logical.MultiAnd mulAnd(
    final nin=4)
    "Check if all the conditions for enabling plant have been met"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));

  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=3)
    "Check if any conditions except plant-on time have been satisfied to disable plant"
    annotation (Placement(transformation(extent={{30,-80},{50,-60}})));

  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if all conditions have been met to disable the plant"
    annotation (Placement(transformation(extent={{80,-40},{100,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Logical Not"
    annotation (Placement(transformation(extent={{-10,-120},{10,-100}})));

  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(
    final p=TOutLoc)
    "Compare measured outdoor air temperature to boiler lockout temperature"
    annotation (Placement(transformation(extent={{-120,-30},{-100,-10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys(
    final uLow=-locDt,
    final uHigh=0)
    "Hysteresis loop to prevent cycling caused by measured value"
    annotation (Placement(transformation(extent={{-120,-60},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Logical.Not not3
    "Logical Not"
    annotation (Placement(transformation(extent={{-70,-40},{-50,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1(t=staOnReqTim)
    "Time since number of requests was greater than number of ignores"
    annotation (Placement(transformation(extent={{-40,-40},{-20,-20}})));

  Buildings.Controls.OBC.CDL.Logical.Not not4
    "Logical Not"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1
    "Logical pre block"
    annotation (Placement(transformation(extent={{-60,40},{-40,60}})));

  Buildings.Controls.OBC.CDL.Logical.Not not2
    "Logical Not"
    annotation (Placement(transformation(extent={{-10,-80},{10,-60}})));

equation
  connect(yPla, yPla)
    annotation (Line(points={{180,0},{180,0}}, color={255,0,255}));
  connect(hys.u, addPar.y) annotation (Line(points={{-122,-50},{-128,-50},{-128,
          -34},{-96,-34},{-96,-20},{-98,-20}},                              color={0,0,127}));
  connect(not3.y, tim1.u)
    annotation (Line(points={{-48,-30},{-42,-30}}, color={255,0,255}));
  connect(not4.y, tim2.u)
    annotation (Line(points={{2,70},{8,70}}, color={255,0,255}));
  connect(not2.u, hys.y) annotation (Line(points={{-12,-70},{-20,-70},{-20,-50},
  {-98,-50}}, color={255,0,255}));
  connect(intGreThr.y, not3.u) annotation (Line(points={{-98,50},{-80,50},{-80,-30},
  {-72,-30}}, color={255,0,255}));
  connect(pre1.y, not4.u) annotation (Line(points={{-38,50},{-30,50},{-30,70},{-22,
  70}}, color={255,0,255}));
  connect(hys.y, mulAnd.u[1]) annotation (Line(points={{-98,-50},{-86,-50},{-86,
          125.25},{78,125.25}}, color={255,0,255}));
  connect(intGreThr.y, mulAnd.u[2]) annotation (Line(points={{-98,50},{-80,50},{
          -80,121.75},{78,121.75}}, color={255,0,255}));
  connect(mulAnd.y, lat.u) annotation (Line(points={{102,120},{110,120},{110,0},
          {118,0}}, color={255,0,255}));
  connect(and2.y, lat.clr) annotation (Line(points={{102,-30},{110,-30},{110,-6},
          {118,-6}}, color={255,0,255}));
  connect(not2.y, mulOr.u[1]) annotation (Line(points={{12,-70},{20,-70},{20,
          -65.3333},{28,-65.3333}},
                     color={255,0,255}));
  connect(not1.y, mulOr.u[2]) annotation (Line(points={{12,-110},{20,-110},{20,-70},
          {28,-70}},      color={255,0,255}));
  connect(mulOr.y, and2.u2) annotation (Line(points={{52,-70},{70,-70},{70,-38},
          {78,-38}}, color={255,0,255}));
  connect(intGreThr.u, supResReq)
    annotation (Line(points={{-122,50},{-180,50}}, color={255,127,0}));
  connect(lat.y, yPla)
    annotation (Line(points={{142,0},{180,0}}, color={255,0,255}));
  connect(lat.y, pre1.u) annotation (Line(points={{142,0},{150,0},{150,30},{-70,
          30},{-70,50},{-62,50}}, color={255,0,255}));
  connect(pre1.y, tim.u) annotation (Line(points={{-38,50},{-30,50},{-30,10},{8,
          10}}, color={255,0,255}));
  connect(tim2.passed, mulAnd.u[3]) annotation (Line(points={{32,62},{40,62},{40,
          118},{78,118},{78,118.25}}, color={255,0,255}));
  connect(tim.passed, and2.u1) annotation (Line(points={{32,2},{70,2},{70,-30},{
          78,-30}}, color={255,0,255}));
  connect(tim1.passed, mulOr.u[3]) annotation (Line(points={{-18,-38},{20,-38},
          {20,-74.6667},{28,-74.6667}},color={255,0,255}));
  connect(addPar.u, gai.y)
    annotation (Line(points={{-122,-20},{-130,-20}}, color={0,0,127}));
  connect(TOut, gai.u)
    annotation (Line(points={{-180,-20},{-154,-20}}, color={0,0,127}));
  connect(uSchEna, not1.u)
    annotation (Line(points={{-180,-110},{-12,-110}}, color={255,0,255}));
  connect(uSchEna, mulAnd.u[4]) annotation (Line(points={{-180,-110},{-92,-110},
          {-92,114.75},{78,114.75}}, color={255,0,255}));
  annotation (defaultComponentName = "plaEna",
  Icon(graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=0.1),
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={28,108,200},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          lineThickness=5,
          borderPattern=BorderPattern.Raised),
        Text(
          extent={{-120,146},{100,108}},
          textColor={0,0,255},
          textString="%name"),
        Ellipse(extent={{-80,80},{80,-80}}, lineColor={28,108,200},fillColor={170,255,213},
          fillPattern=FillPattern.Solid),
        Ellipse(extent={{-90,90},{90,-90}}, lineColor={28,108,200}),
        Rectangle(extent={{-75,2},{75,-2}}, lineColor={28,108,200},
          fillColor={28,108,200},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-66,46},{76,10}},
          textColor={28,108,200},
          textString="START"),
        Text(
          extent={{-66,-8},{76,-44}},
          textColor={28,108,200},
          textString="STOP")},
          coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,140}})),
  Documentation(info="<html>
    <p>
    Block that generates boiler plant enable signal according to sections 5.3.2.1,
    5.3.2.2, and 5.3.2.3 in RP-1711, March 2020 draft.
    </p>
    <p>
    The boiler plant should be enabled and disabled according to the following
    conditions:
    </p>
    <ol>
    <li>
    An enabling schedule should be included to allow operators to lock out the
    boiler plant during off-hour, e.g. to allow off-hour operation of HVAC systems
    except the boiler plant. The default schedule shall be 24/7 and be adjustable.
    </li>
    <li>
    The plant should be enabled when the plant has been continuously disabled
    for at least <code>plaOffThrTim</code> and:
    <ul>
    <li>
    Number of boiler plant requests <code>supResReq</code> is greater than
    number of requests to be ignored <code>nIgnReq</code>, and,
    </li>
    <li>
    Outdoor air temperature <code>TOut</code> is lower than boiler
    lockout temperature <code>TOutLoc</code>, and,
    </li>
    <li>
    The operator defined enabling schedule <code>schTab</code> is active.
    </li>
    </ul>
    </li>
    <li>
    The plant should be disabled when it has been continuously enabled for at
    least <code>plaOnThrTim</code> and:
    <ul>
    <li>
    Number of boiler plant requests <code>supResReq</code> is less than number
    of requests to be ignored <code>nIgnReq</code> for a time
    <code>staOnReqTim</code>, or,
    </li>
    <li>
    Outdoor air temperature <code>TOut</code> is greater than boiler lockout
    temperature <code>TOutLoc</code> by <code>locDt</code> or more,ie,
    <code>TOut</code> &gt; <code>TOutLoc</code> + <code>locDt</code>, or,
    </li>
    <li>
    The operator defined enable schedule <code>schTab</code> is inactive.
    </li>
    </ul>
    </li>
    </ol>
    <p align=\"center\">
    <img alt=\"Validation plot for PlantEnable\"
    src=\"modelica://Buildings/Resources/Images/Controls/OBC/ASHRAE/PrimarySystem/BoilerPlant/Generic/PlantEnable.png\"/>
    <br/>
    Validation plot generated from model <a href=\"modelica://Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.PlantEnable\">
    Buildings.Controls.OBC.ASHRAE.PrimarySystem.BoilerPlant.Generic.Validation.PlantEnable</a>.
    </p>
    </html>",
    revisions="<html>
    <ul>
    <li>
    May 7, 2020, by Karthik Devaprasad:<br/>
    First implementation.
    </li>
    </ul>
    </html>"));
end PlantEnable;
