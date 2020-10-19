within Buildings.Experimental.NatVentControl.Validation;
model NaturalVentilationNightFlushFixedExteriorChicago
  replaceable package MediumA =
      Buildings.Media.Air;
  Fluid.Sensors.TemperatureTwoPort temRoo(
    redeclare package Medium = MediumA,
    m_flow_nominal=0.001,
    transferHeat=false) "HeatingTemperature" annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=90,
        origin={372,-80})));
  Modelica.Blocks.Sources.CombiTimeTable airCon1(
    table=[0,0.001,293.15; 28800,0.05,293.15; 64800,0.001,293.15; 86400,
        0.001,293.15],
    tableOnFile=false,
    tableName="airCon",
    fileName=Modelica.Utilities.Files.loadResource(
        "modelica://Buildings/Resources/Data/ThermalZones/Detailed/FLEXLAB/Rooms/Examples/X3AWithRadiantFloor.txt"),
    columns=2:3,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1) "Inlet air conditions (y[1] = m_flow, y[4] = T)"
    annotation (Placement(transformation(extent={{256,-54},{276,-34}})));

  Fluid.Sources.MassFlowSource_T           airIn1(
    use_m_flow_in=true,
    use_T_in=true,
    redeclare package Medium = MediumA,
    nPorts=1) "Inlet air conditions (from AHU) for X3A"
    annotation (Placement(transformation(extent={{314,-36},{334,-16}})));
  Modelica.Blocks.Sources.CombiTimeTable intGai1(
    table=[0,1.05729426,1.25089426,0; 3600,1.05729426,1.25089426,0; 7200,
        1.05729426,1.25089426,0; 10800,1.05729426,1.25089426,0; 14400,
        1.05729426,1.25089426,0; 18000,1.05729426,1.25089426,0; 21600,
        1.121827593,1.509027593,0; 25200,1.548281766,1.882174238,
        0.330986667; 28800,1.977743414,2.979420831,0.661973333; 32400,
        5.734675369,8.73970762,3.144373333; 36000,5.734675369,8.73970762,
        3.144373333; 39600,5.734675369,8.73970762,3.144373333; 43200,
        5.734675369,8.73970762,3.144373333; 46800,4.496245967,7.501278218,
        1.654933333; 50400,5.734675369,8.73970762,3.144373333; 54000,
        5.734675369,8.73970762,3.144373333; 57600,5.734675369,8.73970762,
        3.144373333; 61200,5.734675369,8.73970762,3.144373333; 64800,
        2.714734464,4.384196826,0.99296; 68400,1.770876747,2.772554164,
        0.330986667; 72000,1.770876747,2.772554164,0.330986667; 75600,
        1.659579257,2.327364201,0.330986667; 79200,1.659579257,2.327364201,
        0.330986667; 82800,1.444848433,1.778740905,0.165493333; 86400,
        1.389199687,1.556145923,0.165493333],
    tableOnFile=false,
    columns=2:4,
    smoothness=Modelica.Blocks.Types.Smoothness.ConstantSegments,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
    timeScale=1,
    startTime=0)
    "Internal gain heat flow (Radiant = 1, Convective = 2, Latent = 3)"
    annotation (Placement(transformation(extent={{360,102},{380,122}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel3(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{454,-46},{474,-26}})));
  Airflow.Multizone.DoorDiscretizedOperable doo(
    show_T=true,
    wOpe=2,
    hOpe=2,
    hA=1,
    hB=1,
    dp_turbulent=1000,
    LClo=0.01,
    redeclare package Medium = MediumA,
    CDOpe=0.7,
    mOpe=0.74)                          "Window"
    annotation (Placement(transformation(extent={{198,100},{218,120}})));
  ThermalZones.Detailed.FLEXLAB.Rooms.X3A.TestCell_Radiant radExt(nPorts=4,
      redeclare package Medium = MediumA)
    annotation (Placement(transformation(extent={{418,42},{458,82}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat1(filNam=
        ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{-42,142},{-22,162}})));
  BoundaryConditions.WeatherData.ReaderTMY3 weaDat2(filNam=
        Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data reader"
    annotation (Placement(transformation(extent={{502,80},{522,100}})));
  Fluid.Sources.Boundary_pT
    airOut2(redeclare package Medium = MediumA, nPorts=1)
                                                     "Air outlet for X3A"
    annotation (Placement(transformation(extent={{288,-90},{308,-70}})));
  Fluid.Sources.Outside_CpLowRise out(
    redeclare package Medium = MediumA,
    s=1,
    azi=0,
    nPorts=2) annotation (Placement(transformation(extent={{14,158},{34,178}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor conBel1(G=0.2)
    "Combined convection and radiation resistance below the slab"
    annotation (Placement(transformation(extent={{416,-84},{436,-64}})));
  BoundaryConditions.WeatherData.Bus weaBus annotation (Placement(
        transformation(extent={{-84,166},{-44,206}}), iconTransformation(extent=
           {{-168,106},{-148,126}})));
  HeatTransfer.Sources.FixedTemperature TFix(T=292.15)
    annotation (Placement(transformation(extent={{554,8},{574,28}})));
  Modelica.Blocks.Sources.BooleanConstant booleanConstant2(k=false)
    annotation (Placement(transformation(extent={{-60,100},{-40,120}})));
  NaturalVentilationNightFlushFixed nitFluFix(TDryBulCut=280)
    annotation (Placement(transformation(extent={{34,-10},{144,94}})));
  Controls.OBC.CDL.Logical.Sources.Pulse booPul(
    width=0.25,
    period=86400,
    startTime=32400)
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  RadiantControl.SlabTempSignal.Validation.BaseClasses.ForecastHighChicago forHiChi
    annotation (Placement(transformation(extent={{-82,-20},{-62,0}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TIntSet(k=293)
    annotation (Placement(transformation(extent={{-98,-98},{-54,-54}})));
equation
  connect(airCon1.y[1],airIn1. m_flow_in) annotation (Line(points={{277,-44},{300,
          -44},{300,-18},{312,-18}},   color={0,0,127}));
  connect(airCon1.y[2],airIn1. T_in) annotation (Line(points={{277,-44},{300,-44},
          {300,-22},{312,-22}},   color={0,0,127}));
  connect(conBel3.port_b, radExt.surf_conBou[1]) annotation (Line(points={{474,
          -36},{480,-36},{480,20},{444,20},{444,46}}, color={191,0,0}));
  connect(airIn1.ports[1], radExt.ports[1]) annotation (Line(points={{334,-26},
          {377,-26},{377,49},{423,49}}, color={0,127,255}));
  connect(radExt.ports[2], doo.port_a2) annotation (Line(points={{423,51},{298,
          51},{298,104},{218,104}}, color={0,127,255}));
  connect(doo.port_b1, radExt.ports[3]) annotation (Line(points={{218,116},{320,
          116},{320,53},{423,53}}, color={0,127,255}));
  connect(radExt.ports[4], temRoo.port_a) annotation (Line(points={{423,55},{
          402,55},{402,-96},{372,-96},{372,-90}}, color={0,127,255}));
  connect(intGai1.y, radExt.qGai_flow) annotation (Line(points={{381,112},{400,
          112},{400,70},{416.4,70}}, color={0,0,127}));
  connect(weaDat2.weaBus, radExt.weaBus) annotation (Line(
      points={{522,90},{544,90},{544,79.9},{455.9,79.9}},
      color={255,204,51},
      thickness=0.5));
  connect(temRoo.port_b, airOut2.ports[1]) annotation (Line(points={{372,-70},{
          340,-70},{340,-80},{308,-80}}, color={0,127,255}));
  connect(weaDat1.weaBus, out.weaBus) annotation (Line(
      points={{-22,152},{0,152},{0,168.2},{14,168.2}},
      color={255,204,51},
      thickness=0.5));
  connect(out.ports[1], doo.port_a1) annotation (Line(points={{34,170},{46,170},
          {46,116},{198,116}}, color={0,127,255}));
  connect(doo.port_b2, out.ports[2]) annotation (Line(points={{198,104},{118,
          104},{118,166},{34,166}}, color={0,127,255}));
  connect(conBel1.port_b, radExt.surf_surBou[1])
    annotation (Line(points={{436,-74},{436,48},{434.2,48}}, color={191,0,0}));
  connect(weaDat1.weaBus, weaBus) annotation (Line(
      points={{-22,152},{-8,152},{-8,186},{-64,186}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(TFix.port, conBel1.port_a) annotation (Line(points={{574,18},{588,18},
          {588,-98},{406,-98},{406,-74},{416,-74}}, color={191,0,0}));
  connect(TFix.port, conBel3.port_a) annotation (Line(points={{574,18},{588,18},
          {588,-50},{446,-50},{446,-36},{454,-36}}, color={191,0,0}));
  connect(booleanConstant2.y, nitFluFix.uManOveRid) annotation (Line(points={{-39,
          110},{-27.5,110},{-27.5,87.76},{23,87.76}}, color={255,0,255}));
  connect(booleanConstant2.y, nitFluFix.uRai) annotation (Line(points={{-39,110},
          {-27.5,110},{-27.5,77.36},{23,77.36}}, color={255,0,255}));
  connect(booPul.y, nitFluFix.uOcc) annotation (Line(points={{-38,70},{-16,70},
          {-16,68},{23,68}}, color={255,0,255}));
  connect(weaBus.TWetBul, nitFluFix.uWetBul) annotation (Line(
      points={{-64,186},{-80,186},{-80,54},{-26,54},{-26,53.44},{23,53.44}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, nitFluFix.uDryBul) annotation (Line(
      points={{-64,186},{-80,186},{-80,17.04},{23,17.04}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.winSpe, nitFluFix.uWinSpe) annotation (Line(
      points={{-64,186},{-80,186},{-80,6},{23,6},{23,5.6}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-3,-6},{-3,-6}},
      horizontalAlignment=TextAlignment.Right));
  connect(nitFluFix.yWinOpe, doo.y) annotation (Line(points={{155,56.56},{180,
          56.56},{180,110},{197,110}}, color={0,0,127}));
  connect(temRoo.T, nitFluFix.uRooMeaTem) annotation (Line(points={{361,-80},{
          352,-80},{352,-96},{0,-96},{0,-4.8},{23,-4.8}}, color={0,0,127}));
  connect(forHiChi.TForHiChi, nitFluFix.uForHi) annotation (Line(points={{-60,-9.8},
          {-20,-9.8},{-20,27.44},{23,27.44}}, color={0,0,127}));
  connect(TIntSet.y, nitFluFix.uRooSet) annotation (Line(points={{-49.6,-76},{
          -40,-76},{-40,43.04},{23,43.04}}, color={0,0,127}));
  annotation (experiment(Tolerance=1e-6, StartTime=0, StopTime=31536000), __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/NatVentControl/Validation/NatVenNitFluFix_Exterior_Chi.mos"
        "Simulate and plot"),Documentation(info="<html>
  <p> fixme : Validation model in progress
</p>
</html>"),Icon(coordinateSystem(extent={{-100,-100},{100,100}}),
                   graphics={
        Ellipse(
          lineColor={75,138,73},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{-100,-100},{100,100}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-36,58},{64,-2},{-36,-62},{-36,58}})}), Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            640,200}})));
end NaturalVentilationNightFlushFixedExteriorChicago;
