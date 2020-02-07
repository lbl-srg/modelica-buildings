within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model FanCoil4PipesHeatPorts
  extends PartialFanCoil4Pipes(
    final have_heaPor=true);
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaCon
    "Convective heat flow rate to load"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,60})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooCon
    "Convective heat flow rate to load"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,40})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,-60})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,-40})));
  Fluid.Sources.Boundary_pT retAir(
    redeclare package Medium = Medium2,
    use_T_in=true,
    nPorts=2)
    "Source for return air"
    annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=0,
        origin={144,0})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium2,
    use_T_in=false,
    nPorts=1)
    "Sink for supply air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-152,0})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTRet
    "Return air temperature (sensed)"
    annotation (Placement(transformation(extent={{180,10},{160,30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(k=0)
    annotation (Placement(transformation(extent={{100,-60},{120,-40}})));
equation
  connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{182,40},{200,40}},
                                  color={191,0,0}));
  connect(retAir.ports[1], senTem.port_a)
    annotation (Line(points={{134,2},{132,2},{132,0},{130,0}},
                                                           color={0,127,255}));
  connect(hexHea.port_b2, sinAir.ports[1]) annotation (Line(points={{-80,0},{
          -142,0}},                color={0,127,255}));
  connect(senTRet.port, heaPorCon) annotation (Line(points={{180,20},{190,20},{190,
          40},{200,40}}, color={191,0,0}));
  connect(senTRet.T, retAir.T_in) annotation (Line(points={{160,20},{150,20},{
          150,14},{160,14},{160,4},{156,4}},
                                           color={0,0,127}));
  connect(zero.y, heaFloHeaRad.Q_flow) annotation (Line(points={{122,-50},{132,-50},
          {132,-40},{162,-40}}, color={0,0,127}));
  connect(zero.y, heaFloCooRad.Q_flow) annotation (Line(points={{122,-50},{132,-50},
          {132,-60},{162,-60}}, color={0,0,127}));
  connect(Q_flowCoo.y, heaFloCooCon.Q_flow) annotation (Line(points={{141,200},{
          150,200},{150,40},{162,40}}, color={0,0,127}));
  connect(Q_flowHea.y, heaFloHeaCon.Q_flow) annotation (Line(points={{141,220},{
          154,220},{154,60},{162,60}}, color={0,0,127}));
  connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{182,60},{190,60},
          {190,40},{200,40}}, color={191,0,0}));
  connect(heaFloHeaRad.port, heaPorRad)
    annotation (Line(points={{182,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{182,-60},{190,
          -60},{190,-40},{200,-40}}, color={191,0,0}));
  connect(TSetHea, conHea.u_s)
    annotation (Line(points={{-220,220},{-12,220}}, color={0,0,127}));
  connect(TSetCoo, conCoo.u_s)
    annotation (Line(points={{-220,180},{-12,180}}, color={0,0,127}));
  connect(senTem.T, conCoo.u_m) annotation (Line(points={{120,11},{120,40},{0,
          40},{0,168}},             color={0,0,127}));
  connect(senTem.T, conHea.u_m) annotation (Line(points={{120,11},{120,40},{0,
          40},{0,160},{-20,160},{-20,200},{0,200},{0,208}}, color={0,0,127}));
  connect(senTem.port_a, retAir.ports[2]) annotation (Line(points={{130,0},{132,
          0},{132,-2},{134,-2}}, color={0,127,255}));
end FanCoil4PipesHeatPorts;
