within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block ZoneTemperatureModeSelectionBool
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal; -1 = precool or preheat; 1 = ratchet; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  CDL.Logical.Switch
                   logSwi
    annotation (Placement(transformation(extent={{14,56},{34,76}})));
  CDL.Logical.Switch
                   logSwi1
    annotation (Placement(transformation(extent={{54,4},{74,24}})));
  CDL.Logical.Switch
                   logSwi2
    annotation (Placement(transformation(extent={{92,-48},{112,-28}})));
  CDL.Interfaces.BooleanInput
                           uPre
    annotation (Placement(transformation(extent={{-140,26},{-100,66}})));
  CDL.Interfaces.BooleanInput
                           uShe
    annotation (Placement(transformation(extent={{-140,-52},{-100,-12}})));
  CDL.Interfaces.BooleanInput
                           uReb
    annotation (Placement(transformation(extent={{-140,-98},{-100,-58}})));
  CDL.Interfaces.BooleanOutput
                            y
    annotation (Placement(transformation(extent={{130,-20},{170,20}})));
  CDL.Integers.Equal intEqu
    annotation (Placement(transformation(extent={{-24,86},{-4,106}})));
  CDL.Integers.Sources.Constant conInt(k=-1)
    annotation (Placement(transformation(extent={{-92,96},{-72,116}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{6,-18},{26,2}})));
  CDL.Integers.Sources.Constant conInt1(k=1)
    annotation (Placement(transformation(extent={{-50,-26},{-30,-6}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{30,-48},{50,-28}})));
  CDL.Integers.Sources.Constant conInt2(k=2)
    annotation (Placement(transformation(extent={{-50,-70},{-30,-50}})));
  CDL.Logical.Sources.Constant con(k=false)
    annotation (Placement(transformation(extent={{-58,58},{-38,78}})));
equation
  connect(intEqu.y, logSwi.u2) annotation (Line(points={{-2,96},{4,96},{4,66},{
          12,66}},      color={255,0,255}));
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-28,-16},{4,-16}},
                             color={255,127,0}));
  connect(uMod, intEqu1.u1) annotation (Line(points={{-120,88},{-72,88},{-72,26},
          {-16,26},{-16,-8},{4,-8}},   color={255,127,0}));
  connect(uMod, intEqu2.u1) annotation (Line(points={{-120,88},{-72,88},{-72,
          -38},{28,-38}},    color={255,127,0}));
  connect(conInt2.y, intEqu2.u2) annotation (Line(points={{-28,-60},{14,-60},{
          14,-46},{28,-46}},                 color={255,127,0}));
  connect(intEqu1.y, logSwi1.u2) annotation (Line(points={{28,-8},{34,-8},{34,
          14},{52,14}},
                    color={255,0,255}));
  connect(intEqu2.y, logSwi2.u2) annotation (Line(points={{52,-38},{90,-38}},
                             color={255,0,255}));
  connect(logSwi2.y, y) annotation (Line(points={{114,-38},{124,-38},{124,0},{
          150,0}},
               color={255,0,255}));
  connect(logSwi1.y, logSwi2.u3) annotation (Line(points={{76,14},{82,14},{82,
          -46},{90,-46}},        color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{36,66},{44,66},{44,6},
          {52,6}},              color={255,0,255}));
  connect(uPre, logSwi.u1) annotation (Line(points={{-120,46},{-12,46},{-12,74},
          {12,74}}, color={255,0,255}));
  connect(uReb, logSwi2.u1) annotation (Line(points={{-120,-78},{62,-78},{62,
          -30},{90,-30}},                  color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{-36,68},{-22,68},{-22,58},
          {12,58}}, color={255,0,255}));
  connect(logSwi1.u1, uShe) annotation (Line(points={{52,22},{-66,22},{-66,-32},
          {-120,-32}}, color={255,0,255}));
  connect(conInt.y, intEqu.u1) annotation (Line(points={{-70,106},{-48,106},{
          -48,96},{-26,96}}, color={255,127,0}));
  connect(uMod, intEqu.u2)
    annotation (Line(points={{-120,88},{-26,88}}, color={255,127,0}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This block serves to choose which of the input variables, including uPre, uNom, uShe, uReb, to output as the output variable y, based on the mode of the system uMod. A &quot;Table&quot; block from the Modelica Standard Library would have easily achieved this task in a more concise way, but because the OBC CDL library does not have such a Table block, an elaborate logic block such as this one needs to be created. </span></p>
</html>"));
end ZoneTemperatureModeSelectionBool;
