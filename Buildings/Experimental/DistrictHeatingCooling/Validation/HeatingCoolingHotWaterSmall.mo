within Buildings.Experimental.DistrictHeatingCooling.Validation;
model HeatingCoolingHotWaterSmall
  "Validation model for a system with heating, cooling and hot water"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 6E5
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.SIunits.Temperature TSetHeaLea = 273.15+12
    "Set point for leaving fluid temperature warm supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Temperature TSetCooLea = 273.15+16
    "Set point for leaving fluid temperature cold supply"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.Pressure dp_nominal(displayUnit="Pa")=30000
    "Pressure difference at nominal flow rate"
    annotation(Dialog(group="Design parameter"));

  parameter Modelica.SIunits.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea-TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation(Dialog(group="Design parameter"));

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = Q_flow_nominal/4200/dT_nominal
    "Nominal mass flow rate";

  Plants.Ideal_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    Q_flow_nominal=Q_flow_nominal,
    TSetHeaLea=TSetHeaLea,
    TSetCooLea=TSetCooLea) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-180,50},{-160,70}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-200,-90})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    v_nominal=2,
    dp_nominal=0,
    useMultipleHeatPorts=true,
    nSeg=1)
    annotation (Placement(transformation(extent={{-140,50},{-120,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    v_nominal=2,
    dp_nominal=0,
    useMultipleHeatPorts=true,
    nSeg=1)
    annotation (Placement(transformation(extent={{-130,-70},{-150,-50}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff(
      redeclare package Medium = Medium,
      filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-80,-20},{-40,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        "modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos",
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret(
    redeclare package Medium = Medium,
    filNam="modelica://Buildings/Resources/Data/Experimental/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos",
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{20,-20},{60,20}})));

  Fluid.FixedResistances.SplitterFixedResistanceDpM splSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-100,50},{-80,70}})));
  Fluid.FixedResistances.SplitterFixedResistanceDpM splRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-30,-50},{-10,-70}})));
equation
  connect(pla.port_b, pip.port_a) annotation (Line(points={{-160,60},{-140,60}},
                         color={0,127,255}));
  connect(pla.port_a, pip1.port_b) annotation (Line(points={{-180,60},{-200,60},
          {-200,-60},{-150,-60}},
                           color={0,127,255}));
  connect(pSet.ports[1], pip1.port_b) annotation (Line(points={{-200,-80},{-200,
          -60},{-150,-60}},
                      color={0,127,255}));
  connect(weaDat.weaBus, larOff.weaBus) annotation (Line(
      points={{-180,110},{-136,110},{-60,110},{-60,16.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaDat.weaBus, ret.weaBus) annotation (Line(
      points={{-180,110},{-114,110},{40,110},{40,16.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(pip.port_b, splSup.port_1) annotation (Line(points={{-120,60},{-110,
          60},{-100,60}}, color={0,127,255}));
  connect(splSup.port_3, larOff.port_a) annotation (Line(points={{-90,50},{-90,
          50},{-90,0},{-80,0}}, color={0,127,255}));
  connect(splSup.port_2, ret.port_a) annotation (Line(points={{-80,60},{-54,60},
          {0,60},{0,0},{20,0}}, color={0,127,255}));
  connect(larOff.port_b, splRet.port_3) annotation (Line(points={{-40.1429,0},{
          -20,0},{-20,-50}}, color={0,127,255}));
  connect(pip1.port_a, splRet.port_1) annotation (Line(points={{-130,-60},{-80,
          -60},{-30,-60}}, color={0,127,255}));
  connect(splRet.port_2, ret.port_b) annotation (Line(points={{-10,-60},{50,-60},
          {80,-60},{80,0},{59.8571,0}}, color={0,127,255}));
  annotation(experiment(StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Validation/HeatingCoolingHotWaterSmall.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal anergy heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},{
            140,140}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end HeatingCoolingHotWaterSmall;
