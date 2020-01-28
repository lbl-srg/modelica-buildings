within Buildings.Applications.DHC.Loads.Validation.BaseClasses;
model BuildingTimeSeries
  "Building model where heating and cooling loads are provided by time series and time functions"
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    redeclare package Medium = Buildings.Media.Water,
    have_fan=false,
    have_pum=false,
    have_eleHea=false,
    have_eleCoo=false,
    have_weaBus=false);
  package Medium2 = Buildings.Media.Air
    "Load side medium";
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    columns={2,3},
    tableName="csv",
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/Loads.csv"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) "Reader for test.csv"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-298,250},{-278,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-258,250},{-238,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-298,210},{-278,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-258,210},{-238,230}})));
  Buildings.Applications.DHC.Loads.Validation.BaseClasses.Terminal4PipesHeatReq
    terUni(
      redeclare package Medium1 = Medium,
      redeclare package Medium2 = Medium2,
      QHea_flow_nominal=500,
      QCoo_flow_nominal=2000,
      T_aHeaWat_nominal=313.15,
      T_aChiWat_nominal=280.15,
      T_bHeaWat_nominal=308.15,
      T_bChiWat_nominal=285.15,
      T_aLoaHea_nominal=293.15,
      T_aLoaCoo_nominal=297.15)
    "Terminal unit"
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    redeclare package Medium = Medium,
    m_flow_nominal=terUni.mHeaWat_flow_nominal,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Heating water distribution system"
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    redeclare package Medium = Medium,
    m_flow_nominal=terUni.mChiWat_flow_nominal,
    disTyp=Buildings.Applications.DHC.Loads.Types.DistributionType.ChilledWater,
    dp_nominal=100000,
    nPorts_a1=1,
    nPorts_b1=1)
    "Chilled water distribution system"
    annotation (
      Placement(transformation(extent={{120,-120},{140,-100}})));
equation
  connect(minTSet.y,from_degC1. u)
    annotation (Line(points={{-276,260},{-260,260}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u)
    annotation (Line(points={{-276,220},{-260,220}}, color={0,0,127}));
  connect(ports_a[1], disFloHea.port_a) annotation (Line(points={{-300,0},{
          -280,0},{-280,-70},{120,-70}},color={0,127,255}));
  connect(disFloHea.port_b, ports_b[1]) annotation (Line(points={{140,-70},{
          280,-70},{280,0},{300,0}}, color={0,127,255}));
  connect(ports_a[2], disFloCoo.port_a) annotation (Line(points={{-300,0},{
          -280,0},{-280,-110},{120,-110}},color={0,127,255}));
  connect(disFloCoo.port_b, ports_b[2]) annotation (Line(points={{140,-110},
          {280,-110},{280,0},{300,0}},color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-236,260},{60,
          260},{60,-7.33333},{79.1667,-7.33333}},
                                             color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-236,220},{60,
          220},{60,-10.6667},{79.1667,-10.6667}},
                                             color={0,0,127}));
  connect(terUni.port_bHeaWat, disFloHea.ports_a1[1]) annotation (Line(points={{100,
          -22.3333},{100,-23.5833},{140,-23.5833},{140,-64}},     color={0,127,
          255}));
  connect(terUni.port_bChiWat, disFloCoo.ports_a1[1]) annotation (Line(points={{100,
          -20.6667},{160,-20.6667},{160,-104},{140,-104}},     color={0,127,255}));
  connect(disFloCoo.ports_b1[1], terUni.port_aChiWat) annotation (Line(points={{120,
          -104},{40,-104},{40,-20.6667},{80,-20.6667}},     color={0,127,255}));
  connect(disFloHea.ports_b1[1], terUni.port_aHeaWat) annotation (Line(points={{120,-64},
          {60,-64},{60,-22.3333},{80,-22.3333}},          color={0,127,255}));
  connect(loa.y[1], terUni.QReqHea_flow) annotation (Line(points={{21,0},{50,0},
          {50,-14},{79.1667,-14}},
                               color={0,0,127}));
  connect(loa.y[2], terUni.QReqCoo_flow) annotation (Line(points={{21,0},{50,0},
          {50,-17.3333},{79.1667,-17.3333}}, color={0,0,127}));
  connect(terUni.mReqHeaWat_flow, disFloHea.mReq_flow[1]) annotation (Line(points={{100.833,
          -17.3333},{100.833,-46},{100,-46},{100,-76},{119,-76},{119,-74}},
        color={0,0,127}));
  connect(terUni.mReqChiWat_flow, disFloCoo.mReq_flow[1]) annotation (Line(points={{100.833,
          -19},{100.833,-115.083},{119,-115.083},{119,-114}},
        color={0,0,127}));
  connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{100.833,
          -7.33333},{100.833,-6},{240,-6},{240,280},{320,280}},
                                                      color={0,0,127}));
  connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{100.833,-9},
          {100,-9},{100,-8},{260,-8},{260,240},{320,240}},
                                                       color={0,0,127}));
  annotation (
  Documentation(info="<html>
  <p>
  This is a simplified building model with:
  </p>
  <ul>
  <li> one heating load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required heating heat flow rate is provided by a time series;
  </li>
  <li>
  one additional heating load which temperature is prescribed with a time function
  and the required heating heat flow rate is also provided by a time function;
  </li>
  <li>
  one cooling load which temperature is computed with
  <a href=\"modelica://Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE\">
  Buildings.DistrictEnergySystem.Loads.BaseClasses.FirstOrderODE</a>
  and the required cooling heat flow rate is provided by a time series.
  </li>
  </ul>
  <p>
  </p>
  </html>"),
  Diagram(coordinateSystem(extent={{-300,-300},{300,300}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end BuildingTimeSeries;
