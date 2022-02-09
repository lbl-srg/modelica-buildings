within Buildings.Obsolete.DistrictHeatingCooling.Validation;
model HeatingCoolingHotWaterSmall
  "Validation model for a system with heating, cooling and hot water"
  extends Modelica.Icons.Example;
    package Medium = Buildings.Media.Water "Fluid in the pipes";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal=6E5
    "Nominal heat flow rate, positive for heating, negative for cooling";

  parameter Modelica.Units.SI.Temperature TSetHeaLea=273.15 + 12
    "Set point for leaving fluid temperature warm supply"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.Temperature TSetCooLea=273.15 + 16
    "Set point for leaving fluid temperature cold supply"
    annotation (Dialog(group="Design parameter"));

  parameter Modelica.Units.SI.TemperatureDifference dT_nominal(
    min=0.5,
    displayUnit="K") = TSetCooLea - TSetHeaLea
    "Temperature difference between warm and cold pipe"
    annotation (Dialog(group="Design parameter"));

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";

  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=Q_flow_nominal/
      4200/dT_nominal "Nominal mass flow rate";

  Plants.HeatingCoolingCarnot_T pla(
    redeclare package Medium = Medium,
    show_T=true,
    m_flow_nominal=m_flow_nominal) "Heating and cooling plant"
    annotation (Placement(transformation(extent={{-210,40},{-190,60}})));
  Buildings.Fluid.Sources.Boundary_pT pSet(redeclare package Medium = Medium,
      nPorts=1) "Model to set the reference pressure"
                                          annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={-260,-90})));
  Buildings.Fluid.FixedResistances.Pipe pip(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    v_nominal=2,
    dp_nominal=50*R_nominal,
    useMultipleHeatPorts=true,
    nSeg=1)
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
  Buildings.Fluid.FixedResistances.Pipe pip1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    v_nominal=2,
    dp_nominal=50*R_nominal,
    useMultipleHeatPorts=true,
    nSeg=1)
    annotation (Placement(transformation(extent={{-52,-70},{-72,-50}})));
  Obsolete.DistrictHeatingCooling.SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT larOff(
      redeclare package Medium = Medium,
      filNam=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/Obsolete/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgLargeOfficeNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    TOut_nominal=273.15) "Large office"
    annotation (Placement(transformation(extent={{-18,-20},{22,20}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"),
      computeWetBulbTemperature=false) "File reader that reads weather data"
    annotation (Placement(transformation(extent={{-200,100},{-180,120}})));
  Obsolete.DistrictHeatingCooling.SubStations.VaporCompression.HeatingCoolingHotwaterTimeSeries_dT ret(
    redeclare package Medium = Medium,
    filNam=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Obsolete/DistrictHeatingCooling/SubStations/VaporCompression/RefBldgStand-aloneRetailNew2004_7.1_5.0_3C_USA_CA_SAN_FRANCISCO.mos"),
    TOut_nominal=273.15) "Retail"
    annotation (Placement(transformation(extent={{80,-20},{120,20}})));

  Plants.LakeWaterHeatExchanger_T bayWatHex(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpHex_nominal=10000)
                     "Bay water heat exchanger"
    annotation (Placement(transformation(extent={{-120,-20},{-100,20}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-168,100},{-152,116}}), iconTransformation(
          extent={{-328,64},{-308,84}})));

  Buildings.Fluid.FixedResistances.Junction splSup(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Buildings.Fluid.FixedResistances.Junction splRet(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    tau=5*60,
    from_dp=false) "Flow splitter"
    annotation (Placement(transformation(extent={{30,-50},{50,-70}})));

  Modelica.Blocks.Sources.CombiTimeTable watTem(
    tableOnFile=true,
    tableName="tab1",
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    y(each unit="K"),
    fileName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/Obsolete/DistrictHeatingCooling/Plants/AlamedaOceanT.mos"))
    "Temperature of the water reservoir (such as a river, lake or ocean)"
    annotation (Placement(transformation(extent={{-170,8},{-150,28}})));

protected
  Modelica.Blocks.Sources.Constant TSetC(k=TSetCooLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-260,60},{-240,80}})));
  Modelica.Blocks.Sources.Constant TSetH(k=TSetHeaLea)
    "Set point temperature for leaving water"
    annotation (Placement(transformation(extent={{-260,100},{-240,120}})));

