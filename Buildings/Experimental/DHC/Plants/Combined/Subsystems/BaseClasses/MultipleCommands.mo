within Buildings.Experimental.DHC.Plants.Combined.Subsystems.BaseClasses;
block MultipleCommands
  "Block that converts command signals for multiple units"


  parameter Integer nUni(final min=1, start=1)
    "Number of units"
    annotation(Evaluate=true);
  parameter Boolean have_mode=false
    "Set to true if an operating mode is used in conjunction with On/Off signal"
    annotation(Evaluate=true);

  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1[nUni]
    "Command signal"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
        iconTransformation(extent={{-140,30},{-100,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1One
    if not have_mode
    "On/Off signal: true if at least one unit is commanded On"
    annotation (Placement(transformation(extent={{100,100},{140,140}}),iconTransformation(
          extent={{100,70},{140,110}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnBou
    if not have_mode
    "Number of units that are commanded On, with lower bound of 1"
    annotation (Placement(transformation(extent={{100,70},{140,110}}),
      iconTransformation(extent={{100,50},{140,90}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOn
    if not have_mode
    "Number of units that are commanded On, unbounded"
    annotation (Placement(transformation(extent={{100,40},{140,80}}),
    iconTransformation(extent={{100,30},{140,70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1NotModOne if have_mode
    "On/Off signal: true if at least one unit is commanded On AND y1Mod is false"
    annotation (Placement(transformation(extent={{100,-80},{140,-40}}),
        iconTransformation(extent={{100,-70},{140,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnNotModBou if have_mode
    "Number of units that are commanded On AND y1Mod is false, with lower bound of 1"
    annotation (Placement(transformation(extent={{100,-110},{140,-70}}),
        iconTransformation(extent={{100,-90},{140,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnNotMod if have_mode
    "Number of units that are commanded On AND y1Mod is false, unbounded"
    annotation (Placement(transformation(extent={{100,-140},{140,-100}}),
        iconTransformation(extent={{100,-110},{140,-70}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput y1Mod[nUni]
    if have_mode
    "Operating mode signal"
    annotation (Placement(transformation(extent={{-140,-60},
    {-100,-20}}), iconTransformation(extent={{-140,-70},{-100,-30}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ModOne if have_mode
    "On/Off signal: true if at least one unit is commanded On AND y1Mod is true"
    annotation (Placement(transformation(extent={{100,10},{140,50}}),
        iconTransformation(extent={{100,-10},{140,30}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnModBou if have_mode
    "Number of units that are commanded On AND y1Mod is true, with lower bound of 1"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
        iconTransformation(extent={{100,-30},{140,10}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput nUniOnMod if have_mode
    "Number of units that are commanded On AND y1Mod is true, unbounded"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
        iconTransformation(extent={{100,-50},{140,-10}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[nUni]
    "Convert to real"
    annotation (Placement(transformation(extent={{-10,30},{10,50}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum(nin=nUni)
    "Total"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr
    "Returns true if at least one unit is commanded on"
    annotation (Placement(transformation(extent={{70,110},{90,130}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max1
    "Maximum value"
    annotation (Placement(transformation(extent={{70,80},{90,100}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant one(final k=1)
    "Constant one"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Max max2
    if have_mode
      "Maximum value"
    annotation (Placement(transformation(extent={{70,-100},{90,-80}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndMod[nUni]
    if have_mode
    "Returns true if commanded On AND y1Mod is true"
    annotation (Placement(transformation(extent={{-70,10},{-50,30}})));
  Buildings.Controls.OBC.CDL.Logical.And onAndNotMod[nUni]
    if have_mode
    "Returns true if commanded On AND y1Mod is false"
    annotation (Placement(transformation(extent={{-40,-50},{-20,-30}})));
  Modelica.Blocks.Routing.BooleanPassThrough pasThr[nUni]
    if not have_mode
    "Direct pass-through"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Controls.OBC.CDL.Logical.Not notMod[nUni]
    if have_mode
    "Returns true if y1Mod is false"
    annotation (Placement(transformation(extent={{-72,-70},{-52,-50}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea1[nUni]
    if have_mode
    "Convert to real"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.MultiSum mulSum1(final nin=nUni)
    if have_mode
    "Total"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greThr1
    if have_mode
    "Returns true if at least one unit is commanded on"
    annotation (Placement(transformation(extent={{70,-70},{90,-50}})));

equation
  connect(booToRea.y, mulSum.u)
    annotation (Line(points={{12,40},{18,40}}, color={0,0,127}));
  connect(greThr.y, y1One)
    annotation (Line(points={{92,120},{120,120}},
                                              color={255,0,255}));
  connect(mulSum.y, greThr.u)
    annotation (Line(points={{42,40},{60,40},{60,120},{68,120}},
                                              color={0,0,127}));
  connect(max1.y, nUniOnBou)
    annotation (Line(points={{92,90},{120,90}}, color={0,0,127}));
  connect(mulSum.y, nUniOn) annotation (Line(points={{42,40},{60,40},{60,60},{120,
          60}},  color={0,0,127}));
  connect(max2.y, nUniOnNotModBou)
    annotation (Line(points={{92,-90},{120,-90}}, color={0,0,127}));
  connect(y1, onAndMod.u1) annotation (Line(points={{-120,40},{-80,40},{-80,20},
          {-72,20}}, color={255,0,255}));
  connect(y1Mod, onAndMod.u2) annotation (Line(points={{-120,-40},{-90,-40},{-90,
          12},{-72,12}}, color={255,0,255}));
  connect(y1, pasThr.u) annotation (Line(points={{-120,40},{-80,40},{-80,60},{-72,
          60}}, color={255,0,255}));
  connect(pasThr.y, booToRea.u) annotation (Line(points={{-49,60},{-40,60},{-40,
          40},{-12,40}}, color={255,0,255}));
  connect(onAndMod.y, booToRea.u) annotation (Line(points={{-48,20},{-40,20},{-40,
          40},{-12,40}}, color={255,0,255}));
  connect(y1Mod, notMod.u)
    annotation (Line(points={{-120,-40},{-90,-40},{-90,-60},{-74,-60}},
                                                    color={255,0,255}));
  connect(y1, onAndNotMod.u1) annotation (Line(points={{-120,40},{-80,40},{-80,-40},
          {-42,-40}}, color={255,0,255}));
  connect(notMod.y, onAndNotMod.u2) annotation (Line(points={{-50,-60},{-46,-60},
          {-46,-48},{-42,-48}}, color={255,0,255}));
  connect(onAndNotMod.y, booToRea1.u)
    annotation (Line(points={{-18,-40},{-12,-40}}, color={255,0,255}));
  connect(booToRea1.y, mulSum1.u)
    annotation (Line(points={{12,-40},{18,-40}}, color={0,0,127}));
  connect(mulSum1.y, nUniOnNotMod) annotation (Line(points={{42,-40},{60,-40},{60,
          -120},{120,-120}}, color={0,0,127}));
  connect(mulSum1.y, max2.u2) annotation (Line(points={{42,-40},{60,-40},{60,-96},
          {68,-96}}, color={0,0,127}));
  connect(one.y, max2.u1) annotation (Line(points={{42,0},{50,0},{50,-84},{68,-84}},
        color={0,0,127}));
  connect(one.y, max1.u2)
    annotation (Line(points={{42,0},{50,0},{50,84},{68,84}}, color={0,0,127}));
  connect(mulSum.y, max1.u1) annotation (Line(points={{42,40},{60,40},{60,96},{68,
          96}}, color={0,0,127}));
  connect(greThr1.y, y1NotModOne)
    annotation (Line(points={{92,-60},{120,-60}}, color={255,0,255}));
  connect(mulSum1.y, greThr1.u) annotation (Line(points={{42,-40},{60,-40},{60,-60},
          {68,-60}}, color={0,0,127}));
  connect(greThr.y, y1ModOne) annotation (Line(points={{92,120},{94,120},{94,30},
          {120,30}},          color={255,0,255}));
  connect(max1.y, nUniOnModBou)
    annotation (Line(points={{92,90},{92,0},{120,0}}, color={0,0,127}));
  connect(mulSum.y, nUniOnMod) annotation (Line(points={{42,40},{60,40},{60,-30},
          {120,-30}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,-100},{100,100}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-150,150},{150,110}},
          textString="%name",
          textColor={0,0,255})}),           Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-100,-140},{100,140}})));
end MultipleCommands;
