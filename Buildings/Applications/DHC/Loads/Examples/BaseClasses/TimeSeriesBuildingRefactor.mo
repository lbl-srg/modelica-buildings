within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model TimeSeriesBuildingRefactor
  "Building model where heating and cooling loads are provided by time series and time functions"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuildingRefactor(
    nLoa=1,
    haveFanPum=false,
    haveEleHeaCoo=false,
    nPorts1=4);
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
    T_a1_nominal={318.15,280.15},
    T_b1_nominal={313.15,285.15},
    T_a2_nominal={293.15,297.15})
    annotation (Placement(transformation(extent={{80,-24},{100,-4}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gaiMin1[nPorts1](k=-1)
    annotation (Placement(transformation(extent={{220,270},{240,290}})));
equation
  connect(minTSet.y,from_degC1. u)
    annotation (Line(points={{-276,260},{-260,260}}, color={0,0,127}));
  connect(maxTSet.y,from_degC2. u)
    annotation (Line(points={{-276,220},{-260,220}}, color={0,0,127}));
  connect(from_degC1.y, terUni.uSet[1]) annotation (Line(points={{-236,260},{60,
          260},{60,-10.75},{79,-10.75}}, color={0,0,127}));
  connect(from_degC2.y, terUni.uSet[2]) annotation (Line(points={{-236,220},{60,
          220},{60,-10.25},{79,-10.25}}, color={0,0,127}));
  connect(ports_a1[1], terUni.ports_a1[1]) annotation (Line(points={{-300,-30},{
          -280,-30},{-280,-23},{80,-23}}, color={0,127,255}));
  connect(terUni.ports_b1[1], ports_b1[1]) annotation (Line(points={{100,-23},{280,
          -23},{280,8},{300,8},{300,-30}}, color={0,127,255}));
  connect(ports_a1[2], terUni.ports_a1[2]) annotation (Line(points={{-300,-10},
          {-280,-10},{-280,-21},{80,-21}},color={0,127,255}));
  connect(terUni.ports_b1[2], ports_b1[2]) annotation (Line(points={{100,-21},{
          280,-21},{280,-10},{300,-10}},
                                   color={0,127,255}));
  connect(loa.y, terUni.Q_flow2Req) annotation (Line(points={{21,0},{50,0},{50,
          -12},{79,-12}}, color={0,0,127}));
  connect(terUni.Q_flow2Act, gaiMin1.u) annotation (Line(points={{101,-10},{120,
          -10},{120,280},{218,280}}, color={0,0,127}));
  connect(gaiMin1.y, Q_flow1Act[:, 1]) annotation (Line(points={{242,280},{274,
          280},{274,280},{320,280}}, color={0,0,127}));
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
end TimeSeriesBuildingRefactor;
