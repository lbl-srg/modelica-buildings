within Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses;
block SelectSortedAvailable
  "Generate a true array of n elements based on priority order and availability"
  parameter Integer nEqu
    "Number of units"
    annotation(Evaluate=true);
  parameter Integer nEquAlt
    "Number of lead/lag alternate units"
    annotation(Evaluate=true);
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput n
    "Number of required lead/lag alternate units"
    annotation(Placement(transformation(extent={{-140,40},{-100,80}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput uIdxSor[nEquAlt]
    "Indices of lead/lag alternate equipment sorted by increasing runtime"
    annotation(Placement(transformation(extent={{-140,-80},{-100,-40}}),
      iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput u1Ava[nEqu]
    "Equipment available signal"
    annotation(Placement(transformation(extent={{-140,-20},{-100,20}}),
      iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y1[nEqu]
    "Enable signal"
    annotation(Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToInteger avaInt[nEqu]
    "Cast available signal to integer"
    annotation(Placement(transformation(extent={{-90,-10},{-70,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerVectorReplicator avaIntAltRep(
    nin=nEqu,
    nout=nEquAlt)
    "Replicate to support reordering at next step"
    annotation(Placement(transformation(extent={{-60,-10},{-40,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerExtractor avaIntIdxEquAlt[nEquAlt](
    each final nin=nEqu)
    "Available signals of lead/lag alternate equipment reordered based on idxEquAlt"
    annotation(Placement(transformation(extent={{-20,-10},{0,10}})));
  Buildings.Controls.OBC.CDL.Integers.Multiply excUna[nEquAlt]
    "Filter out unavailable units"
    annotation(Placement(transformation(extent={{20,-40},{40,-20}})));
  Utilities.TrueArrayConditional truArrCon(final nout=nEqu, nin=nEquAlt)
    "Generate array of size nEqu with nAltReq true elements at uIdxAltSor indices "
    annotation(Placement(transformation(extent={{60,-10},{80,10}})));
equation
  connect(u1Ava, avaInt.u)
    annotation(Line(points={{-120,0},{-92,0}},
      color={255,0,255}));
  connect(avaIntAltRep.y, avaIntIdxEquAlt.u)
    annotation(Line(points={{-38,0},{-22,0}},
      color={255,127,0}));
  connect(avaIntIdxEquAlt.y, excUna.u1)
    annotation(Line(points={{2,0},{10,0},{10,-24},{18,-24}},
      color={255,127,0}));
  connect(avaInt.y, avaIntAltRep.u)
    annotation(Line(points={{-68,0},{-62,0}},
      color={255,127,0}));
  connect(truArrCon.y1, y1)
    annotation(Line(points={{82,0},{120,0}},
      color={255,0,255}));
  connect(n, truArrCon.u)
    annotation(Line(points={{-120,60},{50,60},{50,0},{58,0}},
      color={255,127,0}));
  connect(uIdxSor, avaIntIdxEquAlt.index)
    annotation(Line(points={{-120,-60},{-10,-60},{-10,-12}},
      color={255,127,0}));
  connect(uIdxSor, excUna.u2)
    annotation(Line(points={{-120,-60},{-10,-60},{-10,-36},{18,-36}},
      color={255,127,0}));
  connect(excUna.y, truArrCon.uIdx)
    annotation(Line(points={{42,-30},{50,-30},{50,-6},{58,-6}},
      color={255,127,0}));
annotation(defaultComponentName="selSorAva",
  Icon(coordinateSystem(preserveAspectRatio=false),
    graphics={Rectangle(extent={{-100,100},{100,-100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid),
    Text(extent={{-150,150},{150,110}},
      textString="%name",
      textColor={0,0,255})}),
  Diagram(coordinateSystem(preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This block selects <code>n</code> lead/lag alternate units to enable,
choosing among available units in priority order.
</p>
<p>
The output has size <code>nEqu</code> (total equipment count), not
<code>nEquAlt</code> (number of lead/lag alternate units), so it can be
combined directly with the required-unit enable signals from
<a href=\"modelica://Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage\">
Buildings.Templates.Plants.Controls.StagingRotation.BaseClasses.SelectEquipmentAtStage</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
June 10, 2026, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end SelectSortedAvailable;
