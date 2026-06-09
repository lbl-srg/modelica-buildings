within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectSmallestValues "Select smallest values"

  parameter Integer nVal "Number of values to compare";

  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nVal]
    "A vector of all values"
    annotation (Placement(transformation(extent={{-140,40},{-100,80}}),
        iconTransformation(extent={{-140,40},{-100,80}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nVal]
    "True: the value is one of the smallest values"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.IntegerInput nSel
    "Number of smallest values to select"
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}}),
        iconTransformation(extent={{-140,-80},{-100,-40}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sort sort(ascending=true, nin=nVal)
    "Output the indices of the sorted vector in ascending order"
    annotation (Placement(transformation(extent={{-60,20},{-40,40}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqual intLesEqu[nVal]
    "If indices are no larger than the number of smallest values to select, the corresponding values are the smallest values"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Buildings.Controls.OBC.CDL.Routing.IntegerScalarReplicator intScaRep(nout=nVal)
    "Replicate the number of smallest values to select"
    annotation (Placement(transformation(extent={{-60,-60},{-40,-40}})));
equation
  connect(intLesEqu.y, y)
    annotation (Line(points={{42,0},{120,0}},color={255,0,255}));
  connect(u, sort.u)
    annotation (Line(points={{-120,60},{-80,60},{-80,30},{-62,30}},
      color={0,0,127}));
  connect(nSel, intScaRep.u)
    annotation (Line(points={{-120,-60},{-80,-60},{-80,-50},{-62,-50}},
      color={255,127,0}));
  connect(intScaRep.y, intLesEqu.u2)
    annotation (Line(points={{-38,-50},{-20,-50},{-20,-8},{18,-8}},
      color={255,127,0}));
  connect(sort.yIdx, intLesEqu.u1)
    annotation (Line(points={{-38,24},{-20,24},{-20,0},{18,0}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
This block selects the <code>nSel</code> smallest values out of a total of
<code>nVal</code> values. The output is a boolean vector, where <code>true</code> 
means a value at the corresponding index is one of the smallest values, and
<code>false</code> means otherwise.
</p>
</html>"));
end SelectSmallestValues;
