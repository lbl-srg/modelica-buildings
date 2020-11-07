within Buildings.Obsolete.DistrictHeatingCooling.SubStations.Validation;
model HeatingSubstation "Validation model for heating substation"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  Buildings.Obsolete.DistrictHeatingCooling.SubStations.Heating subSta(
    redeclare package Medium = Medium,
    Q_flow_nominal=100E3,
    show_T=true) "Substation"
                 annotation (Placement(transformation(extent={{0,0},{20,20}})));
  Buildings.Fluid.Sources.Boundary_pT war(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Warm pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-12,50})));
  Buildings.Fluid.Sources.Boundary_pT coo(
    redeclare package Medium = Medium,
    nPorts=1,
    use_T_in=true) "Cool pipe" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={30,-40})));
  Modelica.Blocks.Sources.Ramp TWar(
    height=6,
    duration=86400,
    offset=273.15 + 12) "Temperature of warm supply"
    annotation (Placement(transformation(extent={{-80,64},{-60,84}})));
  Modelica.Blocks.Sources.TimeTable QHea(table=[
    0,  100E3;
    6,  100E3;
    6,   50E3;
    18,  50E3;
    18,  75E3;
    24,  75E3],
    timeScale=3600) "Heating demand"
    annotation (Placement(transformation(extent={{-80,6},{-60,26}})));
  Modelica.Blocks.Sources.Ramp TCoo(
    duration=86400,
    height=8,
    offset=273.15 + 8) "Temperature of cold supply"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
equation
  connect(TWar.y,war. T_in) annotation (Line(points={{-59,74},{-8,74},{-8,62}},
                     color={0,0,127}));
  connect(war.ports[1], subSta.port_a) annotation (Line(points={{-12,40},{-12,
          40},{-12,10},{-6,10},{0,10}},
                            color={0,127,255}));
  connect(subSta.port_b, coo.ports[1]) annotation (Line(points={{20,10},{30,10},
          {30,-16},{30,-24},{30,-30}}, color={0,127,255}));

  connect(TCoo.y, coo.T_in)
    annotation (Line(points={{-59,-70},{26,-70},{26,-52}}, color={0,0,127}));
  connect(QHea.y, subSta.Q_flow)
    annotation (Line(points={{-59,16},{-30,16},{-2,16}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/SubStations/Validation/HeatingSubstation.mos"
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
</html>"));
end HeatingSubstation;
