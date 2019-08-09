within Buildings.Applications.DHC.Loads.Examples.BaseClasses;
model TimeSeriesBuilding
  "Building model where heating and cooling loads are provided by time series and time functions"
  import Buildings;
  extends Buildings.Applications.DHC.Loads.BaseClasses.PartialBuilding(
    nCooLoa=1,
    final cooLoaTyp={Buildings.Applications.DHC.Loads.Types.ModelType.ODE},
    nHeaLoa=2,
    final heaLoaTyp={Buildings.Applications.DHC.Loads.Types.ModelType.ODE,Buildings.Applications.DHC.Loads.Types.ModelType.PrescribedT},
    Q_flowCoo_nominal={2000},
    Q_flowHea_nominal={500,1000},
    THeaLoa_nominal={293.15,298.15});

  Modelica.Blocks.Sources.CombiTimeTable loa(
    tableOnFile=true,
    columns={2,3},
    tableName="csv",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Applications/DHC/Loads/Examples/Resources/Loads.csv"),
    smoothness=Modelica.Blocks.Types.Smoothness.LinearSegments) "Reader for test.csv"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Buildings.Controls.OBC.UnitConversions.From_degC from_degC1
    annotation (Placement(transformation(extent={{-100,120},{-80,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20)
    "Minimum temperature setpoint"
    annotation (Placement(transformation(extent={{-140,120},{-120,140}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant maxTSet(k=24)
    "Maximum temperature setpoint"
    annotation (Placement(transformation(extent={{-140,-140},{-120,-120}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC2
    annotation (Placement(transformation(extent={{-100,-140},{-80,-120}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin(
    amplitude=500,
    freqHz=1/86400,
    offset=500) annotation (Placement(transformation(extent={{0,30},{20,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Sine sin1(
    freqHz=1/86400,
    amplitude=2,
    offset=25)  annotation (Placement(transformation(extent={{-160,40},{-180,60}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC4
    annotation (Placement(transformation(extent={{-200,40},{-220,60}})));
equation
  connect(TCooLoaO.T, cooLoaO.TInd) annotation (Line(points={{-218,-100},{-201,-100}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u) annotation (Line(points={{-119,130},{-102,130}}, color={0,0,127}));
  connect(from_degC1.y, heaLoaO[1].TSet)
    annotation (Line(points={{-79,130},{-60,130},{-60,108},{-178,108}},     color={0,0,127}));
  connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-119,-130},{-102,-130}}, color={0,0,127}));
  connect(from_degC2.y, cooLoaO[1].TSet)
    annotation (Line(points={{-79,-130},{-60,-130},{-60,-92},{-178,-92}},     color={0,0,127}));
  connect(loa.y[1], Q_flowCooReq[1]) annotation (Line(points={{21,0},{172,0},{172,-192},{310,-192}}, color={0,0,127}));
  connect(loa.y[1], cooLoaO[1].Q_flowReq)
    annotation (Line(points={{21,0},{80,0},{80,-100},{-178,-100}}, color={0,0,127}));
  connect(loa.y[2], heaLoaO[1].Q_flowReq) annotation (Line(points={{21,0},{80,0},{80,100},{-178,100}},
                                                                                                     color={0,0,127}));
  connect(loa.y[2], Q_flowHeaReq[1]) annotation (Line(points={{21,0},{172,0},{172,195},{310,195}},
                                                                                                 color={0,0,127}));
  connect(sin.y, Q_flowHeaReq[2]) annotation (Line(points={{21,40},{162,40},{162,205},{310,205}}, color={0,0,127}));
  connect(sin1.y, from_degC4.u) annotation (Line(points={{-181,50},{-198,50}}, color={0,0,127}));
  connect(from_degC4.y, THeaLoaT[1].T) annotation (Line(points={{-221,50},{-218,50}}, color={0,0,127}));
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
