within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block SortRuntime
  "Sort polyvalent heat pumps by increasing runtime in each operating mode"
  parameter Integer nPhp
    "Number of units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Coo[nPhp]
    "Polyvalent HP cooling-only enable"
    annotation(Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Hea[nPhp]
    "Polyvalent HP heating-only enable"
    annotation(Placement(transformation(extent={{-140,60},{-100,100}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorCooPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in cooling-only mode"
    annotation(Placement(transformation(extent={{100,20},{140,60}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorHeaPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in heating-only mode"
    annotation(Placement(transformation(extent={{100,60},{140,100}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorShcPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in SHC mode"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Php_actual[nPhp]
    "Polyvalent heat pump status"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp[nPhp]
    "Polyvalent heat pump available signal"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-100},{-100,-60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ShcPhp[nPhp]
    "Polyvalent HP commanded in SHC mode"
    annotation(Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Shc[nPhp]
    "Polyvalent HP SHC enable"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  StagingRotation.SortRuntime sorRunTimHea(nin=nPhp)
    "Sort by increasing runtime in heating-only mode"
    annotation(Placement(transformation(extent={{60,70},{80,90}})));
  StagingRotation.SortRuntime sorRunTimCoo(nin=nPhp)
    "Sort by increasing runtime in cooling-only mode"
    annotation(Placement(transformation(extent={{60,30},{80,50}})));
  StagingRotation.SortRuntime sorRunTimShc(nin=nPhp)
    "Sort by increasing runtime in SHC mode"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And shc[nPhp]
    "True if commanded in SHC mode"
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1HeaPre[nPhp]
    "Left-limit of signal to break algebraic loop"
    annotation(Placement(transformation(extent={{-90,70},{-70,90}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1CooPre[nPhp]
    "Left-limit of signal to break algebraic loop"
    annotation(Placement(transformation(extent={{-90,30},{-70,50}})));
  Buildings.Controls.OBC.CDL.Logical.And hea[nPhp]
    "True if operating in heating-only mode"
    annotation(Placement(transformation(extent={{10,70},{30,90}})));
  Buildings.Controls.OBC.CDL.Logical.And coo[nPhp]
    "True if operating in cooling-only mode"
    annotation(Placement(transformation(extent={{10,30},{30,50}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1ShcPre[nPhp]
    "Left-limit of signal to break algebraic loop"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
equation
  connect(sorRunTimHea.yIdx, yIdxSorHeaPhp)
    annotation(Line(points={{82,74},{90,74},{90,80},{120,80}},
      color={255,127,0}));
  connect(sorRunTimCoo.yIdx, yIdxSorCooPhp)
    annotation(Line(points={{82,34},{90,34},{90,40},{120,40}},
      color={255,127,0}));
  connect(sorRunTimShc.yIdx, yIdxSorShcPhp)
    annotation(Line(points={{82,-6},{90,-6},{90,0},{120,0}},
      color={255,127,0}));
  connect(u1Hea, u1HeaPre.u)
    annotation(Line(points={{-120,80},{-92,80}},
      color={255,0,255}));
  connect(u1Coo, u1CooPre.u)
    annotation(Line(points={{-120,40},{-92,40}},
      color={255,0,255}));
  connect(shc.y, sorRunTimShc.u1Run)
    annotation(Line(points={{32,0},{50,0},{50,6},{58,6}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimShc.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,-6},{58,-6}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimCoo.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,34},{58,34}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimHea.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,74},{58,74}},
      color={255,0,255}));
  connect(coo.y, sorRunTimCoo.u1Run)
    annotation(Line(points={{32,40},{50,40},{50,46},{58,46}},
      color={255,0,255}));
  connect(hea.y, sorRunTimHea.u1Run)
    annotation(Line(points={{32,80},{40,80},{40,86},{58,86}},
      color={255,0,255}));
  connect(shc.y, y1ShcPhp)
    annotation(Line(points={{32,0},{50,0},{50,-40},{120,-40}},
      color={255,0,255}));
  connect(u1Shc, u1ShcPre.u)
    annotation(Line(points={{-120,0},{-92,0}},
      color={255,0,255}));
  connect(u1HeaPre.y, hea.u1)
    annotation(Line(points={{-68,80},{8,80}},
      color={255,0,255}));
  connect(u1Php_actual, hea.u2)
    annotation(Line(points={{-120,-40},{-40,-40},{-40,72},{8,72}},
      color={255,0,255}));
  connect(u1CooPre.y, coo.u1)
    annotation(Line(points={{-68,40},{8,40}},
      color={255,0,255}));
  connect(u1Php_actual, coo.u2)
    annotation(Line(points={{-120,-40},{-40,-40},{-40,32},{8,32}},
      color={255,0,255}));
  connect(u1Php_actual, shc.u2)
    annotation(Line(points={{-120,-40},{-40,-40},{-40,-8},{8,-8}},
      color={255,0,255}));
  connect(u1ShcPre.y, shc.u1)
    annotation(Line(points={{-68,0},{8,0}},
      color={255,0,255}));
annotation(defaultComponentName="sorRunTimPhp",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
  Documentation(
    info="<html>
<p>
  Polyvalent heat pumps are sorted by increasing runtime separately in each
  mode, as described in
  <a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime\">
    Buildings.Templates.Plants.Controls.StagingRotation.SortRuntime</a>.
</p>
</html>",
    revisions="<html>
<ul>
  <li>
    July 1, 2026, by Antoine Gautier:<br />
    First implementation.
  </li>
</ul>
</html>"));
end SortRuntime;
