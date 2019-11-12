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
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant minTSet(k=20) "Minimum temperature setpoint"
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
    offset=25)  annotation (Placement(transformation(extent={{-120,40},{-140,60}})));
  Buildings.Controls.OBC.UnitConversions.From_degC from_degC4
    annotation (Placement(transformation(extent={{-180,40},{-200,60}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai[nHeaLoa](k=(1) ./ Q_flowHea_nominal)
    annotation (Placement(transformation(extent={{82,190},{102,210}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMinT[nHeaLoa](
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=false,
    each yMin=0) "PI tracking heating load"
    annotation (Placement(transformation(extent={{120,210},{140,190}})));
  Buildings.Controls.OBC.CDL.Continuous.LimPID conPIDMaxT[nCooLoa](
    each Ti=120,
    each yMax=1,
    each controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    each reverseAction=true,
    each yMin=0) "PI tracking cooling load" annotation (Placement(transformation(extent={{120,-202},{140,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai1[nCooLoa](k=(1) ./ Q_flowCoo_nominal)
    annotation (Placement(transformation(extent={{80,-202},{100,-182}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai2[nCooLoa](k=(1) ./ Q_flowCoo_nominal)
    annotation (Placement(transformation(extent={{80,-230},{100,-210}})));
  Buildings.Controls.OBC.CDL.Continuous.Gain gai3
                                                [nHeaLoa](k=(1) ./ Q_flowHea_nominal)
    annotation (Placement(transformation(extent={{80,220},{100,240}})));
equation
  connect(TCooLoaO.T, cooLoaO.TInd) annotation (Line(points={{-218,-100},{-201,-100}}, color={0,0,127}));
  connect(minTSet.y, from_degC1.u) annotation (Line(points={{-118,130},{-102,130}}, color={0,0,127}));
  connect(from_degC1.y, heaLoaO[1].TSet)
    annotation (Line(points={{-78,130},{-60,130},{-60,108},{-178,108}},     color={0,0,127}));
  connect(maxTSet.y, from_degC2.u) annotation (Line(points={{-118,-130},{-102,-130}}, color={0,0,127}));
  connect(from_degC2.y, cooLoaO[1].TSet)
    annotation (Line(points={{-78,-130},{-60,-130},{-60,-92},{-178,-92}},     color={0,0,127}));
  connect(loa.y[1], cooLoaO[1].Q_flowReq)
    annotation (Line(points={{21,0},{80,0},{80,-100},{-178,-100}}, color={0,0,127}));
  connect(loa.y[2], heaLoaO[1].Q_flowReq) annotation (Line(points={{21,0},{80,0},{80,100},{-178,100}},
                                                                                                     color={0,0,127}));
  connect(sin1.y, from_degC4.u) annotation (Line(points={{-142,50},{-178,50}}, color={0,0,127}));
  connect(from_degC4.y, THeaLoaT[1].T) annotation (Line(points={{-202,50},{-218,50}}, color={0,0,127}));
  connect(sin.y, gai[2].u) annotation (Line(points={{22,40},{50,40},{50,200},{80,200}}, color={0,0,127}));
  connect(conPIDMaxT.y, yCooReq) annotation (Line(points={{142,-192},{310,-192}}, color={0,0,127}));
  connect(conPIDMinT.y, yHeaReq) annotation (Line(points={{142,200},{310,200}}, color={0,0,127}));
  connect(loa.y[1], gai1[1].u) annotation (Line(points={{21,0},{50,0},{50,-192},{78,-192}}, color={0,0,127}));
  connect(Q_flowHeaAct, gai3.u) annotation (Line(points={{310,294},{34,294},{34,230},{78,230}}, color={0,0,127}));
  connect(Q_flowCooAct, gai2.u) annotation (Line(points={{310,-294},{32,-294},{32,-220},{78,-220}}, color={0,0,127}));
  connect(loa.y[2], gai[1].u) annotation (Line(points={{21,0},{50,0},{50,200},{80,200}}, color={0,0,127}));
  connect(gai2.y, conPIDMaxT.u_m) annotation (Line(points={{102,-220},{130,-220},{130,-204}}, color={0,0,127}));
  connect(conPIDMaxT.u_s, gai1.y) annotation (Line(points={{118,-192},{102,-192}}, color={0,0,127}));
  connect(gai3.y, conPIDMinT.u_m) annotation (Line(points={{102,230},{130,230},{130,212}}, color={0,0,127}));
  connect(conPIDMinT.u_s, gai.y) annotation (Line(points={{118,200},{104,200}}, color={0,0,127}));
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
