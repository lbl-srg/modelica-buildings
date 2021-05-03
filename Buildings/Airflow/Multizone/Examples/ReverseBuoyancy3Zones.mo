within Buildings.Airflow.Multizone.Examples;
model ReverseBuoyancy3Zones
  "Model with three rooms and buoyancy-driven air circulation that reverses direction"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;
  Buildings.Fluid.MixingVolumes.MixingVolume volEas(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 25,
    nPorts=5,
    m_flow_nominal=0.001) "Control volume for east room"
    annotation (Placement(transformation(extent={{-32,-26},{-12,-6}})));
  Buildings.Airflow.Multizone.Orifice oriOutBot(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice at bottom of east room"
    annotation (Placement(transformation(extent={{38,-86},{58,-66}})));
  Buildings.Airflow.Multizone.MediumColumn colOutTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{91,-30},{111,-10}})));
  Buildings.Airflow.Multizone.Orifice oriOutTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice at top of east room"
    annotation (Placement(transformation(extent={{39,-10},{59,10}})));
  Buildings.Airflow.Multizone.MediumColumn colEasInTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{11,-30},{31,-10}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volOut(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=1E12,
    T_start=273.15 + 15,
    nPorts=2,
    m_flow_nominal=0.001) "Control volume for outside"
    annotation (Placement(transformation(extent={{129,-30},{149,-10}})));
  Buildings.Airflow.Multizone.MediumColumn colEasInBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{10,-70},{30,-50}})));
  Buildings.Airflow.Multizone.MediumColumn colOutBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}})));
  Buildings.Airflow.Multizone.MediumColumn colWesBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-130,11},{-110,31}})));
  Buildings.Airflow.Multizone.Orifice oriWesTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice between west room and top"
                      annotation (Placement(transformation(
        origin={-120,47},
        extent={{-10,-10},{10,10}},
        rotation=270)));
  Buildings.Airflow.Multizone.MediumColumn colWesTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-130,79},{-110,99}})));
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
  Modelica.Blocks.Sources.Constant ope(k=1) "Constant signal for door opening"
    annotation (Placement(
        transformation(extent={{-102,-23},{-82,-3}})));
  Buildings.Airflow.Multizone.MediumColumn col1EasBot(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromBottom)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-20,11},{0,31}})));
  Buildings.Airflow.Multizone.Orifice oriEasTop(
    redeclare package Medium = Medium,
    m=0.5,
    A=0.01,
    dp_turbulent=0.1) "Orifice between east room and top"
                      annotation (Placement(transformation(
        origin={-10,49},
        extent={{-10,-10},{10,10}},
        rotation=90)));
  Buildings.Airflow.Multizone.MediumColumn colEasTop(
    redeclare package Medium = Medium,
    h=1.5,
    densitySelection=Buildings.Airflow.Multizone.Types.densitySelection.fromTop)
    "Medium column to compute static pressure of air"
    annotation (Placement(transformation(extent={{-20,79},{0,99}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volTop(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T_start=273.15 + 20,
    m_flow_nominal=0.001,
    V=2.5*10*10,
    nPorts=2) "Control volume for top floor room"
    annotation (Placement(transformation(extent={{-70,120},{-50,140}})));
  Buildings.Fluid.MixingVolumes.MixingVolume volWes(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=2.5*5*5,
    T_start=273.15 + 22,
    nPorts=3,
    m_flow_nominal=0.001) "Control volume for west room"
    annotation (Placement(transformation(extent={{-164,-27},{-144,-7}})));
equation
  connect(dooOpeClo.port_b2, volWes.ports[1]) annotation (Line(
      points={{-61,-51},{-104,-51},{-104,-50},{-156.667,-50},{-156.667,-27}},
      color={0,127,255}));
  connect(dooOpeClo.port_a1, volWes.ports[2]) annotation (Line(
      points={{-61,-39},{-108,-39},{-108,-40},{-154,-40},{-154,-27}},
      color={0,127,255}));
  connect(dooOpeClo.port_b1, volEas.ports[1]) annotation (Line(
      points={{-41,-39},{-25.2,-39},{-25.2,-26}},
      color={0,127,255}));
  connect(dooOpeClo.port_a2, volEas.ports[2]) annotation (Line(
      points={{-41,-51},{-23.6,-51},{-23.6,-26}},
      color={0,127,255}));
  connect(colWesTop.port_b, oriWesTop.port_a) annotation (Line(
      points={{-120,79},{-120,57}},
      color={0,127,255}));
  connect(oriWesTop.port_b, colWesBot.port_a) annotation (Line(
      points={{-120,37},{-120,31}},
      color={0,127,255}));
  connect(colWesBot.port_b, volWes.ports[3]) annotation (Line(
      points={{-120,11},{-120,-34},{-151.333,-34},{-151.333,-27}},
      color={0,127,255}));
  connect(colEasTop.port_b, oriEasTop.port_b) annotation (Line(
      points={{-10,79},{-10,59}},
      color={0,127,255}));
  connect(oriEasTop.port_a, col1EasBot.port_a) annotation (Line(
      points={{-10,39},{-10,31}},
      color={0,127,255}));
  connect(colEasInBot.port_a, volEas.ports[3]) annotation (Line(
      points={{20,-50},{-22,-50},{-22,-26}},
      color={0,127,255}));
  connect(colEasInTop.port_b, volEas.ports[4]) annotation (Line(
      points={{21,-30},{21,-38},{-20.4,-38},{-20.4,-26}},
      color={0,127,255}));
  connect(col1EasBot.port_b, volEas.ports[5]) annotation (Line(
      points={{-10,11},{-10,-34},{-18.8,-34},{-18.8,-26}},
      color={0,127,255}));
  connect(colOutTop.port_b, volOut.ports[1]) annotation (Line(
      points={{101,-30},{100,-30},{100,-36},{137,-36},{137,-30}},
      color={0,127,255}));
  connect(volOut.ports[2], colOutBot.port_a) annotation (Line(
      points={{141,-30},{141,-40},{100,-40},{100,-50}},
      color={0,127,255}));
  connect(colOutBot.port_b, oriOutBot.port_b) annotation (Line(
      points={{100,-70},{100,-76},{58,-76}},
      color={0,127,255}));
  connect(oriOutBot.port_a, colEasInBot.port_b) annotation (Line(
      points={{38,-76},{20,-76},{20,-70}},
      color={0,127,255}));
  connect(colEasInTop.port_a, oriOutTop.port_a) annotation (Line(
      points={{21,-10},{20,-10},{20,6.10623e-16},{39,6.10623e-16}},
      color={0,127,255}));
  connect(oriOutTop.port_b, colOutTop.port_a) annotation (Line(
      points={{59,6.10623e-16},{101,6.10623e-16},{101,-10}},
      color={0,127,255}));
  connect(ope.y, dooOpeClo.y) annotation (Line(
      points={{-81,-13},{-72,-13},{-72,-45},{-62,-45}},
      color={0,0,127}));
  connect(colWesTop.port_a, volTop.ports[1]) annotation (Line(
      points={{-120,99},{-120,110},{-62,110},{-62,120}},
      color={0,127,255}));
  connect(colEasTop.port_a, volTop.ports[2]) annotation (Line(
      points={{-10,99},{-10,110},{-58,110},{-58,120}},
      color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-200,-100},{160,
            200}}), graphics={Rectangle(
          extent={{-52,48},{48,-96}},
          lineColor={135,135,135},
          lineThickness=1), Rectangle(
          extent={{-176,48},{-52,-96}},
          lineColor={135,135,135},
          lineThickness=1), Rectangle(
          extent={{-176,160},{48,48}},
          lineColor={135,135,135},
          lineThickness=1)}),
experiment(Tolerance=1e-06, StopTime=3600),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/ReverseBuoyancy3Zones.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
March 26, 2021 by Michael Wetter:<br/>
Updated comments for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/515\">IBPSA, #515</a>.
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
</html>", info="<html>
<p>
This model is similar than
<a href=\"modelica://Buildings.Airflow.Multizone.Validation.ThreeRoomsContam\">
Buildings.Airflow.Multizone.Validation.ThreeRoomsContam</a>.
However, the initial temperatures are such that at the start of the
simulation, the flow direction between the three rooms reverses direction.
</p>
<p>
At the start of the simulation,
the outdoor temperature is <i>15</i>&deg;C,
and the temperatures of the volumes are
<i>20</i>&deg;C at the top,
<i>22</i>&deg;C at the bottom west and
<i>25</i>&deg;C at the bottom east.
Thus, initially there is a net flow circulation in the counter-clock
direction.
Because the volume on the east exchanges air with the outside,
it cools down fast. Once it cooled down sufficiently,
the flow direction between the three rooms reverses
because the air in the bottom east is heaviest.
</p>
</html>"));
end ReverseBuoyancy3Zones;
