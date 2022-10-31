within Buildings.Fluid.Boilers.Validation;
model BoilerTableEfficiencyCurves
  "Boilers with efficiency curves specified by look-up table"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Medium model";
  parameter Buildings.Fluid.Boilers.Data.Lochinvar.Crest.FBdash2501 per
    "Record containing a table that describes the efficiency curves"
   annotation (Placement(transformation(extent={{70,60},{90,80}})));

  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    nPorts=3,
    p(displayUnit="Pa") = 300000,
    T=sou.T) "Sink"
    annotation (Placement(transformation(extent={{82,-30},{62,-10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    p=300000 + per.dp_nominal,
    use_T_in=true,
    nPorts=3) "Source"
    annotation (Placement(transformation(extent={{-32,-30},{-12,-10}})));
  Buildings.Fluid.Boilers.BoilerTable boi1(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    T_start=293.15,
    per=per) "Boiler 1 set at 5% firing rate"
    annotation (Placement(transformation(extent={{20,44},{40,64}})));
  Buildings.HeatTransfer.Sources.FixedTemperature
    TAmb1(T=288.15) "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,72},{20,92}})));
  Buildings.Fluid.Boilers.BoilerTable boi2(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    T_start=293.15,
    per=per) "Boiler 2 set at 50% firing rate"
    annotation (Placement(transformation(extent={{20,-16},{40,4}})));
  Buildings.HeatTransfer.Sources.FixedTemperature
    TAmb2(T=288.15) "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,12},{20,32}})));
  Buildings.Fluid.Boilers.BoilerTable boi3(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    from_dp=true,
    T_start=293.15,
    per=per) "Boiler 3 set at 100% firing rate"
    annotation (Placement(transformation(extent={{20,-76},{40,-56}})));
  HeatTransfer.Sources.FixedTemperature TAmb3(T=288.15)
    "Ambient temperature in boiler room"
    annotation (Placement(transformation(extent={{0,-48},{20,-28}})));

  Modelica.Blocks.Sources.Constant y1(k=0.05)
    "Setting the firing rate at constant 5%"
    annotation (Placement(transformation(extent={{-90,52},{-70,72}})));
  Modelica.Blocks.Sources.Constant y2(k=0.5)
    "Setting the firing rate at constant 50%"
    annotation (Placement(transformation(extent={{-90,-8},{-70,12}})));
  Modelica.Blocks.Sources.Constant y3(k=1)
    "Setting the firing rate at constant 100%"
    annotation (Placement(transformation(extent={{-90,-68},{-70,-48}})));
  Modelica.Blocks.Sources.Ramp TIn(
    height=per.effCur[1,end]-per.effCur[1,2],
    duration=3600,
    offset=per.effCur[1,2],
    y(final unit="K",
      displayUnit="degC"))
    "Ramps the T_inlet from the first to the last temperature provided by the efficiency curve table"
    annotation (Placement(transformation(extent={{-62,-26},{-42,-6}})));

equation
  connect(TAmb1.port, boi1.heatPort) annotation (Line(
      points={{20,82},{30,82},{30,61.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(TAmb2.port, boi2.heatPort) annotation (Line(
      points={{20,22},{30,22},{30,1.2}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(boi2.port_b, sin.ports[2]) annotation (Line(
      points={{40,-6},{52,-6},{52,-20},{62,-20}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(boi1.port_b, sin.ports[1]) annotation (Line(
      points={{40,54},{52,54},{52,-21.3333},{62,-21.3333}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(TAmb3.port, boi3.heatPort)
    annotation (Line(points={{20,-38},{30,-38},{30,-58.8}}, color={191,0,0}));
  connect(boi3.port_b, sin.ports[3]) annotation (Line(points={{40,-66},{52,-66},
          {52,-18.6667},{62,-18.6667}}, color={0,127,255}));
  connect(boi1.port_a, sou.ports[1]) annotation (Line(points={{20,54},{-6,54},{
          -6,-21.3333},{-12,-21.3333}},
                              color={0,127,255}));
  connect(boi3.port_a, sou.ports[2]) annotation (Line(points={{20,-66},{-6,-66},
          {-6,-20},{-12,-20}},           color={0,127,255}));
  connect(boi2.port_a, sou.ports[3]) annotation (Line(points={{20,-6},{-6,-6},{
          -6,-18.6667},{-12,-18.6667}},
                             color={0,127,255}));
  connect(y1.y, boi1.y) annotation (Line(points={{-69,62},{18,62}},
                color={0,0,127}));
  connect(y2.y, boi2.y) annotation (Line(points={{-69,2},{18,2}},
        color={0,0,127}));
  connect(y3.y, boi3.y) annotation (Line(points={{-69,-58},{18,-58}},
                    color={0,0,127}));
  connect(TIn.y, sou.T_in)
    annotation (Line(points={{-41,-16},{-34,-16}}, color={0,0,127}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Boilers/Validation/BoilerTableEfficiencyCurves.mos"
        "Simulate and plot"),
    experiment(Tolerance=1e-6, StopTime=3600),
    Documentation(info="<html>
<p>
This model computes the efficiency of boilers for using the model
<a href=\"Buildings.Fluid.Boilers.BoilerTable\">
Buildings.Fluid.Boilers.BoilerTable</a>
at firing rates of 5%, 50%, and 100%.
</p>
<p>
The models are configured to compute the following efficiency curves.
</p>
<p align=\"center\">
<img alt=\"Image of efficiency curves\"
src=\"modelica://Buildings/Resources/Images/Fluid/Boilers/Validation/BoilerTableEfficiencyCurves.png\"/>
</p>
</html>", revisions="<html>
<ul>
<li>
October 13, 2021, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2651\">#2651</a>.
</li>
</ul>
</html>"));
end BoilerTableEfficiencyCurves;
