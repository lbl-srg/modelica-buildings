within Buildings.Experimental.DistrictHeatingCooling.SubStations.Validation;
model CoolingSubstation "Validation model for cooling substation"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  Cooling subSta(redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal=-100E3) "Substation"
                 annotation (Placement(transformation(extent={{-8,0},{12,20}})));
  Modelica.Blocks.Sources.TimeTable QCoo(table=[
    0,       -100E3;
    6*3600,  -100E3;
    6*3600,   -50E3;
    18*3600,  -50E3;
    18*3600,  -75E3;
    24*3600,  -75E3]) "Cooling demand"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Buildings.Fluid.Sources.Boundary_pT coo(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true) "Cool pipe" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-42})));
  Modelica.Blocks.Sources.Ramp TCoo(
    duration=86400,
    height=8,
    offset=273.15 + 8) "Temperature of cold supply"
    annotation (Placement(transformation(extent={{-80,-84},{-60,-64}})));
  Buildings.Fluid.Sources.Boundary_pT war(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Warm pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={32,50})));
  Modelica.Blocks.Sources.Ramp TWar(
    height=6,
    duration=86400,
    offset=273.15 + 12) "Temperature of warm supply"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
equation

  connect(TCoo.y, coo.T_in)
    annotation (Line(points={{-59,-74},{-24,-74},{-24,-54}}, color={0,0,127}));
  connect(TWar.y,war. T_in) annotation (Line(points={{-59,70},{36,70},{36,62}},
                     color={0,0,127}));
  connect(coo.ports[1], subSta.port_a) annotation (Line(points={{-20,-32},{-20,
          -32},{-20,10},{-8,10}},    color={0,127,255}));
  connect(subSta.port_b, war.ports[1])
    annotation (Line(points={{12,10},{32,10},{32,40}}, color={0,127,255}));
  connect(QCoo.y, subSta.Q_flow)
    annotation (Line(points={{-59,16},{-34,16},{-10,16}}, color={0,0,127}));
  annotation(experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/SubStations/Validation/CoolingSubstation.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model tests the heating substation.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end CoolingSubstation;
