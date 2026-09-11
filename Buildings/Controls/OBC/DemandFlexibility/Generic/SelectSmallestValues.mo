within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectSmallestValues "Select smallest values"

  parameter Integer nVal(min=1)
    "Number of values to compare";
  final parameter Real smaNum=1e-5
    "A small number to allow equal values to be ranked";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nVal]
    "A vector of all values"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nVal]
    "A flag vector to disable certain values from comparison"
    annotation (Placement(transformation(extent={{-240,-20},{-200,20}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of smallest values to select"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nVal]
    "True: the value is one of the smallest values"
    annotation (Placement(transformation(extent={{200,-20},{240,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numSeq[nVal](
    final k={i for i in 1:nVal})
    "An ascending numerical sequence from one up to the number of values"
    annotation (Placement(transformation(extent={{-160,40},{-140,60}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaSmaNum[nVal](
    final k=fill(smaNum, nVal))
    "Scale the numerical sequence with a small number"
    annotation (Placement(transformation(extent={{-120,40},{-100,60}})));
  Buildings.Controls.OBC.CDL.Reals.Add addSmaNum[nVal]
    "Add different small numbers to input values to allow ranking of equal input values"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extNSel(final nin=nVal)
    "Extract the n-th smallest value, where n equals the number of smallest values to select"
    annotation (Placement(transformation(extent={{-40,-100},{-20,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator nSelValRep(final nout=nVal)
    "Replicate the n-th smallest value into a vector, where n equals the number of smallest values to select"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));
  Buildings.Controls.OBC.CDL.Reals.Greater greNSelVal[nVal]
    "Check whether the input value is greater than the n-th smallest value, where n equals the number of smallest values to select"
    annotation (Placement(transformation(extent={{60,-70},{80,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notGreNSelVal[nVal]
    "Check whether the input value is less than or equal to the n-th smallest value, where n equals the number of smallest values to select"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDisFla[nVal]
    "The disqualified flag is not active"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Controls.OBC.CDL.Logical.And andNotDisFla[nVal]
    "The disqualified flag must not be true to qualify as one of the smallest values"
    annotation (Placement(transformation(extent={{160,-10},{180,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMax mulMax(nin=nVal)
    "Maximum of all values"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addOne(final p=1)
    "Add one to the maximum value"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nVal]
    "True to pass a large value; false to pass the input value"
    annotation (Placement(transformation(extent={{-120,-100},{-100,-80}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator maxRep(final nout=nVal)
    "Replicate the maximum value plus one into a vector"
    annotation (Placement(transformation(extent={{80,70},{100,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(final ascending=true, nin=nVal)
    "Output the sorted input values in ascending order"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
equation
  connect(disFla, notDisFla.u)
    annotation (Line(points={{-220,0},{-102,0}}, color={255,0,255}));
  connect(notDisFla.y, andNotDisFla.u1)
    annotation (Line(points={{-78,0},{158,0}}, color={255,0,255}));
  connect(andNotDisFla.y, y)
    annotation (Line(points={{182,0},{220,0}}, color={255,0,255}));
  connect(mulMax.y,addOne. u)
    annotation (Line(points={{22,80},{38,80}}, color={0,0,127}));
  connect(disFla, swi.u2)
    annotation (Line(points={{-220,0},{-160,0},{-160,-90},{-122,-90}},
      color={255,0,255}));
  connect(maxRep.y, swi.u1)
    annotation (Line(points={{102,80},{120,80},{120,-30},{-140,-30},{-140,-82},
      {-122,-82}}, color={0,0,127}));
  connect(swi.y, sort.u)
    annotation (Line(points={{-98,-90},{-82,-90}}, color={0,0,127}));
  connect(addOne.y,maxRep. u)
    annotation (Line(points={{62,80},{78,80}}, color={0,0,127}));
  connect(numSeq.y, scaSmaNum.u)
    annotation (Line(points={{-138,50},{-122,50}}, color={0,0,127}));
  connect(scaSmaNum.y, addSmaNum.u2)
    annotation (Line(points={{-98,50},{-80,50},{-80,74},{-62,74}},
      color={0,0,127}));
  connect(u, addSmaNum.u1)
    annotation (Line(points={{-220,110},{-80,110},{-80,86},{-62,86}},
      color={0,0,127}));
  connect(addSmaNum.y, swi.u3)
    annotation (Line(points={{-38,80},{-20,80},{-20,-20},{-150,-20},{-150,-98},
      {-122,-98}},  color={0,0,127}));
  connect(addSmaNum.y,mulMax. u)
    annotation (Line(points={{-38,80},{-2,80}}, color={0,0,127}));
  connect(nSel, extNSel.index)
    annotation (Line(points={{-220,-120},{-30,-120},{-30,-102}},color={255,127,0}));
  connect(sort.y, extNSel.u)
    annotation (Line(points={{-58,-90},{-42,-90}}, color={0,0,127}));
  connect(extNSel.y, nSelValRep.u)
    annotation (Line(points={{-18,-90},{-2,-90}},color={0,0,127}));
  connect(nSelValRep.y, greNSelVal.u2)
    annotation (Line(points={{22,-90},{40,-90},{40,-68},{58,-68}},
      color={0,0,127}));
  connect(addSmaNum.y, greNSelVal.u1)
    annotation (Line(points={{-38,80},{-20,80},{-20,-60},{58,-60}},
      color={0,0,127}));
  connect(greNSelVal.y, notGreNSelVal.u)
    annotation (Line(points={{82,-60},{98,-60}}, color={255,0,255}));
  connect(notGreNSelVal.y, andNotDisFla.u2)
    annotation (Line(points={{122,-60},{140,-60},{140,-8},{158,-8}},
      color={255,0,255}));
  annotation (defaultComponentName="selSmaVal",
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
    extent={{-200,-140},{200,140}},
    grid={2,2})),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> smallest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
boolean vector, where <code>true</code> means a value at the corresponding index is
one of the smallest values, and <code>false</code> means otherwise.
</p>
<p>
If there are equal values from the input vector <code>u</code>, this block will
prioritize values that appear first in the input vector <code>u</code> when
selecting the <code>nSel</code> smallest values.
</p>
<p>
The disabled flag vector <code>disFla</code> serves to disable certain values
in the input vector from small-value comparison by changing these values to a large
number. If the number of values that do not have the disabled flag is smaller
than <code>nSel</code>, the final number of selected smallest values will be smaller
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
end SelectSmallestValues;
