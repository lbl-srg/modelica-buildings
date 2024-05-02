within Buildings.ThermalZones.EnergyPlus_9_6_0.Examples.SingleFamilyHouse;
model AirHeating
  "Example model with an air-based heating system that conditions a thermal zone in EnergyPlus"
  extends Modelica.Icons.Example;
  package Medium=Buildings.Media.Air
    "Medium model";
  inner Building building(
    idfName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/Data/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse_TwoSpeed_ZoneAirBalance/SingleFamilyHouse_TwoSpeed_ZoneAirBalance.idf"),
    weaName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    epwName=Modelica.Utilities.Files.loadResource(
      "modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.epw"),
    computeWetBulbTemperature=false)
    "Building model"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  constant Modelica.Units.SI.Volume VRoo=453.138 "Room volume";
  constant Modelica.Units.SI.Area AFlo=185.834
    "Floor area of the whole floor of the building";
  parameter Modelica.Units.SI.MassFlowRate mOut_flow_nominal=0.3*VRoo*1.2/3600
    "Outdoor air mass flow rate, assuming constant infiltration air flow rate";
  parameter Modelica.Units.SI.MassFlowRate mRec_flow_nominal=8*VRoo*1.2/3600
    "Nominal mass flow rate for recirculated air";
  Buildings.ThermalZones.EnergyPlus_9_6_0.ThermalZone zon(
    redeclare package Medium=Medium,
    zoneName="LIVING ZONE",
    nPorts=4)
    "Thermal zone"
    annotation (Placement(transformation(extent={{20,80},{60,120}})));
  Fluid.Movers.FlowControlled_m_flow fan(
    redeclare package Medium=Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=mRec_flow_nominal,
    nominalValuesDefineDefaultPressureCurve=true)
    "Fan"
    annotation (Placement(transformation(extent={{40,-30},{60,-10}})));
  Controls.OBC.CDL.Reals.Sources.Pulse TSet(
    shift(
      displayUnit="h")=21600,
    amplitude=6,
    period(
      displayUnit="d")=86400,
    offset=273.15+16,
    y(unit="K",
      displayUnit="degC"))
    "Setpoint for room air"
    annotation (Placement(transformation(extent={{-150,-110},{-130,-90}})));
  Controls.OBC.CDL.Reals.PID conPID(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.PI,
    k=1,
    Ti(
      displayUnit="min")=1800,
    yMax=1,
    yMin=0,
    u_s(
      unit="K",
      displayUnit="degC"),
    u_m(
      unit="K",
      displayUnit="degC"))
    "Controller for heater"
    annotation (Placement(transformation(extent={{-120,-110},{-100,-90}})));
  Fluid.HeatExchangers.Heater_T hea(
    redeclare final package Medium=Medium,
    m_flow_nominal=mRec_flow_nominal,
    dp_nominal=200,
    tau=0,
    show_T=true,
    QMax_flow=4000)
    "Ideal heater"
    annotation (Placement(transformation(extent={{80,-30},{100,-10}})));
  Fluid.Sources.Boundary_pT pAtm(
    redeclare package Medium=Medium,
    nPorts=1)
    "Boundary condition"
    annotation (Placement(transformation(extent={{-40,50},{-20,70}})));
  Fluid.FixedResistances.PressureDrop duc(
    redeclare package Medium=Medium,
    allowFlowReversal=false,
    linearized=true,
    from_dp=true,
    dp_nominal=100,
    m_flow_nominal=mOut_flow_nominal)
    "Duct resistance (to decouple room and outside pressure)"
    annotation (Placement(transformation(extent={{10,50},{-10,70}})));
  Fluid.Sources.MassFlowSource_WeatherData freshAir(
    redeclare package Medium=Medium,
    m_flow=mOut_flow_nominal,
    nPorts=1)
    "Outside air supply"
    annotation (Placement(transformation(extent={{-40,20},{-20,40}})));
  Controls.OBC.CDL.Reals.Hysteresis sta1(
    uLow=0.05,
    uHigh=0.5)
    "Hysteresis to switch on stage 1"
    annotation (Placement(transformation(extent={{-80,-90},{-60,-70}})));
  Controls.OBC.CDL.Conversions.BooleanToReal mSetFan1_flow(
    realTrue=mRec_flow_nominal/2)
    "Mass flow rate for 1st stage"
    annotation (Placement(transformation(extent={{-50,-90},{-30,-70}})));
  Controls.OBC.CDL.Reals.Hysteresis sta2(
    uLow=0.5,
    uHigh=0.75)
    "Hysteresis to switch on stage 2"
    annotation (Placement(transformation(extent={{-80,-60},{-60,-40}})));
  Controls.OBC.CDL.Conversions.BooleanToReal mSetFan2_flow(
    realTrue=mRec_flow_nominal/2)
    "Mass flow rate added for 2nd stage"
    annotation (Placement(transformation(extent={{-50,-60},{-30,-40}})));
  Controls.OBC.CDL.Reals.Add m_fan_set
    "Mass flow rate for fan"
    annotation (Placement(transformation(extent={{8,-66},{28,-46}})));
  Controls.OBC.CDL.Reals.Add TAirLvgSet
    "Set point temperature for air leaving the heater"
    annotation (Placement(transformation(extent={{40,-90},{60,-70}})));
  Controls.OBC.CDL.Reals.AddParameter TSupMin(
    p=2)
    "Minimum supply air temperature"
    annotation (Placement(transformation(extent={{8,-110},{28,-90}})));

  Modelica.Blocks.Sources.Constant qIntGai[3](each k=0)
    "Internal heat gains, set to zero because these are modeled in EnergyPlus"
    annotation (Placement(transformation(extent={{-40,100},{-20,120}})));
  Controls.OBC.CDL.Reals.MultiplyByParameter gai(final k=8) "Gain factor"
    annotation (Placement(transformation(extent={{-6,-90},{14,-70}})));
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
    annotation (Line(points={{-128,-100},{-122,-100}},color={0,0,127}));
  connect(conPID.u_m,zon.TAir)
    annotation (Line(points={{-110,-112},{-110,-120},{122,-120},{122,118},{61,118}},color={0,0,127}));
  connect(fan.port_b,hea.port_a)
    annotation (Line(points={{60,-20},{80,-20}},color={0,127,255}));
  connect(building.weaBus,freshAir.weaBus)
    annotation (Line(points={{-60,30},{-50,30},{-50,30.2},{-40,30.2}},color={255,204,51},thickness=0.5));
  connect(duc.port_a,zon.ports[1])
    annotation (Line(points={{10,60},{38.5,60},{38.5,80.9}},
                                                        color={0,127,255}));
  connect(freshAir.ports[1],zon.ports[2])
    annotation (Line(points={{-20,30},{39.5,30},{39.5,80.9}},
                                                         color={0,127,255}));
  connect(fan.port_a,zon.ports[3])
    annotation (Line(points={{40,-20},{20,-20},{20,10},{40.5,10},{40.5,80.9}},
                                                                          color={0,127,255}));
  connect(hea.port_b,zon.ports[4])
    annotation (Line(points={{100,-20},{112,-20},{112,30},{41.5,30},{41.5,80.9}},
                                                                             color={0,127,255}));
  connect(duc.port_b,pAtm.ports[1])
    annotation (Line(points={{-10,60},{-20,60}},color={0,127,255}));
  connect(conPID.y,sta1.u)
    annotation (Line(points={{-98,-100},{-90,-100},{-90,-80},{-82,-80}},color={0,0,127}));
  connect(sta1.y,mSetFan1_flow.u)
    annotation (Line(points={{-58,-80},{-52,-80}},color={255,0,255}));
  connect(conPID.y,sta2.u)
    annotation (Line(points={{-98,-100},{-90,-100},{-90,-50},{-82,-50}},color={0,0,127}));
  connect(sta2.y,mSetFan2_flow.u)
    annotation (Line(points={{-58,-50},{-52,-50}},color={255,0,255}));
  connect(mSetFan2_flow.y,m_fan_set.u1)
    annotation (Line(points={{-28,-50},{6,-50}},color={0,0,127}));
  connect(mSetFan1_flow.y,m_fan_set.u2)
    annotation (Line(points={{-28,-80},{-20,-80},{-20,-62},{6,-62}},color={0,0,127}));
  connect(m_fan_set.y,fan.m_flow_in)
    annotation (Line(points={{30,-56},{34,-56},{34,0},{50,0},{50,-8}},color={0,0,127}));
  connect(TAirLvgSet.y,hea.TSet)
    annotation (Line(points={{62,-80},{70,-80},{70,-12},{78,-12}},color={0,0,127}));
  connect(zon.TAir,TSupMin.u)
    annotation (Line(points={{61,118},{122,118},{122,-120},{0,-120},{0,-100},{6,-100}},color={0,0,127}));
  connect(TSupMin.y,TAirLvgSet.u2)
    annotation (Line(points={{30,-100},{34,-100},{34,-86},{38,-86}},color={0,0,127}));
  connect(zon.qGai_flow, qIntGai.y)
    annotation (Line(points={{18,110},{-19,110}}, color={0,0,127}));
  connect(conPID.y, gai.u)
    annotation (Line(points={{-98,-100},{-12,-100},{-12,-80},{-8,-80}}, color={0,0,127}));
  connect(gai.y, TAirLvgSet.u1)
    annotation (Line(points={{16,-80},{20,-80},{20,-74},{38,-74}}, color={0,0,127}));
  annotation (
    Documentation(
      info="<html>
<p>
Example of one building with one thermal zone
in which the room air temperature is controlled with a PI controller.
Heating is provided through recirculated air.
The control output is used to compute the set point for the supply air
temperature, which is met by the heating coil.
The setpoint for the room air temperature changes between day and night.
The fan is either off, or operating on stage 1 or 2, depending on the output
of the room temperature controller.
The zone also has a constant air infiltration flow rate.
</p>
<p>
Note that for simplicity, the model has no cooling system. Therefore, in summer, the house overheats.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 13, 2024, by Michael Wetter:<br/>
Updated <code>idf</code> file to add insulation, and restricted capacity of heater.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">issue 3707</a>.
</li>
<li>
March 1, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_9_6_0/Examples/SingleFamilyHouse/AirHeating.mos" "Simulate and plot"),
    experiment(
      StopTime=86400,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        extent={{-160,-140},{140,140}})),
    Icon(
      coordinateSystem(
        extent={{-100,-100},{100,100}})));
end AirHeating;
