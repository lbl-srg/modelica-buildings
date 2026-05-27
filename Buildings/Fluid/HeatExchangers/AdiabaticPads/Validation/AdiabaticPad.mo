within Buildings.Fluid.HeatExchangers.AdiabaticPads.Validation;
model AdiabaticPad
  extends Modelica.Icons.Example;
  package MediumAir = Buildings.Media.Air;
  package MediumWater = Buildings.Media.Water;
  package MediumPropyleneGlycol =
      Buildings.Media.Antifreeze.PropyleneGlycolWater (property_T=273.15+50, X_a=
            0.4);
  CCC_test.ESTCP.AdiabaticPad adiabaticPad1(redeclare package Medium =
        MediumAir, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{-26,-18},{-6,2}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin
                                   sin(
    amplitude=1,
    freqHz=1/43200,
    offset=0)
    annotation (Placement(transformation(extent={{-114,46},{-94,66}})));
  Modelica.Fluid.Sources.Boundary_pT boundary1(redeclare package Medium =
        MediumAir,
    use_T_in=true,
    use_X_in=true,
    T=308.15,
    nPorts=1)
    annotation (Placement(transformation(extent={{10,-9},{-10,9}},
        rotation=0,
        origin={156,-7})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temIn(redeclare package Medium =
        MediumAir, m_flow_nominal=1) annotation (Placement(transformation(
          extent={{-56,-18},{-36,2}},
                                    rotation=0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temOut(redeclare package Medium =
        MediumAir, m_flow_nominal=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,12})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData bou(
    redeclare package Medium = MediumAir,
    use_m_flow_in=true,
    nPorts=1) annotation (Placement(transformation(extent={{-86,-18},{-66,2}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        ModelicaServices.ExternalReferences.loadResource(
        "modelica://CCC_test/Resources/weatherdata/Sacramento_TMY3.mos"))
    annotation (Placement(transformation(extent={{-220,-58},{-200,-38}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin
                                   sin1(
    amplitude=5,
    freqHz=1/43200,
    offset=273.15 + 35)
    annotation (Placement(transformation(extent={{132,50},{152,70}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin sin2(
    amplitude=0.002,
    freqHz=1/43200,
    offset=0.009)
    annotation (Placement(transformation(extent={{142,-64},{162,-44}})));
  Buildings.Controls.OBC.CDL.Reals.Subtract sub
    annotation (Placement(transformation(extent={{190,-94},{210,-74}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(k=1)
    annotation (Placement(transformation(extent={{78,-96},{98,-76}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort temInt(redeclare package Medium =
        MediumAir, m_flow_nominal=1) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={26,-6})));
  CCC_test.ESTCP.AdiabaticPad adiabaticPad2(redeclare package Medium =
        MediumAir, m_flow_nominal=1)
    annotation (Placement(transformation(extent={{48,-18},{68,2}})));
equation
  connect(temOut.port_b, boundary1.ports[1]) annotation (Line(points={{100,12},
          {124,12},{124,-7},{146,-7}}, color={0,127,255}));
  connect(weaDat.weaBus, bou.weaBus) annotation (Line(
      points={{-200,-48},{-174,-48},{-174,-7.8},{-86,-7.8}},
      color={255,204,51},
      thickness=0.5));
  connect(sin.y, bou.m_flow_in) annotation (Line(points={{-92,56},{-92,32},{-86,
          32},{-86,0}}, color={0,0,127}));
  connect(bou.ports[1], temIn.port_a) annotation (Line(points={{-66,-8},{-56,-8}},
                            color={0,127,255}));
  connect(sin1.y, boundary1.T_in) annotation (Line(points={{154,60},{154,30},{
          168,30},{168,-3.4}}, color={0,0,127}));
  connect(con.y, sub.u1) annotation (Line(points={{100,-86},{152,-86},{152,-78},
          {188,-78}}, color={0,0,127}));
  connect(sin2.y, sub.u2) annotation (Line(points={{164,-54},{176,-54},{176,-90},
          {188,-90}}, color={0,0,127}));
  connect(sin2.y, boundary1.X_in[1]) annotation (Line(points={{164,-54},{178,
          -54},{178,-10.6},{168,-10.6}}, color={0,0,127}));
  connect(sub.y, boundary1.X_in[2]) annotation (Line(points={{212,-84},{224,-84},
          {224,-12},{168,-12},{168,-10.6}}, color={0,0,127}));
  connect(temIn.port_b, adiabaticPad1.port_a)
    annotation (Line(points={{-36,-8},{-26,-8}}, color={0,127,255}));
  connect(adiabaticPad1.port_b, temInt.port_a) annotation (Line(points={{-6,-8},
          {14,-8},{14,-6},{16,-6}}, color={0,127,255}));
  connect(temInt.port_b, adiabaticPad2.port_a)
    annotation (Line(points={{36,-6},{36,-8},{48,-8}}, color={0,127,255}));
  connect(adiabaticPad2.port_b, temOut.port_a) annotation (Line(points={{68,-8},
          {74,-8},{74,12},{80,12}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    experiment(
      StartTime=18144000,
      StopTime=18230400,
      Interval=60,
      __Dymola_Algorithm="Dassl"));
end AdiabaticPad;
