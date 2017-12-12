within Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.Validation;
model HeatingCoolingHotwaterTimeSeries_dT "Validation model for substation"
  extends Modelica.Icons.Example;
  package Medium = Buildings.Media.Water "Fluid in the pipes";

  Modelica.Blocks.Sources.Constant TCoo(k=273.15 + 12)
    "Temperature of cold supply"
    annotation (Placement(transformation(extent={{-80,-80},{-60,-60}})));
  Buildings.Fluid.Sources.Boundary_pT war(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Warm pipe"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},
        rotation=270,
        origin={10,50})));
  Modelica.Blocks.Sources.Constant TWar(k=273.15 + 18)
    "Temperature of warm supply"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Buildings.Experimental.DistrictHeatingCooling.SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT subSta(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    show_T=true,
    TOut_nominal=273.15) "Substation model"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
  Buildings.Fluid.Sources.Boundary_pT coo1(
    redeclare package Medium = Medium,
    use_T_in=true,
    nPorts=1) "Cool pipe"      annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={40,-50})));
equation
  connect(TWar.y,war. T_in) annotation (Line(points={{-59,70},{14,70},{14,62}},
                     color={0,0,127}));
  connect(TCoo.y, coo1.T_in)
    annotation (Line(points={{-59,-70},{36,-70},{36,-62}}, color={0,0,127}));
  connect(weaDat.weaBus, subSta.weaBus) annotation (Line(
      points={{-60,10},{-34,10},{10,10},{10,8.35714}},
      color={255,204,51},
      thickness=0.5));
  connect(subSta.port_a, war.ports[1]) annotation (Line(points={{0,0},{-10,0},{
          -10,30},{10,30},{10,40}}, color={0,127,255}));
  connect(subSta.port_b, coo1.ports[1])
    annotation (Line(points={{19.9286,0},{40,0},{40,-40}}, color={0,127,255}));
  annotation(experiment(Tolerance=1e-08, StopTime=864000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/Validation/HeatingCoolingHotwaterTimeSeries_dT.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model tests the substation that has heat pumps for cooling, heating and hot water preparation.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
<li>
December 1, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatingCoolingHotwaterTimeSeries_dT;
