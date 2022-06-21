within Buildings.Fluid.HydronicConfigurations.Controls.Validation;
model PIDWithReset
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID(
    Ti=1,
    Td=1,
    y_reset=0.5)
    "Controller"
    annotation (Placement(transformation(extent={{30,10},{50,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.ModelTime modTim
    "Model time"
    annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
  Buildings.Controls.OBC.CDL.Continuous.GreaterThreshold greEquThr(t=1)
    "Outputs true after t=1"
    annotation (Placement(transformation(extent={{-40,10},{-20,30}})));
  Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable mode(table=[0,0; 1,0; 1,
        1; 5,1; 5,2; 9,2; 9,0; 10,0], period=10)
                                      "Operating mode"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));
  Buildings.Controls.OBC.CDL.Integers.Change cha
    "Monitor change of signal value"
    annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
  Buildings.Controls.OBC.CDL.Continuous.PIDWithReset conPID1(
    Ti=1,
    Td=1,
    y_reset=0.5)
    "Controller"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes1
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{70,10},{90,30}})));
  Buildings.Controls.OBC.CDL.Continuous.IntegratorWithReset intWitRes2
    "Integrator whose output should be brought to the set point"
    annotation (Placement(transformation(extent={{70,-50},{90,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant val1(k=0) "Any value"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Constant con(final k=false)
    "Constant false"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal setPoi
    "Set point"
    annotation (Placement(transformation(extent={{-8,10},{12,30}})));
equation
  connect(modTim.y, greEquThr.u)
    annotation (Line(points={{-58,20},{-42,20}},
                                               color={0,0,127}));
  connect(mode.y[1], cha.u)
    annotation (Line(points={{-58,-60},{-42,-60}}, color={255,127,0}));
  connect(greEquThr.y, conPID.trigger) annotation (Line(points={{-18,20},{-16,
          20},{-16,0},{34,0},{34,8}}, color={255,0,255}));
  connect(cha.y, conPID1.trigger)
    annotation (Line(points={{-18,-60},{34,-60},{34,-52}}, color={255,0,255}));
  connect(conPID.y, intWitRes1.u)
    annotation (Line(points={{52,20},{68,20}}, color={0,0,127}));
  connect(conPID1.y, intWitRes2.u)
    annotation (Line(points={{52,-40},{68,-40}}, color={0,0,127}));
  connect(intWitRes1.y, conPID.u_m) annotation (Line(points={{92,20},{96,20},{
          96,0},{40,0},{40,8}}, color={0,0,127}));
  connect(intWitRes2.y, conPID1.u_m) annotation (Line(points={{92,-40},{96,-40},
          {96,-60},{40,-60},{40,-52}}, color={0,0,127}));
  connect(val1.y, intWitRes1.y_reset_in) annotation (Line(points={{-58,60},{60,
          60},{60,12},{68,12}}, color={0,0,127}));
  connect(val1.y, intWitRes2.y_reset_in) annotation (Line(points={{-58,60},{60,
          60},{60,-48},{68,-48}}, color={0,0,127}));
  connect(con.y, intWitRes1.trigger)
    annotation (Line(points={{-58,-10},{80,-10},{80,8}}, color={255,0,255}));
  connect(con.y, intWitRes2.trigger) annotation (Line(points={{-58,-10},{66,-10},
          {66,-56},{80,-56},{80,-52}}, color={255,0,255}));
  connect(greEquThr.y, setPoi.u)
    annotation (Line(points={{-18,20},{-10,20}}, color={255,0,255}));
  connect(setPoi.y, conPID.u_s)
    annotation (Line(points={{14,20},{28,20}}, color={0,0,127}));
  connect(setPoi.y, conPID1.u_s) annotation (Line(points={{14,20},{20,20},{20,
          -40},{28,-40}}, color={0,0,127}));
annotation (
    experiment(
      StopTime=10,
      Tolerance=1e-06));
end PIDWithReset;
