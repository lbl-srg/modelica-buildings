within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model MassTransfer
  "Validation model for the MassTransfer model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"Particle","VOC"})
    "Air";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium, nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{180,-10},{160,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    namCon={"Particle","VOC"})
    "Mass transfer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubParOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="Particle")
    "Trace substance sensor of particle in outlet air"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubParIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="Particle")
    "Trace substance sensor of particle in inlet air"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Buildings.Fluid.FixedResistances.PressureDrop res(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal=100)
    "Resistance"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in inlet air"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in outlet air"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp parSou(
    height=50/1000000000/1.293,
    duration=63072000,
    offset=50/1000000000/1.293,
    startTime=3600)
    "Particle mass flow rate"
    annotation(Placement(transformation(origin={-170,30}, extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Sin vocEps(
    amplitude=0.3,
    freqHz=1/(24*3600*365),
    offset=0.6)
    "Filtration efficiency for VOC"
    annotation (Placement(transformation(origin={10,50}, extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp parEps(
    height=-0.5,
    duration=63072000,
    offset=0.95)
    "Filtration efficiency for particle"
    annotation (Placement(transformation(origin={10,80}, extent={{-10,-10},{10,10}})));
  Controls.OBC.CDL.Reals.Sources.Ramp vocSou(
    height=50/1000000000/1.293,
    duration=63072000,
    offset=25/1000000000/1.293,
    startTime=36000) "VOC mass flow rate" annotation (Placement(transformation(
          origin={-170,-30}, extent={{-10,-10},{10,10}})));
equation
  connect(senTraSubParOut.port_a, masTra.port_b)
    annotation (Line(points={{80,0},{60,0}}, color={0,127,255}));
  connect(res.port_b,senTraSubParIn. port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(res.port_a, sou.ports[1])
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(senTraSubParIn.port_b, senTraSubVOCIn.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(senTraSubVOCIn.port_b, masTra.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  connect(senTraSubParOut.port_b, senTraSubVOCOut.port_a)
    annotation (Line(points={{100,0},{120,0}}, color={0,127,255}));
  connect(senTraSubVOCOut.port_b, sin.ports[1])
    annotation (Line(points={{140,0},{160,0}},color={0,127,255}));
  connect(parSou.y, sou.C_in[1]) annotation (Line(points={{-158,30},{-140,30},{-140,
          -8},{-122,-8}}, color={0,0,127}));
  connect(parEps.y, masTra.eps[1])
    annotation (Line(points={{22,80},{30,80},{30,6},{38,6}}, color={0,0,127}));
  connect(vocEps.y, masTra.eps[2])
    annotation (Line(points={{22,50},{28,50},{28,6},{38,6}}, color={0,0,127}));
  connect(vocSou.y, sou.C_in[2]) annotation (Line(points={{-158,-30},{-140,-30},
          {-140,-8},{-122,-8}}, color={0,0,127}));
annotation (experiment(Tolerance=1e-6, StopTime=63072000),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/MassTransfer.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
The validation model shows that along with the filtration efficiency reduces, less
contaminant is captured thus the contaminant concentration difference between the
inlet and the outlet becomes smaller.
</p>
</html>", revisions="<html>
<ul>
<li>
December 23, 2025, by Jianjun Hu:<br/>
Changed to 2 years validation.
</li>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-100},{200,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end MassTransfer;
