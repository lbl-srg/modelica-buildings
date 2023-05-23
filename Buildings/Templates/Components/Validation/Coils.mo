within Buildings.Templates.Components.Validation;
model Coils "Validation model for coil components"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";

  parameter Data.Coil datCoo(
    typ=Buildings.Templates.Components.Types.Coil.WaterBasedCooling,
    typVal=coiCoo.typVal,
    mAir_flow_nominal=1,
    dpAir_nominal=200,
    mWat_flow_nominal=1,
    dpWat_nominal=2E4,
    dpValve_nominal=datCoo.dpWat_nominal,
    cap_nominal=-5E4,
    TWatEnt_nominal=280.15,
    TAirEnt_nominal=308.15,
    wAirEnt_nominal=0.017) "Cooling coil parameters"
    annotation (Placement(transformation(extent={{110,170},{130,190}})));
  parameter Data.Coil datHea(
    typ=Buildings.Templates.Components.Types.Coil.WaterBasedHeating,
    typVal=coiHea.typVal,
    mAir_flow_nominal=1,
    dpAir_nominal=200,
    mWat_flow_nominal=1,
    dpWat_nominal=2E4,
    dpValve_nominal=datCoo.dpWat_nominal,
    cap_nominal=5E4,
    TWatEnt_nominal=323.15,
    TAirEnt_nominal=263.15) "Heating coil parameters"
    annotation (Placement(transformation(extent={{80,170},{100,190}})));
  parameter Data.Coil datEle(
    typ=Buildings.Templates.Components.Types.Coil.ElectricHeating,
    typVal=coiEle.typVal,
    mAir_flow_nominal=1,
    dpAir_nominal=200,
    cap_nominal=5E4,
    TAirEnt_nominal=263.15) "Electric heating coil parameters"
    annotation (Placement(transformation(extent={{50,170},{70,190}})));
  parameter Data.Coil datEva(
    typ=Buildings.Templates.Components.Types.Coil.EvaporatorVariableSpeed,
    typVal=coiEva.typVal,
    dpAir_nominal=200) "Variable speed DX coil parameters"
    annotation (Placement(transformation(extent={{20,170},{40,190}})));
  parameter Data.Coil datMul(
    redeclare
    Buildings.Fluid.HeatExchangers.DXCoils.AirSource.Data.DoubleSpeed.Lennox_SCA240H4B
    datCoi,
    typ=Buildings.Templates.Components.Types.Coil.EvaporatorMultiStage,
    typVal=coiMul.typVal,
    dpAir_nominal=200) "Multistage DX coil parameters"
    annotation (Placement(transformation(extent={{-10,170},{10,190}})));

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bouAirEntCoo(
    redeclare final package Medium = MediumAir,
    X={datCoo.wAirEnt_nominal/(1 + datCoo.wAirEnt_nominal),1 - datCoo.wAirEnt_nominal
        /(1 + datCoo.wAirEnt_nominal)},
    p=bouAirLvg.p + datCoo.dpAir_nominal,
    T=datCoo.TAirEnt_nominal,
    nPorts=1) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Fluid.Sources.Boundary_pT bouChiWatEnt(
    redeclare final package Medium = MediumLiq,
    p=bouLiqLvg.p + datCoo.dpWat_nominal + datCoo.dpValve_nominal,
    T=datCoo.TWatEnt_nominal,
    nPorts=1) "Boundary conditions for entering CHW"
    annotation (Placement(transformation(extent={{100,70},{80,90}})));
  Fluid.Sources.Boundary_pT bouLiqLvg(
    redeclare final package Medium =MediumLiq, nPorts=2)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Fluid.Sources.Boundary_pT bouAirLvg(
    redeclare final package Medium =MediumAir, nPorts=5) "Boundary conditions for leaving air"
    annotation (Placement(transformation(extent={{100,110},{80,130}})));

  Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
    redeclare final package MediumAir=MediumAir,
    redeclare final package MediumChiWat=MediumLiq,
    final dat=datCoo,
    final energyDynamics=energyDynamics,
    redeclare replaceable
      Buildings.Templates.Components.Valves.TwoWayModulating val
      "Two-way modulating valve") "Water-based cooling coil"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Interfaces.Bus bus annotation (Placement(transformation(extent={{-20,120},{20,
            160}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Continuous.Sources.Ramp y(height=1,
    duration=10) "Coil/valve control signal"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
    redeclare final package MediumAir = MediumAir,
    final dat=datHea,
    final energyDynamics=energyDynamics,
    redeclare replaceable Valves.TwoWayModulating val
      "Two-way modulating valve") "Water-based heating"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Interfaces.Bus bus1 "Control bus"
    annotation (Placement(transformation(extent={{-20,40},{20,80}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Fluid.Sources.Boundary_pT bouAirEntHea(
    redeclare final package Medium = MediumAir,
    p=bouAirLvg.p + datHea.dpAir_nominal,
    T=datHea.TAirEnt_nominal,
    nPorts=2) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT bouHeaWatEnt(
    redeclare final package Medium = MediumLiq,
    p=bouLiqLvg.p + datHea.dpWat_nominal + datHea.dpValve_nominal,
    T=datHea.TWatEnt_nominal,
    nPorts=1) "Boundary conditions for entering HW"
    annotation (Placement(transformation(extent={{100,10},{80,30}})));
  Buildings.Templates.Components.Coils.ElectricHeating coiEle(
    redeclare final package MediumAir = MediumAir,
    final dat=datEle,
    final energyDynamics=energyDynamics) "Electric heating"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Interfaces.Bus bus2 "Control bus"
    annotation (Placement(transformation(extent={{-20,-40},{20,0}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));


  Buildings.Templates.Components.Coils.EvaporatorVariableSpeed coiEva(
    redeclare final package MediumAir = MediumAir,
    final dat=datEva,
    final energyDynamics=energyDynamics) "Variable speed evaporator coil"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  BoundaryConditions.WeatherData.Bus
      weaBus "Weather data bus" annotation (Placement(transformation(extent={{-50,
            -110},{-10,-70}}),   iconTransformation(extent={{190,-10},{210,10}})));
  Interfaces.Bus bus3 "Control bus"
    annotation (Placement(transformation(extent={{-20,-100},{20,-60}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TOut(k=datEva.datCoi.sta[1].nomVal.TConIn_nominal)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  Controls.OBC.CDL.Continuous.Sources.Constant XOut(k=0.015)
    "Water mass fraction in outdoor air"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare final package Medium = MediumAir)
    "Compute wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  Controls.OBC.CDL.Continuous.Sources.Constant pOut(k=101325)
    "Outdoor pressure"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Fluid.Sources.Boundary_pT bouAirEntCoo1(
    redeclare final package Medium = MediumAir,
    use_Xi_in=true,
    p=bouAirLvg.p + datEva.dpAir_nominal,
    T=datEva.datCoi.sta[1].nomVal.TEvaIn_nominal,
    nPorts=2) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    "Compute wet bulb temperature"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TAirEnt(k=datEva.datCoi.sta[1].nomVal.TEvaIn_nominal)
    "Enetring air temperature"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant phiAirEnt(k=datEva.datCoi.sta[1].nomVal.phiIn_nominal)
    "Enetring air relative humidity"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Templates.Components.Coils.EvaporatorMultiStage    coiMul(
    redeclare final package MediumAir = MediumAir,
    final dat=datMul,
    final energyDynamics=energyDynamics) "Multiple stage evaporator coil"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  Controls.OBC.CDL.Integers.Sources.TimeTable
                                           y1(
    table=[0,0; 1,1; 2,2],
    timeScale=50,
    period=200)  "Coil/valve control signal"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Interfaces.Bus bus4 "Control bus"
    annotation (Placement(transformation(extent={{-20,-160},{20,-120}}),
        iconTransformation(extent={{-250,-32},{-210,8}})));
equation
  connect(bouAirEntCoo.ports[1], coiCoo.port_a) annotation (Line(points={{-70,120},
          {10,120}},                      color={0,127,255}));
  connect(coiCoo.port_b, bouAirLvg.ports[1]) annotation (Line(points={{30,120},{
          60,120},{60,118.4},{80,118.4}},
                                color={0,127,255}));
  connect(bouChiWatEnt.ports[1], coiCoo.port_aSou)
    annotation (Line(points={{80,80},{25,80},{25,110}},
                                                   color={0,127,255}));
  connect(bouLiqLvg.ports[1], coiCoo.port_bSou)
    annotation (Line(points={{-70,79},{15,79},{15,110}},
                                                      color={0,127,255}));
  connect(y.y, bus.y) annotation (Line(points={{-68,160},{0,160},{0,140}},
        color={0,0,127}));
  connect(bus, coiCoo.bus) annotation (Line(
      points={{0,140},{20,140},{20,130}},
      color={255,204,51},
      thickness=0.5));
  connect(coiHea.bus, bus1) annotation (Line(
      points={{20,50},{20,60},{0,60}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus1.y)
    annotation (Line(points={{-68,160},{0,160},{0,60}},    color={0,0,127}));
  connect(bouAirEntHea.ports[1], coiHea.port_a) annotation (Line(points={{-70,39},
          {-16,39},{-16,40},{10,40}},  color={0,127,255}));
  connect(coiHea.port_b, bouAirLvg.ports[2]) annotation (Line(points={{30,40},{60,
          40},{60,119.2},{80,119.2}},
                                    color={0,127,255}));
  connect(bouHeaWatEnt.ports[1], coiHea.port_aSou)
    annotation (Line(points={{80,20},{25,20},{25,30}},  color={0,127,255}));
  connect(coiHea.port_bSou, bouLiqLvg.ports[2]) annotation (Line(points={{15,30},
          {15,20},{-20,20},{-20,81},{-70,81}}, color={0,127,255}));
  connect(bouAirEntHea.ports[2], coiEle.port_a) annotation (Line(points={{-70,41},
          {-40,41},{-40,-40},{10,-40}},  color={0,127,255}));
  connect(coiEle.bus, bus2) annotation (Line(
      points={{20,-30},{20,-20},{0,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(coiEle.port_b, bouAirLvg.ports[3]) annotation (Line(points={{30,-40},{
          64,-40},{64,120},{80,120}},           color={0,127,255}));
  connect(y.y, bus2.y)
    annotation (Line(points={{-68,160},{0,160},{0,-20}},    color={0,0,127}));
  connect(coiEva.port_b, bouAirLvg.ports[4]) annotation (Line(points={{30,-100},
          {68,-100},{68,118},{80,118},{80,120.8}}, color={0,127,255}));
  connect(bus3, coiEva.bus) annotation (Line(
      points={{0,-80},{20,-80},{20,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, coiEva.busWea) annotation (Line(
      points={{-30,-90},{16,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus3.y) annotation (Line(points={{-68,160},{-48,160},{-48,134},{0,
          134},{0,-80}},   color={0,0,127}));
  connect(TOut.y, weaBus.TDryBul) annotation (Line(points={{-108,-100},{-70,-100},
          {-70,-90},{-30,-90}}, color={0,0,127}));
  connect(TOut.y, wetBul.TDryBul) annotation (Line(points={{-108,-100},{-70,-100},
          {-70,-112},{-61,-112}},  color={0,0,127}));
  connect(pOut.y, wetBul.p) annotation (Line(points={{-108,-180},{-100,-180},{-100,
          -128},{-61,-128}}, color={0,0,127}));
  connect(wetBul.TWetBul, weaBus.TWetBul) annotation (Line(points={{-39,-120},{-32,
          -120},{-32,-90},{-30,-90}},
                            color={0,0,127}));
  connect(XOut.y, wetBul.Xi[1]) annotation (Line(points={{-108,-140},{-84,-140},
          {-84,-120},{-61,-120}}, color={0,0,127}));
  connect(bouAirEntCoo1.ports[1], coiEva.port_a) annotation (Line(points={{-70,-61},
          {-14,-61},{-14,-100},{10,-100}},
                                 color={0,127,255}));
  connect(phiAirEnt.y, x_pTphi.phi) annotation (Line(points={{-108,-20},{-100,-20},
          {-100,-6},{-90,-6}}, color={0,0,127}));
  connect(TAirEnt.y, x_pTphi.T) annotation (Line(points={{-108,20},{-100,20},{-100,
          0},{-90,0}}, color={0,0,127}));
  connect(x_pTphi.X[1], bouAirEntCoo1.Xi_in[1]) annotation (Line(points={{-67,0},
          {-60,0},{-60,-20},{-96,-20},{-96,-64},{-92,-64}}, color={0,0,127}));
  connect(coiMul.port_b, bouAirLvg.ports[5]) annotation (Line(points={{30,-160},
          {72,-160},{72,121.6},{80,121.6}}, color={0,127,255}));
  connect(bouAirEntCoo1.ports[2], coiMul.port_a) annotation (Line(points={{-70,-59},
          {-70,-60},{-14,-60},{-14,-160},{10,-160}}, color={0,127,255}));
  connect(weaBus, coiMul.busWea) annotation (Line(
      points={{-30,-90},{-30,-150},{16,-150}},
      color={255,204,51},
      thickness=0.5));
  connect(y1.y[1], bus4.y) annotation (Line(points={{-58,-180},{0,-180},{0,-140}},
        color={255,127,0}));
        connect(coiMul.bus, bus4) annotation (Line(points={{20,-150},{20,-140},{
          0,-140}},
        color={255,127,0}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Coils.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=200),
  Diagram(coordinateSystem(extent={{-140,-200},{140,200}})));
end Coils;
