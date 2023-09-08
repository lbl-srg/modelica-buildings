within Buildings.Experimental.DHC.Loads.HotWater.Examples;
model HeaterAndFixtureHeatPumpWithTank
  extends Modelica.Icons.Example;
  extends Buildings.Experimental.DHC.Loads.HotWater.Examples.BaseClasses.partialHeaterAndFixture(
    souCol(nPorts=2),
    souDis(nPorts=1),
    sinDis(nPorts=1));

  HeatPumpWithTank gen(
    redeclare package Medium = Medium,
    mHotSou_flow_nominal=mHotSou_flow_nominal,
    mDis_flow_nominal=mDis_flow_nominal,
    datWatHea=datWatHea,
    COP_nominal=2.3,
    TCon_nominal=datWatHea.THex_nominal,
    TEva_nominal=TDis + 5) "Heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));
  Buildings.Experimental.DHC.Loads.HotWater.Data.GenericHeatPumpWaterHeater datWatHea(
    mHex_flow_nominal=1.5,
    QCon_flow_max=60000,
    QCon_flow_nominal=50000,
    TTan_nominal=(TSetHotSou + TCol)/2,
    THotSou_nominal=TSetHotSou,
    dTCon_nominal=datWatHea.THex_nominal - datWatHea.TTan_nominal)
    "Data for heat pump water heater with tank"
    annotation (Placement(transformation(extent={{-46,16},{-36,26}})));
equation

  connect(gen.port_b1, tmv.port_hotsou) annotation (Line(points={{-30,6},{-10,6},
          {-10,4},{0,4}}, color={0,127,255}));
  connect(gen.port_a1, souCol.ports[2]) annotation (Line(points={{-50,6},{-60,6},
          {-60,-20},{10,-20},{10,-40}}, color={0,127,255}));
  connect(gen.port_a2, souDis.ports[1]) annotation (Line(points={{-30,-6},{-20,-6},
          {-20,-32},{-30,-32},{-30,-40}}, color={0,127,255}));
  connect(gen.port_b2, sinDis.ports[1])
    annotation (Line(points={{-50,-6},{-70,-6},{-70,-40}}, color={0,127,255}));
  connect(conTSetHotSou.y, gen.TSetHotSou)
    annotation (Line(points={{-79,0},{-51,0}}, color={0,0,127}));
  connect(gen.PHea, PEle) annotation (Line(points={{-29,0},{-12,0},{-12,80},{110,
          80}}, color={0,0,127}));
  annotation (experiment(
      StopTime=86400,
      Interval=1,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"));
end HeaterAndFixtureHeatPumpWithTank;
