within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectLargestValues "Select largest values"

  parameter Integer nVal
    "Number of values to compare";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nVal]
    "A vector of all values"
    annotation (Placement(transformation(extent={{-220,-20},{-180,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nVal]
    "A flag vector to disqualify certain values from comparison"
    annotation (Placement(transformation(extent={{-220,40},{-180,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of largest values to select"
    annotation (Placement(transformation(extent={{-220,-80},{-180,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nVal]
    "True: the value is one of the largest values"
    annotation (Placement(transformation(extent={{180,-20},{220,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Logical.Not not1[nVal]
    "The disqualified flag is not active"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));
  Buildings.Controls.OBC.CDL.Logical.And and1[nVal]
    "The disqualified flag must not be true to qualify as one of the largest values"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nVal)
    "Minimum of all values"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(final p=-1)
    "Minus one to the minimum value"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nVal]
    "True to pass a small value; false to pass the input value"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator reaScaRep(nout=nVal)
    "Turn the minimum value minus one into a vector"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(ascending=false,nin=nVal)
    "Output the indices of the sorted vector in descending order"
    annotation (Placement(transformation(extent={{20,0},{40,20}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu[nVal]
    "If indices are no larger than the number of largest values to select, the corresponding values are the largest values"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nVal)
    "Replicate the number of largest values to select"
    annotation (Placement(transformation(extent={{-20,-70},{0,-50}})));
equation
  connect(nSel, intScaRep.u)
    annotation (Line(points={{-200,-60},{-22,-60}}, color={255,127,0}));
  connect(intScaRep.y, intLesEqu.u2)
    annotation (Line(points={{2,-60},{60,-60},{60,-8},{78,-8}}, color={255,127,0}));
  connect(sort.yIdx, intLesEqu.u1)
    annotation (Line(points={{42,4},{60,4},{60,0},{78,0}}, color={255,127,0}));
  connect(disFla, not1.u)
    annotation (Line(points={{-200,60},{-22,60}}, color={255,0,255}));
  connect(not1.y,and1. u1)
    annotation (Line(points={{2,60},{120,60},{120,0},{138,0}}, color={255,0,255}));
  connect(and1.u2, intLesEqu.y)
    annotation (Line(points={{138,-8},{110,-8},{110,0},{102,0}}, color={255,0,255}));
  connect(and1.y, y)
    annotation (Line(points={{162,0},{200,0}}, color={255,0,255}));
  connect(u,mulMin. u)
    annotation (Line(points={{-200,0},{-170,0},{-170,30},{-162,30}},
      color={0,0,127}));
  connect(mulMin.y, addPar.u)
    annotation (Line(points={{-138,30},{-122,30}}, color={0,0,127}));
  connect(disFla, swi.u2)
    annotation (Line(points={{-200,60},{-40,60},{-40,10},{-22,10}},
      color={255,0,255}));
  connect(reaScaRep.y, swi.u1)
    annotation (Line(points={{-58,30},{-30,30},{-30,18},{-22,18}}, color={0,0,127}));
  connect(u, swi.u3)
    annotation (Line(points={{-200,0},{-40,0},{-40,2},{-22,2}}, color={0,0,127}));
  connect(swi.y, sort.u)
    annotation (Line(points={{2,10},{18,10}}, color={0,0,127}));
  connect(addPar.y, reaScaRep.u)
    annotation (Line(points={{-98,30},{-82,30}}, color={0,0,127}));
  annotation (defaultComponentName="selLarVal",
    Icon(coordinateSystem(preserveAspectRatio=false,
    extent={{-100,-100},{100,100}},
    grid={2,2}), graphics={Rectangle(
      extent={{-100,-100},{100,100}},
      lineColor={0,0,0},
      fillColor={255,255,255},
      fillPattern=FillPattern.Solid), Text(
      extent={{-100,140},{100,100}},
      textColor={0,0,255},
          textString="%name")}), Diagram(
    coordinateSystem(preserveAspectRatio=false,
    extent={{-180,-100},{180,100}},
    grid={2,2})),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> largest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
boolean vector, where <code>true</code> means a value at the corresponding index is
one of the largest values, and <code>false</code> means otherwise.
</p>
<p>
The disqualified flag vector <code>disFla</code> serves to disqualify certain values
in the input vector from large-value comparison by changing these values to a small
number. If the number of values that do not have the disqualified flag is smaller
than <code>nSel</code>, the final number of selected largest values will be smaller
than <code>nSel</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
June 11, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"));
end SelectLargestValues;
