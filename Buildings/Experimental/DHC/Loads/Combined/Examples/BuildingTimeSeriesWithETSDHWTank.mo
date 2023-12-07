within Buildings.Experimental.DHC.Loads.Combined.Examples;
model BuildingTimeSeriesWithETSDHWTank
    "Example model of a building in an ambient district network with loads provided as time series and heat pump heating, free cooling, and heat pump with storage tank domestic hot water"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Water
    "Medium model";
  Buildings.Fluid.Sources.Boundary_pT supAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    use_T_in=true,
    T=280.15,
    nPorts=1) "Ambient water supply"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,10})));
  Buildings.Fluid.Sources.Boundary_pT sinAmbWat(
    redeclare package Medium = Medium,
    p(displayUnit="bar"),
    nPorts=1) "Sink for ambient water"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}},rotation=0,origin={-50,-50})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Modelica.Blocks.Sources.Constant TDisSup(k(
      unit="K",
      displayUnit="degC") = 288.15)
    "District supply temperature"
    annotation (Placement(transformation(extent={{-90,4},{-70,24}})));
  Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    bui(facMul=10),
    allowFlowReversalSer=true,
    THotWatSup_nominal=313.15,
    filNam=
        "modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    datWatHea=datWatHea) "Building load with time series data"
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TColWat(k=bui.ets.TColWat_nominal)
    "Cold water temperature"
    annotation (Placement(transformation(extent={{70,70},{90,90}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant THotWatSupSet(k=bui.THotWatSup_nominal)
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{30,70},{50,90}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant TChiWatSupSet(k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-10,70},{10,90}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMaxSet(k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-50,70},{-30,90}})));
 Buildings.Controls.OBC.CDL.Reals.Sources.Constant THeaWatSupMinSet(each k=28 + 273.15)
    "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  parameter Buildings.Experimental.DHC.Loads.HotWater.Data.GenericDomesticHotWaterWithHeatExchanger datWatHea(VTan=0.3,
      mDom_flow_nominal=0.03,
    TDom_nominal=318.15)
    "Performance data"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

equation
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{-69,14},{-62,14}}, color={0,0,127}));
  connect(senMasFlo.port_b, bui.port_aSerAmb) annotation (Line(points={{0,10},{20,
          10},{20,-10},{40,-10}}, color={0,127,255}));
  connect(sinAmbWat.ports[1], bui.port_bSerAmb) annotation (Line(points={{-40,-50},
          {80,-50},{80,-10},{60,-10}}, color={0,127,255}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{-68,80},
          {-60,80},{-60,60},{34,60},{34,-1},{38,-1}},     color={0,0,127}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{-28,80},
          {-20,80},{-20,58},{32,58},{32,-3},{38,-3}},     color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{12,80},
          {20,80},{20,56},{30,56},{30,-5},{38,-5}},
                                                color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{52,80},
          {60,80},{60,40},{28,40},{28,-7},{38,-7}},color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{92,80},{96,80},{96,
          38},{26,38},{26,-26},{42,-26},{42,-22}},
                                               color={0,0,127}));
  annotation (
    Icon(
      coordinateSystem(
        preserveAspectRatio=false)),
    Diagram(
        coordinateSystem(
        preserveAspectRatio=false)),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Combined/Examples/BuildingTimeSeriesWithETSDHWTank.mos" "Simulate and plot"),
    experiment(
      StopTime=864000,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model of a building in an ambient district network with loads 
provided as time series and heat pump heating, free cooling, and heat pump 
with storage tank domestic hot water
<a href=\"modelica://Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank\">
Buildings.Experimental.DHC.Loads.Combined.BuildingTimeSeriesWithETSWithDHWTank</a>
</p>
</html>", revisions="<html>
<ul>
<li>
September 13, 2023, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesWithETSDHWTank;
