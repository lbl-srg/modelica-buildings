within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model Radiator
  "Example model with an radiator that conditions a thermal zone in EnergyPlus"
  extends Modelica.Icons.Example;
  package MediumA=Buildings.Media.Air "Medium model for air";
  package MediumW=Buildings.Media.Water "Medium model for water";

  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    epwName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-140,-20},{-120,0}})));
  constant Modelica.Units.SI.Volume VRoo=453.138 "Room volume";
  constant Modelica.Units.SI.Area AFlo=185.834
    "Floor area of the whole floor of the building";
  parameter Modelica.Units.SI.MassFlowRate mOut_flow_nominal=0.3*VRoo*1.2/3600
    "Outdoor air mass flow rate, assuming constant infiltration air flow rate";
  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=8*VRoo*1.2/3600
    "Nominal mass flow rate for recirculated air";

  parameter Modelica.Units.SI.HeatFlowRate QRad_flow_nominal = 15000
    "Radiator design heat flow rate (at 50/40)";
  parameter Modelica.Units.SI.Temperature TSup_nominal = 323.15
    "Water supply temperature";
  parameter Modelica.Units.SI.Temperature TRet_nominal = 313.15
    "Water return temperature";
  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal = QRad_flow_nominal/4200/(TSup_nominal-TRet_nominal)
    "Radiator design water flow rate";
  parameter Modelica.Units.SI.PressureDifference dpVal_nominal=6000
    "Pressure difference of valve";

  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    redeclare package Medium=MediumA,
    zoneName="LIVING ZONE",
    nPorts=2)
    "Thermal zone"
    annotation (Placement(transformation(extent={{0,40},{40,80}})));
  Controls.OBC.CDL.Continuous.Sources.Pulse TSet(
    shift(
      displayUnit="h")=21600,
    amplitude=6,
    period(
      displayUnit="d")=86400,
    offset=273.15+16,
    y(unit="K",
      displayUnit="degC"))
    "Setpoint for room air"
    annotation (Placement(transformation(extent={{-140,-60},{-120,-40}})));
  Controls.OBC.CDL.Continuous.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=0.2,
    Ti(displayUnit="min") = 600,
    yMax=1,
    yMin=0,
    u_s(
      unit="K",
      displayUnit="degC"),
    u_m(
      unit="K",
      displayUnit="degC"))
    "Controller for heater"
    annotation (Placement(transformation(extent={{-100,-60},{-80,-40}})));
  Fluid.Sources.Boundary_pT pAtm(
    redeclare package Medium=MediumA,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-60,10},{-40,30}})));
  Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium=MediumA,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=mOut_flow_nominal)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{-10,10},{-30,30}})));
  Fluid.Sources.MassFlowSource_WeatherData freshAir(
    redeclare package Medium=MediumA,
    m_flow=mOut_flow_nominal,
    nPorts=1)
    "Outside air supply"
    annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));

  Modelica.Blocks.Sources.Constant qIntGai[3](each k=0)
    "Internal heat gains, set to zero because these are modeled in EnergyPlus"
    annotation (Placement(transformation(extent={{-60,60},{-40,80}})));
  Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    Q_flow_nominal=QRad_flow_nominal,
    T_a_nominal=TSup_nominal,
    T_b_nominal=TRet_nominal) "Radiator"
    annotation (Placement(transformation(extent={{60,-90},{80,-70}})));
  Fluid.Sources.Boundary_pT sin(
    redeclare package Medium = MediumW,
    p=200000,
    T=TRet_nominal,
    nPorts=1) "Pressure source for sink"
    annotation (Placement(transformation(extent={{120,-90},{100,-70}})));
  Fluid.Sources.Boundary_pT sou(
    redeclare package Medium = MediumW,
    p(displayUnit="Pa") = 2E5 + dpVal_nominal + 1000,
    use_T_in=true,
    nPorts=1) "Pressure source for sink"
    annotation (Placement(transformation(extent={{-20,-90},{0,-70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = MediumW,
    m_flow_nominal=mRad_flow_nominal,
    dpValve_nominal(displayUnit="Pa") = dpVal_nominal,
    dpFixed_nominal=1000,
    from_dp=true,
    use_inputFilter=false) "Radiator valve"
    annotation (Placement(transformation(extent={{20,-90},{40,-70}})));
  Controls.OBC.Utilities.SetPoints.SupplyReturnTemperatureReset watRes(
    TSup_nominal=TSup_nominal,
    TRet_nominal=TRet_nominal,
    TOut_nominal=253.15)
    annotation (Placement(transformation(extent={{-60,-92},{-40,-72}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus" annotation (
      Placement(transformation(extent={{-98,-20},{-78,0}}), iconTransformation(
          extent={{-60,26},{-40,46}})));
initial equation
  // Stop simulation if the hard-coded values differ from the ones computed by EnergyPlus.
  assert(
    abs(
      VRoo-zon.V) < 0.01,
    "Zone volume VRoo differs from volume returned by EnergyPlus.");
  assert(
    abs(
      AFlo-zon.AFlo) < 0.01,
    "Zone floor area AFlo differs from area returned by EnergyPlus.");

equation
  connect(TSet.y,conPID.u_s)
    annotation (Line(points={{-118,-50},{-102,-50}},  color={0,0,127}));
  connect(conPID.u_m,zon.TAir)
    annotation (Line(points={{-90,-62},{-90,-98},{128,-98},{128,78},{41,78}},       color={0,0,127}));
  connect(duc.port_a,zon.ports[1])
    annotation (Line(points={{-10,20},{19,20},{19,40.9}},
                                                        color={0,127,255}));
  connect(freshAir.ports[1],zon.ports[2])
    annotation (Line(points={{-40,-10},{21,-10},{21,40.9}},
                                                         color={0,127,255}));
  connect(duc.port_b,pAtm.ports[1])
    annotation (Line(points={{-30,20},{-40,20}},color={0,127,255}));
  connect(zon.qGai_flow, qIntGai.y)
    annotation (Line(points={{-2,70},{-39,70}},   color={0,0,127}));
  connect(rad.heatPortCon, zon.heaPorAir) annotation (Line(points={{68,-72.8},{
          68,60},{20,60}},                color={191,0,0}));
  connect(rad.heatPortRad, zon.heaPorRad) annotation (Line(points={{72,-72.8},{
          72,54},{20.2,54}},     color={191,0,0}));
  connect(sou.ports[1], val.port_a)
    annotation (Line(points={{0,-80},{20,-80}},  color={0,127,255}));
  connect(val.port_b, rad.port_a)
    annotation (Line(points={{40,-80},{60,-80}}, color={0,127,255}));
  connect(conPID.y, val.y)
    annotation (Line(points={{-78,-50},{30,-50},{30,-68}}, color={0,0,127}));
  connect(sou.T_in, watRes.TSup)
    annotation (Line(points={{-22,-76},{-38,-76}}, color={0,0,127}));
  connect(building.weaBus, weaBus) annotation (Line(
      points={{-120,-10},{-88,-10}},
      color={255,204,51},
      thickness=0.5));
  connect(freshAir.weaBus, weaBus) annotation (Line(
      points={{-60,-9.8},{-74,-9.8},{-74,-10},{-88,-10}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%second",
      index=1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));
  connect(weaBus.TDryBul, watRes.TOut) annotation (Line(
      points={{-88,-10},{-90,-10},{-90,-28},{-150,-28},{-150,-76},{-62,-76}},
      color={255,204,51},
      thickness=0.5), Text(
      string="%first",
      index=-1,
      extent={{-6,3},{-6,3}},
      horizontalAlignment=TextAlignment.Right));

  connect(watRes.TSetZon, TSet.y) annotation (Line(points={{-62,-88},{-110,-88},
          {-110,-50},{-118,-50}}, color={0,0,127}));
  connect(sin.ports[1], rad.port_b)
    annotation (Line(points={{100,-80},{80,-80}}, color={0,127,255}));
  annotation (
    Documentation(
      info="<html>
<p>
Example of one building with one thermal zone
in which the room air temperature is controlled with a PI controller.
Heating is provided through a radiator.
The control output is used to regulate the water flow rate through the radiator.
The setpoint for the room air temperature changes between day and night.

The zone also has a constant air infiltration flow rate.
</p>
<p>
Note that for simplicity, the model has no cooling system. Therefore, in summer, the house overheats.
Also note that the surface temperature of the radiator is not taken into account when computing
the radiative temperature of the thermal zone.
</p>
</html>",
      revisions="<html>
<ul>
<li>
February 14, 2024, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3659\">Buildings, #3659</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/Radiator.mos" "Simulate and plot"),
    experiment(
      StopTime=259200,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-160,-120},{140,100}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end Radiator;
