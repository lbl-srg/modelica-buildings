within Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses;
model FanCoil4PipeHeatPorts
  "Model of a sensible only four-pipe fan coil unit computing a required water mass flow rate"
  extends PartialFanCoil4Pipe(
    final have_heaPor=true,
    final have_fluPor=false,
    final have_TSen=false);
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaCon
    "Convective heat flow rate to load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={50,70})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow heaFloCooCon
    "Convective heat flow rate to load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={50,50})));
  Fluid.Sources.Boundary_pT retAir(
    redeclare package Medium=Medium2,
    use_T_in=true,
    nPorts=1)
    "Source for return air"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}},rotation=0,origin={110,0})));
  Fluid.Sources.Boundary_pT sinAir(
    redeclare package Medium=Medium2,
    use_T_in=false,
    nPorts=1)
    "Sink for supply air"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-110,0})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFloHeaRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={110,-40})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFloCooRad
    "Radiative heat flow rate to load"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={110,-80})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zero(
    k=0)
    "Zero"
    annotation (Placement(transformation(extent={{60,-50},{80,-30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senT
    "Load temperature (measured)"
    annotation (Placement(transformation(extent={{180,10},{160,30}})));
equation
  connect(hexHea.port_b2,sinAir.ports[1])
    annotation (Line(points={{-80,0},{-100,0}},color={0,127,255}));
  connect(Q_flowCoo.y,heaFloCooCon.Q_flow)
    annotation (Line(points={{-59,40},{30,40},{30,50},{40,50}},color={0,0,127}));
  connect(Q_flowHea.y,heaFloHeaCon.Q_flow)
    annotation (Line(points={{-59,60},{-20,60},{-20,70},{40,70}},color={0,0,127}));
  connect(zero.y,heaFloHeaRad.Q_flow)
    annotation (Line(points={{82,-40},{100,-40}},color={0,0,127}));
  connect(zero.y,heaFloCooRad.Q_flow)
    annotation (Line(points={{82,-40},{90,-40},{90,-80},{100,-80}},color={0,0,127}));
  connect(retAir.ports[1],fan.port_a)
    annotation (Line(points={{100,0},{90,0}},color={0,127,255}));
  connect(heaPorCon,senT.port)
    annotation (Line(points={{200,40},{190,40},{190,20},{180,20}},color={191,0,0}));
  connect(senT.T,retAir.T_in)
    annotation (Line(points={{160,20},{132,20},{132,4},{122,4}},color={0,0,127}));
  connect(senT.T,conCoo.u_m)
    annotation (Line(points={{160,20},{120,20},{120,160},{0,160},{0,168}},color={0,0,127}));
  connect(senT.T,conHea.u_m)
    annotation (Line(points={{160,20},{120,20},{120,204},{0,204},{0,208}},color={0,0,127}));
  connect(heaFloCooCon.port,mulHeaFloCon.port_a)
    annotation (Line(points={{60,50},{110,50},{110,40},{160,40}},color={191,0,0}));
  connect(heaFloHeaCon.port,mulHeaFloCon.port_a)
    annotation (Line(points={{60,70},{110,70},{110,40},{160,40}},color={191,0,0}));
  connect(heaFloHeaRad.port,mulHeaFloRad.port_a)
    annotation (Line(points={{120,-40},{160,-40}},color={191,0,0}));
  connect(heaFloCooRad.port,mulHeaFloRad.port_a)
    annotation (Line(points={{120,-80},{140,-80},{140,-40},{160,-40}},color={191,0,0}));
  annotation (
    Documentation(
      info="<html>
<p>
This is a simplified model of a sensible only four-pipe fan coil unit for heating and cooling.
It is intended to be coupled to a room model by means of heat ports.
See
<a href=\"modelica://Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.PartialFanCoil4Pipe\">
Buildings.Experimental.DHC.Loads.BaseClasses.Examples.BaseClasses.PartialFanCoil4Pipe</a>
for a description of the modeling principles.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 21, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end FanCoil4PipeHeatPorts;
