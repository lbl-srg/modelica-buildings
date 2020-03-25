within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model FanCoil4PipeHeatPorts
  "Model of a sensible only four-pipe fan coil unit computing a required water mass flow rate"
  extends PartialFanCoil4Pipe(
    final have_heaPor=true,
    final have_fluPor=false,
    final have_TSen=false);
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
        origin={120,0})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium = Medium2,
    use_T_in=false,
    nPorts=1)
    "Sink for supply air"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-152,0})));
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
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senT
    "Load temperature (measured)"
    annotation (Placement(transformation(extent={{180,10},{160,30}})));
equation
  connect(heaFloCooCon.port, heaPorCon) annotation (Line(points={{182,40},{200,40}},
                                  color={191,0,0}));
  connect(hexHea.port_b2, sinAir.ports[1]) annotation (Line(points={{-80,0},{
          -142,0}},                color={0,127,255}));
  connect(Q_flowCoo.y, heaFloCooCon.Q_flow) annotation (Line(points={{141,200},{
          146,200},{146,40},{162,40}}, color={0,0,127}));
  connect(Q_flowHea.y, heaFloHeaCon.Q_flow) annotation (Line(points={{141,220},{
          150,220},{150,60},{162,60}}, color={0,0,127}));
  connect(heaFloHeaCon.port, heaPorCon) annotation (Line(points={{182,60},{190,60},
          {190,40},{200,40}}, color={191,0,0}));
  connect(heaFloHeaRad.port, heaPorRad)
    annotation (Line(points={{182,-40},{200,-40}}, color={191,0,0}));
  connect(heaFloCooRad.port, heaPorRad) annotation (Line(points={{182,-60},{190,
          -60},{190,-40},{200,-40}}, color={191,0,0}));
  connect(zero.y, heaFloHeaRad.Q_flow)
    annotation (Line(points={{142,-40},{162,-40}}, color={0,0,127}));
  connect(zero.y, heaFloCooRad.Q_flow) annotation (Line(points={{142,-40},{152,
          -40},{152,-60},{162,-60}}, color={0,0,127}));
  connect(retAir.ports[1], fan.port_a)
    annotation (Line(points={{110,0},{90,0}}, color={0,127,255}));
  connect(heaPorCon, senT.port) annotation (Line(points={{200,40},{190,40},{190,
          20},{180,20}}, color={191,0,0}));
  connect(senT.T, retAir.T_in) annotation (Line(points={{160,20},{150,20},{150,
          4},{132,4}}, color={0,0,127}));
  connect(senT.T, conCoo.u_m) annotation (Line(points={{160,20},{-40,20},{-40,
          160},{0,160},{0,168}}, color={0,0,127}));
  connect(senT.T, conHea.u_m) annotation (Line(points={{160,20},{-40,20},{-40,
          200},{0,200},{0,208}}, color={0,0,127}));
annotation (
Documentation(
info="<html>
<p>
This is a simplified model of a sensible only four-pipe fan coil unit for heating and cooling.
It is intended to be coupled to a room model by means of heat ports.
See
<a href=\"modelica://Buildings.Applications.DHC.Loads.Examples.BaseClasses.PartialFanCoil4Pipe\">
Buildings.Applications.DHC.Loads.Examples.BaseClasses.PartialFanCoil4Pipe</a>
for a description of the modeling principles.
</p>
</html>",
revisions=
"<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end FanCoil4PipeHeatPorts;
