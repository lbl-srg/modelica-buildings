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
  Fluid.Sources.Boundary_pT retAir(
    redeclare package Medium = Medium2,
    use_T_in=true,
    nPorts=1)
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
  HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
    "Radiative heat flow rate to load" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,-40})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
    "Radiative heat flow rate to load" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={172,-60})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant zero(k=0) "Zero"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
equation
  connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{182,40},{200,40}},
                                  color={191,0,0}));
  connect(retAir.ports[1], senTem.port_a)
    annotation (Line(points={{134,0},{132,0},{132,0},{130,0}},
                                                           color={0,127,255}));
  connect(hexHea.port_b2, sinAir.ports[1]) annotation (Line(points={{-80,0},{
          -142,0}},                color={0,127,255}));
  connect(senTRet.port, heaPorCon) annotation (Line(points={{180,20},{190,20},{190,
          40},{200,40}}, color={191,0,0}));
  connect(senTRet.T, retAir.T_in) annotation (Line(points={{160,20},{150,20},{
          150,14},{160,14},{160,4},{156,4}},
                                           color={0,0,127}));
  connect(Q_flowCoo.y, heaFloCooCon.Q_flow) annotation (Line(points={{141,200},{
          146,200},{146,40},{162,40}}, color={0,0,127}));
  connect(Q_flowHea.y, heaFloHeaCon.Q_flow) annotation (Line(points={{141,220},{
          150,220},{150,60},{162,60}}, color={0,0,127}));
  connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{182,60},{190,60},
          {190,40},{200,40}}, color={191,0,0}));
  connect(senTem.port_a, retAir.ports[2]) annotation (Line(points={{130,0},{132,
          0},{132,0},{134,0}},   color={0,127,255}));
  connect(heaFloHeaRad.port, heaPorRad)
    annotation (Line(points={{182,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{182,-60},{190,
          -60},{190,-40},{200,-40}}, color={191,0,0}));
  connect(zero.y, heaFloHeaRad.Q_flow)
    annotation (Line(points={{142,-40},{162,-40}}, color={0,0,127}));
  connect(zero.y, heaFloCooRad.Q_flow) annotation (Line(points={{142,-40},{152,
          -40},{152,-60},{162,-60}}, color={0,0,127}));
end FanCoil4PipesHeatPorts;
