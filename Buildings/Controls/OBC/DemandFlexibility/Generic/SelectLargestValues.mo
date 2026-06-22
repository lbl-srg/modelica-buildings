within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectLargestValues "Select largest values"

  parameter Integer nVal
    "Number of values to compare";
  final parameter Real smaNum=1e-5
    "A small number to allow equal values to be ranked";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nVal]
    "A vector of all values"
    annotation (Placement(transformation(extent={{-320,-20},{-280,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanInput disFla[nVal]
    "A flag vector to disqualify certain values from comparison"
    annotation (Placement(transformation(extent={{-320,40},{-280,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of largest values to select"
    annotation (Placement(transformation(extent={{-320,-80},{-280,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nVal]
    "True: the value is one of the largest values"
    annotation (Placement(transformation(extent={{280,-20},{320,20}}),
        iconTransformation(extent={{100,-20},{140,20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant numSeq[nVal](k=1:1:nVal)
    "A numerical sequence from one up to the number of values"
    annotation (Placement(transformation(extent={{-260,-40},{-240,-20}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter scaSmaNum[nVal](k=smaNum)
    "Scale the numerical sequence with a small number"
    annotation (Placement(transformation(extent={{-220,-40},{-200,-20}})));
  Buildings.Controls.OBC.CDL.Reals.Add addSmaNum[nVal]
    "Add different small numbers to input values to allow ranking of equal input values"
    annotation (Placement(transformation(extent={{-180,0},{-160,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor extNSel(nin=nVal)
    "Extract the nSel largest value"
    annotation (Placement(transformation(extent={{80,0},{100,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator nSelValRep(nout=nVal)
    "Replicate the nSel largest value into a vector"
    annotation (Placement(transformation(extent={{120,0},{140,20}})));
  Buildings.Controls.OBC.CDL.Reals.Less lesNSelVal[nVal]
    "Check whether the input value is less than the nSel largest value"
    annotation (Placement(transformation(extent={{160,-40},{180,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not notLesNSelVal[nVal]
    "Check whether the input value is greater than or equal to the nSel largest value"
    annotation (Placement(transformation(extent={{200,-40},{220,-20}})));
  Buildings.Controls.OBC.CDL.Logical.Not notDisFla[nVal]
    "The disqualified flag is not active"
    annotation (Placement(transformation(extent={{60,50},{80,70}})));
  Buildings.Controls.OBC.CDL.Logical.And andNotDisFla[nVal]
    "The disqualified flag must not be true to qualify as one of the largest values"
    annotation (Placement(transformation(extent={{240,-10},{260,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiMin mulMin(nin=nVal)
    "Minimum of all values"
    annotation (Placement(transformation(extent={{-140,20},{-120,40}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter subOne(final p=-1)
    "Subtract one to the minimum value"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Buildings.Controls.OBC.CDL.Reals.Switch swi[nVal]
    "True to pass a small value; false to pass the input value"
    annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Controls.OBC.CDL.Routing.RealScalarReplicator minRep(nout=nVal)
    "Replicate the minimum value minus one into a vector"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(ascending=false, nin=nVal)
    "Output the sorted input values in descending order"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
equation
  connect(disFla, notDisFla.u)
    annotation (Line(points={{-300,60},{58,60}}, color={255,0,255}));
  connect(notDisFla.y, andNotDisFla.u1)
    annotation (Line(points={{82,60},{200,60},{200,0},{238,0}}, color={255,0,255}));
  connect(andNotDisFla.y, y)
    annotation (Line(points={{262,0},{300,0}}, color={255,0,255}));
  connect(mulMin.y,subOne. u)
    annotation (Line(points={{-118,30},{-102,30}}, color={0,0,127}));
  connect(disFla, swi.u2)
    annotation (Line(points={{-300,60},{-20,60},{-20,10},{-2,10}},
      color={255,0,255}));
  connect(minRep.y, swi.u1)
    annotation (Line(points={{-38,30},{-10,30},{-10,18},{-2,18}}, color={0,0,127}));
  connect(swi.y, sort.u)
    annotation (Line(points={{22,10},{38,10}},color={0,0,127}));
  connect(subOne.y, minRep.u)
    annotation (Line(points={{-78,30},{-62,30}}, color={0,0,127}));
  connect(numSeq.y, scaSmaNum.u)
    annotation (Line(points={{-238,-30},{-222,-30}}, color={0,0,127}));
  connect(scaSmaNum.y, addSmaNum.u2)
    annotation (Line(points={{-198,-30},{-190,-30},{-190,4},{-182,4}},
      color={0,0,127}));
  connect(u, addSmaNum.u1)
    annotation (Line(points={{-300,0},{-240,0},{-240,16},{-182,16}},
      color={0,0,127}));
  connect(addSmaNum.y, swi.u3)
    annotation (Line(points={{-158,10},{-60,10},{-60,2},{-2,2}}, color={0,0,127}));
  connect(addSmaNum.y, mulMin.u)
    annotation (Line(points={{-158,10},{-150,10},{-150,30},{-142,30}},
      color={0,0,127}));
  connect(nSel, extNSel.index)
    annotation (Line(points={{-300,-60},{90,-60},{90,-2}}, color={255,127,0}));
  connect(sort.y, extNSel.u)
    annotation (Line(points={{62,10},{78,10}}, color={0,0,127}));
  connect(extNSel.y, nSelValRep.u)
    annotation (Line(points={{102,10},{118,10}}, color={0,0,127}));
  connect(nSelValRep.y, lesNSelVal.u2)
    annotation (Line(points={{142,10},{150,10},{150,-38},{158,-38}},
      color={0,0,127}));
  connect(addSmaNum.y, lesNSelVal.u1)
    annotation (Line(points={{-158,10},{-60,10},{-60,-30},{158,-30}},
      color={0,0,127}));
  connect(lesNSelVal.y, notLesNSelVal.u)
    annotation (Line(points={{182,-30},{198,-30}}, color={255,0,255}));
  connect(notLesNSelVal.y, andNotDisFla.u2)
    annotation (Line(points={{222,-30},{230,-30},{230,-8},{238,-8}},
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
    extent={{-280,-100},{280,100}},
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
