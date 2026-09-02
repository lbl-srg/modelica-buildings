within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectLargestValues "Select largest values"

  parameter Integer nVal(min=1)
    "Number of values to compare";
  final parameter Real smaNum=1e-5
    "A small number to allow equal values to be ranked";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nVal]
    "A vector of all values"
    annotation (Placement(transformation(extent={{-240,90},{-200,130}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nVal]
    "A flag vector to exclude values from comparison. Set to true if the value should be excluded"
    annotation (Placement(transformation(extent={{-240,0},{-200,40}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of largest values to select"
    annotation (Placement(transformation(extent={{-240,-130},{-200,-90}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nVal]
    "True: the value is one of the largest values"
    annotation (Placement(transformation(extent={{200,0},{240,40}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numSeq[nVal](final k={i
        for i in nVal:-1:1})
    "A descending numerical sequence from the number of values down to one"
    annotation (Placement(transformation(extent={{-160,50},{-140,70}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaSmaNum[nVal](
    final k=fill(smaNum, nVal))
    "Scale the numerical sequence with a small number"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Buildings.Controls.OBC.CDL.Reals.Add addSmaNum[nVal]
    "Add different small numbers to input values to allow ranking of equal input values"
    annotation (Placement(transformation(extent={{-60,90},{-40,110}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extNSel(
    final nin=nVal)
    "Extract the n-th largest value, where n equals the number of largest values to select"
    annotation (Placement(transformation(extent={{-40,-90},{-20,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator nSelValRep(
    final nout=nVal)
    "Replicate the n-th largest value into a vector, where n equals the number of largest values to select"
    annotation (Placement(transformation(extent={{0,-90},{20,-70}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesNSelVal[nVal]
    "Check whether the input value is less than the n-th largest value, where n equals the number of largest values to select"
    annotation (Placement(transformation(extent={{60,-60},{80,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesNSelVal[nVal]
    "Check whether the input value is greater than or equal to the n-th largest value, where n equals the number of largest values to select"
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDisFla[nVal]
    "The disqualified flag is not active"
    annotation (Placement(transformation(extent={{-100,10},{-80,30}})));
  Buildings.Controls.OBC.CDL.Logical.And andNotDisFla[nVal]
    "The disqualified flag must not be true to qualify as one of the largest values"
    annotation (Placement(transformation(extent={{160,10},{180,30}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(
    final nin=nVal)
    "Minimum of all values"
    annotation (Placement(transformation(extent={{0,110},{20,130}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subOne(
    final p=-1)
    "Subtract one to the minimum value"
    annotation (Placement(transformation(extent={{40,110},{60,130}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nVal]
    "True to pass a small value; false to pass the input value"
    annotation (Placement(transformation(extent={{-120,-90},{-100,-70}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator minRep(
    final nout=nVal)
    "Replicate the minimum value minus one into a vector"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(
    final ascending=false,
    final nin=nVal)
    "Output the sorted input values in descending order"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
equation
  connect(disFla, notDisFla.u)
    annotation (Line(points={{-220,20},{-102,20}}, color={255,0,255}));
  connect(notDisFla.y, andNotDisFla.u1)
    annotation (Line(points={{-78,20},{158,20}}, color={255,0,255}));
  connect(andNotDisFla.y, y)
    annotation (Line(points={{182,20},{220,20}}, color={255,0,255}));
  connect(mulMin.y,subOne. u)
    annotation (Line(points={{22,120},{38,120}}, color={0,0,127}));
  connect(disFla, swi.u2)
    annotation (Line(points={{-220,20},{-160,20},{-160,-80},{-122,-80}},
      color={255,0,255}));
  connect(minRep.y, swi.u1)
    annotation (Line(points={{102,120},{120,120},{120,-20},{-140,-20},{-140,-72},
      {-122,-72}}, color={0,0,127}));
  connect(swi.y, sort.u)
    annotation (Line(points={{-98,-80},{-82,-80}}, color={0,0,127}));
  connect(subOne.y, minRep.u)
    annotation (Line(points={{62,120},{78,120}}, color={0,0,127}));
  connect(numSeq.y, scaSmaNum.u)
    annotation (Line(points={{-138,60},{-122,60}}, color={0,0,127}));
  connect(scaSmaNum.y, addSmaNum.u2)
    annotation (Line(points={{-98,60},{-80,60},{-80,94},{-62,94}},
      color={0,0,127}));
  connect(u, addSmaNum.u1)
    annotation (Line(points={{-220,110},{-80,110},{-80,106},{-62,106}},
      color={0,0,127}));
  connect(addSmaNum.y, swi.u3)
    annotation (Line(points={{-38,100},{-20,100},{-20,-10},{-150,-10},{-150,-88},
      {-122,-88}}, color={0,0,127}));
  connect(addSmaNum.y, mulMin.u)
    annotation (Line(points={{-38,100},{-20,100},{-20,120},{-2,120}},
      color={0,0,127}));
  connect(nSel, extNSel.index)
    annotation (Line(points={{-220,-110},{-30,-110},{-30,-92}}, color={255,127,0}));
  connect(sort.y, extNSel.u)
    annotation (Line(points={{-58,-80},{-42,-80}}, color={0,0,127}));
  connect(extNSel.y, nSelValRep.u)
    annotation (Line(points={{-18,-80},{-2,-80}},color={0,0,127}));
  connect(nSelValRep.y, lesNSelVal.u2)
    annotation (Line(points={{22,-80},{40,-80},{40,-58},{58,-58}},
      color={0,0,127}));
  connect(addSmaNum.y, lesNSelVal.u1)
    annotation (Line(points={{-38,100},{-20,100},{-20,-50},{58,-50}},
      color={0,0,127}));
  connect(lesNSelVal.y, notLesNSelVal.u)
    annotation (Line(points={{82,-50},{98,-50}},   color={255,0,255}));
  connect(notLesNSelVal.y, andNotDisFla.u2)
    annotation (Line(points={{122,-50},{140,-50},{140,12},{158,12}},
      color={255,0,255}));
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
    extent={{-200,-140},{200,140}},
    grid={2,2})),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> largest values out of a total of
<code>nVal</code> values from the input vector <code>u</code>. The output is a
boolean vector, where <code>true</code> means a value at the corresponding index is
one of the largest values, and <code>false</code> means otherwise.
</p>
<p>
If there are equal values from the input vector <code>u</code>, this block will
prioritize values that appear first in the input vector <code>u</code> when
selecting the <code>nSel</code> largest values.
</p>
<p>
The disabled flag vector <code>disFla</code> serves to disable certain values
in the input vector from large-value comparison by changing these values to a small
number. If the number of values that do not have the disabled flag is smaller
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
