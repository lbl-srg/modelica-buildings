within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model DecouplingTemperature
  "Model illustrating the operation of a decoupling circuit with Delta-T control"
  extends
    Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples.Decoupling(
      con(have_ctl=false, dpBal3_nominal=0));

  Buildings.Controls.OBC.CDL.Continuous.Subtract dT(
    y(final unit="K")) "Compute T1Ret-T2Ret"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={60,-40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dTSetVal[2](
    final k={if typ == Types.ControlFunction.Heating then 1 else -1, 1})
    "Delta-T set point values"
    annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Controls.OBC.CDL.Routing.RealExtractor dTSet(
    y(final unit="K"),
    final nin=2,
    outOfRangeValue=0) "Select actual set point based on operating mode"
    annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=0,
        origin={140,0})));
  Controls.PIDWithOperatingMode ctl(
    k=0.1,
    Ti=120,
    u_s(final unit="K", displayUnit="K"),
    u_m(final unit="K", displayUnit="K"),
    final reverseActing=typ==Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Heating)
    "Controller"
    annotation (Placement(transformation(extent={{90,-50},{110,-30}})));
equation
  connect(mode.y[1], dTSet.index) annotation (Line(points={{-118,100},{20,100},
          {20,80},{150,80},{150,14},{140,14},{140,12}},
                     color={255,127,0}));
  connect(mode.y[1], ctl.mod) annotation (Line(points={{-118,100},{-10,100},{
          -10,-54},{94,-54},{94,-52}},
                                     color={255,127,0}));

  connect(T2Ret.T, dT.u2)
    annotation (Line(points={{40,9},{40,-34},{48,-34}}, color={0,0,127}));
  connect(T1ConRet.T, dT.u1) annotation (Line(points={{31,-20},{36,-20},{36,-46},
          {48,-46}}, color={0,0,127}));
  connect(dT.y, ctl.u_m) annotation (Line(points={{72,-40},{74,-40},{74,-60},{
          100,-60},{100,-52}}, color={0,0,127}));
  connect(dTSetVal.y, dTSet.u)
    annotation (Line(points={{122,0},{128,0}}, color={0,0,127}));
  connect(dTSet.y, ctl.u_s) annotation (Line(points={{152,0},{154,0},{154,-20},
          {80,-20},{80,-40},{88,-40}}, color={0,0,127}));
  connect(ctl.y, con.yVal) annotation (Line(points={{112,-40},{120,-40},{120,
          -110},{-6,-110},{-6,10},{-2,10}}, color={0,0,127}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/DecouplingTemperature.mos"
    "Simulate and plot"));
end DecouplingTemperature;
