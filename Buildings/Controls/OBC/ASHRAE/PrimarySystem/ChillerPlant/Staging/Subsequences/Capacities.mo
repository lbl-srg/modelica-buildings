within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities "Returns nominal and minimal capacities for calculating all operating part load ratios"

  parameter Integer nSta = 3
    "Total number of stages";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLow "Current stage is the lowest stage"
    annotation (Placement(transformation(extent={{-300,-120},{-260,-80}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHigh "Current stage is the highest stage"
    annotation (Placement(transformation(extent={{-300,-180},{-260,-140}}),
        iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-300,
            100},{-260,140}}), iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp(
    final min=0,
    final max=nSta)
    "Next higher available stage"
    annotation (Placement(transformation(extent={{
      -300,40},{-260,80}}), iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDown(
    final min=0,
    final max=nSta) "Next lower available stage"
    annotation (Placement(transformation(extent={{-300,-20},{-260,20}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));


  Buildings.Controls.OBC.CDL.Interfaces.RealInput uNomCap[nSta](
    final quantity="Power",
    final unit="W")
    "Nominal stage capacities considering the chiller availability"
    annotation (
     Placement(transformation(extent={{-300,180},{-260,220}}),
        iconTransformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinCap[nSta](
    final quantity="Power",
    final unit="W")
    "Unload stage capacities considering the chiller availability" annotation (
      Placement(transformation(extent={{-300,-240},{-260,-200}}),
        iconTransformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yNom(final unit="W", final
      quantity="Power") "Nominal capacity of the current stage" annotation (
      Placement(transformation(extent={{260,90},{280,110}}), iconTransformation(
          extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDowNom(final unit="W",
      final quantity="Power") "Nominal capacity of the first stage down"
    annotation (Placement(transformation(extent={{260,10},{280,30}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpNom(final unit="W",
      final quantity="Power") "Nominal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{260,50},{280,70}}),
        iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMin(final unit="W", final
      quantity="Power") "Minimum capacity of the current stage" annotation (
      Placement(transformation(extent={{260,-30},{280,-10}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpMin(final unit="W",
      final quantity="Power") "Minimum capacity of the next higher stage"
    annotation (Placement(transformation(extent={{260,-70},{280,-50}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

//protected
  final parameter Real small = 0.001
  "Small number to avoid division with zero";

  final parameter Real larGai = 10
  "Large gain generate number much larger than the highest stage capacity";

  Buildings.Controls.OBC.CDL.Routing.RealExtractor cap(
    allowOutOfRange=true,                              final outOfRangeValue=
        small, final nin=nSta)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-120,140},{-100,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor dowCap(
    final outOfRangeValue=small,
    final nin=nSta,
    final allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=small)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=small)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{20,70},{40,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor capMin(
    final nin=nSta,
    final outOfRangeValue=small,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{20,-100},{40,-80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2
    "Switch"
    annotation (Placement(transformation(extent={{200,60},{220,80}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4
    "Switch"
    annotation (Placement(transformation(extent={{200,-100},{220,-80}})));

  Modelica.Blocks.Logical.Switch swi1
    "Use minimum stage capacity for nominal stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=larGai)
    "To make a very large and unachievable staging up capacity if already the highest available stage"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));
equation
  connect(swi2.y, yUpNom) annotation (Line(points={{221,70},{250,70},{250,60},{
          270,60}}, color={0,0,127}));
  connect(upCap.y, swi2.u3) annotation (Line(points={{41,80},{80,80},{80,62},{
          198,62}}, color={0,0,127}));
  connect(yMin, yMin)
    annotation (Line(points={{270,-20},{270,-20}}, color={0,0,127}));
  connect(upCapMin.y, swi4.u3) annotation (Line(points={{41,-30},{50,-30},{50,
          -98},{198,-98}}, color={0,0,127}));
  connect(swi4.y, yUpMin) annotation (Line(points={{221,-90},{250,-90},{250,-60},
          {270,-60}}, color={0,0,127}));
  connect(capMin.y, yMin) annotation (Line(points={{41,-90},{100,-90},{100,-20},
          {270,-20}}, color={0,0,127}));
  connect(dowCap.y, swi1.u3) annotation (Line(points={{-79,80},{-60,80},{-60,-8},
          {98,-8}}, color={0,0,127}));
  connect(uMinCap, upCapMin.u) annotation (Line(points={{-280,-220},{-200,-220},
          {-200,-30},{18,-30}}, color={0,0,127}));
  connect(uMinCap, capMin.u) annotation (Line(points={{-280,-220},{-100,-220},{
          -100,-90},{18,-90}}, color={0,0,127}));
  connect(uNomCap, cap.u) annotation (Line(points={{-280,200},{-160,200},{-160,
          150},{-122,150}}, color={0,0,127}));
  connect(uNomCap, dowCap.u) annotation (Line(points={{-280,200},{-220,200},{
          -220,140},{-130,140},{-130,80},{-102,80}}, color={0,0,127}));
  connect(uNomCap, upCap.u) annotation (Line(points={{-280,200},{-20,200},{-20,
          80},{18,80}}, color={0,0,127}));
  connect(uLow, swi1.u2) annotation (Line(points={{-280,-100},{-140,-100},{-140,
          0},{98,0}},
               color={255,0,255}));
  connect(uHigh, swi2.u2) annotation (Line(points={{-280,-160},{160,-160},{160,
          70},{198,70}},
                     color={255,0,255}));
  connect(uHigh, swi4.u2) annotation (Line(points={{-280,-160},{160,-160},{160,
          -90},{198,-90}},
                      color={255,0,255}));
  connect(cap.y, gai.u) annotation (Line(points={{-99,150},{-70,150},{-70,120},
          {-62,120}}, color={0,0,127}));
  connect(gai.y, swi2.u1) annotation (Line(points={{-39,120},{80,120},{80,90},{
          160,90},{160,78},{198,78}},          color={0,0,127}));
  connect(gai.y, swi4.u1) annotation (Line(points={{-39,120},{60,120},{60,-82},
          {198,-82}},                color={0,0,127}));
  connect(swi1.y, yDowNom) annotation (Line(points={{121,0},{200,0},{200,20},{
          270,20}}, color={0,0,127}));
  connect(u, cap.index) annotation (Line(points={{-280,120},{-110,120},{-110,
          138}}, color={255,127,0}));
  connect(uDown, dowCap.index) annotation (Line(points={{-280,0},{-160,0},{-160,
          20},{-90,20},{-90,68}},
                                color={255,127,0}));
  connect(uUp, upCap.index) annotation (Line(points={{-280,60},{-120,60},{-120,48},
          {30,48},{30,68}},     color={255,127,0}));
  connect(uUp, upCapMin.index) annotation (Line(points={{-280,60},{-120,60},{-120,
          -52},{30,-52},{30,-42}},      color={255,127,0}));
  connect(cap.y, yNom) annotation (Line(points={{-99,150},{220,150},{220,100},{
          270,100}}, color={0,0,127}));
  connect(capMin.y, swi1.u1) annotation (Line(points={{41,-90},{80,-90},{80,8},
          {98,8}}, color={0,0,127}));
  connect(u, capMin.index) annotation (Line(points={{-280,120},{-190,120},{-190,
          -110},{30,-110},{30,-102}}, color={255,127,0}));
  annotation (defaultComponentName = "cap",
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
        Rectangle(extent={{-80,-30},{-20,-42}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-48},{-20,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-42},{-72,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-42},{-24,-48}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-10},{80,-30}}, lineColor={0,0,127}),
        Rectangle(extent={{0,-40},{80,-60}}, lineColor={0,0,127}),
        Rectangle(extent={{6,-30},{12,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{68,-30},{74,-40}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,10},{-20,-2}}, lineColor={0,0,127}),
        Rectangle(extent={{-80,-8},{-20,-20}}, lineColor={0,0,127}),
        Rectangle(extent={{-76,-2},{-72,-8}}, lineColor={0,0,127}),
        Rectangle(extent={{-28,-2},{-24,-8}}, lineColor={0,0,127})}),
                          Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-260,-240},{260,240}})),
Documentation(info="<html>
<p>
Based on the current chiller stage and nominal stage capacities returns:
</p>
<ul>
<li>
The design capacities of the current, first available higher and lower stage
</li>
<li>
The minimal capacity of the current and first higher stage
</li>
</ul>
<p>
for the purpose of calculating the operative and staging part load ratios, 
OPLR and SPLR, respectively.
</p>
<p>
If operating at the lowest available chiller stage, the minimal capacity 
of that stage is returned as the design capacity of stage 0. If operating at 
the highest stage, the design and minimal stage down conditionals are set to 
a value significantly larger than the design capacity of the highest stage.
This ensures numerical stability and satisfies the staging down conditionals.
[fixme: Milica to revise this once integrated with other subsequences.]
</p>
</html>",
revisions="<html>
<ul>
<li>
January 13, 2019, by Milica Grahovac:<br/>
First implementation.
</li>
</ul>
</html>"));
end Capacities;
