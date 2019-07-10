within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Staging.Subsequences;
block Capacities
  "Returns nominal and minimal stage capacities required for calculating operating and stage part load ratios"

  parameter Integer nSta = 3
    "Total number of stages";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uLow
    "Current stage is the lowest stage"
    annotation (Placement(transformation(extent={{-240,-80},{-200,-40}}),
        iconTransformation(extent={{-120,-100},{-100,-80}})));

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uHig
    "Current stage is the highest stage" annotation (Placement(transformation(
    extent={{-240,-140},{-200,-100}}), iconTransformation(extent={{-120,-80},{-100,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput u(
    final min=0,
    final max=nSta) "Chiller stage"
    annotation (Placement(transformation(extent={{-240,100},{-200,140}}),
                           iconTransformation(extent={{-120,20},{-100,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uUp(
    final min=0,
    final max=nSta)
    "Next higher available stage"
    annotation (Placement(transformation(extent={{-240,40},{-200,80}}),
      iconTransformation(extent={{-120,0},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uDown(
    final min=0,
    final max=nSta) "Next lower available stage"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
      iconTransformation(extent={{-120,-20},{-100,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uDesCap[nSta](
    final quantity="Power",
    final unit="W") "Design stage capacities"
    annotation (
     Placement(transformation(extent={{-240,160},{-200,200}}),
        iconTransformation(extent={{-120,80},{-100,100}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput uMinCap[nSta](
    final quantity="Power",
    final unit="W") "Unload stage capacities" annotation (
      Placement(transformation(extent={{-240,-200},{-200,-160}}),
        iconTransformation(extent={{-120,60},{-100,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yNom(
      final unit="W",
      final quantity="Power") "Nominal capacity of the current stage"
      annotation (Placement(transformation(extent={{200,140},{220,160}}),
        iconTransformation(extent={{100,60},{120,80}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yDowNom(
      final unit="W",
      final quantity="Power") "Nominal capacity of the first stage down"
      annotation (Placement(transformation(extent={{200,10},{220,30}}),
        iconTransformation(extent={{100,-20},{120,0}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpNom(
      final unit="W",
      final quantity="Power") "Nominal capacity of the next higher stage"
      annotation (Placement(transformation(extent={{200,50},{220,70}}),
        iconTransformation(extent={{100,20},{120,40}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yMin(
      final unit="W",
      final quantity="Power") "Minimum capacity of the current stage"
      annotation (Placement(transformation(extent={{200,-30},{220,-10}}),
        iconTransformation(extent={{100,-80},{120,-60}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput yUpMin(
      final unit="W",
      final quantity="Power") "Minimum capacity of the next higher stage"
      annotation (Placement(transformation(extent={{200,-100},{220,-80}}),
        iconTransformation(extent={{100,-60},{120,-40}})));

protected
  final parameter Real small = 0.001
  "Small number to avoid division with zero";

  final parameter Real larGai = 10
  "Large gain";

  Buildings.Controls.OBC.CDL.Routing.RealExtractor cap(
    final nin=nSta,
    final outOfRangeValue=small,
    final allowOutOfRange=true)
    "Extracts the nominal capacity at the current stage"
    annotation (Placement(transformation(extent={{-100,140},{-80,160}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor dowCap(
    final nin=nSta,
    final outOfRangeValue=small,
    final allowOutOfRange=true)
    "Extracts the nominal capacity of one stage lower than the current stage"
    annotation (Placement(transformation(extent={{-100,70},{-80,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCapMin(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=small)
    "Extracts minimal capacity of the next higher stage"
    annotation (Placement(transformation(extent={{0,-40},{20,-20}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor upCap(
    final nin=nSta,
    final allowOutOfRange=true,
    final outOfRangeValue=small)
    "Extracts the nominal capacity of the next stage"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));

  Buildings.Controls.OBC.CDL.Routing.RealExtractor capMin(
    final nin=nSta,
    final outOfRangeValue=small,
    final allowOutOfRange=true)
    "Extracts the minimum capacity of the current stage"
    annotation (Placement(transformation(extent={{0,-80},{20,-60}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi2 "Switch"
    annotation (Placement(transformation(extent={{160,50},{180,70}})));

  Buildings.Controls.OBC.CDL.Logical.Switch swi4 "Switch"
    annotation (Placement(transformation(extent={{160,-100},{180,-80}})));

  Modelica.Blocks.Logical.Switch swi1
    "Outputs minimum current stage capacity as nominal stage down capacity if operating in the lowest available stage"
    annotation (Placement(transformation(extent={{100,10},{120,30}})));

  Buildings.Controls.OBC.CDL.Continuous.Gain gai(k=larGai)
    "Ouputs a very large and unachievable staging up capacity when current is the highest available stage"
    annotation (Placement(transformation(extent={{-60,110},{-40,130}})));

equation
  connect(swi2.y, yUpNom) annotation (Line(points={{181,60},{210,60}}, color={0,0,127}));
  connect(upCap.y, swi2.u3) annotation (
    Line(points={{21,80},{80,80},{80,52},{158,52}}, color={0,0,127}));
  connect(yMin, yMin)
    annotation (Line(points={{210,-20},{210,-20}}, color={0,0,127}));
  connect(upCapMin.y, swi4.u3) annotation (Line(points={{21,-30},{50,-30},{50,-98},
          {158,-98}}, color={0,0,127}));
  connect(swi4.y, yUpMin) annotation (Line(points={{181,-90},{210,-90}}, color={0,0,127}));
  connect(capMin.y, yMin) annotation (Line(points={{21,-70},{100,-70},{100,-20},
          {210,-20}}, color={0,0,127}));
  connect(dowCap.y, swi1.u3) annotation (Line(points={{-79,80},{-60,80},{-60,12},
          {98,12}}, color={0,0,127}));
  connect(uMinCap, upCapMin.u) annotation (Line(points={{-220,-180},{-130,-180},
          {-130,-30},{-2,-30}}, color={0,0,127}));
  connect(uMinCap, capMin.u) annotation (Line(points={{-220,-180},{-100,-180},{-100,
          -70},{-2,-70}}, color={0,0,127}));
  connect(uDesCap, cap.u) annotation (Line(points={{-220,180},{-120,180},{-120,150},
          {-102,150}}, color={0,0,127}));
  connect(uDesCap, dowCap.u) annotation (Line(points={{-220,180},{-140,180},{-140,
          80},{-102,80}},                            color={0,0,127}));
  connect(uDesCap, upCap.u) annotation (Line(points={{-220,180},{-20,180},{-20,80},
          {-2,80}}, color={0,0,127}));
  connect(uLow, swi1.u2) annotation (Line(points={{-220,-60},{-140,-60},{-140,20},
          {98,20}},  color={255,0,255}));
  connect(uHig, swi2.u2) annotation (Line(points={{-220,-120},{140,-120},{140,60},
          {158,60}}, color={255,0,255}));
  connect(uHig, swi4.u2) annotation (Line(points={{-220,-120},{140,-120},{140,-90},
          {158,-90}}, color={255,0,255}));
  connect(cap.y, gai.u) annotation (Line(points={{-79,150},{-70,150},{-70,120},{
          -62,120}}, color={0,0,127}));
  connect(gai.y, swi2.u1) annotation (Line(points={{-39,120},{100,120},{100,68},
          {158,68}}, color={0,0,127}));
  connect(gai.y, swi4.u1) annotation (Line(points={{-39,120},{60,120},{60,-82},{
          158,-82}}, color={0,0,127}));
  connect(swi1.y, yDowNom) annotation (Line(points={{121,20},{210,20}}, color={0,0,127}));
  connect(u, cap.index) annotation (Line(points={{-220,120},{-90,120},{-90,138}},
                 color={255,127,0}));
  connect(uDown, dowCap.index) annotation (Line(points={{-220,0},{-90,0},{-90,68}},
          color={255,127,0}));
  connect(uUp, upCap.index) annotation (Line(points={{-220,60},{10,60},{10,68}},
          color={255,127,0}));
  connect(uUp, upCapMin.index) annotation (Line(points={{-220,60},{-70,60},{-70,
          -50},{10,-50},{10,-42}}, color={255,127,0}));
  connect(cap.y, yNom) annotation (Line(points={{-79,150},{210,150}},
          color={0,0,127}));
  connect(capMin.y, swi1.u1) annotation (Line(points={{21,-70},{80,-70},{80,28},
          {98,28}},color={0,0,127}));
  connect(u, capMin.index) annotation (Line(points={{-220,120},{-160,120},{-160,
          -90},{10,-90},{10,-82}}, color={255,127,0}));
  connect(yUpMin, yUpMin)
    annotation (Line(points={{210,-90},{210,-90}}, color={0,0,127}));
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
          textString="%name")}),
        Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-200,-200},{200,200}})),
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
for the purpose of calculating the operating and stage part load ratios, 
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
