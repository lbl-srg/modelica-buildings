within Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation.BaseClasses;
partial model PartialPlant
  "Partial examples for Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation"

  package MediumCHW = Buildings.Media.Water "Medium model";
  package MediumCW = Buildings.Media.Water "Medium model";

  parameter Modelica.SIunits.MassFlowRate mCHW_flow_nominal=2567.1*1000/(
    4200*10)
    "Nominal mass flow rate at chilled water";

  parameter Modelica.SIunits.MassFlowRate mCW_flow_nominal=2567.1*1000/ (
    4200*8.5)
    "Nominal mass flow rate at condenser water";
  parameter Modelica.SIunits.PressureDifference dpCHW_nominal = 40000
    "Nominal pressure";
  parameter Modelica.SIunits.PressureDifference dpCW_nominal = 40000
    "Nominal pressure";
  parameter Integer numChi=1 "Number of chillers";

  Buildings.Fluid.Sources.Boundary_pT sin1(
    redeclare package Medium = MediumCW)
    "Sink on medium 1 side"
    annotation (Placement(
        transformation(
        extent={{10,-10},{-10,10}},
        origin={80,-4})));
  Fluid.Sources.Boundary_pT sou1(
    p=MediumCW.p_default + 45E3,
    use_T_in=true,
    redeclare package Medium = MediumCW,
    T=298.15)
    "Source on medium 1 side"
    annotation (Placement(transformation(extent={{-60,-14},{-40,6}})));
  Modelica.Blocks.Sources.TimeTable TCon_in(
    table=[0,273.15 + 12.78;
          7200,273.15 + 12.78;
          7200,273.15 + 18.33;
          14400,273.15 + 18.33;
          14400,273.15 + 26.67],
    offset=0,
    startTime=0)
    "Condenser inlet temperature"
    annotation (Placement(transformation(extent={{-100,-10},{-80,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin2(
    nPorts=1,
    redeclare package Medium = MediumCHW)
    "Sink on medium 2 side"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={-80,-70})));

  Modelica.Blocks.Sources.Constant TEva_in(k=273.15 + 25.28)
    "Evaporator inlet temperature"
    annotation (Placement(transformation(extent={{90,-80},{70,-60}})));
  Modelica.Blocks.Sources.Constant TSet(
    k(unit="K",displayUnit="degC")=273.15+15.56)
    "Leaving chilled water temperature setpoint"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort TSup1(redeclare package Medium =
        MediumCHW, m_flow_nominal=mCHW_flow_nominal) "Temperature sensor"
    annotation (Placement(transformation(extent={{-40,-54},{-60,-34}})));
  Modelica.Blocks.Sources.BooleanStep onChi(startTime=7200)
    "On and off signal for the chiller"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  Modelica.Blocks.Sources.BooleanStep onWSE(startTime=14400, startValue=true)
    "On and off signal for the WSE"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
equation
  connect(TCon_in.y,sou1. T_in)
    annotation (Line(points={{-79,0},{-62,0}},
      color={0,0,127}));
  connect(sin2.ports[1], TSup1.port_b) annotation (Line(points={{-70,-70},{-68,
          -70},{-68,-70},{-64,-70},{-64,-44},{-60,-44}}, color={0,127,255}));
  annotation (Documentation(info="<html>
<p>
This is a partial model for the examples in
<a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.Validation</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
May 13, 2021, by Michael Wetter:<br/>
Changed boundary condition model to prescribed pressure rather than prescribed mass flow rate.
Prescribing the mass flow rate caused
unreasonably large pressure drop because the mass flow rate was forced through a closed valve.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2488\">#2488</a>.
</li>
<li>
September 11, 2017, by Michael Wetter:<br/>
Corrected wrong use of replaceable model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/921\">issue 921</a>.
</li>
<li>
June 25, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPlant;
