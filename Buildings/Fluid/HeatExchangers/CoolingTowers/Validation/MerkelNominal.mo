within Buildings.Fluid.HeatExchangers.CoolingTowers.Validation;
model MerkelNominal
  "Validation model that simulates the cooling tower at design conditions"
  extends Modelica.Icons.Example;
  package Medium_W = Buildings.Media.Water "Medium model for water";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=0.5
    "Design water flow rate"
    annotation (Dialog(group="Nominal condition"));
  parameter Real ratWatAir_nominal = 0.625
    "Design water-to-air ratio"
    annotation (Dialog(group="Nominal condition"));
  Buildings.Fluid.HeatExchangers.CoolingTowers.Merkel tow(
  redeclare package Medium = Medium_W,
  ratWatAir_nominal=ratWatAir_nominal,
  TAirInWB_nominal=273.15 + 25.55,
  TWatIn_nominal=273.15 + 35,
  TWatOut_nominal=273.15 + 35 - 5.56,
  PFan_nominal=4800,
  m_flow_nominal=m_flow_nominal,
  dp_nominal=6000,
  energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
  show_T=true)
  "Cooling tower"
  annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant yFan(k=1) "Fan speed"
    annotation (Placement(transformation(extent={{-60,70},{-40,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TWetBul(k=tow.TAirInWB_nominal)
    "Wetbulb temperature"
    annotation (Placement(transformation(extent={{-60,30},{-40,50}})));
  Buildings.Fluid.Sources.MassFlowSource_T sou(
    redeclare final package Medium = Medium_W,
    m_flow=m_flow_nominal,
    T=tow.TWatIn_nominal,
    nPorts=1) "Water source"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium_W,
    nPorts=1) "Sink"
    annotation (Placement(transformation(extent={{82,-10},{62,10}})));
equation
  connect(sou.ports[1], tow.port_a)
    annotation (Line(points={{-60,0},{-10,0}}, color={0,127,255}));
  connect(tow.port_b,sin. ports[1])
    annotation (Line(points={{10,0},{62,0}}, color={0,127,255}));
  connect(TWetBul.y, tow.TAir) annotation (Line(points={{-38,40},{-28,40},{-28,4},
          {-12,4}}, color={0,0,127}));
  connect(yFan.y, tow.y) annotation (Line(points={{-38,80},{-20,80},{-20,8},{-12,
          8}}, color={0,0,127}));
annotation (
  __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatExchangers/CoolingTowers/Validation/MerkelNominal.mos"
    "Simulate and plot"),
  experiment(StartTime=0, StopTime=1000, Tolerance=1e-06),
  Documentation(info="<html>
<p>
Validation model for the Merkel cooling tower.
</p>
<p>
The model simulates the cooling tower at the design conditions,
and it verifies that at steady-state, the outlet temperature is the same as the one from the design condition.
</p>
</html>", revisions="<html>
<ul>
<li>
April 17, 2025, by Antoine Gautier and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end MerkelNominal;
