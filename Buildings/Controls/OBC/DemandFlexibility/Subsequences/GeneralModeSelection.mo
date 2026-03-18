within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block GeneralModeSelection
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{56,0},{76,20}})));
  CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{88,-48},{108,-28}})));
  CDL.Interfaces.RealInput uNom
    annotation (Placement(transformation(extent={{-140,-12},{-100,28}})));
  CDL.Interfaces.RealInput uShe
    annotation (Placement(transformation(extent={{-140,-52},{-100,-12}})));
  CDL.Interfaces.RealInput uReb
    annotation (Placement(transformation(extent={{-140,-98},{-100,-58}})));
  CDL.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{130,-20},{170,20}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  CDL.Integers.Sources.Constant conInt1(k=1)
    annotation (Placement(transformation(extent={{-58,-24},{-38,-4}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{42,-48},{62,-28}})));
  CDL.Integers.Sources.Constant conInt2(k=2)
    annotation (Placement(transformation(extent={{-56,-70},{-36,-50}})));
equation
  connect(swi2.y, y) annotation (Line(points={{110,-38},{124,-38},{124,0},{150,
          0}},
        color={0,0,127}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-36,-14},{-22,-14},{
          -22,2},{-8,2}},    color={255,127,0}));
  connect(uMod, intEqu1.u1) annotation (Line(points={{-120,88},{-86,88},{-86,10},
          {-8,10}},                    color={255,127,0}));
  connect(uMod, intEqu2.u1) annotation (Line(points={{-120,88},{-86,88},{-86,
          -38},{40,-38}},    color={255,127,0}));
  connect(conInt2.y, intEqu2.u2) annotation (Line(points={{-34,-60},{-10,-60},{
          -10,-46},{40,-46}},                color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{16,10},{54,10}},
                   color={255,0,255}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{64,-38},{86,-38}},
                         color={255,0,255}));
  connect(uShe, swi1.u1) annotation (Line(points={{-120,-32},{28,-32},{28,18},{
          54,18}}, color={0,0,127}));
  connect(uReb, swi2.u1) annotation (Line(points={{-120,-78},{74,-78},{74,-30},
          {86,-30}},                  color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{78,10},{82,10},{82,-46},{
          86,-46}},
                 color={0,0,127}));
  connect(uNom, swi1.u3) annotation (Line(points={{-120,8},{-64,8},{-64,32},{40,
          32},{40,2},{54,2}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})));
end GeneralModeSelection;
