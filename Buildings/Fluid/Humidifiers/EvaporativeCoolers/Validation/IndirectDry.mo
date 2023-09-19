within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model IndirectDry
  "Validation model for indirect dry evaporative cooler"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air;
  parameter Real mflownom1(final unit = "1") = 2;
  parameter Real mflownom2(final unit = "1") = 2;
  Buildings.Fluid.Sources.Boundary_pT bou(redeclare package Medium =
        Buildings.Media.Air, nPorts=2)                                                                annotation (
    Placement(visible = true, transformation(origin = {124, -10}, extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sources.MassFlowSource_T boundary(redeclare package Medium =
        Buildings.Media.Air,                                                                        nPorts = 1, use_T_in = true, use_Xi_in = true, use_m_flow_in = true) annotation (
    Placement(visible = true, transformation(origin={-80,10},      extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(columns = 2:11, fileName = ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/Data/Fluid/Humidifiers/EvaporativeCoolers/Direct/IndirectDry.dat"), tableName = "EnergyPlus", tableOnFile = true, timeScale = 1) annotation (
    Placement(visible = true, transformation(origin={-178,90},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        Buildings.Media.Air,                                                                        m_flow_nominal = mflownom1) annotation (
    Placement(visible = true, transformation(origin={10,20},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort temperatureTwoPort(redeclare
      package Medium =
        Buildings.Media.Air,                                                                                    m_flow_nominal = mflownom2) annotation (
    Placement(visible = true, transformation(origin={10,-30},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degCPriIn
    "Primary air inlet temperature to Kelvin" annotation (Placement(visible=
          true, transformation(
        origin={-130,50},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(redeclare package
      Medium =
        Buildings.Media.Air,                                                                            m_flow_nominal = mflownom1) annotation (
    Placement(visible = true, transformation(origin={60,20},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.MassFractionTwoPort massFractionTwoPort(redeclare
      package Medium =
        Buildings.Media.Air,                                                                                      m_flow_nominal = mflownom2) annotation (
    Placement(visible = true, transformation(origin={62,-30},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean direct_db(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin={50,-70},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean direct_massFrac(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin={110,-70},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean indirect_db_mean(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin={40,60},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean indirect_massFrac_mean(f = 1/3600) annotation (
    Placement(visible = true, transformation(origin={90,60},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Buildings.Fluid.Sources.MassFlowSource_T boundary1(redeclare package Medium =
        Buildings.Media.Air,                                                                       use_T_in = true, use_Xi_in = true, use_m_flow_in = true, nPorts = 1)  annotation (
    Placement(visible = true, transformation(origin={-80,-30},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));
Modelica.Blocks.Math.UnitConversions.From_degC from_degCSecIn
    "Secondary air inlet temperature to Kelvin" annotation (Placement(visible=
          true, transformation(
        origin={-130,-40},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  .Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDry indirect_Dry_Phy(
    redeclare package Medium = MediumA,
      redeclare package Medium1 = Buildings.Media.Air, redeclare package
      Medium2 = Buildings.Media.Air) annotation (Placement(visible=true,
        transformation(
        origin={-30,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirPriIn
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAir1
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
equation
  connect(boundary.m_flow_in, combiTimeTable.y[9]) annotation (
    Line(points={{-92,18},{-110,18},{-110,90},{-167,90}},        color = {0, 0, 127}));
  connect(combiTimeTable.y[5], from_degCPriIn.u) annotation (Line(points={{-167,
          90},{-150,90},{-150,50},{-142,50}}, color={0,0,127}));
  connect(from_degCPriIn.y, boundary.T_in) annotation (Line(points={{-119,50},{
          -114,50},{-114,14},{-92,14}}, color={0,0,127}));
  connect(temperatureTwoPort.T, direct_db.u) annotation (
    Line(points={{10,-19},{10,-10},{30,-10},{30,-70},{38,-70}},     color = {0, 0, 127}));
  connect(massFractionTwoPort.X, direct_massFrac.u) annotation (
    Line(points={{62,-19},{62,-10},{80,-10},{80,-70},{98,-70}},
                                          color = {0, 0, 127}));
  connect(senTem.T, indirect_db_mean.u) annotation (
    Line(points={{10,31},{10,60},{28,60}},                      color = {0, 0, 127}));
  connect(senMasFra.X, indirect_massFrac_mean.u) annotation (
    Line(points={{60,31},{60,60},{78,60}},        color = {0, 0, 127}));
connect(combiTimeTable.y[9], boundary1.m_flow_in) annotation (
    Line(points={{-167,90},{-110,90},{-110,-22},{-92,-22}},          color = {0, 0, 127}));
  connect(combiTimeTable.y[1], from_degCSecIn.u) annotation (Line(points={{-167,
          90},{-150,90},{-150,-40},{-142,-40}}, color={0,0,127}));
  connect(from_degCSecIn.y, boundary1.T_in) annotation (Line(points={{-119,-40},
          {-110,-40},{-110,-26},{-92,-26}}, color={0,0,127}));
connect(indirect_Dry_Phy.port_b1, senTem.port_a) annotation (
    Line(points={{-20,6},{-10,6},{-10,20},{0,20}},                color = {0, 127, 255}));
connect(indirect_Dry_Phy.port_b2, temperatureTwoPort.port_a) annotation (
    Line(points={{-20,-6},{-10,-6},{-10,-30},{0,-30}},
                                            color = {0, 127, 255}));
connect(indirect_Dry_Phy.port_a1, boundary.ports[1]) annotation (
    Line(points={{-40,6},{-60,6},{-60,10},{-70,10}},      color = {0, 127, 255}));
connect(indirect_Dry_Phy.port_a2, boundary1.ports[1]) annotation (
    Line(points={{-40,-6},{-60,-6},{-60,-30},{-70,-30}},               color = {0, 127, 255}));
  connect(combiTimeTable.y[6], toTotAirPriIn.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,10},{-141,10}}, color={0,0,127}));
  connect(toTotAirPriIn.XiTotalAir, boundary.Xi_in[1]) annotation (Line(points=
          {{-119,10},{-100,10},{-100,6},{-92,6}}, color={0,0,127}));
  connect(toTotAir1.XiTotalAir, boundary1.Xi_in[1]) annotation (Line(points={{-119,
          -70},{-100,-70},{-100,-34},{-92,-34}}, color={0,0,127}));
  connect(combiTimeTable.y[10], toTotAir1.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,-70},{-141,-70}}, color={0,0,127}));
  connect(senTem.port_b, senMasFra.port_a)
    annotation (Line(points={{20,20},{50,20}}, color={0,127,255}));
  connect(senMasFra.port_b, bou.ports[1]) annotation (Line(points={{70,20},{148,
          20},{148,-8},{134,-8}}, color={0,127,255}));
  connect(temperatureTwoPort.port_b, massFractionTwoPort.port_a)
    annotation (Line(points={{20,-30},{52,-30}}, color={0,127,255}));
  connect(massFractionTwoPort.port_b, bou.ports[2]) annotation (Line(points={{72,
          -30},{148,-30},{148,-12},{134,-12}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-180},{180,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})));
end IndirectDry;
