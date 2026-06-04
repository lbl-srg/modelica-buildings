within Buildings.Templates.Plants.Controls.StagingRotation;
block UpdateEnableState
  parameter Integer nEqu
    "Number of equipment"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uSta
    "Stage index"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Equipment enable command"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Detect stage index change"
    annotation(Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre y1Pre[nEqu]
    "Left limit of signal in discrete time"
    annotation(Placement(transformation(extent={{70,-10},{50,10}})));
  Buildings.Controls.OBC.CDL.Logical.Switch logSwi[nEqu]
    "Switch to newly computed value at stage change"
    annotation(Placement(transformation(extent={{50,50},{70,70}})));
  Buildings.Controls.OBC.CDL.Routing.BooleanScalarReplicator booScaRep(
    final nout=nEqu)
    "Replicate signal"
    annotation(Placement(transformation(extent={{0,-10},{20,10}})));
  Utilities.CountTrue nEnaAvaPre(nin=nEqu)
    "Count the number of previously enabled equipment that are available"
    annotation(Placement(transformation(extent={{-10,-70},{-30,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Greater intGre
    "Compare to required number of equipment"
    annotation(Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Or swiEna
    "Evaluate condition to switch to newly computed enable signal"
    annotation(Placement(transformation(extent={{-30,-10},{-10,10}})));
  Buildings.Controls.OBC.CDL.Logical.And isEnaPreAva[nEqu]
    "Return true if equipment previously enabled and available"
    annotation(Placement(transformation(extent={{30,-70},{10,-50}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1[nEqu]
    "Raw enable signal"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput n
    "Number of equipment"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
equation
  connect(y1Pre.y, logSwi.u3)
    annotation(Line(points={{48,0},{40,0},{40,52},{48,52}},
      color={255,0,255}));
  connect(booScaRep.y, logSwi.u2)
    annotation(Line(points={{22,0},{34,0},{34,60},{48,60}},
      color={255,0,255}));
  connect(swiEna.y, booScaRep.u)
    annotation(Line(points={{-8,0},{-2,0}},
      color={255,0,255}));
  connect(cha.y, swiEna.u1)
    annotation(Line(points={{-58,0},{-32,0}},
      color={255,0,255}));
  connect(intGre.y, swiEna.u2)
    annotation(Line(points={{-58,-40},{-50,-40},{-50,-8},{-32,-8}},
      color={255,0,255}));
  connect(isEnaPreAva.y, nEnaAvaPre.u1)
    annotation(Line(points={{8,-60},{-8,-60}},
      color={255,0,255}));
  connect(y1, y1Pre.u)
    annotation(Line(points={{120,0},{72,0}},
      color={255,0,255}));
  connect(logSwi.y, y1)
    annotation(Line(points={{72,60},{80,60},{80,0},{120,0}},
      color={255,0,255}));
  connect(u1, logSwi.u1)
    annotation(Line(points={{-120,60},{20,60},{20,68},{48,68}},
      color={255,0,255}));
  connect(uSta, cha.u)
    annotation(Line(points={{-120,0},{-82,0}},
      color={255,127,0}));
  connect(n, intGre.u1)
    annotation(Line(points={{-120,-40},{-82,-40}},
      color={255,127,0}));
  connect(u1Ava, isEnaPreAva.u2)
    annotation(Line(points={{-120,-80},{40,-80},{40,-68},{32,-68}},
      color={255,0,255}));
  connect(y1Pre.y, isEnaPreAva.u1)
    annotation(Line(points={{48,0},{40,0},{40,-60},{32,-60}},
      color={255,0,255}));
  connect(nEnaAvaPre.y, intGre.u2)
    annotation(Line(points={{-32,-60},{-90,-60},{-90,-48},{-82,-48}},
      color={255,127,0}));
annotation(defaultComponentName="updEnaSta",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)));
end UpdateEnableState;
