within Buildings.Controls.OBC.DemandFlexibility.Generic;
block SelectSmallestValues

  parameter Integer nNum=5;
  parameter Integer nSel=3;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nNum]
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(ascending=true, nin=nNum)
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr[nNum](
     t=nSel)
    annotation (Placement(transformation(extent={{6,-16},{26,4}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nNum]
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  connect(intLesEquThr.u, sort.yIdx)
    annotation (Line(points={{4,-6},{-36,-6}}, color={255,127,0}));
  connect(intLesEquThr.y, y) annotation (Line(points={{28,-6},{94,-6},{94,0},{
          120,0}}, color={255,0,255}));
  connect(u, sort.u)
    annotation (Line(points={{-120,0},{-60,0}},color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This block selects the nSel smallest values out of a total of nNum values. The output is an array, where 1 means the value is one of the smallest values, and 0 means otherwise.</span></p>
</html>"));
end SelectSmallestValues;
