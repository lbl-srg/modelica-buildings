within Buildings.Controls.OBC.RooftopUnits.CompressorDR;
block CompressorDR
  "Sequences to control compressor speed for demand reponse"

  parameter Real kDR1(
    final min=0,
    final max=1)=0.9
    "Constant compressor speed gain at demand-limit Level 1"
    annotation (Dialog(group="Compressor DR parameters"));

  parameter Real kDR2(
    final min=0,
    final max=1)=0.85
    "Constant compressor speed gain at demand-limit Level 2"
    annotation (Dialog(group="Compressor DR parameters"));

  parameter Real kDR3(
    final min=0,
    final max=1)=0.8
    "Constant compressor speed gain at demand-limit Level 3"
    annotation (Dialog(group="Compressor DR parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uComSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Current ompressor speed"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

protected
  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,74},{-28,94}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev1(
    final k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,74},{-68,94}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev2(
    final k=2)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,34},{-68,54}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev3(
    final k=3)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,-6},{-68,14}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,34},{-28,54}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,-6},{-28,14}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    final k=kDR1)
    "Constant gain"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Logic Switch"
    annotation (Placement(transformation(extent={{80,74},{100,94}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Logic Switch"
    annotation (Placement(transformation(extent={{40,34},{60,54}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Logic Switch"
    annotation (Placement(transformation(extent={{0,-6},{20,14}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(
    final k=kDR2)
    "Constant gain"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(
    final k=kDR3)
    "Constant gain"
    annotation (Placement(transformation(extent={{-48,-100},{-28,-80}})));

equation
  connect(conIntDemLev1.y, intEqu1.u1)
    annotation (Line(points={{-66,84},{-50,84}}, color={255,127,0}));
  connect(conIntDemLev2.y, intEqu2.u1)
    annotation (Line(points={{-66,44},{-50,44}},   color={255,127,0}));
  connect(conIntDemLev3.y, intEqu3.u1)
    annotation (Line(points={{-66,4},{-50,4}},     color={255,127,0}));
  connect(uDemLimLev, intEqu1.u2) annotation (Line(points={{-140,60},{-100,60},{
          -100,64},{-60,64},{-60,76},{-50,76}}, color={255,127,0}));
  connect(uDemLimLev, intEqu2.u2) annotation (Line(points={{-140,60},{-100,60},{
          -100,24},{-60,24},{-60,36},{-50,36}},     color={255,127,0}));
  connect(uDemLimLev, intEqu3.u2) annotation (Line(points={{-140,60},{-100,60},{
          -100,-14},{-60,-14},{-60,-4},{-50,-4}},   color={255,127,0}));
  connect(uComSpe, gai1.u) annotation (Line(points={{-140,-60},{-60,-60},{-60,-30},
          {38,-30}},  color={0,0,127}));
  connect(intEqu3.y, swi3.u2)
    annotation (Line(points={{-26,4},{-2,4}},        color={255,0,255}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-26,44},{38,44}},
                     color={255,0,255}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-26,84},{78,84}},
                    color={255,0,255}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{62,44},{74,44},{74,76},{78,76}},
                                                          color={0,0,127}));
  connect(swi3.y, swi2.u3)
    annotation (Line(points={{22,4},{34,4},{34,36},{38,36}},color={0,0,127}));
  connect(gai1.y, swi1.u1) annotation (Line(points={{62,-30},{68,-30},{68,92},{78,
          92}}, color={0,0,127}));
  connect(gai2.y, swi2.u1) annotation (Line(points={{22,-60},{28,-60},{28,52},{38,
          52}},                    color={0,0,127}));
  connect(gai3.y, swi3.u1) annotation (Line(points={{-26,-90},{-20,-90},{-20,12},
          {-2,12}},                color={0,0,127}));
  connect(uComSpe, swi3.u3) annotation (Line(points={{-140,-60},{-100,-60},{-100,
          -20},{-10,-20},{-10,-4},{-2,-4}}, color={0,0,127}));
  connect(uComSpe, gai3.u) annotation (Line(points={{-140,-60},{-60,-60},{-60,-90},
          {-50,-90}},color={0,0,127}));
  connect(gai2.u, uComSpe)
    annotation (Line(points={{-2,-60},{-140,-60}},color={0,0,127}));
  connect(swi1.y, yComSpe) annotation (Line(points={{102,84},{110,84},{110,0},{140,
          0}},      color={0,0,127}));

  annotation (
    defaultComponentName="ComSpeDR",
    Icon(coordinateSystem(preserveAspectRatio=false,
      extent={{-100,-100},{100,100}}),
        graphics={
          Rectangle(
            extent={{-100,-100},{100,100}},
            lineColor={0,0,127},
            fillColor={255,255,255},
            fillPattern=FillPattern.Solid),
          Text(
            extent={{-100,100},{100,100}},
            textColor={0,0,255}),
          Text(
            extent={{-94,-50},{-42,-70}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="uComSpe"),
          Text(
            extent={{-94,72},{-24,48}},
            textColor={255,127,0},
            textString="uDemLimLev"),
          Text(
            extent={{46,8},{96,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
            textString="yComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
  Documentation(info="<html>
  <p>
  This is a control module for adjusting compressor speed in response to demand response. 
  The control module is operated as follows: 
  </p>
  <ul>
  <li>
  Reduce the compressor speed to <code>kDR1</code> at demand-limit Level 1 <code>conIntDemLev1</code>.
  </li>
  <li>
  Reduce the compressor speed to <code>kDR2</code> at demand-limit Level 2 <code>conIntDemLev2</code>.
  </li>
  <li>
  Reduce the compressor speed to <code>kDR3</code> at demand-limit Level 3 <code>conIntDemLev3</code>.
  </li>
  </ul>
  </html>", revisions="<html>
  <ul>
  <li>
  August 8, 2023, by Junke Wang and Karthik Devaprasad:<br/>
  First implementation.
  </li>
  </ul>
  </html>"));
end CompressorDR;
