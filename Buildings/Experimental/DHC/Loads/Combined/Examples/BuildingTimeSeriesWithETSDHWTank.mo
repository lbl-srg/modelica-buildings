within Buildings.Experimental.DHC.Loads.Combined.Examples;
model BuildingTimeSeriesWithETSDHWTank
  "Example model of a building with loads provided as time series for heating, cooling, and domestic hot water heat pump and tank"
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
  BuildingTimeSeriesWithETSWithDHWTank                                bui(
    redeclare package MediumSer = Medium,
    redeclare package MediumBui = Medium,
    bui(facMul=10),
    allowFlowReversalSer=true,
    filNam="modelica://Buildings/Resources/Data/Experimental/DHC/Loads/Examples/SwissOffice_20190916.mos",
    datWatHea=datWatHea)
    annotation (Placement(transformation(extent={{40,-20},{60,0}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TColWat(k=bui.ets.TColWat_nominal)
    "Cold water temperature"
    annotation (Placement(transformation(extent={{60,80},{80,100}})));
  Controls.OBC.CDL.Continuous.Sources.Constant THotWatSupSet(k=bui.ets.THotWatSup_nominal)
    "Hot water supply temperature set point"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
 Controls.OBC.CDL.Continuous.Sources.Constant TChiWatSupSet(k=bui.TChiWatSup_nominal)
    "Chilled water supply temperature set point"
    annotation (Placement(transformation(extent={{-20,80},{0,100}})));
 Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMaxSet(k=bui.THeaWatSup_nominal)
    "Heating water supply temperature set point - Maximum value"
    annotation (Placement(transformation(extent={{-60,80},{-40,100}})));
 Controls.OBC.CDL.Continuous.Sources.Constant THeaWatSupMinSet(each k=28 + 273.15)
    "Heating water supply temperature set point - Minimum value"
    annotation (Placement(transformation(extent={{-100,80},{-80,100}})));
  parameter DHW.Data.GenericHeatPumpWaterHeater datWatHea(
    mHex_flow_nominal=datWatHea.QCon_flow_nominal/4200/datWatHea.dTCon_nominal,

    QCon_flow_max=1.2*datWatHea.QCon_flow_nominal,
    QCon_flow_nominal=bui.QHot_flow_nominal,
    TTan_nominal=333.15,
    THex_nominal=datWatHea.TTan_nominal + datWatHea.dTCon_nominal)
    "Performance data"
    annotation (Placement(transformation(extent={{44,-38},{56,-26}})));

equation
  connect(supAmbWat.ports[1], senMasFlo.port_a)
    annotation (Line(points={{-40,10},{-20,10}}, color={0,127,255}));
  connect(TDisSup.y,supAmbWat. T_in)
    annotation (Line(points={{-69,14},{-62,14}}, color={0,0,127}));
  connect(senMasFlo.port_b, bui.port_aSerAmb) annotation (Line(points={{0,10},{20,
          10},{20,-10},{40,-10}}, color={0,127,255}));
  connect(sinAmbWat.ports[1], bui.port_bSerAmb) annotation (Line(points={{-40,-50},
          {80,-50},{80,-10},{60,-10}}, color={0,127,255}));
  connect(THeaWatSupMinSet.y, bui.THeaWatSupMinSet) annotation (Line(points={{-78,
          90},{-70,90},{-70,60},{34,60},{34,-1},{38,-1}}, color={0,0,127}));
  connect(THeaWatSupMaxSet.y, bui.THeaWatSupMaxSet) annotation (Line(points={{-38,
          90},{-30,90},{-30,58},{32,58},{32,-3},{38,-3}}, color={0,0,127}));
  connect(TChiWatSupSet.y, bui.TChiWatSupSet) annotation (Line(points={{2,90},{10,
          90},{10,56},{30,56},{30,-5},{38,-5}}, color={0,0,127}));
  connect(THotWatSupSet.y, bui.THotWatSupSet) annotation (Line(points={{42,90},{
          50,90},{50,40},{28,40},{28,-7},{38,-7}}, color={0,0,127}));
  connect(TColWat.y, bui.TColWat) annotation (Line(points={{82,90},{88,90},{88,38},
          {26,38},{26,-26},{42,-26},{42,-22}}, color={0,0,127}));
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
      StopTime=864000,
      Interval=600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
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
end BuildingTimeSeriesWithETSDHWTank;
