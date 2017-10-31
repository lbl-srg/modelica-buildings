within Buildings.Experimental.DistrictHeatingCooling.Plants.Validation;
model Plant_T "Validation model for plant with ideal temperature control"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 1E6
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+8
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+14
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";
  Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Fluid.Sources.MassFlowSource_T war(
    redeclare package Medium = Medium,
    use_T_in=true,
    use_m_flow_in=true,
    nPorts=1) "Warm pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={40,30})));
  Buildings.Fluid.Sources.Boundary_pT coo(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Cool pipe"      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-20,-40})));
  Modelica.Blocks.Sources.Ramp TWar(
    height=6,
    duration=86400,
    offset=273.15 + 12) "Temperature of warm supply"
    annotation (Placement(transformation(extent={{-80,40},{-60,60}})));
  Modelica.Blocks.Sources.Ramp TCoo(
    duration=86400,
    height=12,
    offset=273.15 + 4) "Temperature of cold supply"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Modelica.Blocks.Sources.Ramp m_flow(
    duration=86400,
    height=2*m_flow_nominal,
    offset=-m_flow_nominal) "Mass flow rate in warm pipe"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
protected
  Modelica.Blocks.Sources.Constant TSetH(k=273.15 + 12)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Modelica.Blocks.Sources.Constant TSetC(k=273.15 + 16)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-80,-30},{-60,-10}})));
equation
  connect(TWar.y,war. T_in) annotation (Line(points={{-59,50},{44,50},{44,42}},
                     color={0,0,127}));

  connect(TCoo.y, coo.T_in)
    annotation (Line(points={{-59,-70},{-24,-70},{-24,-52}},
                                                           color={0,0,127}));
  connect(war.ports[1], pla.port_b) annotation (Line(points={{40,20},{40,20},{40,
          0},{20,0}},      color={0,127,255}));
  connect(m_flow.y, war.m_flow_in) annotation (Line(points={{-59,80},{-10,80},{48,
          80},{48,40}}, color={0,0,127}));
  connect(coo.ports[1], pla.port_a) annotation (Line(points={{-20,-30},{-20,-30},
          {-20,0},{0,0}}, color={0,127,255}));
  connect(pla.TSetHea, TSetH.y) annotation (Line(points={{-2,8},{-40,8},{-40,10},
          {-59,10}}, color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-59,-20},{-40,-20},{-40,
          4},{-2,4}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-6, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Plants/Validation/Plant_T.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model tests the ideal plant that takes the leaving water temperature setpoint as an input signal.
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
end Plant_T;
