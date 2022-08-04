within Buildings.Airflow.Multizone.Examples;
model PressurizationData
  "Model showing how the 'Powerlaw_1DataPoint' model can be used when data is available from a pressurization test."
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Air;

  parameter Real n50=3 "ACH50, air changes at 50 Pa";

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-88,0},{-68,20}})));
  Fluid.Sources.Outside_CpLowRise west(
    redeclare package Medium = Medium,
    s=5,
    azi=Buildings.Types.Azimuth.W,
    Cp0=0.6,
    nPorts=1) "Model with outside conditions"
    annotation (Placement(transformation(extent={{82,0},{62,20}})));
  Fluid.Sources.Outside_CpLowRise east(
    redeclare package Medium = Medium,
    s=5,
    azi=Buildings.Types.Azimuth.E,
    Cp0=0.6,
    nPorts=1) "Model with outside conditions"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Fluid.MixingVolumes.MixingVolume room(
    redeclare package Medium = Medium,
    V=2.5*5*5,
    nPorts=2,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    m_flow_nominal=0.01) "Room model"
    annotation (Placement(transformation(extent={{0,20},{20,40}})));
  Buildings.Airflow.Multizone.Point_m_flow pow_1dat(
    dpMea_nominal(displayUnit="Pa") = 50,
    redeclare package Medium = Medium,
    m=0.66,
    mMea_flow_nominal=0.5*(room.V*n50*1.2))
    "Crack in envelope representing 50% of the leakage area"
    annotation (Placement(transformation(extent={{-30,0},{-10,20}})));
  Buildings.Airflow.Multizone.Point_m_flow pow_1dat1(
    dpMea_nominal(displayUnit="Pa") = 50,
    redeclare package Medium = Medium,
    m=0.66,
    mMea_flow_nominal=0.5*(room.V*n50*1.2))
    "Crack in envelope representing 50% of the leakage area"
    annotation (Placement(transformation(extent={{30,0},{50,20}})));
equation
  connect(weaDat.weaBus, west.weaBus) annotation (Line(
      points={{-68,10},{-64,10},{-64,-24},{82,-24},{82,10.2}},
      color={255,204,51},
      thickness=0.5));
  connect(east.weaBus, weaDat.weaBus) annotation (Line(
      points={{-60,10.2},{-60,10},{-68,10}},
      color={255,204,51},
      thickness=0.5));
  connect(east.ports[1], pow_1dat.port_a)
    annotation (Line(points={{-40,10},{-30,10}},   color={0,127,255}));
  connect(pow_1dat.port_b,room. ports[1])
    annotation (Line(points={{-10,10},{9,10},{9,20}},      color={0,127,255}));
  connect(pow_1dat1.port_a,room. ports[2])
    annotation (Line(points={{30,10},{11,10},{11,20}},    color={0,127,255}));
  connect(pow_1dat1.port_b, west.ports[1])
    annotation (Line(points={{50,10},{62,10}},   color={0,127,255}));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Airflow/Multizone/Examples/PressurizationData.mos"
        "Simulate and plot"),
        experiment(
      StopTime=2592000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model illustrates the use of
<a href=\"modelica://Buildings.Airflow.Multizone.Point_m_flow\">
Buildings.Airflow.Multizone.Point_m_flow</a>
to model
infiltration through the building evelope for a known <i>n<sub>50</sub></i> value (also known as ACH50).
As the <i>n<sub>50</sub></i> value and the building volume is known,
the flow at 50 Pa is known. Dividing this flow accross the entire envelope
(typically surface weighted) and using
<a href=\"modelica://Buildings.Airflow.Multizone.Point_m_flow\">
Buildings.Airflow.Multizone.Point_m_flow</a>,
the infiltration airflow at lower pressure differences can be modelled.
<br/>
In this example, the two models each represent 50% of the surface where airflow occured due to the pressurization test.
</p>
</html>", revisions="<html>
<ul>
<li>
April 8, 2022, by Michael Wetter:<br/>
Changed tolerance from <i>1E-8</i> to <i>1E-6</i>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1606\">IBPSA, #1606</a>.
</li>
<li>
February 2, 2022, by Michael Wetter:<br/>
Revised implementation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1436\">IBPSA, #1436</a>.
</li>
<li>
May 03, 2021 by Klaas De Jonge:<br/>
Added example for simulating infiltration airflow using the Powerlaw_1DataPoint model
</li>
</ul>
</html>"));
end PressurizationData;
