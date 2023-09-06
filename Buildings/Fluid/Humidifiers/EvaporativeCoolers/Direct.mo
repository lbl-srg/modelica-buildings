within Buildings.Fluid.Humidifiers.EvaporativeCoolers;
model Direct "Direct Evaporative cooler"

  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Real mflownom(final unit = "kg/s") = 1 "Nominal mass flow rate";
  parameter Modelica.Units.SI.Area PadArea = 1 "Area of the rigid media evaporative pad";
  parameter Modelica.Units.SI.Density density = 1.225 "Air density";
  parameter Modelica.Units.SI.Length Depth = 0.5 "Depth of the rigid media evaporative pad";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(
    redeclare final package Medium = Medium,
    m_flow_nominal=mflownom,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    T_start=298.15)
    "Dry bulb temperature sensor"
      annotation (Placement(visible=true, transformation(
        origin={-80,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senTemWetBul(
    redeclare final package Medium = Medium,
    m_flow_nominal=mflownom,
    initType=Modelica.Blocks.Types.Init.InitialOutput,
    TWetBul_start=296.15)
    "Wet bulb temperature sensor"
      annotation (Placement(visible=true, transformation(
        origin={-50,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.VolumeFlowRate senVolflo(redeclare final package
      Medium =  Medium, m_flow_nominal = mflownom)
      "Volume flow rate sensor"
        annotation (
    Placement(visible = true, transformation(origin = {-20, 0}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.FixedResistances.PressureDrop res(redeclare final package
      Medium = Medium, dp_nominal = 10, m_flow_nominal = mflownom)
      "Pressure drop"
        annotation (
    Placement(visible = true, transformation(origin={30,0},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.MixingVolumes.MixingVolumeMoistAir vol(redeclare final
      package Medium = Medium, m_flow_nominal = mflownom, V = 1, nPorts = 2)
      "Moist air mixing volume"
      annotation (
    Placement(visible = true, transformation(origin={80,20},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.Baseclasses.DirectCalculations directEvapCooler(
    redeclare package Medium = Medium,
    Depth=Depth,
    PadArea=PadArea,
    density=density)
    "Evaporative cooler calculator"
      annotation (Placement(visible=true, transformation(
        origin={0,60},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.Pressure senPre(redeclare final package Medium =
        Medium)
        "Pressure"
          annotation (Placement(visible=true, transformation(
        origin={-80,60},
        extent={{-10,-10},{10,10}},
        rotation=0)));
equation
  connect(senVolflo.V_flow, directEvapCooler.V_flow) annotation (Line(points={{
          -20,11},{-20,58},{-12,58},{-12,58.2}}, color={0,0,127}));
  connect(senTemWetBul.T, directEvapCooler.TWetBulSup) annotation (Line(points={
          {-50,11},{-44,11},{-44,68.2},{-11.8,68.2}}, color={0,0,127}));
  connect(senTem.T, directEvapCooler.TDryBulSupIn) annotation (Line(points={{-80,
          11},{-64,11},{-64,63.2},{-12,63.2}}, color={0,0,127}));
  connect(senTem.port_b, senTemWetBul.port_a)    annotation (Line(points={{-70,0},{-60,0}}, color={0,127,255}));
  connect(senTemWetBul.port_b, senVolflo.port_a)
    annotation (Line(points={{-40,0},{-30,0}}));
  connect(res.port_b, vol.ports[1]) annotation (
    Line(points={{40,0},{78,0},{78,10}},         color = {0, 127, 255}));
  connect(port_a, senTem.port_a) annotation (Line(points={{-100,0},{-90,0}}));
  connect(vol.ports[2], port_b) annotation (
    Line(points={{82,10},{82,0},{100,0}},        color = {0, 127, 255}));
  connect(senTem.port_a, senPre.port)
    annotation (Line(points={{-90,0},{-90,50},{-80,50}}, color={0,127,255}));
  connect(senPre.p, directEvapCooler.p) annotation (Line(points={{-69,60},{-34,60},
          {-34,53.4},{-12,53.4}}, color={0,0,127}));
  connect(directEvapCooler.dmWat_flow, vol.mWat_flow) annotation (Line(points={{
          11,50.6},{60,50.6},{60,28},{68,28}}, color={0,0,127}));
  connect(senVolflo.port_b, res.port_a)
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
            fillPattern =                                                                                                                                                                                                        FillPattern.Solid, points = {{42, -26}, {54, -34}, {54, -34}, {42, -40}, {42, -38}, {50, -34}, {50, -34}, {42, -28}, {42, -26}})}, coordinateSystem(extent = {{-100, -100}, {100, 100}})),
      Documentation(info="<html>
<p>Model for a direct evaporative cooler.</p>
<p>This model adds moisture into the air stream. The amount of exchanged moisture is equal to </p>
<p align=\"center\"><i>ṁ<sub>wat</sub> = (Xi<sub>Out</sub> - Xi<sub>In</sub>) * V<sub>_flow </sub>* density </i></p>
<p>where <i>Xi<sub>Out</i></sub> is the water mass fraction at the inlet, <i>Xi<sub>Out </i></sub>is the water mass fraction at the outlet, <i>V<sub>_flow</i></sub> is the air volume flow rate, <i>density</i> is the air density. </p>
</html>"));
end Direct;
