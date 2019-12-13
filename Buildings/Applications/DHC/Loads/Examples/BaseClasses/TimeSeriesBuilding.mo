within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model TimeSeriesBuilding
  "Building model where heating and cooling loads are provided by time series and time functions"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    nLoa=1,
    haveFanPum=false,
    haveEleHeaCoo=false,
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
    Q_flow_nominal={500,2000},
    T_a1_nominal={disFloHea.T_a1_nominal,disFloCoo.T_a1_nominal},
    T_b1_nominal={disFloHea.T_b1_nominal,disFloCoo.T_b1_nominal},
    T_a2_nominal={293.15,297.15})
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloHea(
    m_flow1_nominal=terUni.m_flow1_nominal[1],
    T_a1_nominal=313.15,
    T_b1_nominal=308.15,
    nLoa=1)
    annotation (Placement(transformation(extent={{120,-80},{140,-60}})));
  Buildings.Applications.DHC.Loads.BaseClasses.FlowDistribution disFloCoo(
    m_flow1_nominal=terUni.m_flow1_nominal[2],
    T_a1_nominal=280.15,
    T_b1_nominal=285.15,
    nLoa=1)
    annotation (Placement(transformation(extent={{120,-120},{140,-100}})));
equation
  connect(minTSet.y,from_degC1. u)
    annotation (Line(points={{-276,260},{-260,260}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u)
    annotation (Line(points={{-276,220},{-260,220}}, color={0,0,127}));
  connect(from_degC1.y, terUni.uSet[1]) annotation (Line(points={{-236,260},{60,
          260},{60,-10.5},{79,-10.5}},   color={0,0,127}));
  connect(from_degC2.y, terUni.uSet[2]) annotation (Line(points={{-236,220},{60,
          220},{60,-9.5},{79,-9.5}},     color={0,0,127}));
  connect(loa.y, terUni.Q_flow2Req) annotation (Line(points={{21,0},{50,0},{50,
          -12},{79,-12}}, color={0,0,127}));
  connect(terUni.Q_flow2Act, Q_flow2Act[1, :]) annotation (Line(points={{101,-10},
          {240,-10},{240,280},{320,280}}, color={0,0,127}));
  connect(ports_a1[1], disFloHea.port_a) annotation (Line(points={{-300,-20},{-280,
          -20},{-280,-70},{120,-70}}, color={0,127,255}));
  connect(disFloHea.port_b, ports_b1[1]) annotation (Line(points={{140,-70},{280,
          -70},{280,-20},{300,-20}}, color={0,127,255}));
  connect(ports_a1[2], disFloCoo.port_a) annotation (Line(points={{-300,20},{-280,
          20},{-280,-110},{120,-110}}, color={0,127,255}));
  connect(disFloCoo.port_b, ports_b1[2]) annotation (Line(points={{140,-110},{280,
          -110},{280,20},{300,20}}, color={0,127,255}));
  connect(terUni.ports_b1[1], disFloHea.ports_a1[1]) annotation (Line(points={{100,
          -22},{160,-22},{160,-64},{140,-64}}, color={0,127,255}));
  connect(disFloHea.ports_b1[1], terUni.ports_a1[1]) annotation (Line(points={{120,
          -64},{60,-64},{60,-22},{80,-22}}, color={0,127,255}));
  connect(terUni.ports_b1[2], disFloCoo.ports_a1[1]) annotation (Line(points={{100,
          -18},{180,-18},{180,-104},{140,-104}}, color={0,127,255}));
  connect(disFloCoo.ports_b1[1], terUni.ports_a1[2]) annotation (Line(points={{120,
          -104},{40,-104},{40,-18},{80,-18}}, color={0,127,255}));
  connect(terUni.m_flow1Req[1], disFloHea.m_flow1Req_i[1]) annotation (Line(
        points={{101,-8.5},{108,-8.5},{108,-78},{119,-78}}, color={0,0,127}));
  connect(terUni.m_flow1Req[2], disFloCoo.m_flow1Req_i[1]) annotation (Line(
        points={{101,-7.5},{108,-7.5},{108,-118},{119,-118}}, color={0,0,127}));
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
