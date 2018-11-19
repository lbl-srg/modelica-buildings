within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Economizer.Subsequences;
block Tuning
  "Defines a value used to tune the economizer outlet temperature prediction"

  parameter Real step=0.02
  "Tuning step";

  parameter Modelica.SIunits.Time wseOnTimDec = 60*60
  "Economizer enable time needed to allow decrease of the tuning parameter";

  parameter Modelica.SIunits.Time wseOnTimInc = 30*60
  "Economizer enable time needed to allow increase of the tuning parameter";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uWseSta
    "Waterside economizer enable disable status"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,30},{-100,70}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uTowFanSpe
    "Waterside economizer tower fan speed"
    annotation (Placement(transformation(extent={{-220,-170},{-180,-130}}),
        iconTransformation(extent={{-140,-70},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput y(min=-0.2, max=0.5)
    "Tuning parameter for the waterside economizer outlet temperature prediction "
    annotation (Placement(transformation(extent={{180,-10},{200,10}}),
        iconTransformation(extent={{100,-10},{120,10}})));

protected
  final parameter Real initTunPar = 0
  "Initial value of the tuning parameter";

  Buildings.Controls.OBC.CDL.Logical.Timer tim "Timer"
    annotation (Placement(transformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg "Falling edge"
    annotation (Placement(transformation(extent={{-120,10},{-100,30}})));

  Buildings.Controls.OBC.CDL.Logical.And and2 "And"
    annotation (Placement(transformation(extent={{0,80},{20,100}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqual greEqu "Greater or equal than"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim(
    final k=wseOnTimDec)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant tunStep(
    final k=step) "Tuning step"
    annotation (Placement(transformation(extent={{0,120},{20,140}})));
  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam(y_start=0)
    annotation (Placement(transformation(extent={{60,100},{80,120}})));

  Buildings.Controls.OBC.CDL.Continuous.Add add2(final k1=-1) "Add"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre "Logical pre"
    annotation (Placement(transformation(extent={{-50,80},{-30,100}})));

  Buildings.Controls.OBC.CDL.Logical.Timer tim1 "Timer"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}})));

  Buildings.Controls.OBC.CDL.Logical.FallingEdge falEdg1 "Falling edge"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));

  Buildings.Controls.OBC.CDL.Logical.And3 and1 "And"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.LessEqual lesEqu "Less equal than"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant wseOnTim1(
    final k=wseOnTimInc)
    "Check if econ was on for the defined time period"
    annotation (Placement(transformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam1(
    final y_start=initTunPar) "Sampler"
    annotation (Placement(transformation(extent={{50,-30},{70,-10}})));

  Buildings.Controls.OBC.CDL.Logical.Pre pre1 "Pre"
    annotation (Placement(transformation(extent={{-50,-50},{-30,-30}})));

  Buildings.Controls.OBC.CDL.Continuous.Less lesEqu1 "Less equal"
    annotation (Placement(transformation(extent={{-120,-160},{-100,-140}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant MaxTowFanSpe(
    final k=1)
    "Maximal tower fan speed"
    annotation (Placement(transformation(extent={{-160,-190},{-140,-170}})));

  Buildings.Controls.OBC.CDL.Discrete.TriggeredSampler triSam2(
    final y_start=0) "Sampler"
    annotation (Placement(transformation(extent={{-40,-140},{-20,-120}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant Zero(
    final k=0)
    "Minimal tower fan speed"
    annotation (Placement(transformation(extent={{-120,-210},{-100,-190}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi "Logical switch"
    annotation (Placement(transformation(extent={{-74,-200},{-54,-180}})));

  Buildings.Controls.OBC.CDL.Continuous.GreaterEqualThreshold greEquThr(
    final threshold=0.5)
    annotation (Placement(transformation(extent={{0,-140},{20,-120}})));

equation
  connect(uWseSta, tim.u)
    annotation (Line(points={{-200,60},{-160,60},{-160,90},{-122,90}},
                                                     color={255,0,255}));
  connect(uWseSta, falEdg.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          20},{-122,20}},color={255,0,255}));
  connect(greEqu.u2, wseOnTim.y) annotation (Line(points={{-82,82},{-90,82},{-90,
          60},{-99,60}}, color={0,0,127}));
  connect(tim.y, greEqu.u1)
    annotation (Line(points={{-99,90},{-82,90}},   color={0,0,127}));
  connect(triSam.u, tunStep.y) annotation (Line(points={{58,110},{40,110},{40,130},
          {21,130}},color={0,0,127}));
  connect(triSam.y, add2.u1) annotation (Line(points={{81,110},{90,110},{90,6},{
          98,6}},
                color={0,0,127}));
  connect(add2.y, y)
    annotation (Line(points={{121,0},{190,0}}, color={0,0,127}));
  connect(and2.y, triSam.trigger)
    annotation (Line(points={{21,90},{70,90},{70,98.2}}, color={255,0,255}));
  connect(falEdg.y, and2.u2) annotation (Line(points={{-99,20},{-20,20},{-20,82},
          {-2,82}}, color={255,0,255}));
  connect(greEqu.y, pre.u)
    annotation (Line(points={{-59,90},{-52,90}}, color={255,0,255}));
  connect(and2.u1, pre.y)
    annotation (Line(points={{-2,90},{-29,90}}, color={255,0,255}));
  connect(uWseSta, tim1.u) annotation (Line(points={{-200,60},{-160,60},{-160,-40},
          {-122,-40}}, color={255,0,255}));
  connect(uWseSta, falEdg1.u) annotation (Line(points={{-200,60},{-160,60},{-160,
          -110},{-122,-110}},
                        color={255,0,255}));
  connect(lesEqu.u2, wseOnTim1.y) annotation (Line(points={{-82,-48},{-90,-48},{
          -90,-70},{-99,-70}}, color={0,0,127}));
  connect(tim1.y, lesEqu.u1)
    annotation (Line(points={{-99,-40},{-82,-40}}, color={0,0,127}));
  connect(and1.y, triSam1.trigger) annotation (Line(points={{41,-40},{60,-40},{60,
          -31.8}}, color={255,0,255}));
  connect(falEdg1.y, and1.u2) annotation (Line(points={{-99,-110},{-10,-110},{
          -10,-40},{18,-40}},
                          color={255,0,255}));
  connect(lesEqu.y, pre1.u)
    annotation (Line(points={{-59,-40},{-52,-40}}, color={255,0,255}));
  connect(and1.u1, pre1.y) annotation (Line(points={{18,-32},{-20,-32},{-20,-40},
          {-29,-40}}, color={255,0,255}));
  connect(tunStep.y, triSam1.u) annotation (Line(points={{21,130},{40,130},{40,-20},
          {48,-20}}, color={0,0,127}));
  connect(uTowFanSpe, lesEqu1.u1)
    annotation (Line(points={{-200,-150},{-122,-150}}, color={0,0,127}));
  connect(MaxTowFanSpe.y, lesEqu1.u2) annotation (Line(points={{-139,-180},{-130,
          -180},{-130,-158},{-122,-158}}, color={0,0,127}));
  connect(lesEqu1.y, triSam2.trigger) annotation (Line(points={{-99,-150},{-90,-150},
          {-90,-170},{-30,-170},{-30,-141.8}}, color={255,0,255}));
  connect(lesEqu.y, swi.u2) annotation (Line(points={{-59,-40},{-54,-40},{-54,-80},
          {-86,-80},{-86,-190},{-76,-190}},
                                  color={255,0,255}));
  connect(MaxTowFanSpe.y, swi.u1) annotation (Line(points={{-139,-180},{-88,
          -180},{-88,-182},{-76,-182}},
                                  color={0,0,127}));
  connect(swi.y, triSam2.u) annotation (Line(points={{-53,-190},{-50,-190},{-50,
          -130},{-42,-130}}, color={0,0,127}));
  connect(triSam2.y, greEquThr.u)
    annotation (Line(points={{-19,-130},{-2,-130}}, color={0,0,127}));
  connect(greEquThr.y, and1.u3) annotation (Line(points={{21,-130},{30,-130},{30,
          -72},{10,-72},{10,-48},{18,-48}}, color={255,0,255}));
  connect(triSam1.y, add2.u2) annotation (Line(points={{71,-20},{90,-20},{90,-6},
          {98,-6}}, color={0,0,127}));
  connect(Zero.y, swi.u3) annotation (Line(points={{-99,-200},{-88,-200},{-88,
          -198},{-76,-198}}, color={0,0,127}));
  annotation (defaultComponentName = "wseTun",
        Icon(graphics={
        Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Text(
          extent={{-120,146},{100,108}},
          lineColor={0,0,255},
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-180,-220},{180,180}})),
Documentation(info="<html>
<p>
Waterside economizer outlet temperature prediction tuning parameter subsequence 
per OBC Chilled Water Plant Sequence of Operation, section 3.2.3.3. The parameter
is increased or decreased in a <code>step</code> depending on how long the
the economizer remained enabled and the value of the cooling tower fan speed signal 
<code>uTowFanSpe</code>.
</p>
</html>",
revisions="<html>
<ul>
<li>
October 13, 2018, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Tuning;
