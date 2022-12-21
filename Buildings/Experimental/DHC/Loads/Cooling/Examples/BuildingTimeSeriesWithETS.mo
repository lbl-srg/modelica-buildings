within Buildings.Experimental.DHC.Loads.Cooling.Examples;
model BuildingTimeSeriesWithETS
  "Example model of a building with loads provided as time series and 
  connected to an ETS for cooling"
  extends Modelica.Icons.Example;
  extends Modelica.Icons.UnderConstruction;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Experimental.DHC.Loads.Cooling.BuildingTimeSeriesWithETS buiWitETS(
    filNam=
      "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/MediumOffice-90.1-2010-5A.mos")
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
    p(displayUnit="bar") = 300000,
    nPorts=1)
    "Sink for chilled water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-50})));
  Modelica.Blocks.Sources.RealExpression TDisSup(y=273.15 + 7)
    "District supply temperature setpoint"
    annotation (Placement(transformation(extent={{-88,4},{-68,24}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
equation
  connect(TDisSup.y, supChiWat.T_in) annotation (Line(points={{-67,14},{-62,14}},
                             color={0,0,127}));
  connect(supChiWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(senMasFlo.port_b, buiWitETS.port_aSerCoo) annotation (Line(points={{0,
          10},{20,10},{20,-18},{40,-18}}, color={0,127,255}));
  connect(buiWitETS.port_bSerCoo, sinChiWat.ports[1]) annotation (Line(points={
          {60,-18},{80,-18},{80,-50},{-40,-50}}, color={0,127,255}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Cooling/Examples/BuildingTimeSeriesWithETS.mos" "Simulate and plot"),
    experiment(
      StopTime=31536000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model provides an example for a building with loads provided 
as time series and connected to a direct uncontrolled ETS for cooling. 
</p>
</html>", revisions="<html>
<ul>
<li>March 20, 2022, by Chengnan Shi:<br>First implementation. </li>
</ul>
</html>"));
end BuildingTimeSeriesWithETS;
