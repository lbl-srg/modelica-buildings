within Buildings.Fluid.Humidifiers.EvaporativeCoolers.Validation;
model IndirectDry
  "Validation model for indirect dry evaporative cooler"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air;

  parameter Real mAirPri_flow_nominal=0.002 "Primary air nominal mass flow rate";

  Buildings.Fluid.Sources.Boundary_pT sin(redeclare package Medium = MediumA,
                                                    nPorts=1)
    "Sink for primary and secondary flow"
    annotation (Placement(visible=true, transformation(
      origin={130,0},
      extent={{-10,-10},{10,10}},
      rotation=180)));

  Buildings.Fluid.Sources.MassFlowSource_T souPri(
    redeclare package Medium = MediumA,
    nPorts=1,
    use_T_in=true,
    use_Xi_in=true,
    use_m_flow_in=true) "Primary air source" annotation (Placement(visible=true,
        transformation(
        origin={-80,10},
        extent={{-10,-10},{10,10}},
        rotation=0)));

  Modelica.Blocks.Sources.CombiTimeTable combiTimeTable(
    columns=2:12,                                                       fileName = ModelicaServices.ExternalReferences.loadResource("./Buildings/Resources/Data/Fluid/Humidifiers/EvaporativeCoolers/IndirectDry/IndirectDry.dat"), tableName = "EnergyPlus", tableOnFile = true, timeScale = 1)
    "Table input from EnergyPlus"                                                                                                                                                                                                         annotation (
    Placement(visible = true, transformation(origin={-178,90},   extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTem(redeclare package Medium =
        MediumA, m_flow_nominal=mAirPri_flow_nominal)
    "Outlet air drybulb temperature sensor"                                                                                     annotation (
    Placement(visible = true, transformation(origin={10,20},     extent = {{-10, -10}, {10, 10}}, rotation = 0)));

  Modelica.Blocks.Math.UnitConversions.From_degC from_degCPriIn
    "Primary air inlet temperature to Kelvin" annotation (Placement(visible=true,
        transformation(
        origin={-130,50},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(redeclare package
      Medium = MediumA, m_flow_nominal=mAirPri_flow_nominal)
    "Measured primary outlet air mass fraction"                                                                                     annotation (
    Placement(visible = true, transformation(origin={60,20},    extent = {{-10, -10}, {10, 10}}, rotation = 0)));
  Modelica.Blocks.Math.Mean TOut_mean(f=1/3600)
    "Measured outlet air drybulb temperature mean" annotation (Placement(
        visible=true, transformation(
        origin={70,90},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Math.Mean XOut_mean(f=1/3600)
    "Measured primary outlet air mass fraction mean" annotation (Placement(
        visible=true, transformation(
        origin={90,60},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Sources.MassFlowSource_T souSec(
    redeclare package Medium = MediumA,
    use_T_in=true,
    use_Xi_in=true,
    use_m_flow_in=true,
    nPorts=1) "Secondary air source" annotation (Placement(visible=true,
        transformation(
        origin={-80,-30},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Modelica.Blocks.Math.UnitConversions.From_degC from_degCSecIn
    "Secondary air inlet temperature to Kelvin" annotation (Placement(visible=true,
        transformation(
        origin={-130,-40},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Fluid.Humidifiers.EvaporativeCoolers.IndirectDry indDryEvaCoo(
    redeclare package MediumPri = MediumA,
    redeclare package MediumSec = MediumA,
    eps=0.67,
    dp_nom=200,
    mAirPri_flow_nominal=mAirPri_flow_nominal,
    mAirSec_flow_nominal=0.002,
    padAre=0.6,
    dep=0.2) "Indirect dry evaporative cooler" annotation (Placement(visible=
          true, transformation(
        origin={-30,0},
        extent={{-10,-10},{10,10}},
        rotation=0)));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirPriIn
    "Primary inlet air mass fraction"
    annotation (Placement(transformation(extent={{-140,0},{-120,20}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirSecIn
    "Secondary inlet air mass fraction"
    annotation (Placement(transformation(extent={{-140,-80},{-120,-60}})));
  Buildings.Utilities.Psychrometrics.ToTotalAir toTotAirPriOut
    "Primary outlet air mass fraction"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));
  Modelica.Blocks.Math.UnitConversions.To_degC to_degC
    "Measured outlet air temperature to degree C"
    annotation (Placement(transformation(extent={{20,80},{40,100}})));
  Controls.OBC.CDL.Reals.Sources.Constant con(k=2)
    annotation (Placement(transformation(extent={{-140,-120},{-120,-100}})));
  Sources.Boundary_pT                 sin1(redeclare package Medium = MediumA,
      nPorts=1)
    "Sink for primary and secondary flow"
    annotation (Placement(visible=true, transformation(
      origin={118,-38},
      extent={{-10,-10},{10,10}},
      rotation=180)));
equation
  connect(combiTimeTable.y[5], from_degCPriIn.u) annotation (Line(points={{-167,
          90},{-150,90},{-150,50},{-142,50}}, color={0,0,127}));
  connect(from_degCPriIn.y, souPri.T_in) annotation (Line(points={{-119,50},{-114,
          50},{-114,14},{-92,14}}, color={0,0,127}));
  connect(senMasFra.X, XOut_mean.u)
    annotation (Line(points={{60,31},{60,60},{78,60}}, color={0,0,127}));
  connect(from_degCSecIn.y, souSec.T_in) annotation (Line(points={{-119,-40},{-110,
          -40},{-110,-26},{-92,-26}}, color={0,0,127}));
  connect(indDryEvaCoo.port_b1, senTem.port_a) annotation (Line(points={{-20,6},
          {-10,6},{-10,20},{0,20}}, color={0,127,255}));
  connect(indDryEvaCoo.port_a1, souPri.ports[1]) annotation (Line(points={{-40,
          6},{-60,6},{-60,10},{-70,10}}, color={0,127,255}));
  connect(indDryEvaCoo.port_a2, souSec.ports[1]) annotation (Line(points={{-40,
          -6},{-60,-6},{-60,-30},{-70,-30}}, color={0,127,255}));
  connect(combiTimeTable.y[6], toTotAirPriIn.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,10},{-141,10}}, color={0,0,127}));
  connect(toTotAirPriIn.XiTotalAir, souPri.Xi_in[1]) annotation (Line(points={{-119,
          10},{-100,10},{-100,6},{-92,6}}, color={0,0,127}));
  connect(toTotAirSecIn.XiTotalAir, souSec.Xi_in[1]) annotation (Line(points={{-119,
          -70},{-104,-70},{-104,-34},{-92,-34}}, color={0,0,127}));
  connect(senTem.port_b, senMasFra.port_a)
    annotation (Line(points={{20,20},{50,20}}, color={0,127,255}));
  connect(combiTimeTable.y[8], toTotAirPriOut.XiDry)
    annotation (Line(points={{-167,90},{-81,90}}, color={0,0,127}));
  connect(combiTimeTable.y[9], souPri.m_flow_in) annotation (Line(points={{-167,
          90},{-100,90},{-100,18},{-92,18}}, color={0,0,127}));
  connect(senMasFra.port_b, sin.ports[1]) annotation (Line(points={{70,20},{106,
          20},{106,6.66134e-16},{120,6.66134e-16}},
                                  color={0,127,255}));
  connect(to_degC.y, TOut_mean.u) annotation (Line(points={{41,90},{50,90},{50,
          90},{58,90}}, color={0,0,127}));
  connect(to_degC.u, senTem.T)
    annotation (Line(points={{18,90},{10,90},{10,31}}, color={0,0,127}));
  connect(con.y, souSec.m_flow_in) annotation (Line(points={{-118,-110},{-106,
          -110},{-106,-22},{-92,-22}}, color={0,0,127}));
  connect(combiTimeTable.y[1], from_degCSecIn.u) annotation (Line(points={{-167,
          90},{-150,90},{-150,-40},{-142,-40}}, color={0,0,127}));
  connect(combiTimeTable.y[11], toTotAirSecIn.XiDry) annotation (Line(points={{-167,
          90},{-160,90},{-160,-70},{-141,-70}}, color={0,0,127}));
  connect(indDryEvaCoo.port_b2, sin1.ports[1]) annotation (Line(points={{-20,-6},
          {46,-6},{46,-38},{108,-38}}, color={0,127,255}));
  annotation (
    Diagram(coordinateSystem(extent={{-200,-180},{180,180}})), Icon(
        coordinateSystem(extent={{-100,-100},{100,100}})),
    experiment(
      StopTime=604800,
      Interval=600,
      __Dymola_Algorithm="Dassl"),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativeCoolers/Validation/IndirectDry.mos"
      "Simulate and plot"));
end IndirectDry;
