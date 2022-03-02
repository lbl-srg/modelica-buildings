within Buildings.Experimental.DHC.Loads.Steam.BaseClasses.Examples;
model prvWithHex
  "Model to compare the performance of PRV and Ideal source"
  extends Modelica.Icons.Example;

  //package MediumSteam = DES.Media.Steam;
  package MediumWat = Buildings.Media.Water;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1
    "Nominal mass flow rate";
  parameter Modelica.Units.SI.AbsolutePressure pIn=900000 "Inlet pressure";

  parameter Modelica.Units.SI.Temperature TSat=
      MediumSteam.saturationTemperature(pIn) "Saturation temperature";

  Buildings.Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumSteam,
    use_p_in=false,
    p(displayUnit="Pa") = 900000,
    T(displayUnit="K") = MediumSteam.saturationTemperature(sou.p),
    nPorts=1) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumWat,
    p(displayUnit="Pa"),
    T(displayUnit="K"),
    nPorts=1) annotation (Placement(transformation(extent={{238,-10},{218,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntIn(redeclare package
      Medium =
        MediumSteam,
      m_flow_nominal=m_flow_nominal)
                        annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  Buildings.Fluid.Sensors.SpecificEnthalpyTwoPort speEntOu(redeclare package
      Medium =
        MediumSteam,
      m_flow_nominal=m_flow_nominal)
                        annotation (Placement(transformation(extent={{40,-10},{60,10}})));
  DES.Heating.EnergyTransferStations.BaseClasses.MixingVolumeCondensation mixingVolumeCondensation1(
    p_start=mixingVolumeCondensation1.pSat,
    T_start=TSat,
    pSat=300000,
    m_flow_nominal=1,
    V=20) annotation (Placement(transformation(extent={{100,-10},{120,10}})));
  Buildings.Fluid.Movers.FlowControlled_m_flow pumCNR(
    redeclare package Medium = MediumWat,
    m_flow_nominal=m_flow_nominal,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true)
    "Condensate return pump"
    annotation (Placement(transformation(extent={{180,-10},{200,10}})));
  Modelica.Blocks.Sources.Constant mFlo(k=1) "Nominal mass flow rate setpoint"
    annotation (Placement(transformation(extent={{238,40},{218,60}})));
  DES.Heating.EnergyTransferStations.BaseClasses.SteamTrap steTra(redeclare
      package Medium = MediumWat, final m_flow_nominal=m_flow_nominal)
    "Steam trap"
    annotation (Placement(transformation(extent={{140,-10},{160,10}})));
  Buildings.Experimental.DHC.Loads.Steam.BaseClasses.SteamTwoWayValveSelfActing
    steamTwoWayValveSelfActingIdeal(
    redeclare package Medium = MediumSteam,
    m_flow_nominal=m_flow_nominal,
    show_T=true,
    pb_nominal=300000) "Self acting valve"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));
equation
  connect(sou.ports[1], speEntIn.port_a)
    annotation (Line(points={{-60,0},{-40,0}}, color={0,127,255}));
  connect(speEntOu.port_b, mixingVolumeCondensation1.port_a)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(pumCNR.port_b, sin.ports[1])
    annotation (Line(points={{200,0},{218,0}}, color={0,127,255}));
  connect(mFlo.y, pumCNR.m_flow_in) annotation (Line(
      points={{217,50},{190,50},{190,12}},
      color={0,0,127},
      pattern=LinePattern.Dash));
  connect(mixingVolumeCondensation1.port_b, steTra.port_a)
    annotation (Line(points={{120,0},{140,0}}, color={0,127,255}));
  connect(steTra.port_b, pumCNR.port_a)
    annotation (Line(points={{160,0},{180,0}}, color={0,127,255}));
  connect(speEntIn.port_b, steamTwoWayValveSelfActingIdeal.port_a)
    annotation (Line(points={{-20,0},{0,0}}, color={0,127,255}));
  connect(steamTwoWayValveSelfActingIdeal.port_b, speEntOu.port_a)
    annotation (Line(points={{20,0},{40,0}}, color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(coordinateSystem(preserveAspectRatio=false,
          extent={{-100,-140},{260,80}})),
__Dymola_Commands(file=
    "modelica://DES/Resources/Scripts/Dymola/Heating/Loads/Valves/Examples/SteamTwoWayValveSelfActing.mos"
    "Simulate and plot"),
  experiment(StopTime=1000,Tolerance=1e-06),
    Documentation(info="<html>
<p>
Example model for the self-acting two way steam pressure regulating valve model.
</p>
</html>"));
end prvWithHex;
