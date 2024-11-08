within Buildings.Fluid.AirFilters.Validation;
model Empirical "Example for using the empirical air filter model"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air(extraPropertiesNames={"VOC","CO2"})
    "Air";
  parameter Buildings.Fluid.AirFilters.BaseClasses.Data.Generic per(
    mCon_nominal=10,
    substanceName={"CO2","VOC"},
    filEffPar(
      rat={{0,0.5,1},{0,0.5,1}},
      eps={{0.7,0.6,0.5},{0.8,0.7,0.5}}))
    "Performance dataset"
    annotation (Placement(transformation(extent={{22,46},{42,66}})));
  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = Medium,
    use_C_in=true,
    p(displayUnit="Pa") = 101325 + 100,
    nPorts=1)
    "Air source"
    annotation (Placement(transformation(
    extent={{-106,-10},{-86,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = Medium,
    p(displayUnit="Pa") = 101325,
    nPorts=1)
    "Air sink"
    annotation (Placement(transformation(
    extent={{130,-10},{110,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse repSig(period=60, shift=30)
    "Filter replacement signal"
    annotation (Placement(transformation(extent={{-50,40},{-30,60}})));
  Modelica.Blocks.Sources.Ramp C_CO2_inflow(
    duration=30,
    height=-0.03,
    offset=0.1,
    startTime=20) "Contaminant mass flow rate fraction for CO2"
    annotation (Placement(transformation(extent={{-160,20},{-140,40}})));
  Modelica.Blocks.Sources.Ramp C_VOC_inflow(
    duration=30,
    height=-0.03,
    offset=0.1,
    startTime=20)
    "Contaminant mass flow rate fraction for VOC"
    annotation (Placement(transformation(extent={{-160,-40},{-140,-20}})));
  Buildings.Fluid.AirFilters.Empirical airFil(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    dp_nominal(displayUnit="Pa") = 100,
    per=per) "Air filter"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubCO2In(
    redeclare package Medium = Medium, m_flow_nominal=1)
    "Trace substance sensor of CO2 in inlet air"
    annotation (Placement(transformation(extent={{-72,-10},{-52,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCIn(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in inlet air"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubCO2Out(
    redeclare package Medium = Medium, m_flow_nominal=1)
    "Trace substance sensor of CO2 in outlet air"
    annotation (Placement(transformation(extent={{32,-10},{52,10}})));
  Buildings.Fluid.Sensors.TraceSubstancesTwoPort senTraSubVOCOut(
    redeclare package Medium = Medium,
    m_flow_nominal=1,
    substanceName="VOC") "Trace substance sensor of VOC in outlet air"
    annotation (Placement(transformation(extent={{70,-10},{90,10}})));
equation
  connect(repSig.y, airFil.uRep) annotation (Line(points={{-28,50},{-4,50},{-4,
          6},{-2,6}}, color={255,0,255}));
  connect(C_CO2_inflow.y, sou.C_in[2]) annotation (Line(points={{-139,30},{-120,
          30},{-120,-8},{-108,-8}}, color={0,0,127}));
  connect(C_VOC_inflow.y, sou.C_in[1]) annotation (Line(points={{-139,-30},{-120,
          -30},{-120,-8},{-108,-8}}, color={0,0,127}));
  connect(senTraSubVOCIn.port_b, airFil.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(senTraSubCO2In.port_b, senTraSubVOCIn.port_a)
    annotation (Line(points={{-52,0},{-40,0}}, color={0,127,255}));
  connect(sou.ports[1], senTraSubCO2In.port_a)
    annotation (Line(points={{-86,0},{-72,0}}, color={0,127,255}));
  connect(airFil.port_b, senTraSubCO2Out.port_a)
    annotation (Line(points={{20,0},{32,0}}, color={0,127,255}));
  connect(senTraSubCO2Out.port_b, senTraSubVOCOut.port_a)
    annotation (Line(points={{52,0},{70,0}}, color={0,127,255}));
  connect(senTraSubVOCOut.port_b, sin.ports[1])
    annotation (Line(points={{90,0},{110,0}}, color={0,127,255}));
  annotation (experiment(
      StopTime=50,
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
From 0 to 12 seconds, the testing case is warming-up and the inlet trace substances of 
are fixed at <i>0.1kg/kg</i>.
</p>
<p>
From 20 to 50 seconds, the inlet trace substances changes from <i>0.1</i> to <i>0.07kg/kg</i>.
</p>
<p>
At the 30 seconds, the filter replacement signal <code>repSig</code> changes from <i>false</i> to <i>true</i>.
</p>
<p>
From 12 to 30 seconds, the trace substance of the outlet port <code>C_out</code> doesn't change much;
From 30 to 45 seconds, the outlet trace substances first decrease and then becomes relatively smooth.
</p>
</html>"),
    Diagram(coordinateSystem(extent={{-180,-100},{140,100}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end Empirical;
