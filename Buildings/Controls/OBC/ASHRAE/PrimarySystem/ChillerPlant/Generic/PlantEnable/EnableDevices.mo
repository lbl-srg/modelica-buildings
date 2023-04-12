within Buildings.Controls.OBC.ASHRAE.PrimarySystem.ChillerPlant.Generic.PlantEnable;
block EnableDevices
  "Enable devices when plants is enabled in chiller mode or waterside economizer mode"

  parameter Integer nSta = 3
    "Number of chiller stages";
  parameter Integer nChiWatPum = 2
    "Total number of chilled water pumps";
  parameter Integer nConWatPum = 2
    "Total number of condenser water pumps";

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uPla
    "Plant enable signal"
    annotation (Placement(transformation(extent={{-200,80},{-160,120}}),
        iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIni(
    final min=0,
    final max=nSta)
    "Initial chiller stage (at plant enable)"
    annotation (Placement(transformation(extent={{-200,40},{-160,80}}),
        iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uChiSta(
    final min=0,
    final max=nSta)
    "Current chiller stage"
    annotation (Placement(transformation(extent={{-200,10},{-160,50}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uChiWatPum[nChiWatPum]
    "Chilled water pump proven on"
    annotation (Placement(transformation(extent={{-200,-80},{-160,-40}}),
        iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput uConWatPum[nConWatPum]
    "Condenser water pump proven on"
    annotation (Placement(transformation(extent={{-200,-130},{-160,-90}}),
        iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yEnaPlaPro
    "True: it is in the plant enabling process"
    annotation (Placement(transformation(extent={{160,80},{200,120}}),
        iconTransformation(extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yChiWatIsoVal
    "Lead chiller chilled water isolation valve  commanded open"
    annotation (Placement(transformation(extent={{160,10},{200,50}}),
        iconTransformation(extent={{100,40},{140,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yConWatIsoVal
    "Lead chiller condenser water isolation valve  commanded open"
    annotation (Placement(transformation(extent={{160,-20},{200,20}}),
        iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaPriChiPum
    "Lead primary chilled water pump  commanded on"
    annotation (Placement(transformation(extent={{160,-50},{200,-10}}),
        iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaConPum
    "Lead condenser water pump  commanded on"
    annotation (Placement(transformation(extent={{160,-80},{200,-40}}),
        iconTransformation(extent={{100,-50},{140,-10}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaTowCel
    "Lead cooling tower cell  commanded on"
    annotation (Placement(transformation(extent={{160,-110},{200,-70}}),
        iconTransformation(extent={{100,-80},{140,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput yLeaChi
    "Lead chiller commanded on"
    annotation (Placement(transformation(extent={{160,-140},{200,-100}}),
        iconTransformation(extent={{100,-110},{140,-70}})));

  Buildings.Controls.OBC.CDL.Integers.Equal intEqu1
    "Check if current stage is initial stage"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not not1
    "Not in initial stage"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg1
    "Becoming not initial stage"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.Edge edg
    "Plant enable edge"
    annotation (Placement(transformation(extent={{-100,90},{-80,110}})));
  Buildings.Controls.OBC.CDL.Logical.Latch ecoMod "Plant enabled in economizer mode"
    annotation (Placement(transformation(extent={{40,90},{60,110}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.Constant conInt(
    final k=1)
    "Stage 1, meaning it stages in chiller mode"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Controls.OBC.CDL.Integers.Equal intChiMod
    "Output true if it is enabled in chiller mode"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Buildings.Controls.OBC.CDL.Logical.And and1
    "Enabled devices associate with chiller mode operation"
    annotation (Placement(transformation(extent={{100,20},{120,40}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr(
    final nin=nChiWatPum)
    "Check if there is any chilled water pump proven on"
    annotation (Placement(transformation(extent={{-120,-70},{-100,-50}})));
  Buildings.Controls.OBC.CDL.Logical.MultiOr mulOr1(
    final nin=nConWatPum)
    "Check if there is any condenser water pump proven on"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Buildings.Controls.OBC.CDL.Logical.And and2
    "Check if the lead pumps are proven on"
    annotation (Placement(transformation(extent={{-60,-70},{-40,-50}})));
  Buildings.Controls.OBC.CDL.Logical.And and3
    "Enable lead chiller"
    annotation (Placement(transformation(extent={{20,-130},{40,-110}})));

equation
  connect(uPla, edg.u)
    annotation (Line(points={{-180,100},{-102,100}}, color={255,0,255}));
  connect(uIni, intEqu1.u1) annotation (Line(points={{-180,60},{-102,60}},
          color={255,127,0}));
  connect(uChiSta, intEqu1.u2)
    annotation (Line(points={{-180,30},{-140,30},{-140,52},{-102,52}}, color={255,127,0}));
  connect(intEqu1.y, not1.u)
    annotation (Line(points={{-78,60},{-62,60}}, color={255,0,255}));
  connect(not1.y, edg1.u)
    annotation (Line(points={{-38,60},{-22,60}}, color={255,0,255}));
  connect(edg1.y, ecoMod.clr) annotation (Line(points={{2,60},{20,60},{20,94},{38,
          94}}, color={255,0,255}));
  connect(edg.y, ecoMod.u)
    annotation (Line(points={{-78,100},{38,100}}, color={255,0,255}));
  connect(ecoMod.y, yEnaPlaPro)
    annotation (Line(points={{62,100},{180,100}}, color={255,0,255}));
  connect(ecoMod.y, yLeaPriChiPum) annotation (Line(points={{62,100},{80,100},{80,
          -30},{180,-30}}, color={255,0,255}));
  connect(ecoMod.y, yLeaConPum) annotation (Line(points={{62,100},{80,100},{80,-60},
          {180,-60}}, color={255,0,255}));
  connect(ecoMod.y,yLeaTowCel)  annotation (Line(points={{62,100},{80,100},{80,-90},
          {180,-90}},  color={255,0,255}));
  connect(conInt.y, intChiMod.u2) annotation (Line(points={{-98,0},{-60,0},{-60,
          22},{-42,22}}, color={255,127,0}));
  connect(uIni, intChiMod.u1) annotation (Line(points={{-180,60},{-120,60},{-120,
          30},{-42,30}}, color={255,127,0}));
  connect(intChiMod.y, and1.u1)
    annotation (Line(points={{-18,30},{98,30}}, color={255,0,255}));
  connect(ecoMod.y, and1.u2) annotation (Line(points={{62,100},{80,100},{80,22},
          {98,22}}, color={255,0,255}));
  connect(and1.y, yChiWatIsoVal)
    annotation (Line(points={{122,30},{180,30}}, color={255,0,255}));
  connect(and1.y, yConWatIsoVal) annotation (Line(points={{122,30},{140,30},{140,
          0},{180,0}},     color={255,0,255}));
  connect(uChiWatPum, mulOr.u)
    annotation (Line(points={{-180,-60},{-122,-60}}, color={255,0,255}));
  connect(uConWatPum, mulOr1.u)
    annotation (Line(points={{-180,-110},{-122,-110}}, color={255,0,255}));
  connect(mulOr.y, and2.u1)
    annotation (Line(points={{-98,-60},{-62,-60}}, color={255,0,255}));
  connect(mulOr1.y, and2.u2) annotation (Line(points={{-98,-110},{-80,-110},{-80,
          -68},{-62,-68}}, color={255,0,255}));
  connect(and2.y, and3.u2) annotation (Line(points={{-38,-60},{-20,-60},{-20,-128},
          {18,-128}}, color={255,0,255}));
  connect(and1.y, and3.u1) annotation (Line(points={{122,30},{140,30},{140,0},{0,
          0},{0,-120},{18,-120}}, color={255,0,255}));
  connect(and3.y, yLeaChi)
    annotation (Line(points={{42,-120},{180,-120}}, color={255,0,255}));
annotation (defaultComponentName = "enaDev",
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
    graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(extent={{-100,138},{100,98}},
          textColor={0,0,255},
          textString="%name")}),
  Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-160,-140},{160,140}})),
  Documentation(info="<html>
<p>
It controls the devices when the chiller plant is enabled in chiller mode or
waterside economizer mode. It is implemented as provided in sections 5.2.2.4,
section 1 and 2.
</p>
<ol>
<li>
Open the isolation valves,
<ul>
<li>
If the plant is enabled in waterside economizer mode,
open the condenser water isolation valve of the waterside economizer.
</li>
<li>
If the plant is enabled in chiller mode,
open the chilled water isolation valve and the condenser water isolation valve
of the lead chiller.
</li>
</ul>
</li>
<li>
Stage on lead primary chilled water pump, condenser water pump, and cooling
tower respectively.
</li>
<li>
If the plant is enabled in chiller mode,
once the lead pumps are proven on, enable lead chiller.
</li>
</ol>
</html>",
revisions="<html>
<ul>
<li>
July 20, 2022, by Jianjun Hu:<br/>
First implementation.
</li>
</ul>
</html>"));
end EnableDevices;
