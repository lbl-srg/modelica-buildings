within Buildings.Experimental.DHC.Loads.Combined.Examples;
model BuildingTimeSeriesWithETS
  "Example model of a building with loads provided as time series for heat pump heating and free cooling in an ambient district network"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-48,-10})));
  Buildings.Fluid.Sources.Boundary_pT sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-70})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-18,-20},{2,0}})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 288.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{-88,-16},{-68,4}})));
  Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETS bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    bui(facMul=10),
    allowFlowReversalSer=true,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos")
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TColWat(k=bui.ets.TColWat_nominal)
    "Cold water temperature"
    annotation (Placement(transformation(extent={{-20,-50},{0,-30}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet(k=bui.ets.THotWatSup_nominal)
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{-80,70},{-60,90}})));
 Buildings.Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{40,70},{60,90}})));
 Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMaxSet(k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{0,70},{20,90}})));
 Buildings.Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMinSet(each k(
   final unit="K",
   displayUnit="degC") = 301.15)
   "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
equation
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-38,-10},{-18,-10}},
                                                 color={0,127,255}));
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{-67,-6},{-60,-6}}, color={0,0,127}));
  connect(senMasFlo.port_b, bui.port_aSerAmb) annotation (Line(points={{2,-10},{
          40,-10}},               color={0,127,255}));
  connect(sinAmbWat.ports[1], bui.port_bSerAmb) annotation (Line(points={{-40,-70},
          {70,-70},{70,-10},{60,-10}}, color={0,127,255}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{-18,80},
          {-8,80},{-8,50},{32,50},{32,-2},{38,-2},{38,-1}},
                                                          color={0,0,127}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{22,80},
          {28,80},{28,-4},{38,-4},{38,-3}},               color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{62,80},{
          72,80},{72,20},{34,20},{34,-5},{38,-5}},
                                                color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{-58,80},
          {-48,80},{-48,48},{26,48},{26,-8},{38,-8},{38,-7}},
                                                   color={0,0,127}));
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
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Combined/Examples/BuildingTimeSeriesWithETS.mos" "Simulate and plot"),
    experiment(
      StopTime=864000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model of a building with loads provided as time series for heat 
pump space heating, heat pump domestic hot water heating,
and free cooling in an ambient district network.
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
