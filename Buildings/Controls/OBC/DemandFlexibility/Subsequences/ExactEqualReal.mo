within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block ExactEqualReal
  parameter Real alwDev(min=0)=0.001
    "allowed deviations for equality";
  CDL.Interfaces.RealInput u1
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput u2
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanOutput yEquFla "equal flag"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-30,-26},{-10,-6}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-40,-86},{-20,-66}})));
  CDL.Reals.Sources.Constant con(k=alwDev)
    annotation (Placement(transformation(extent={{-94,-96},{-74,-76}})));
  CDL.Reals.Greater gre
    annotation (Placement(transformation(extent={{26,-78},{46,-58}})));
  CDL.Reals.Less les
    annotation (Placement(transformation(extent={{24,12},{44,32}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{56,-40},{76,-20}})));
equation
  connect(u2, add2.u1) annotation (Line(points={{-120,-60},{-120,-16},{-42,-16},
          {-42,-10},{-32,-10}}, color={0,0,127}));
  connect(u2, sub.u1) annotation (Line(points={{-120,-60},{-50,-60},{-50,-70},{-42,
          -70}}, color={0,0,127}));
  connect(con.y, add2.u2) annotation (Line(points={{-72,-86},{-64,-86},{-64,-22},
          {-32,-22}}, color={0,0,127}));
  connect(con.y, sub.u2) annotation (Line(points={{-72,-86},{-64,-86},{-64,-82},
          {-42,-82}}, color={0,0,127}));
  connect(u1, les.u1) annotation (Line(points={{-120,60},{12,60},{12,22},{22,22}},
        color={0,0,127}));
  connect(u1, gre.u1) annotation (Line(points={{-120,60},{12,60},{12,-68},{24,-68}},
        color={0,0,127}));
  connect(add2.y, les.u2) annotation (Line(points={{-8,-16},{14,-16},{14,14},{22,
          14}}, color={0,0,127}));
  connect(sub.y, gre.u2)
    annotation (Line(points={{-18,-76},{24,-76}}, color={0,0,127}));
  connect(les.y, and2.u1) annotation (Line(points={{46,22},{54,22},{54,-16},{44,
          -16},{44,-30},{54,-30}}, color={255,0,255}));
  connect(gre.y, and2.u2) annotation (Line(points={{48,-68},{56,-68},{56,-46},{54,
          -46},{54,-38}}, color={255,0,255}));
  connect(and2.y, yEquFla) annotation (Line(points={{78,-30},{94,-30},{94,0},{120,
          0}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ExactEqualReal;
