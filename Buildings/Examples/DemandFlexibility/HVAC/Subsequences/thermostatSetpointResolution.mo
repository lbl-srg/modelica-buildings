within Buildings.Examples.DemandFlexibility.HVAC.Subsequences;
block thermostatSetpointResolution
  parameter Real temRes=0.5556
    "temperature setpoint resolution";
  Buildings.Controls.OBC.CDL.Interfaces.RealInput setpointCommand annotation (
      Placement(transformation(extent={{-140,-20},{-100,20}}),
        iconTransformation(extent={{-140,-20},{-100,20}})));
  Buildings.Controls.OBC.CDL.Interfaces.RealOutput actualSetpoint annotation (
      Placement(transformation(extent={{150,-20},{190,20}}), iconTransformation(
          extent={{150,-20},{190,20}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=293.15)
    annotation (Placement(transformation(extent={{-94,-22},{-74,-2}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{-42,28},{-22,48}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1
    annotation (Placement(transformation(extent={{-12,-34},{8,-14}})));
  Buildings.Controls.OBC.CDL.Reals.Round rou(n=0)
    annotation (Placement(transformation(extent={{28,-36},{48,-16}})));
  Buildings.Controls.OBC.CDL.Reals.Multiply mul
    annotation (Placement(transformation(extent={{62,-62},{82,-42}})));
  Buildings.Controls.OBC.CDL.Reals.Add add2
    annotation (Placement(transformation(extent={{98,-52},{118,-32}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con1(k=temRes)
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
equation
  connect(setpointCommand, sub.u1) annotation (Line(points={{-120,0},{-56,0},{
          -56,44},{-44,44}}, color={0,0,127}));
  connect(con.y, sub.u2)
    annotation (Line(points={{-72,-12},{-52,-12},{-52,32},{-44,32}},
                                                            color={0,0,127}));
  connect(sub.y, div1.u1) annotation (Line(points={{-20,38},{-18,38},{-18,-18},{
          -14,-18}}, color={0,0,127}));
  connect(div1.y, rou.u)
    annotation (Line(points={{10,-24},{10,-26},{26,-26}}, color={0,0,127}));
  connect(rou.y, mul.u1) annotation (Line(points={{50,-26},{58,-26},{58,-38},{60,
          -38},{60,-46}},
                    color={0,0,127}));
  connect(mul.y, add2.u2) annotation (Line(points={{84,-52},{90,-52},{90,-48},{96,
          -48}},      color={0,0,127}));
  connect(con.y, add2.u1) annotation (Line(points={{-72,-12},{-52,-12},{-52,-8},
          {88,-8},{88,-36},{96,-36}},                       color={0,0,127}));
  connect(add2.y, actualSetpoint) annotation (Line(points={{120,-42},{144,-42},{
          144,0},{170,0}},  color={0,0,127}));
  connect(con1.y, div1.u2) annotation (Line(points={{-58,-50},{-22,-50},{-22,
          -30},{-14,-30}}, color={0,0,127}));
  connect(con1.y, mul.u2) annotation (Line(points={{-58,-50},{50,-50},{50,-58},
          {60,-58}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{150,100}},
        grid={2,2})),                                            Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{150,
            100}},
        grid={2,2})));
end thermostatSetpointResolution;
