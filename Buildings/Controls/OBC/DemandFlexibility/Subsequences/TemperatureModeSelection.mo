within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block TemperatureModeSelection
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  CDL.Reals.Switch swi
    annotation (Placement(transformation(extent={{0,52},{20,72}})));
  CDL.Reals.Switch swi1
    annotation (Placement(transformation(extent={{18,4},{38,24}})));
  CDL.Reals.Switch swi2
    annotation (Placement(transformation(extent={{6,-48},{26,-28}})));
  CDL.Interfaces.RealInput uPre
    annotation (Placement(transformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.RealInput uNom
    annotation (Placement(transformation(extent={{-140,-12},{-100,28}})));
  CDL.Interfaces.RealInput uShe
    annotation (Placement(transformation(extent={{-140,-52},{-100,-12}})));
  CDL.Interfaces.RealInput uReb
    annotation (Placement(transformation(extent={{-140,-98},{-100,-58}})));
  CDL.Interfaces.RealOutput y
    annotation (Placement(transformation(extent={{100,-20},{140,20}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-48,90},{-28,110}})));
  CDL.Integers.Sources.Constant conInt(k=-1)
    annotation (Placement(transformation(extent={{-82,58},{-62,78}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-40,8},{-20,28}})));
  CDL.Integers.Sources.Constant conInt1(k=1)
    annotation (Placement(transformation(extent={{-82,2},{-62,22}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{-52,-112},{-32,-92}})));
  CDL.Integers.Sources.Constant conInt2(k=2)
    annotation (Placement(transformation(extent={{-86,-144},{-66,-124}})));
equation
  connect(uPre, swi.u1) annotation (Line(points={{-120,46},{-12,46},{-12,70},{
          -2,70}}, color={0,0,127}));
  connect(swi2.y, y) annotation (Line(points={{28,-38},{94,-38},{94,0},{120,0}},
        color={0,0,127}));
  connect(uMod, intEqu.u1) annotation (Line(points={{-120,88},{-60,88},{-60,100},
          {-50,100}}, color={255,127,0}));
  connect(conInt.y, intEqu.u2) annotation (Line(points={{-60,68},{-52,68},{-52,
          84},{-50,84},{-50,92}}, color={255,127,0}));
  connect(intEqu.y, swi.u2) annotation (Line(points={{-26,100},{-16,100},{-16,
          62},{-2,62}}, color={255,0,255}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-60,12},{-54,12},{
          -54,10},{-42,10}}, color={255,127,0}));
  connect(uMod, intEqu1.u1) annotation (Line(points={{-120,88},{-86,88},{-86,26},
          {-56,26},{-56,18},{-42,18}}, color={255,127,0}));
  connect(uMod, intEqu2.u1) annotation (Line(points={{-120,88},{-86,88},{-86,
          -102},{-54,-102}}, color={255,127,0}));
  connect(conInt2.y, intEqu2.u2) annotation (Line(points={{-64,-134},{-56,-134},
          {-56,-118},{-54,-118},{-54,-110}}, color={255,127,0}));
  connect(intEqu1.y, swi1.u2) annotation (Line(points={{-18,18},{6,18},{6,14},{
          16,14}}, color={255,0,255}));
  connect(intEqu2.y, swi2.u2) annotation (Line(points={{-30,-102},{-6,-102},{-6,
          -38},{4,-38}}, color={255,0,255}));
  connect(uShe, swi1.u1) annotation (Line(points={{-120,-32},{-6,-32},{-6,22},{
          16,22}}, color={0,0,127}));
  connect(uReb, swi2.u1) annotation (Line(points={{-120,-78},{-8,-78},{-8,-34},
          {-4,-34},{-4,-30},{4,-30}}, color={0,0,127}));
  connect(swi.y, swi1.u3)
    annotation (Line(points={{22,62},{42,62},{42,6},{16,6}}, color={0,0,127}));
  connect(swi1.y, swi2.u3) annotation (Line(points={{40,14},{50,14},{50,-46},{4,
          -46}}, color={0,0,127}));
  connect(uNom, swi.u3) annotation (Line(points={{-120,8},{-90,8},{-90,48},{-10,
          48},{-10,54},{-2,54}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end TemperatureModeSelection;
