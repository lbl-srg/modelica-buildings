within Buildings.Controls.OBC.DemandFlexibility.Generic;
block ExactEqualReal
  parameter Real alwDev(min=0)=0.01
    "allowed deviations for equality";
  CDL.Interfaces.RealInput u1
    annotation (Placement(transformation(extent={{-140,40},{-100,80}})));
  CDL.Interfaces.RealInput u2
    annotation (Placement(transformation(extent={{-140,-80},{-100,-40}})));
  CDL.Interfaces.BooleanOutput yEquFla "equal flag"
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{-36,4},{-16,24}})));
  CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-36,-76},{-16,-56}})));
  CDL.Reals.Sources.Constant con(k=alwDev)
    annotation (Placement(transformation(extent={{-94,-28},{-74,-8}})));
  CDL.Reals.Greater gre
    annotation (Placement(transformation(extent={{18,-68},{38,-48}})));
  CDL.Reals.Less les
    annotation (Placement(transformation(extent={{16,12},{36,32}})));
  CDL.Logical.And and2
    annotation (Placement(transformation(extent={{66,-10},{86,10}})));
equation
  connect(u2, add2.u1) annotation (Line(points={{-120,-60},{-66,-60},{-66,20},{
          -38,20}},             color={0,0,127}));
  connect(u2, sub.u1) annotation (Line(points={{-120,-60},{-38,-60}},
                 color={0,0,127}));
  connect(con.y, add2.u2) annotation (Line(points={{-72,-18},{-48,-18},{-48,8},
          {-38,8}},   color={0,0,127}));
  connect(con.y, sub.u2) annotation (Line(points={{-72,-18},{-48,-18},{-48,-72},
          {-38,-72}}, color={0,0,127}));
  connect(u1, les.u1) annotation (Line(points={{-120,60},{0,60},{0,22},{14,22}},
        color={0,0,127}));
  connect(u1, gre.u1) annotation (Line(points={{-120,60},{0,60},{0,-58},{16,-58}},
        color={0,0,127}));
  connect(add2.y, les.u2) annotation (Line(points={{-14,14},{14,14}},
                color={0,0,127}));
  connect(sub.y, gre.u2)
    annotation (Line(points={{-14,-66},{16,-66}}, color={0,0,127}));
  connect(les.y, and2.u1) annotation (Line(points={{38,22},{54,22},{54,0},{64,0}},
                                   color={255,0,255}));
  connect(gre.y, and2.u2) annotation (Line(points={{40,-58},{56,-58},{56,-8},{
          64,-8}},        color={255,0,255}));
  connect(and2.y, yEquFla) annotation (Line(points={{88,0},{120,0}},
               color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p><span style=\"font-family: Courier New;\">This block compares 2 real input variables, and if these 2 real input variables are equal to each other with a deviation less than alwDev, then the output is true. Otherwise, the output is false. </span></p>
</html>"));
end ExactEqualReal;
