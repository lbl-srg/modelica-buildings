within Buildings.Controls.OBC.RooftopUnits.CompressorDR;
block CompressorDR "Compressor speed controller for demand reponse"
  extends Modelica.Blocks.Icons.Block;

  parameter Real k1=0.9
    "Constant compressor speed gain at demand-limit Level 1"
    annotation (Dialog(group="Compressor DR parameters"));

  parameter Real k2=0.85
    "Constant compressor speed gain at demand-limit Level 2"
    annotation (Dialog(group="Compressor DR parameters"));

  parameter Real k3=0.8
    "Constant compressor speed gain at demand-limit Level 3"
    annotation (Dialog(group="Compressor DR parameters"));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDemLimLev
    "Demand limit level"
    annotation (Placement(transformation(extent={{-160,-80},{-120,-40}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yComSpe(
    min=0,
    max=1,
    final unit="1")
    "Compressor commanded speed"
    annotation (Placement(transformation(extent={{120,-20},{160,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uComSpe(
    final min=0,
    final max=1,
    final unit="1")
    "Current ompressor speed"
    annotation (Placement(transformation(extent={{-160,40},{-120,80}}),
      iconTransformation(extent={{-140,40},{-100,80}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,-26},{-28,-6}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev1(
    k=1)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,-26},{-68,-6}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev2(
    k=2)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,-66},{-68,-46}})));

  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conIntDemLev3(
    k=3)
    "Constant integer"
    annotation (Placement(transformation(extent={{-88,-106},{-68,-86}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu2
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,-66},{-28,-46}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu3
    "Output true Boolean signal if two integer inputs are equal"
    annotation (Placement(transformation(extent={{-48,-106},{-28,-86}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai1(
    k=k1)
    "Constant gain"
    annotation (Placement(transformation(extent={{-8,90},{12,110}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi1
    "Logic Switch"
    annotation (Placement(transformation(extent={{80,-26},{100,-6}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi2
    "Logic Switch"
    annotation (Placement(transformation(extent={{40,-66},{60,-46}})));

  Buildings.Controls.OBC.CDL.Continuous.Switch swi3
    "Logic Switch"
    annotation (Placement(transformation(extent={{0,-106},{20,-86}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai2(k=k2)
    "Constant gain"
    annotation (Placement(transformation(extent={{-8,50},{12,70}})));

  Buildings.Controls.OBC.CDL.Continuous.MultiplyByParameter gai3(k=k3)
    "Constant gain"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));

equation
  connect(conIntDemLev1.y, intEqu1.u1)
    annotation (Line(points={{-66,-16},{-50,-16}},
                                                 color={255,127,0}));
  connect(conIntDemLev2.y, intEqu2.u1)
    annotation (Line(points={{-66,-56},{-50,-56}}, color={255,127,0}));
  connect(conIntDemLev3.y, intEqu3.u1)
    annotation (Line(points={{-66,-96},{-50,-96}}, color={255,127,0}));
  connect(uDemLimLev, intEqu1.u2) annotation (Line(points={{-140,-60},{-100,-60},
          {-100,-36},{-60,-36},{-60,-24},{-50,-24}},
                                                color={255,127,0}));
  connect(uDemLimLev, intEqu2.u2) annotation (Line(points={{-140,-60},{-100,-60},
          {-100,-76},{-60,-76},{-60,-64},{-50,-64}},color={255,127,0}));
  connect(uDemLimLev, intEqu3.u2) annotation (Line(points={{-140,-60},{-100,-60},
          {-100,-114},{-60,-114},{-60,-104},{-50,-104}},
                                                    color={255,127,0}));
  connect(uComSpe, gai1.u) annotation (Line(points={{-140,60},{-20,60},{-20,100},
          {-10,100}}, color={0,0,127}));
  connect(intEqu3.y, swi3.u2)
    annotation (Line(points={{-26,-96},{-2,-96}},    color={255,0,255}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-26,-56},{38,-56}},
                     color={255,0,255}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-26,-16},{78,-16}},
                    color={255,0,255}));
  connect(swi2.y, swi1.u3)
    annotation (Line(points={{62,-56},{70,-56},{70,-24},{78,-24}},
                                                          color={0,0,127}));
  connect(swi3.y, swi2.u3)
    annotation (Line(points={{22,-96},{30,-96},{30,-64},{38,-64}},
                                                            color={0,0,127}));
  connect(gai1.y, swi1.u1) annotation (Line(points={{14,100},{70,100},{70,-8},{78,
          -8}}, color={0,0,127}));
  connect(gai2.y, swi2.u1) annotation (Line(points={{14,60},{30,60},{30,-48},{38,
          -48}},                   color={0,0,127}));
  connect(gai3.y, swi3.u1) annotation (Line(points={{14,20},{20,20},{20,-72},{-10,
          -72},{-10,-88},{-2,-88}},color={0,0,127}));
  connect(uComSpe, swi3.u3) annotation (Line(points={{-140,60},{-20,60},{-20,-104},
          {-2,-104}},                       color={0,0,127}));
  connect(uComSpe, gai3.u) annotation (Line(points={{-140,60},{-20,60},{-20,20},
          {-10,20}}, color={0,0,127}));
  connect(gai2.u, uComSpe)
    annotation (Line(points={{-10,60},{-140,60}}, color={0,0,127}));
  connect(swi1.y, yComSpe) annotation (Line(points={{102,-16},{110,-16},{110,0},
          {140,0}}, color={0,0,127}));
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
            extent={{-94,70},{-42,50}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="uComSpe"),
       Text(extent={{-94,-48},{-24,-72}},
          textColor={255,127,0},
          textString="uDemLimLev"),
          Text(
            extent={{46,8},{96,-8}},
            textColor={0,0,127},
            pattern=LinePattern.Dash,
          textString="yComSpe")}),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-120,-120},{120,120}})));
end CompressorDR;
