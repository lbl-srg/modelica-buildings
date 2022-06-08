within Buildings.Fluid.HydronicConfigurations.ActiveNetworks.Examples;
model InjectionTwoWayVariable
  "Model illustrating the operation of an inversion circuit with two-way valve and variable secondary"
  extends HydronicConfigurations.ActiveNetworks.Examples.InjectionTwoWayConstant(
    redeclare BaseClasses.LoadTwoWayValveControl loa(
      final mAir_flow_nominal=mAir_flow_nominal),
    redeclare BaseClasses.LoadTwoWayValveControl loa1(
      final mAir_flow_nominal=mAir_flow_nominal),
    del2(nPorts=4),
    dp2_nominal=dpPip_nominal + dp2Set,
    m2_flow_nominal=2 * mTer_flow_nominal / 0.9,
    mTer_flow_nominal=2.46,
    TAirEnt_nominal=25.6 + 273.15,
    phiAirEnt_nominal = 0.5,
    TLiqEnt_nominal=4.4+273.15,
    TLiqLvg_nominal=13.5+273.15,
    TLiqSup_nominal=3+273.15,
    con(
      typPum=Buildings.Fluid.HydronicConfigurations.Types.Pump.SingleVariable,
      typFun=Buildings.Fluid.HydronicConfigurations.Types.ControlFunction.Cooling,
      typCtl=Buildings.Fluid.HydronicConfigurations.Types.ControlVariable.SupplyTemperature),
    setOff(table=[0,0; 9,0; 15,+5; 16,+5; 17,0; 24,0]));

  parameter Modelica.Units.SI.Pressure dp2Set(
    final min=0,
    displayUnit="Pa") = loa1.dpTer_nominal + loa1.dpValve_nominal
    "Secondary pressure differential set point";
  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal=6.8
    "Air mass flow rate at design conditions";

  FixedResistances.PressureDrop res2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=mTer_flow_nominal,
    final dp_nominal=dpPip_nominal)
    "Pipe pressure drop"
    annotation (Placement(transformation(extent={{70,50},{90,70}})));
  Sensors.RelativePressure dp2(redeclare final package Medium = MediumLiq)
    "Differential pressure"
    annotation (Placement(transformation(extent={{100,60},{120,80}})));
  FixedResistances.PressureDrop resEnd2(
    redeclare final package Medium = MediumLiq,
    final m_flow_nominal=0.1*m2_flow_nominal,
    final dp_nominal=dp2Set)
    "Pipe pressure drop"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={140,40})));
  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant dp2SetVal(
    final k=dp2Set)
    "Pressure differential set point"
    annotation (Placement(transformation(extent={{-120,50},{-100,70}})));
  Controls.PIDWithOperatingMode ctlPum2(
    k=1,
    Ti=60,
    r=MediumLiq.p_default,
    y_reset=1) "Pump controller"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));


equation
  connect(dp2.port_a, loa1.port_a)
    annotation (Line(points={{100,70},{100,100}}, color={0,127,255}));
  connect(dp2.port_b, loa1.port_b)
    annotation (Line(points={{120,70},{120,100}}, color={0,127,255}));
  connect(res2.port_b, resEnd2.port_a)
    annotation (Line(points={{90,60},{140,60},{140,50}}, color={0,127,255}));
  connect(resEnd2.port_b, del2.ports[4])
    annotation (Line(points={{140,30},{140,20},{60,20}}, color={0,127,255}));
  connect(dp2SetVal.y, ctlPum2.u_s)
    annotation (Line(points={{-98,60},{-72,60}}, color={0,0,127}));
  connect(mod1.y[1], ctlPum2.mod)
    annotation (Line(points={{-98,20},{-66,20},{-66,48}}, color={255,127,0}));
  connect(dp2.p_rel, ctlPum2.u_m) annotation (Line(points={{110,61},{110,40},{-60,
          40},{-60,48}}, color={0,0,127}));
  connect(ctlPum2.y, con.yPum) annotation (Line(points={{-48,60},{6,60},{6,14},
          {18,14}}, color={0,0,127}));
   annotation (experiment(
    StopTime=86400,
    Tolerance=1e-6),
    __Dymola_Commands(file=
    "modelica://Buildings/Resources/Scripts/Dymola/Fluid/HydronicConfigurations/ActiveNetworks/Examples/InjectionTwoWayVariable.mos"
    "Simulate and plot"),
    Documentation(info="<html>
<p>
This model illustrates the use of an injection circuit with a two-way valve
that serves as the interface between a variable flow primary circuit at constant
supply temperature and a constant flow secondary circuit at variable supply
temperature.
Two identical terminal units circuits are served by the secondary circuit.
Each terminal unit has its own hourly load profile.
The main assumptions are enumerated below.
</p>
<ul>
<li>
The design conditions are defined without
considering any load diversity.
</li>
<li>
Each circuit is balanced at design conditions.
</li>
<li>
No heat is added by the pump to the medium:...
</li>
<li>
Setting of PI for dp set point tracking: reset at max is important,
so is the scaling.
</li>
</ul>

</html>"),
    Diagram(coordinateSystem(extent={{-160,-160},{160,160}})));
end InjectionTwoWayVariable;