equation
  connect(pip.port_b, splSup.port_1) annotation (Line(points={{-50,60},{-50,60},
          {-40,60}},      color={0,127,255}));
  connect(splSup.port_3, larOff.port_a) annotation (Line(points={{-30,50},{-30,50},
          {-30,0},{-18,0}},     color={0,127,255}));
  connect(splSup.port_2, ret.port_a) annotation (Line(points={{-20,60},{6,60},{60,
          60},{60,0},{80,0}},   color={0,127,255}));
  connect(larOff.port_b, splRet.port_3) annotation (Line(points={{21.8571,0},{
          40,0},{40,-50}},   color={0,127,255}));
  connect(pip1.port_a, splRet.port_1) annotation (Line(points={{-52,-60},{-52,-60},
          {30,-60}},       color={0,127,255}));
  connect(splRet.port_2, ret.port_b) annotation (Line(points={{50,-60},{50,-60},
          {132,-60},{132,0},{119.857,0}},
                                        color={0,127,255}));
  connect(TSetH.y, pla.TSetHea) annotation (Line(points={{-239,110},{-228,110},
          {-228,58},{-212,58}},color={0,0,127}));
  connect(TSetC.y, pla.TSetCoo) annotation (Line(points={{-239,70},{-232,70},{
          -232,54},{-212,54}},
                          color={0,0,127}));
  connect(pip.port_a, bayWatHex.port_b1) annotation (Line(points={{-70,60},{-84,
          60},{-84,-4},{-100,-4}},     color={0,127,255}));
  connect(bayWatHex.port_a1, pla.port_b) annotation (Line(points={{-120,-4},{-180,
          -4},{-180,50},{-190,50}},     color={0,127,255}));
  connect(bayWatHex.port_b2, pla.port_a) annotation (Line(points={{-120,-16},{-120,
          -2},{-258,-2},{-258,50},{-210,50}},      color={0,127,255}));
  connect(bayWatHex.port_a2, pip1.port_b) annotation (Line(points={{-100,-16},{-80,
          -16},{-80,-60},{-72,-60}},       color={0,127,255}));
  connect(bayWatHex.TSetHea, TSetH.y) annotation (Line(points={{-122,6},{-228,6},
          {-228,110},{-239,110}},     color={0,0,127}));
  connect(pSet.ports[1], pla.port_a) annotation (Line(points={{-260,-80},{-260,
          -80},{-260,-42},{-260,50},{-210,50}}, color={0,127,255}));
  connect(weaDat.weaBus, weaBus) annotation (Line(
      points={{-180,110},{-180,108},{-160,108}},
      color={255,204,51},
      thickness=0.5));
  connect(pla.TSink, weaBus.TDryBul) annotation (Line(points={{-212,44},{-220,44},
          {-220,88},{-218,88},{-160,88},{-160,108}},     color={0,0,127}));
  connect(weaBus, larOff.weaBus) annotation (Line(
      points={{-160,108},{2,108},{2,16.7143}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, ret.weaBus) annotation (Line(
      points={{-160,108},{-160,108},{100,108},{100,16.7143}},
      color={255,204,51},
      thickness=0.5));

  connect(bayWatHex.TSouWat, watTem.y[1]) annotation (Line(points={{-122,18},{
          -140,18},{-149,18}},      color={0,0,127}));
  connect(bayWatHex.TSouHea, weaBus.TDryBul) annotation (Line(points={{-122,14},
          {-130,14},{-130,108},{-160,108}}, color={0,0,127}));
  connect(bayWatHex.TSetCoo, TSetC.y) annotation (Line(points={{-122,2},{-232,2},
          {-232,70},{-239,70},{-239,70}}, color={0,0,127}));
  connect(bayWatHex.TSouCoo, weaBus.TDryBul) annotation (Line(points={{-122,10},
          {-130,10},{-130,108},{-160,108}}, color={0,0,127}));
  annotation(experiment(Tolerance=1e-06, StopTime=31536000),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Obsolete/DistrictHeatingCooling/Validation/HeatingCoolingHotWaterSmall.mos"
        "Simulate and plot"),
    Documentation(
    info="<html>
<p>
This model validates a small ideal bi-directional heating and cooling network.
The heating and cooling heat flow rates extracted from the district supply
are prescribed by time series.
</p>
</html>",
revisions="<html>
<ul>
<li>
December 12, 2017, by Michael Wetter:<br/>
Added <code>Modelica.Utilities.Files.loadResource</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1097\">issue 1097</a>.
</li>
<li>
November 8, 2016, by Michael Wetter:<br/>
Added missing <code>each</code> keyword to output of combi time table.
</li>
<li>
June 2, 2016, by Michael Wetter:<br/>
Changed pressure drops and removed top-level parameter <code>dp_nominal</code>.
</li>
<li>
November 20, 2015, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-280,-120},{
            140,140}})));
end HeatingCoolingHotWaterSmall;
