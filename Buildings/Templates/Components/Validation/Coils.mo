within Buildings.Templates.Components.Validation;
model Coils "Validation model for coil components"
  extends Modelica.Icons.Example;

  replaceable package MediumAir=Buildings.Media.Air
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "Air medium";
  replaceable package MediumLiq=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW or CHW medium";

  parameter Modelica.Fluid.Types.Dynamics energyDynamics=
    Modelica.Fluid.Types.Dynamics.FixedInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  Fluid.Sources.Boundary_pT bouAirEntCoo(
    redeclare final package Medium = MediumAir,
    X={coiCoo.dat.wAirEnt_nominal/(1 + coiCoo.dat.wAirEnt_nominal),1 - coiCoo.dat.wAirEnt_nominal
        /(1 + coiCoo.dat.wAirEnt_nominal)},
    p=bouAirLvg.p + coiCoo.dat.dpAir_nominal,
    T=coiCoo.dat.TAirEnt_nominal,
    nPorts=2) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,110},{-70,130}})));
  Fluid.Sources.Boundary_pT bouChiWatEnt(
    redeclare final package Medium = MediumLiq,
    p=bouLiqLvg.p + coiCoo.dat.dpWat_nominal + coiCoo.dat.dpValve_nominal,
    T=coiCoo.dat.TWatEnt_nominal,
    nPorts=1) "Boundary conditions for entering CHW"
    annotation (Placement(transformation(extent={{110,70},{90,90}})));
  Fluid.Sources.Boundary_pT bouLiqLvg(
    redeclare final package Medium =MediumLiq, nPorts=2)
    "Boundary conditions for leaving liquid"
    annotation (Placement(transformation(extent={{-90,70},{-70,90}})));
  Fluid.Sources.Boundary_pT bouAirLvg(
    redeclare final package Medium =MediumAir, nPorts=6) "Boundary conditions for leaving air"
    annotation (Placement(transformation(extent={{110,110},{90,130}})));

  Buildings.Templates.Components.Coils.WaterBasedCooling coiCoo(
    redeclare final package MediumAir=MediumAir,
    redeclare final package MediumChiWat=MediumLiq,
    dat(
      mAir_flow_nominal=1,
      dpAir_nominal=200,
      mWat_flow_nominal=1,
      dpWat_nominal=2E4,
      dpValve_nominal=coiCoo.dat.dpWat_nominal,
      cap_nominal=-5E4,
      TWatEnt_nominal=280.15,
      TAirEnt_nominal=308.15,
      wAirEnt_nominal=0.017),
    final energyDynamics=energyDynamics,
    val(y_start=0)) "Water-based cooling coil"
    annotation (Placement(transformation(extent={{10,110},{30,130}})));
  Interfaces.Bus bus "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,120},{20,160}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp y(height=1,
    duration=10) "Coil/valve control signal"
    annotation (Placement(transformation(extent={{-90,150},{-70,170}})));

  Buildings.Templates.Components.Coils.WaterBasedHeating coiHea(
    redeclare final package MediumAir = MediumAir,
    redeclare final package MediumHeaWat=MediumLiq,
    dat(
      mAir_flow_nominal=1,
      dpAir_nominal=200,
      mWat_flow_nominal=1,
      dpWat_nominal=2E4,
      dpValve_nominal=coiCoo.dat.dpWat_nominal,
      cap_nominal=5E4,
      TWatEnt_nominal=323.15,
      TAirEnt_nominal=263.15),
    final energyDynamics=energyDynamics,
    val(y_start=0)) "Water-based heating"
    annotation (Placement(transformation(extent={{10,30},{30,50}})));
  Interfaces.Bus bus1 "Control bus"
    annotation (Placement(
    iconVisible=false,
    transformation(extent={{-20,40},{20,80}}),
    iconTransformation(extent={{-250,-32},{-210,8}})));
  Fluid.Sources.Boundary_pT bouAirEntHea(
    redeclare final package Medium = MediumAir,
    p=bouAirLvg.p + coiHea.dat.dpAir_nominal,
    T=coiHea.dat.TAirEnt_nominal,
    nPorts=2) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,30},{-70,50}})));
  Fluid.Sources.Boundary_pT bouHeaWatEnt(
    redeclare final package Medium = MediumLiq,
    p=bouLiqLvg.p + coiHea.dat.dpWat_nominal + coiHea.dat.dpValve_nominal,
    T=coiHea.dat.TWatEnt_nominal,
    nPorts=1) "Boundary conditions for entering HW"
    annotation (Placement(transformation(extent={{110,10},{90,30}})));

  Buildings.Templates.Components.Coils.ElectricHeating coiEle(
    redeclare final package MediumAir = MediumAir,
    dat(
    mAir_flow_nominal=1,
    dpAir_nominal=200,
    cap_nominal=5E4),
    final energyDynamics=energyDynamics) "Electric heating"
    annotation (Placement(transformation(extent={{10,-50},{30,-30}})));
  Interfaces.Bus bus2 "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-40},{20,0}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Templates.Components.Coils.EvaporatorVariableSpeed coiEva(
    redeclare final package MediumAir = MediumAir,
    dat(dpAir_nominal=200),
    final energyDynamics=energyDynamics) "Variable speed evaporator coil"
    annotation (Placement(transformation(extent={{10,-110},{30,-90}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(
    iconVisible=false,
    transformation(extent={{-50,-110},{-10,-70}}),
    iconTransformation(extent={{190,-10},{210,10}})));
  Interfaces.Bus bus3 "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-100},{20,-60}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant TOut(
    k=coiEva.dat.datCoi.sta[1].nomVal.TConIn_nominal)
    "Outdoor temperature"
    annotation (Placement(transformation(extent={{-130,-110},{-110,-90}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant XOut(k=0.015)
    "Water mass fraction in outdoor air"
    annotation (Placement(transformation(extent={{-130,-150},{-110,-130}})));
  Utilities.Psychrometrics.TWetBul_TDryBulXi wetBul(
    redeclare final package Medium = MediumAir)
    "Compute wet bulb temperature"
    annotation (Placement(transformation(extent={{-60,-130},{-40,-110}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant pOut(k=101325)
    "Outdoor pressure"
    annotation (Placement(transformation(extent={{-130,-190},{-110,-170}})));
  Fluid.Sources.Boundary_pT bouAirEntCoo1(
    redeclare final package Medium = MediumAir,
    use_Xi_in=true,
    p=bouAirLvg.p + coiEva.dat.dpAir_nominal,
    T=coiEva.dat.datCoi.sta[1].nomVal.TEvaIn_nominal,
    nPorts=2) "Boundary conditions for entering air"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
  Utilities.Psychrometrics.X_pTphi x_pTphi(use_p_in=false)
    "Compute wet bulb temperature"
    annotation (Placement(transformation(extent={{-88,-10},{-68,10}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant TAirEnt(k=coiEva.dat.datCoi.sta[
        1].nomVal.TEvaIn_nominal) "Entering air temperature"
    annotation (Placement(transformation(extent={{-130,10},{-110,30}})));
  .Buildings.Controls.OBC.CDL.Reals.Sources.Constant phiAirEnt(k=coiEva.dat.datCoi.sta[
        1].nomVal.phiIn_nominal) "Enetring air relative humidity"
    annotation (Placement(transformation(extent={{-130,-30},{-110,-10}})));
  Buildings.Templates.Components.Coils.EvaporatorMultiStage coiMul(
    redeclare final package MediumAir = MediumAir,
    dat(
      redeclare
      Buildings.Fluid.DXSystems.Cooling.AirSource.Data.DoubleSpeed.Lennox_SCA240H4B
      datCoi,
      dpAir_nominal=200),
    final energyDynamics=energyDynamics) "Multiple stage evaporator coil"
    annotation (Placement(transformation(extent={{10,-170},{30,-150}})));
  .Buildings.Controls.OBC.CDL.Integers.Sources.TimeTable y1(
    table=[0,0; 1,1; 2,2],
    timeScale=50,
    period=200) "Coil/valve control signal"
    annotation (Placement(transformation(extent={{-80,-190},{-60,-170}})));
  Interfaces.Bus bus4 "Control bus"
    annotation (Placement(
      iconVisible=false,
      transformation(extent={{-20,-160},{20,-120}}),
      iconTransformation(extent={{-250,-32},{-210,8}})));
  Fluid.FixedResistances.PressureDrop res(
    redeclare final package Medium = MediumAir,
    final m_flow_nominal=coiCoo.dat.mAir_flow_nominal,
    final dp_nominal=coiCoo.dat.dpAir_nominal) "Flow resistance"
    annotation (Placement(transformation(extent={{-30,170},{-10,190}})));
  Buildings.Templates.Components.Coils.None non(
    redeclare final package MediumAir =MediumAir) "No coilamper"
    annotation (Placement(transformation(extent={{10,170},{30,190}})));
equation
  connect(bouAirEntCoo.ports[1], coiCoo.port_a) annotation (Line(points={{-70,119},
          {-30,119},{-30,120},{10,120}},  color={0,127,255}));
  connect(coiCoo.port_b, bouAirLvg.ports[1]) annotation (Line(points={{30,120},
          {60,120},{60,118.333},{90,118.333}},
                                color={0,127,255}));
  connect(bouChiWatEnt.ports[1], coiCoo.port_aSou)
    annotation (Line(points={{90,80},{25,80},{25,110}},
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
          40},{60,119},{90,119}},   color={0,127,255}));
  connect(bouHeaWatEnt.ports[1], coiHea.port_aSou)
    annotation (Line(points={{90,20},{25,20},{25,30}},  color={0,127,255}));
  connect(coiHea.port_bSou, bouLiqLvg.ports[2]) annotation (Line(points={{15,30},
          {15,20},{-20,20},{-20,81},{-70,81}}, color={0,127,255}));
  connect(bouAirEntHea.ports[2], coiEle.port_a) annotation (Line(points={{-70,41},
          {-40,41},{-40,-40},{10,-40}},  color={0,127,255}));
  connect(coiEle.bus, bus2) annotation (Line(
      points={{20,-30},{20,-20},{0,-20}},
      color={255,204,51},
      thickness=0.5));
  connect(coiEle.port_b, bouAirLvg.ports[3]) annotation (Line(points={{30,-40},
          {64,-40},{64,119.667},{90,119.667}},  color={0,127,255}));
  connect(y.y, bus2.y)
    annotation (Line(points={{-68,160},{0,160},{0,-20}},    color={0,0,127}));
  connect(coiEva.port_b, bouAirLvg.ports[4]) annotation (Line(points={{30,-100},
          {68,-100},{68,118},{90,118},{90,120.333}},
                                                   color={0,127,255}));
  connect(bus3, coiEva.bus) annotation (Line(
      points={{0,-80},{20,-80},{20,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(weaBus, coiEva.busWea) annotation (Line(
      points={{-30,-90},{16,-90}},
      color={255,204,51},
      thickness=0.5));
  connect(y.y, bus3.y) annotation (Line(points={{-68,160},{0,160},{0,-80}},
                           color={0,0,127}));
  connect(TOut.y, weaBus.TDryBul) annotation (Line(points={{-108,-100},{-70,-100},
          {-70,-89.9},{-29.9,-89.9}},
                                color={0,0,127}));
  connect(TOut.y, wetBul.TDryBul) annotation (Line(points={{-108,-100},{-70,-100},
          {-70,-112},{-61,-112}},  color={0,0,127}));
  connect(pOut.y, wetBul.p) annotation (Line(points={{-108,-180},{-100,-180},{-100,
          -128},{-61,-128}}, color={0,0,127}));
  connect(wetBul.TWetBul, weaBus.TWetBul) annotation (Line(points={{-39,-120},{-32,
          -120},{-32,-89.9},{-29.9,-89.9}},
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
          {72,-160},{72,121},{90,121}},     color={0,127,255}));
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
  connect(res.port_b, non.port_a) annotation (Line(points={{-10,180},{-2,180},{-2,
          180},{10,180}}, color={0,127,255}));
  connect(non.port_b, bouAirLvg.ports[6]) annotation (Line(points={{30,180},{90,
          180},{90,121.667}}, color={0,127,255}));
  connect(bouAirEntCoo.ports[2], res.port_a) annotation (Line(points={{-70,121},
          {-40,121},{-40,180},{-30,180}}, color={0,127,255}));
annotation (
  __Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Templates/Components/Validation/Coils.mos"
  "Simulate and plot"),
  experiment(Tolerance=1e-6, StopTime=200),
  Diagram(coordinateSystem(extent={{-140,-200},{140,200}})),
    Documentation(info="<html>
<p>
This model validates the models within
<a href=\"modelica://Buildings.Templates.Components.Coils\">
Buildings.Templates.Components.Coils</a>
by exposing them to a fixed pressure difference on
the air side.
Models representing a water-based coil with valve
are also exposed to a fixed pressure difference on the
water side, and a varying valve opening from fully closed
to fully open position.
Other coil models are controlled with a signal varying
from <i>0</i> to <i>1</i>.
</p>
</html>"));
end Coils;
