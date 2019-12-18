within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model TimeSeriesBuilding
  "Building model where heating and cooling loads are provided by time series and time functions"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    haveFan=false,
    havePum=false,
    haveEleHea=false,
    haveEleCoo=false,
    nPorts1=2);
  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    columns={2,3},
    tableName="csv",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/Loads.csv"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) "Reader for test.csv"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-298,250},{-278,270}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-258,250},{-238,270}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24) "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-298,210},{-278,230}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-258,210},{-238,230}})));
  Buildings.Applications.DHC.Loads.Examples.BaseClasses.Terminal4PipesHeatReq terUni(
    QHea_flow_nominal=500,
    QCoo_flow_nominal=2000,
    T_a1Hea_nominal=disFloHea.T_a1_nominal,
    T_a1Coo_nominal=disFloCoo.T_a1_nominal,
    T_b1Hea_nominal=disFloHea.T_b1_nominal,
    T_b1Coo_nominal=disFloCoo.T_b1_nominal,
    T_a2Hea_nominal=293.15,
    T_a2Coo_nominal=297.15)
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m1_flow_nominal=terUni.m1Hea_flow_nominal,
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=1)
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m1_flow_nominal=terUni.m1Coo_flow_nominal,
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=1)
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
equation
  connect(minTSet.y,from_degC1. u)
    annotation (Line(points={{-276,260},{-260,260}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u)
    annotation (Line(points={{-276,220},{-260,220}}, color={0,0,127}));
  connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{-280,
          -20},{-280,-70},{120,-70}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{140,-70},{280,
          -70},{280,-20},{300,-20}}, color={0,127,255}));
  connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
          20},{-280,-110},{120,-110}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{140,-110},{280,
          -110},{280,20},{300,20}}, color={0,127,255}));
  connect(from_degC1.y, terUni.TSetHea) annotation (Line(points={{-236,260},{60,
          260},{60,-7.33333},{79.1667,-7.33333}}, color={0,0,127}));
  connect(from_degC2.y, terUni.TSetCoo) annotation (Line(points={{-236,220},{60,
          220},{60,-10.6667},{79.1667,-10.6667}}, color={0,0,127}));
  connect(terUni.port_b1Hea, disFloHea.ports_a1[1]) annotation (Line(points={{
          100,-23.1667},{100,-23.5833},{140,-23.5833},{140,-64}}, color={0,127,
          255}));
  connect(terUni.port_b1Coo, disFloCoo.ports_a1[1]) annotation (Line(points={{
          100,-20.6667},{160,-20.6667},{160,-104},{140,-104}}, color={0,127,255}));
  connect(disFloCoo.ports_b1[1], terUni.port_a1Coo) annotation (Line(points={{
          120,-104},{40,-104},{40,-20.6667},{80,-20.6667}}, color={0,127,255}));
  connect(disFloHea.ports_b1[1], terUni.port_a1Hea) annotation (Line(points={{
          120,-64},{60,-64},{60,-23.1667},{80,-23.1667}}, color={0,127,255}));
  connect(terUni.m1ReqHea_flow, disFloHea.m1Req_flow_i[1]) annotation (Line(
        points={{100.833,-16.5},{100.833,-77.25},{119,-77.25},{119,-78}}, color
        ={0,0,127}));
  connect(terUni.m1ReqCoo_flow, disFloCoo.m1Req_flow_i[1]) annotation (Line(
        points={{100.833,-18.1667},{100.833,-118},{119,-118}}, color={0,0,127}));
  connect(terUni.QActHea_flow, QHea_flow) annotation (Line(points={{100.833,
          -6.5},{100.833,279.917},{320,279.917},{320,280}}, color={0,0,127}));
  connect(terUni.QActCoo_flow, QCoo_flow) annotation (Line(points={{100.833,
          -8.16667},{100.833,239.083},{320,239.083},{320,240}}, color={0,0,127}));
  connect(loa.y[1], terUni.QReqHea_flow) annotation (Line(points={{21,0},{50,0},
          {50,-14},{79.1667,-14}}, color={0,0,127}));
  connect(loa.y[2], terUni.QReqCoo_flow) annotation (Line(points={{21,0},{50,0},
          {50,-17.3333},{79.1667,-17.3333}}, color={0,0,127}));
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
end TimeSeriesBuilding;
