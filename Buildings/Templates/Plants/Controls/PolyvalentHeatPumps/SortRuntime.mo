within Buildings.Templates.Plants.Controls.PolyvalentHeatPumps;
block SortRuntime
  "Sort polyvalent heat pumps by increasing runtime in each operating mode"
  parameter Integer nPhp
    "Number of units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1CooPhp[nPhp]
    "Polyvalent HP cooling on/off command"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1HeaPhp[nPhp]
    "Polyvalent HP heating on/off command"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,60},{-100,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorCooPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in cooling-only mode"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,20},{140,60}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorHeaPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in heating-only mode"
    annotation(Placement(transformation(extent={{100,40},{140,80}}),
      iconTransformation(extent={{100,60},{140,100}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerOutput yIdxSorShcPhp[nPhp]
    "Indices of polyvalent units sorted by increasing runtime in SHC mode"
    annotation(Placement(transformation(extent={{100,-60},{140,-20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Php_actual[nPhp]
    "Polyvalent heat pump status"
    annotation(Placement(transformation(extent={{-140,-60},{-100,-20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1AvaPhp[nPhp]
    "Polyvalent heat pump available signal"
    annotation(Placement(transformation(extent={{-140,-100},{-100,-60}}),
      iconTransformation(extent={{-140,-60},{-100,-20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1ShcPhp[nPhp]
    "Polyvalent HP commanded in SHC mode"
    annotation(Placement(transformation(extent={{100,-100},{140,-60}}),
      iconTransformation(extent={{100,-60},{140,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Xor heaXorCoo[nPhp]
    "True if commanded in single mode"
    annotation(Placement(transformation(extent={{-40,20},{-20,40}})));
  StagingRotation.SortRuntime sorRunTimHea(nin=nPhp)
    "Sort by increasing runtime in heating-only mode"
    annotation(Placement(transformation(extent={{60,50},{80,70}})));
  StagingRotation.SortRuntime sorRunTimCoo(nin=nPhp)
    "Sort by increasing runtime in cooling-only mode"
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
  StagingRotation.SortRuntime sorRunTimShc(nin=nPhp)
    "Sort by increasing runtime in SHC mode"
    annotation(Placement(transformation(extent={{60,-50},{80,-30}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd shc[nPhp](each nin=3)
    "True if commanded in SHC mode"
    annotation(Placement(transformation(extent={{10,-50},{30,-30}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1HeaPre[nPhp]
    "Left-limit of signal to break algebraic loop"
    annotation(Placement(transformation(extent={{-90,50},{-70,70}})));
  Buildings.Controls.OBC.CDL.Logical.Pre u1CooPre[nPhp]
    "Left-limit of signal to break algebraic loop"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd hea[nPhp](each nin=3)
    "True if operating in heating-only mode"
    annotation(Placement(transformation(extent={{10,50},{30,70}})));
  Buildings.Controls.OBC.CDL.Logical.MultiAnd coo[nPhp](each nin=3)
    "True if operating in cooling-only mode"
    annotation(Placement(transformation(extent={{10,-10},{30,10}})));
equation
  connect(sorRunTimHea.yIdx, yIdxSorHeaPhp)
    annotation(Line(points={{82,54},{90,54},{90,60},{120,60}},
      color={255,127,0}));
  connect(sorRunTimCoo.yIdx, yIdxSorCooPhp)
    annotation(Line(points={{82,-6},{90,-6},{90,0},{120,0}},
      color={255,127,0}));
  connect(sorRunTimShc.yIdx, yIdxSorShcPhp)
    annotation(Line(points={{82,-46},{90,-46},{90,-40},{120,-40}},
      color={255,127,0}));
  connect(u1HeaPhp, u1HeaPre.u)
    annotation(Line(points={{-120,60},{-92,60}},
      color={255,0,255}));
  connect(u1CooPhp, u1CooPre.u)
    annotation(Line(points={{-120,0},{-92,0}},
      color={255,0,255}));
  connect(u1HeaPre.y, heaXorCoo.u1)
    annotation(Line(points={{-68,60},{-60,60},{-60,30},{-42,30}},
      color={255,0,255}));
  connect(u1CooPre.y, heaXorCoo.u2)
    annotation(Line(points={{-68,0},{-50,0},{-50,22},{-42,22}},
      color={255,0,255}));
  connect(u1HeaPre.y, hea.u[1])
    annotation(Line(points={{-68,60},{8,60},{8,57.6667}},
      color={255,0,255}));
  connect(heaXorCoo.y, hea.u[2])
    annotation(Line(points={{-18,30},{4,30},{4,60},{8,60}},
      color={255,0,255}));
  connect(heaXorCoo.y, coo.u[2])
    annotation(Line(points={{-18,30},{4,30},{4,0},{8,0}},
      color={255,0,255}));
  connect(shc.y, sorRunTimShc.u1Run)
    annotation(Line(points={{32,-40},{50,-40},{50,-34},{58,-34}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimShc.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,-46},{58,-46}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimCoo.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,-6},{58,-6}},
      color={255,0,255}));
  connect(u1AvaPhp, sorRunTimHea.u1Ava)
    annotation(Line(points={{-120,-80},{40,-80},{40,54},{58,54}},
      color={255,0,255}));
  connect(coo.y, sorRunTimCoo.u1Run)
    annotation(Line(points={{32,0},{50,0},{50,6},{58,6}},
      color={255,0,255}));
  connect(hea.y, sorRunTimHea.u1Run)
    annotation(Line(points={{32,60},{50,60},{50,66},{58,66}},
      color={255,0,255}));
  connect(u1CooPre.y, coo.u[1])
    annotation(Line(points={{-68,0},{8,0},{8,-2.33333}},
      color={255,0,255}));
  connect(u1HeaPre.y, shc.u[1])
    annotation(Line(points={{-68,60},{-60,60},{-60,-38},{8,-38},{8,-42.3333}},
      color={255,0,255}));
  connect(u1CooPre.y, shc.u[2])
    annotation(Line(points={{-68,0},{-50,0},{-50,-36},{8,-36},{8,-40}},
      color={255,0,255}));
  connect(u1Php_actual, shc.u[3])
    annotation(Line(points={{-120,-40},{8,-40},{8,-37.6667}},
      color={255,0,255}));
  connect(u1Php_actual, hea.u[3])
    annotation(Line(points={{-120,-40},{0,-40},{0,62.3333},{8,62.3333}},
      color={255,0,255}));
  connect(u1Php_actual, coo.u[3])
    annotation(Line(points={{-120,-40},{0,-40},{0,2.33333},{8,2.33333}},
      color={255,0,255}));
  connect(shc.y, y1ShcPhp)
    annotation(Line(points={{32,-40},{50,-40},{50,-80},{120,-80}},
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
