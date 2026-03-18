within Buildings.Controls.OBC.DemandFlexibility.Subsequences;
block GeneralModeSelectionBool
  CDL.Interfaces.IntegerInput uMod
    "setpoint mode; 0 = normal;  1 = shed; 2 = rebound"
    annotation (Placement(transformation(extent={{-140,68},{-100,108}}),
        iconTransformation(extent={{-140,68},{-100,108}})));
  CDL.Logical.Switch
                   logSwi
    annotation (Placement(transformation(extent={{56,0},{76,20}})));
  CDL.Logical.Switch
                   logSwi1
    annotation (Placement(transformation(extent={{88,-48},{108,-28}})));
  CDL.Interfaces.BooleanInput
                           uShe
    annotation (Placement(transformation(extent={{-140,-52},{-100,-12}})));
  CDL.Interfaces.BooleanInput
                           uReb
    annotation (Placement(transformation(extent={{-140,-98},{-100,-58}})));
  CDL.Interfaces.BooleanOutput
                            y
    annotation (Placement(transformation(extent={{130,-20},{170,20}})));
  CDL.Integers.Equal intEqu1
    annotation (Placement(transformation(extent={{-6,0},{14,20}})));
  CDL.Integers.Sources.Constant conInt1(k=1)
    annotation (Placement(transformation(extent={{-58,-24},{-38,-4}})));
  CDL.Integers.Equal intEqu2
    annotation (Placement(transformation(extent={{42,-48},{62,-28}})));
  CDL.Integers.Sources.Constant conInt2(k=2)
    annotation (Placement(transformation(extent={{-56,-70},{-36,-50}})));
  CDL.Logical.Sources.Constant con(k=false)
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));
equation
  connect(conInt1.y, intEqu1.u2) annotation (Line(points={{-36,-14},{-22,-14},{
          -22,2},{-8,2}},    color={255,127,0}));
  connect(uMod, intEqu1.u1) annotation (Line(points={{-120,88},{-86,88},{-86,10},
          {-8,10}},                    color={255,127,0}));
  connect(uMod, intEqu2.u1) annotation (Line(points={{-120,88},{-86,88},{-86,
          -38},{40,-38}},    color={255,127,0}));
  connect(conInt2.y, intEqu2.u2) annotation (Line(points={{-34,-60},{-10,-60},{
          -10,-46},{40,-46}},                color={255,127,0}));
  connect(intEqu1.y, logSwi.u2)
    annotation (Line(points={{16,10},{54,10}}, color={255,0,255}));
  connect(intEqu2.y, logSwi1.u2)
    annotation (Line(points={{64,-38},{86,-38}}, color={255,0,255}));
  connect(logSwi1.y, y) annotation (Line(points={{110,-38},{122,-38},{122,0},{
          150,0}}, color={255,0,255}));
  connect(logSwi.y, logSwi1.u3) annotation (Line(points={{78,10},{82,10},{82,
          -46},{86,-46}}, color={255,0,255}));
  connect(uReb, logSwi1.u1) annotation (Line(points={{-120,-78},{74,-78},{74,
          -30},{86,-30}}, color={255,0,255}));
  connect(uShe, logSwi.u1) annotation (Line(points={{-120,-32},{26,-32},{26,18},
          {54,18}}, color={255,0,255}));
  connect(con.y, logSwi.u3) annotation (Line(points={{12,50},{38,50},{38,2},{54,
          2}}, color={255,0,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false,
        extent={{-100,-120},{130,120}},
        grid={2,2})),
    Documentation(info="<html>
<p><span style=\"font-size: 9pt;\">This block serves to choose which of the input variables, including uNom, uShe, uReb, to output as the output variable y, based on the mode of the system uMod. A &quot;Table&quot; block from the Modelica Standard Library would have easily achieved this task in a more concise way, but because the OBC CDL library does not have such a Table block, an elaborate logic block such as this one needs to be created. </span></p>
</html>"));
end GeneralModeSelectionBool;
