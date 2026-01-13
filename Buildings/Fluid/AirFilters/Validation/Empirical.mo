within Buildings.Fluid.AirFilters.Validation;
model Empirical "Example for using the empirical air filter model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"VOC","Particle"})
    "Air";
  parameter Buildings.Fluid.AirFilters.Data.Generic per(
    mCon_max= 2,
    mCon_start=0,
    namCon={"Particle","VOC"},
    filEffPar={
      Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters(rat={0,0.5,1},eps={0.7,0.6,0.5}),
      Buildings.Fluid.AirFilters.Data.Characteristics.FiltrationEfficiencyParameters(rat={0,0.5,1},eps={0.8,0.7,0.5})},
    m_flow_nominal=1,
    dp_nominal=100) "Performance dataset"
    annotation (Placement(transformation(extent={{40,60},{60,80}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(
    extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(
    extent={{130,-10},{110,10}})));
  Buildings.Fluid.AirFilters.Empirical airFil(
    redeclare package Medium = Medium,
    per=per) "Air filter"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubParIn(
    redeclare package Medium = Medium, m_flow_nominal=1,
    substanceName="Particle")
    "Trace substance sensor of CO2 in inlet air"
    annotation (Placement(transformation(extent={{-70,-10},{-50,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in inlet air"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubParOut(
    redeclare package Medium = Medium, m_flow_nominal=1,
    substanceName="Particle")
    "Trace substance sensor of CO2 in outlet air"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in outlet air"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin parSou(
    amplitude = 25/1000000000/1.293,
    freqHz = 1/(24*3600*365),
    offset = 100/1000000000/1.293)
    "Particle mass flow rate"
    annotation(Placement(transformation(origin = {-150, 40}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin vocSou(
    amplitude = 5/1000000000/1.293,
    freqHz = 1/(24*3600*365),
    offset = 10/1000000000/1.293)
    "VOC mass flow rate"
    annotation(Placement(transformation(origin = {-150, -40}, extent = {{-10, -10}, {10, 10}})));
  Buildings.Controls.OBC.CDL.Logical.TrueDelay resFil(
    delayTime = 3600)
    annotation(Placement(transformation(origin = {50, 30}, extent = {{-10, -10}, {10, 10}})));
equation
  connect(senTraSubVOCIn.port_b, airFil.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(senTraSubParIn.port_b, senTraSubVOCIn.port_a)
    annotation (Line(points={{-50,0},{-40,0}}, color={0,127,255}));
  connect(sou.ports[1], senTraSubParIn.port_a)
    annotation (Line(points={{-80,0},{-70,0}}, color={0,127,255}));
  connect(airFil.port_b, senTraSubParOut.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTraSubParOut.port_b, senTraSubVOCOut.port_a)
    annotation (Line(points={{60,0},{70,0}}, color={0,127,255}));
  connect(senTraSubVOCOut.port_b, sin.ports[1])
    annotation (Line(points={{90,0},{110,0}}, color={0,127,255}));
  connect(vocSou.y, sou.C_in[1]) annotation(
    Line(points={{-138,-40},{-120,-40},{-120,-8},{-102,-8}},color={0,0,127}));
  connect(parSou.y, sou.C_in[2]) annotation(
    Line(points={{-138, 40},{-120, 40}, {-120,-8},{-102,-8}},color={0,0,127}));
  connect(airFil.yRep, resFil.u) annotation(
    Line(points={{22,7},{30,7},{30,30},{38,30}},color = {255, 0, 255}));
  connect(resFil.y, airFil.uRep) annotation(
    Line(points={{62,30},{70,30},{70,50},{-10,50},{-10,6},{-2,6}}, color={255,0,255}));
  annotation (experiment(
      StopTime=63072000,
      Tolerance=1e-06),
      __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/Validation/Empirical.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
The example shows a filter that captures particles and VOCs. It has different
filtration efficiencies capturing the particles and VOCs.
</p>
<p>
It set up a simulation that shows the performance change of the filter in 2 years operation. The
filtration efficiencies for both contaminants decrease along with the contaminant
accumulation on the filtration.
</p>
<p>
When the contaminant accumultion reaches the maximum at around 412 days, the filter
is replaced and the efficiencies are reset.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Empirical;
