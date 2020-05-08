within Buildings.Experimental.DistrictHeatingCooling.Validation;
model SteamIdealSystem
  "Testing model for evaluting steam medium in a small district"
  extends Modelica.Icons.Example;

  package MediumSte = IBPSA.Media.Steam "Steam medium";
  package MediumWat = IBPSA.Media.Water(T_max=180+273.15) "Water medium";

//  parameter Modelica.SIunits.HeatFlowRate Q_flow_nominal = 0.5E6
//    "Nominal heat flow rate, positive for heating, negative for cooling";

  final parameter Modelica.SIunits.MassFlowRate m_flow_nominal = 20
    "Nominal mass flow rate";

  parameter Real R_nominal(unit="Pa/m") = 100
    "Pressure drop per meter at nominal flow rate";

  parameter Modelica.SIunits.AbsolutePressure pSte_nominal = 1000000
    "Nominal steam pressure for district supply";

  final parameter Modelica.SIunits.Temperature TSte_nominal=
    MediumSte.saturationTemperature(pSte_nominal)
      "Nominal steam temperature (saturated)";

  final parameter Modelica.SIunits.SpecificEnthalpy dh_nominal=
    MediumSte.enthalpyOfVaporization_sat(
      MediumSte.saturationState_p(pSte_nominal))
      "Nominal change in enthalpy";

  Fluid.FixedResistances.Junction           spl(
    redeclare package Medium = MediumSte,
    T_start=TSte_nominal,
    tau=1,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    from_dp=false)
    annotation (Placement(transformation(extent={{-10,20},{10,40}})));
  SubStations.HeatingSteam hea1(Q_flow_nominal=200E3, dh_nominal=dh_nominal)
                                "Heating system 1"
    annotation (Placement(transformation(extent={{40,-40},{60,-20}})));
  Fluid.FixedResistances.Pipe pipRet(
    redeclare package Medium = MediumWat,
    T_start=TSte_nominal,
    m_flow_nominal=m_flow_nominal,
    nSeg=3,
    thicknessIns=0.2,
    lambdaIns=0.04,
    length=50) "Return pipe"
    annotation (Placement(transformation(extent={{-30,-80},{-50,-60}})));
  SubStations.HeatingSteam hea2(Q_flow_nominal=100E3, dh_nominal=dh_nominal)
                                "Heating system 1"
    annotation (Placement(transformation(extent={{140,-40},{160,-20}})));
  Fluid.FixedResistances.Junction           spl1(
    redeclare package Medium = MediumWat,
    T_start=TSte_nominal,
    tau=1,
    m_flow_nominal=m_flow_nominal*{1,1,1},
    dp_nominal=40*R_nominal*{0,1,1},
    from_dp=false)
    annotation (Placement(transformation(extent={{100,-60},{80,-80}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea1(
    table=[0,200E3; 6,200E3; 6,50E3; 18,50E3; 18,75E3; 24,75E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{10,0},{30,20}})));
  Modelica.Blocks.Sources.CombiTimeTable
                                    QHea2(
    table=[0,100E3; 6,100E3; 6,50E3; 18,50E3; 18,75E3; 24,75E3],
    timeScale=3600,
    extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic)
    "Heating demand"
    annotation (Placement(transformation(extent={{110,0},{130,20}})));
  Fluid.Boilers.SteamBoilerIdeal boi(m_flow_nominal=m_flow_nominal)
    "Steam boiler"
    annotation (Placement(transformation(extent={{-100,20},{-80,40}})));
  Modelica.Blocks.Sources.Constant p_steam(k=pSte_nominal)
    "Prescribed steam pressure"
    annotation (Placement(transformation(extent={{-180,60},{-160,80}})));
  Fluid.Sources.Boundary_pT pSet(
    redeclare package Medium = MediumWat,
    use_p_in=true,
    nPorts=1) "Reference pressure"
    annotation (Placement(transformation(extent={{-50,52},{-30,72}})));
  Fluid.Sensors.TemperatureTwoPort senT_boiOut(redeclare package Medium =
        MediumSte, m_flow_nominal=m_flow_nominal,
    T_start=TSte_nominal)
    annotation (Placement(transformation(extent={{-70,20},{-50,40}})));
  Fluid.Sensors.TemperatureTwoPort senT_hea1In(redeclare package Medium =
        MediumSte, m_flow_nominal=m_flow_nominal,
    T_start=TSte_nominal)
    annotation (Placement(transformation(extent={{10,-40},{30,-20}})));
  Fluid.Sensors.TemperatureTwoPort senT_hea1Out(redeclare package Medium =
        MediumWat, m_flow_nominal=m_flow_nominal,
    T_start=TSte_nominal)
    annotation (Placement(transformation(extent={{66,-40},{86,-20}})));
  Fluid.Sensors.TemperatureTwoPort senT_boiIn(redeclare package Medium =
        MediumWat, m_flow_nominal=m_flow_nominal,
    T_start=TSte_nominal)
    annotation (Placement(transformation(extent={{-128,20},{-108,40}})));
equation
  connect(spl.port_2, hea2.port_a) annotation (Line(points={{10,30},{102,30},{
          102,-30},{140,-30}},
                           color={0,127,255}));
  connect(hea2.port_b, spl1.port_1) annotation (Line(points={{160,-30},{170,-30},
          {170,-70},{100,-70}},color={0,127,255}));
  connect(hea2.Q_flow, QHea2.y[1]) annotation (Line(points={{138,-24},{134,-24},
          {134,10},{131,10}},
                         color={0,0,127}));
  connect(hea1.Q_flow, QHea1.y[1]) annotation (Line(points={{38,-24},{34,-24},{
          34,10},{31,10}},
                        color={0,0,127}));
  connect(p_steam.y, boi.pSte) annotation (Line(points={{-159,70},{-110,70},{
          -110,36},{-101,36}},
                          color={0,0,127}));
  connect(spl1.port_2, pipRet.port_a)
    annotation (Line(points={{80,-70},{-30,-70}}, color={0,127,255}));
  connect(boi.port_b, senT_boiOut.port_a)
    annotation (Line(points={{-80,30},{-70,30}}, color={0,127,255}));
  connect(spl.port_3, senT_hea1In.port_a)
    annotation (Line(points={{0,20},{0,-30},{10,-30}}, color={0,127,255}));
  connect(senT_hea1In.port_b, hea1.port_a)
    annotation (Line(points={{30,-30},{40,-30}}, color={0,127,255}));
  connect(hea1.port_b, senT_hea1Out.port_a)
    annotation (Line(points={{60,-30},{66,-30}}, color={0,127,255}));
  connect(senT_hea1Out.port_b, spl1.port_3) annotation (Line(points={{86,-30},{
          90,-30},{90,-60},{90,-60}}, color={0,127,255}));
  connect(pipRet.port_b, senT_boiIn.port_a) annotation (Line(points={{-50,-70},{
          -136,-70},{-136,30},{-128,30}}, color={0,127,255}));
  connect(senT_boiIn.port_b, boi.port_a)
    annotation (Line(points={{-108,30},{-100,30}}, color={0,127,255}));
  connect(senT_boiOut.port_b, spl.port_1)
    annotation (Line(points={{-50,30},{-10,30}}, color={0,127,255}));
  connect(pSet.ports[1], spl.port_1) annotation (Line(points={{-30,62},{-22,62},
          {-22,30},{-10,30}}, color={0,127,255}));
  connect(p_steam.y, pSet.p_in)
    annotation (Line(points={{-159,70},{-52,70}}, color={0,0,127}));
  annotation (experiment(Tolerance=1E-06, StopTime=86400),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/DistrictHeatingCooling/Validation/SteamIdealSystem.mos"
        "Simulate and plot"),
  Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}})),
                                                                 Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-200,-100},{200,
            100}})));
end SteamIdealSystem;
