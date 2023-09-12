within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model Direct "Validation model for a direct evaporative cooler"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air;
  parameter Real mflownom(final unit = "1") = 2;
  Buildings.Fluid.Sources.Boundary_pT sink(redeclare final package Medium = MediumA, T = 340, nPorts = 1, use_T_in = false) annotation (
    Placement(visible = true, transformation(origin = {190, -70}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    columns = 2:10,
    fileName=ModelicaServices.ExternalReferences.loadResource(
        "modelica://Buildings/Resources/Data/Fluid/Humidifiers/EvaporativeCoolers/Direct.dat"),
    tableName = "EnergyPlus",
    tableOnFile = true,
    timeScale = 1)
    annotation (Placement(visible = true,
      transformation(origin={-244,120},
      extent = {{-10, -10}, {10, 10}},
      rotation = 0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct dEC_physicsmodel1(
    dep=0.2,
    redeclare package Medium = MediumA,
    padAre=0.6,
    den(displayUnit="kg/m3"),
    m_flow_nominal=mflownom) annotation (Placement(visible=true, transformation(
        origin={-2,-14},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar(p = 1) annotation (
    Placement(transformation(extent={{-90,4},{-70,24}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div annotation (
    Placement(transformation(extent={{-40,40},{-20,60}})));
  Buildings.Controls.OBC.CDL.Reals.Divide div1 annotation (
    Placement(transformation(extent = {{70, 50}, {90, 70}})));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addPar1(p = 1) annotation (
    Placement(transformation(extent={{20,22},{40,42}})));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium = MediumA, m_flow = 1, nPorts = 1, use_C_in = false, use_T_in = true, use_Xi_in = true, use_m_flow_in = true) annotation (
    Placement(visible = true, transformation(origin={-110,-2},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium = MediumA, initType = Modelica.Blocks.Types.Init.InitialOutput, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin = {-98, -40}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem1(redeclare package Medium = MediumA, initType = Modelica.Blocks.Types.Init.InitialOutput, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin = {30, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senWetBul(redeclare package
      Medium =                                                                           MediumA, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin = {-42, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureWetBulbTwoPort senWetBul1(redeclare
      package Medium =                                                                    MediumA, m_flow_nominal = mflownom) annotation (
    Placement(visible = true, transformation(origin = {68, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Controls.OBC.CDL.Reals.AddParameter addParameter(p = 273.15) annotation (
    Placement(visible = true, transformation(origin = {-98, 18}, extent = {{-90, 12}, {-70, 32}}, rotation = 0)));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(redeclare package
      Medium =                                                                     MediumA, m_flow_nominal = mflownom)  annotation (
    Placement(visible = true, transformation(origin = {-128, -42}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra1(redeclare package
      Medium =                                                                      MediumA, m_flow_nominal = mflownom)  annotation (
    Placement(visible = true, transformation(origin = {94, -64}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean(f = 1/3600)  annotation (
    Placement(visible = true, transformation(origin = {38, 2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean1(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin = {66, -24}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean2(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin = {96, 8}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(redeclare package
      Medium =                                                                         MediumA, m_flow_nominal = mflownom)  annotation (
    Placement(visible = true, transformation(origin = {122, -38}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean mean3(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin = {140, -2}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Controls.OBC.CDL.Reals.AddParameter           addParameter1(p=-273.15) annotation (
    Placement(visible = true, transformation(origin={202,22},    extent = {{-90, 12}, {-70, 32}}, rotation = 0)));
equation
  connect(addPar.y, div.u2) annotation (
    Line(points={{-68,14},{-60,14},{-60,44},{-42,44}},          color = {0, 0, 127}));
  connect(combiTimeTable.y[6], addPar.u) annotation (
    Line(points={{-233,120},{-100,120},{-100,14},{-92,14}},        color = {0, 0, 127}));
  connect(combiTimeTable.y[6], div.u1) annotation (
    Line(points={{-233,120},{-100,120},{-100,56},{-42,56}},        color = {0, 0, 127}));
  connect(addPar1.y, div1.u2) annotation (
    Line(points={{42,32},{60,32},{60,54},{68,54}},          color = {0, 0, 127}));
  connect(combiTimeTable.y[8], div1.u1) annotation (
    Line(points={{-233,120},{-24,120},{-24,66},{68,66}},        color = {0, 0, 127}));
  connect(combiTimeTable.y[8], addPar1.u) annotation (
    Line(points={{-233,120},{-48,120},{-48,32},{18,32}},        color = {0, 0, 127}));
  connect(combiTimeTable.y[9], boundary.m_flow_in) annotation (
    Line(points={{-233,120},{-136,120},{-136,54},{-156,54},{-156,36},{-154,36},
          {-154,6},{-122,6}},                           color = {0, 0, 127}));
  connect(div.y, boundary.Xi_in[1]) annotation (
    Line(points={{-18,50},{-18,36},{-136,36},{-136,20},{-138,20},{-138,-6},{
          -122,-6}},                                             color = {0, 0, 127}));
  connect(senTem.port_b, senWetBul.port_a) annotation (
    Line(points = {{-88, -40}, {-71, -40}, {-71, -42}, {-52, -42}}, color = {0, 127, 255}));
  connect(senWetBul.port_b, dEC_physicsmodel1.port_a) annotation (
    Line(points = {{-32, -42}, {-32, -14}, {-12, -14}}, color = {0, 127, 255}));
  connect(dEC_physicsmodel1.port_b, senTem1.port_a) annotation (
    Line(points = {{8, -14}, {20, -14}, {20, -64}}, color = {0, 127, 255}));
  connect(senTem1.port_b, senWetBul1.port_a) annotation (
    Line(points = {{40, -64}, {58, -64}}, color = {0, 127, 255}));
  connect(combiTimeTable.y[5], addParameter.u) annotation (
    Line(points={{-233,120},{-198,120},{-198,40},{-190,40}},        color = {0, 0, 127}));
  connect(addParameter.y, boundary.T_in) annotation (
    Line(points={{-166,40},{-162,40},{-162,2},{-122,2}},            color = {0, 0, 127}));
  connect(boundary.ports[1], senMasFra.port_a) annotation (
    Line(points={{-100,-2},{-114,-2},{-114,-42},{-138,-42}},        color = {0, 127, 255}));
  connect(senMasFra.port_b, senTem.port_a) annotation (
    Line(points = {{-118, -42}, {-114, -42}, {-114, -40}, {-108, -40}}, color = {0, 127, 255}));
  connect(senWetBul1.port_b, senMasFra1.port_a) annotation (
    Line(points = {{78, -64}, {84, -64}}, color = {0, 127, 255}));
  connect(senTem1.T, mean.u) annotation (
    Line(points={{30,-53},{30,-25},{26,-25},{26,2}},          color = {0, 0, 127}));
  connect(senWetBul1.T, mean1.u) annotation (
    Line(points={{68,-53},{42,-53},{42,-24},{54,-24}},          color = {0, 0, 127}));
  connect(senMasFra1.X, mean2.u) annotation (
    Line(points={{94,-53},{84,-53},{84,8}},        color = {0, 0, 127}));
  connect(senMasFra1.port_b, senRelHum.port_a) annotation (
    Line(points = {{104, -64}, {104, -38}, {112, -38}}, color = {0, 127, 255}));
  connect(senRelHum.port_b, sink.ports[1]) annotation (
    Line(points = {{132, -38}, {200, -38}, {200, -70}}, color = {0, 127, 255}));
  connect(senRelHum.phi, mean3.u) annotation (
    Line(points={{122.1,-27},{120,-27},{120,-2},{128,-2}},        color = {0, 0, 127}));
  connect(mean.y, addParameter1.u) annotation (Line(points={{49,2},{80,2},{80,
          44},{110,44}}, color={0,0,127}));
  annotation (
    Placement(visible = true, transformation(origin = {-62, 66}, extent = {{-10, -10}, {10, 10}}, rotation = 0)),
    Diagram(coordinateSystem(extent = {{-100, -100}, {100, 100}})),
    experiment(
      StopTime=604800,
      Interval=60,
      __Dymola_Algorithm="Dassl"),
    Documentation(info="<html>
<p>Model that demonstrates the use of the <a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct\">
Buildings.Fluid.Humidifiers.EvaporativeCoolers.Direct</a> evaporative cooler model. </p>
</html>"));
end Direct;
