within Buildings.DHC.Loads.Cooling.Examples;
model BuildingTimeSeriesWithETS
  "Example model of a building with loads provided as time series and
  connected to an ETS for cooling"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.DHC.Loads.Cooling.BuildingTimeSeriesWithETS buiWitETS(
    filNam=
      "modelica://Buildings/Resources/Data/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos")
  "Building Time Series load coupled with ETS"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Fluid.Sources.Boundary_pT supChiWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar") = 350000,
    use_T_in=true,
    T=280.15,
    nPorts=1)
    "Chilled water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,10})));
  Buildings.Fluid.Sources.Boundary_pT sinChiWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar") = 340000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-50})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant TDisRetSet(k=273.15 + 16)
    "Setpoint for district return temperature"
    annotation (Placement(transformation(extent={{0,40},{20,60}})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 280.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
equation
  connect(supChiWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(senMasFlo.port_b, buiWitETS.port_aSerCoo) annotation (Line(points={{0,
          10},{20,10},{20,-18},{40,-18}}, color={0,127,255}));
  connect(buiWitETS.port_bSerCoo, sinChiWat.ports[1]) annotation (Line(points={
          {60,-18},{80,-18},{80,-50},{-40,-50}}, color={0,127,255}));
  connect(TDisSup.y, supChiWat.T_in)
    annotation (Line(points={{-69,14},{-62,14}}, color={0,0,127}));
  connect(TDisRetSet.y,buiWitETS.TDisRetSet)  annotation (Line(points={{21,50},
          {30,50},{30,-3},{39,-3}}, color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/Cooling/Examples/BuildingTimeSeriesWithETS.mos" "Simulate and plot"),
    experiment(
      StartTime=2592000,
      StopTime=3628800,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model provides an example for a building with loads provided
as time series and connected to a direct ETS for cooling with the
return chilled water temperature controlled above a minimum threshold.
</p>
</html>", revisions="<html>
<ul>
<li>
March 20, 2022, by Chengnan Shi:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETS;
