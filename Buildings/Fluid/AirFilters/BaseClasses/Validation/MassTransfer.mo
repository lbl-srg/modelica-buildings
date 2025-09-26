within Buildings.Fluid.AirFilters.BaseClasses.Validation;
model MassTransfer
  "Validation model for the MassTransfer model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"CO2","VOC"})
    "Air";
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium, nPorts=1)
    "Air sink"
    annotation (Placement(transformation(extent={{180,-10},{160,10}})));
  Buildings.Fluid.AirFilters.BaseClasses.MassTransfer masTra(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    namCon={"CO2","VOC"})
    "Mass transfer"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  Modelica.Blocks.Sources.Ramp eps[2](
    each duration=20,
    each height=-0.7,
    each offset=0.9,
    each startTime=5)
    "Mass transfer efficiency"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubCO2Out(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Trace substance sensor of CO2 in outlet air"
    annotation (Placement(transformation(extent={{80,-10},{100,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubCO2In(
    redeclare package Medium = Medium,
    m_flow_nominal=1)
    "Trace substance sensor of CO2 in inlet air"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(
    extent={{-120,-10},{-100,10}})));
  Modelica.Blocks.Sources.Ramp C_CO2_inflow(
    duration=20,
    height=-0.7,
    offset=0.9,
    startTime=5)  "Contaminant mass flow rate fraction for CO2"
    annotation (Placement(transformation(extent={{-170,20},{-150,40}})));
  Modelica.Blocks.Sources.Ramp C_VOC_inflow(
    duration=20,
    height=-0.6,
    offset=1,
    startTime=5)  "Contaminant mass flow rate fraction for VOC"
    annotation (Placement(transformation(extent={{-170,-40},{-150,-20}})));
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
equation
  connect(senTraSubCO2Out.port_a, masTra.port_b)
    annotation (Line(points={{80,0},{60,0}}, color={0,127,255}));
  connect(C_VOC_inflow.y, sou.C_in[2]) annotation (Line(points={{-149,-30},{-130,
          -30},{-130,-8},{-122,-8}}, color={0,0,127}));
  connect(C_CO2_inflow.y, sou.C_in[1]) annotation (Line(points={{-149,30},{-130,
          30},{-130,-8},{-122,-8}}, color={0,0,127}));
  connect(eps.y, masTra.eps) annotation (Line(points={{21,50},{30,50},{30,6},{38,
          6}},      color={0,0,127}));
  connect(res.port_b, senTraSubCO2In.port_a)
    annotation (Line(points={{-60,0},{-40,0}},   color={0,127,255}));
  connect(res.port_a, sou.ports[1])
    annotation (Line(points={{-80,0},{-100,0}},
    color={0,127,255}));
  connect(senTraSubCO2In.port_b, senTraSubVOCIn.port_a)
    annotation (Line(points={{-20,0},{0,0}},   color={0,127,255}));
  connect(senTraSubVOCIn.port_b, masTra.port_a)
    annotation (Line(points={{20,0},{40,0}},   color={0,127,255}));
  connect(senTraSubCO2Out.port_b, senTraSubVOCOut.port_a)
    annotation (Line(points={{100,0},{120,0}}, color={0,127,255}));
  connect(senTraSubVOCOut.port_b, sin.ports[1])
    annotation (Line(points={{140,0},{160,0}},color={0,127,255}));
annotation (experiment(Tolerance=1e-6, StopTime=30),
  __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/AirFilters/BaseClasses/Validation/MassTransfer.mos"
        "Simulate and plot"),
Documentation(info="<html>
<p>
From 0 to 5 seconds, the testing case is warming-up and the mass transfer
efficiencies are fixed at <i>0.9</i>.
</p>
<p>
From 5 to 25 seconds, the mass transfer efficiencies change
from <i>0.9</i> to <i>0.2</i>. After 25 seconds, they are fixed at <i>0.2</i>.
</p>
<p>
The differences between the trace substances of inlet ports and that of the outlet port first
increase and then decrease.
</p>
</html>", revisions="<html>
<ul>
<li>
December 22, 2023, by Sen Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-200,-100},{200,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end MassTransfer;
