within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block SelectSmallestValues

  parameter Integer nNum=5;
  parameter Integer nSel=3;
  Buildings.Controls.OBC.CDL.Interfaces.RealInput u[nNum]
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2[nNum]
    annotation (Placement(transformation(extent={{-26,-10},{-6,10}})));
  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter gai[nNum](k=0.000001
        *Buildings.Controls.OBC.CDL.Constants.pi)
    annotation (Placement(transformation(extent={{-56,-68},{-36,-48}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant const[nNum](k=1:1:
        nNum)
    annotation (Placement(transformation(extent={{-88,-68},{-68,-48}})));
  Buildings.Controls.OBC.CDL.Reals.Sort sort(ascending=true, nin=nNum)
    annotation (Placement(transformation(extent={{14,-10},{34,10}})));
  Buildings.Controls.OBC.CDL.Integers.LessEqualThreshold intLesEquThr[nNum](
     t=nSel)
    annotation (Placement(transformation(extent={{56,-16},{76,4}})));
  Buildings.Controls.OBC.CDL.Interfaces.BooleanOutput y[nNum]
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
equation
  connect(const.y, gai.u)
    annotation (Line(points={{-66,-58},{-58,-58}}, color={0,0,127}));
  connect(gai.y, add2.u2)
    annotation (Line(points={{-34,-58},{-34,-6},{-28,-6}}, color={0,0,127}));
  connect(u, add2.u1) annotation (Line(points={{-120,0},{-66,0},{-66,6},{-28,6}},
        color={0,0,127}));
  connect(add2.y, sort.u)
    annotation (Line(points={{-4,0},{12,0}}, color={0,0,127}));
  connect(intLesEquThr.u, sort.yIdx)
    annotation (Line(points={{54,-6},{36,-6}}, color={255,127,0}));
  connect(intLesEquThr.y, y) annotation (Line(points={{78,-6},{92,-6},{92,0},{
          120,0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end SelectSmallestValues;
