within Buildings.Airflow.Multizone.Examples;
model ReverseBuoyancy
  "Model with four rooms and buoyancy-driven air circulation that reverses direction"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.MixingVolumes.MixingVolume volBotEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 25,
    nPorts=5,
    m_flow_nominal=0.001) "Volume of bottom floor, east room"
    annotation (Placement(transformation(extent={{-34,-30},{-14,-10}})));
  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice at bottom"
    annotation (Placement(transformation(extent={{38,-88},{58,-68}})));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{97,-34},{117,-14}})));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice at top"
    annotation (Placement(transformation(extent={{37,-10},{57,10}})));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-1,-30},{19,-10}})));
  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{0,-72},{20,-52}})));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{98,-74},{118,-54}})));
  MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-124,1},{-104,21}})));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice between west rooms"
                      annotation (Placement(transformation(
        origin={-114,47},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-124,73},{-104,93}})));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeClo(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    hA=3/2,
    hB=3/2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    vZer=0.01,
    dp_turbulent=0.1) "Discretized door"
    annotation (Placement(transformation(extent={{-61,-55},{-41,-35}})));
  Fluid.Delays.DelayFirstOrder volBotWes(
    redeclare package Medium = Medium,
    m_flow_nominal=1.2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=2.5*5*5,
    T_start=273.15 + 22,
    nPorts=3,
    p_start=101325) "Volume of bottom floor, west room"
    annotation (Placement(transformation(extent={{-161,-29},{-141,-9}})));
  Modelica.Blocks.Sources.Constant ope(k=1) "Constant signal for door opening"
                                            annotation (Placement(
        transformation(extent={{-102,-23},{-82,-3}})));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-18,-1},{2,19}})));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice between east rooms"
                      annotation (Placement(transformation(
        origin={-8,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-18,69},{2,89}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*10,
    T_start=273.15 + 21,
    nPorts=3,
    m_flow_nominal=0.001) "Volume of top floor, east room"
    annotation (Placement(transformation(extent={{-30,121},{-10,141}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volTopWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    V=2.5*5*10,
    nPorts=3,
    m_flow_nominal=0.001) "Volume of top floor, west room"
    annotation (Placement(transformation(extent={{-110,120},{-90,140}})));
  Buildings.Airflow.Multizone.DoorDiscretizedOperable dooOpeCloTop(
    redeclare package Medium = Medium,
    LClo=20*1E-4,
    wOpe=1,
    hOpe=2.2,
    hA=3/2,
    hB=3/2,
    CDOpe=0.78,
    CDClo=0.78,
    nCom=10,
    vZer=0.01,
    dp_turbulent=0.1) "Discretized door"
    annotation (Placement(transformation(extent={{-63,80},{-43,100}})));
  Buildings.Fluid.Sources.Boundary_pT volOut(
    redeclare package Medium = Medium,
    p=100000,
    T=283.15,
    nPorts=2) "Ambient conditions"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
      rotation=180, origin={130,-46})));
equation
  connect(ope.y, dooOpeClo.y) annotation (Line(points={{-81,-13},{-74,-13},{-74,
          -45},{-62,-45}}, color={0,0,255}));
  connect(ope.y, dooOpeCloTop.y) annotation (Line(points={{-81,-13},{-72,-13},{
          -72,90},{-64,90}}, color={0,0,255}));
  connect(oriEasTop.port_b, colEasTop.port_b)
    annotation (Line(points={{-8,59},{-8,69},{-8,69}}, color={0,127,255}));
  connect(oriWesTop.port_b, colWesBot.port_a)
    annotation (Line(points={{-114,37},{-114,21}},color={0,127,255}));
  connect(oriWesTop.port_a, colWesTop.port_b) annotation (Line(points={{-114,57},
          {-114,66},{-114,73}}, color={0,127,255}));
  connect(oriOutBot.port_b, colOutBot.port_b) annotation (Line(points={{58,-78},
          {92,-78},{92,-80},{108,-80},{108,-74}},
                                       color={0,127,255}));
  connect(colEasInBot.port_b, oriOutBot.port_a) annotation (Line(points={{10,-72},
          {10,-78},{38,-78}},                   color={0,127,255}));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(points={{9,-10},
          {10,-10},{10,0},{23.5,0},{23.5,6.10623e-16},{37,6.10623e-16}},
        color={0,127,255}));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(points={{57,
          6.10623e-16},{108,6.10623e-16},{108,-12},{108,-14},{107,-14}}, color=
          {0,127,255}));
  connect(volBotWes.ports[1], dooOpeClo.port_b2)
                                              annotation (Line(
      points={{-153.667,-29},{-153.667,-51},{-61,-51}},
      color={0,127,255}));
  connect(volBotWes.ports[2], dooOpeClo.port_a1)
                                              annotation (Line(
      points={{-151,-29},{-151,-39},{-61,-39}},
      color={0,127,255}));
  connect(colWesBot.port_b, volBotWes.ports[3])
                                             annotation (Line(
      points={{-114,1},{-114,-36},{-148.333,-36},{-148.333,-29}},
      color={0,127,255}));
  connect(volTopWes.ports[1], colWesTop.port_a) annotation (Line(
      points={{-102.667,120},{-102.667,93},{-114,93}},
      color={0,127,255}));
  connect(volTopWes.ports[2], dooOpeCloTop.port_b2) annotation (Line(
      points={{-100,120},{-100,84},{-63,84}},
      color={0,127,255}));
  connect(volTopWes.ports[3], dooOpeCloTop.port_a1) annotation (Line(
      points={{-97.3333,120},{-97.3333,110},{-90,110},{-90,96},{-63,96}},
      color={0,127,255}));
  connect(volTopEas.ports[1], dooOpeCloTop.port_b1) annotation (Line(
      points={{-22.6667,121},{-22.6667,96},{-43,96}},
      color={0,127,255}));
  connect(dooOpeCloTop.port_a2, volTopEas.ports[2]) annotation (Line(
      points={{-43,84},{-20,84},{-20,121}},
      color={0,127,255}));
  connect(colEasTop.port_a, volTopEas.ports[3]) annotation (Line(
      points={{-8,89},{-8,104},{-17.3333,104},{-17.3333,121}},
      color={0,127,255}));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{-8,39},{-8,29},{-8,19},{-8,19}},
      color={0,127,255}));
  connect(dooOpeClo.port_b1, volBotEas.ports[1])
                                              annotation (Line(
      points={{-41,-39},{-33.5,-39},{-33.5,-30},{-27.2,-30}},
      color={0,127,255}));
  connect(dooOpeClo.port_a2, volBotEas.ports[2])
                                              annotation (Line(
      points={{-41,-51},{-25.6,-51},{-25.6,-30}},
      color={0,127,255}));
  connect(colEasInBot.port_a, volBotEas.ports[3])
                                               annotation (Line(
      points={{10,-52},{10,-42},{-22,-42},{-22,-34},{-24,-34},{-24,-30}},
      color={0,127,255}));
  connect(colEasInTop.port_b, volBotEas.ports[4])
                                               annotation (Line(
      points={{9,-30},{8,-30},{8,-40},{-22,-40},{-22,-30},{-22.4,-30}},
      color={0,127,255}));
  connect(col1EasBot.port_b, volBotEas.ports[5])
                                              annotation (Line(
      points={{-8,-1},{-8,-30},{-20.8,-30}},
      color={0,127,255}));
  connect(colOutBot.port_a, volOut.ports[1]) annotation (Line(
      points={{108,-54},{108,-48},{120,-48}},
      color={0,127,255}));
  connect(colOutTop.port_b, volOut.ports[2]) annotation (Line(
      points={{107,-34},{108,-34},{108,-44},{120,-44}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{160,
            200}}), graphics={
        Rectangle(
          extent={{-52,48},{48,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,48},{-52,-96}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-52,156},{48,48}},
          lineColor={135,135,135},
          lineThickness=1),
        Rectangle(
          extent={{-176,156},{-52,48}},
          lineColor={135,135,135},
          lineThickness=1)}),
experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ReverseBuoyancy.mos"
        "Simulate and plot"),
    Documentation(info="<html>
<p>
This model is similar than
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a> but it has four
instead of three rooms.
The outdoor conditions are held constant at <i>10</i>&deg;C and
atmospheric pressure.
All four rooms are at different temperatures, with the rooms on the bottom
floor being initially at a higher temperature than the rooms on the top floor.
As time progresses, the temperatures of the two rooms on the respective floors
asymptotically approach each other. The bottom floor eventually cools below
the temperature of the top floor, because the
bottom floor directly exchanges air with the outside.
</p>
</html>", revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
</li>
<li>
May 15, 2019, by Jianjun Hu:<br/>
Replaced fluid source. This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1072\"> #1072</a>.
</li>
<li>
December 22, 2014 by Michael Wetter:<br/>
Removed <code>Modelica.Fluid.System</code>
to address issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/311\">#311</a>.
</li>
<li>
November 10, 2011, by Michael Wetter:<br/>
Added documentation.
</li>
</ul>
</html>"));
end ReverseBuoyancy;
