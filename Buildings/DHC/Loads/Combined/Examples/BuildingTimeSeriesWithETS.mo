within Buildings.DHC.Loads.Combined.Examples;
model BuildingTimeSeriesWithETS
  "Example model of a building in an ambient district network with loads provided as time series and heat pump heating, free cooling, and heat pump domestic hot water"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-10})));
  Buildings.Fluid.Sources.Boundary_pT sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-70})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-20,-20},{0,0}})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 288.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{-92,-16},{-72,4}})));
  Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    bui(facMul=10),
    allowFlowReversalSer=true,
    THotWatSup_nominal=322.15,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos")
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat(k=bui.ets.TColWat_nominal)
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet(k=bui.ets.THotWatSup_nominal)
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-90,20},{-70,40}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-90,60},{-70,80}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMaxSet(k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMinSet(
   k(final unit="K",
     displayUnit="degC") = 301.15)
   "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{0,60},{20,80}})));
equation
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,-10},{-20,-10}},
                                                 color={0,127,255}));
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{-71,-6},{-62,-6}}, color={0,0,127}));
  connect(senMasFlo.port_b, bui.port_aSerAmb) annotation (Line(points={{0,-10},
          {40,-10}},              color={0,127,255}));
  connect(sinAmbWat.ports[1], bui.port_bSerAmb) annotation (Line(points={{-40,-70},
          {70,-70},{70,-10},{60,-10}}, color={0,127,255}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{22,70},
          {34,70},{34,0},{38,0},{38,-1}},                 color={0,0,127}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{-18,70},
          {-10,70},{-10,34},{32,34},{32,-3},{38,-3}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{-68,70},
          {-52,70},{-52,32},{30,32},{30,-5},{38,-5}},
                                                color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-68,30},
          {26,30},{26,-7},{38,-7}},                color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{2,-40},{34,-40},{34,
          -22},{42,-22}},                      color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Loads/Combined/Examples/BuildingTimeSeriesWithETS.mos" "Simulate and plot"),
    experiment(
      StopTime=864000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model of a building in an ambient district network with loads
provided as time series and heat pump heating, free cooling,
and heat pump domestic hot water.  It uses
<a href=\"modelica://Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS\">
Buildings.DHC.Loads.Combined.BuildingTimeSeriesWithETS</a>
</p>
</html>", revisions="<html>
<ul>
<li>
May 3, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETS;
