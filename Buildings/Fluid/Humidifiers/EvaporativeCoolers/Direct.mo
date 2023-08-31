within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model Direct
  /*redeclare package Medium = Modelica.Media.Interfaces.PartialMedium  annotation (choices(
                choice(redeclare package Medium = Buildings.Media.Air "Moist air"),
                choice(redeclare package Medium = Buildings.Media.Water "Water"),
                choice(redeclare package Medium =
                    Buildings.Media.Antifreeze.PropyleneGlycolWater (
                      property_T=293.15,
                      X_a=0.40)
                      "Propylene glycol water, 40% mass fraction")))*/
  extends Buildings.Fluid.Interfaces.PartialTwoPort;
  parameter Real mflownom(final unit = "1") = 1;
  parameter Modelica.Units.SI.Area PadArea = 1;
  parameter Modelica.Units.SI.Density density = 1.225;
  parameter Modelica.Units.SI.Length Depth = 0.5;
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare final package
      Medium =                                                                       Medium, m_flow_nominal = mflownom, initType = Modelica.Blocks.Types.Init.InitialOutput, T_start = 298.15) annotation (
    Placement(visible = true, transformation(origin={-80,0},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senWetBul(redeclare final
      package Medium =                                                                         Medium, m_flow_nominal = mflownom, initType = Modelica.Blocks.Types.Init.InitialOutput, TWetBul_start = 296.15) annotation (
    Placement(visible = true, transformation(origin={-50,0},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.VolumeFlowRate senVolFlo(redeclare final package
      Medium =                                                                      Medium, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.PressureDrop res(redeclare final package
      Medium =                                                                       Medium, dp_nominal = 10, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin={30,0},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(redeclare final
      package Medium =                                                                    Medium, m_flow_nominal = mflownom, V = 1, nPorts = 2) annotation (
    Placement(visible = true, transformation(origin={80,20},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Baseclasses.DirectCalculations directEvapCooler(
    redeclare package Medium = Medium,
    Depth=Depth,
    PadArea=PadArea,
    density=density) annotation (Placement(visible=true, transformation(
        origin={0,60},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.Pressure senPre(redeclare final package Medium = Medium) annotation (
    Placement(visible = true, transformation(origin={-80,60},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
equation
  connect(senVolFlo.V_flow, directEvapCooler.V_flow) annotation (Line(points={{
          -20,11},{-20,58},{-12,58},{-12,58.2}}, color={0,0,127}));
  connect(senWetBul.T,directEvapCooler.TWetBulSup)  annotation (Line(points={{-50,
          11},{-44,11},{-44,68.2},{-11.8,68.2}}, color={0,0,127}));
  connect(senTem.T, directEvapCooler.TDryBulSupIn) annotation (Line(points={{-80,
          11},{-64,11},{-64,63.2},{-12,63.2}}, color={0,0,127}));
  connect(senTem.port_b, senWetBul.port_a) annotation (
    Line(points={{-70,0},{-60,0}},      color = {0, 127, 255}));
  connect(senWetBul.port_b, senVolFlo.port_a) annotation (
    Line(points={{-40,0},{-30,0}}));
  connect(res.port_b, vol.ports[1]) annotation (
    Line(points={{40,0},{78,0},{78,10}},         color = {0, 127, 255}));
  connect(port_a, senTem.port_a) annotation (
    Line(points={{-100,0},{-90,0}}));
  connect(vol.ports[2], port_b) annotation (
    Line(points={{82,10},{82,0},{100,0}},        color = {0, 127, 255}));
  connect(senTem.port_a, senPre.port) annotation (
    Line(points={{-90,0},{-90,50},{-80,50}},                   color = {0, 127, 255}));
  connect(senPre.p, directEvapCooler.p) annotation (Line(points={{-69,60},{-34,
          60},{-34,53.4},{-12,53.4}}, color={0,0,127}));
  connect(directEvapCooler.dmW, vol.mWat_flow) annotation (Line(points={{11,
          50.6},{60,50.6},{60,28},{68,28}}, color={0,0,127}));
  connect(senVolFlo.port_b, res.port_a)
    annotation (Line(points={{-10,0},{20,0}}, color={0,127,255}));
  annotation (
    Icon(graphics={  Rectangle(lineColor = {0, 0, 255}, fillColor = {95, 95, 95}, pattern = LinePattern.None,
            fillPattern =                                                                                                   FillPattern.Solid, extent = {{-70, 60}, {70, -60}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-101, 5}, {100, -4}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {255, 0, 0}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{0, -4}, {100, 5}}), Text(textColor = {0, 0, 127}, extent = {{-52, -60}, {58, -120}}, textString = "m=%m_flow_nominal"), Rectangle(lineColor = {0, 0, 255}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-100, 5}, {101, -5}}), Rectangle(lineColor = {0, 0, 255}, fillColor = {0, 62, 0}, pattern = LinePattern.None,
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{-70, 60}, {70, -60}}), Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{42, 42}, {54, 34}, {54, 34}, {42, 28}, {42, 30}, {50, 34}, {50, 34}, {42, 40}, {42, 42}}), Rectangle(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, extent = {{58, -54}, {54, 52}}), Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{42, 10}, {54, 2}, {54, 2}, {42, -4}, {42, -2}, {50, 2}, {50, 2}, {42, 8}, {42, 10}}), Polygon(lineColor = {255, 255, 255}, fillColor = {255, 255, 255},
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{42, -26}, {54, -34}, {54, -34}, {42, -40}, {42, -38}, {50, -34}, {50, -34}, {42, -28}, {42, -26}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})));
end Direct;
