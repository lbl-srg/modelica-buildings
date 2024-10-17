within Buildings.DHC.Plants.Combined.Subsystems.Validation.BaseClasses;
partial model PartialMultiplePumps
  "Base class for validating the multiple pumps model"
  extends Modelica.Icons.Example;

  package Medium = Buildings.Media.Water
    "Medium model for hot water";

  parameter Integer nPum(
    final min=1)=2
    "Number of pumps"
    annotation(Evaluate=true);
  parameter Modelica.Units.SI.MassFlowRate mPum_flow_nominal=1
    "Pump mass flow rate (each pump)"
    annotation(Dialog(group="Nominal condition"));
  parameter Modelica.Units.SI.PressureDifference dpPum_nominal = 1E5
    "Pump head (each pump)"
    annotation(Dialog(group="Nominal condition"));
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=
    nPum * mPum_flow_nominal
    "Circuit mass flow rate at design conditions";
  parameter Modelica.Units.SI.Pressure p_min = 2E5
    "Circuit minimum pressure";
  parameter Modelica.Units.SI.PressureDifference dp_nominal = dpPum_nominal
    "Circuit total pressure drop at design conditions";

  Fluid.Sources.Boundary_pT bou(
    redeclare final package Medium = Medium,
    final p=p_min,
    nPorts=2)
    "Pressure boundary condition"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));
  replaceable Buildings.DHC.Plants.Combined.Subsystems.MultiplePumpsSpeed pum
    constrainedby
    Buildings.DHC.Plants.Combined.Subsystems.BaseClasses.PartialMultiplePumps(
    redeclare final package Medium = Medium,
    final nPum=nPum,
    final mPum_flow_nominal=mPum_flow_nominal,
    final dpPum_nominal=dpPum_nominal,
    use_riseTime=false,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial)
    "Multiple pumps in parallel - Speed controlled"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));

  Fluid.Sensors.RelativePressure senRelPre(redeclare package Medium = Medium)
    "Differential pressure sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={40,60})));
  Fluid.Sensors.MassFlowRate senMasFlo(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={20,30})));
  Buildings.Controls.OBC.CDL.Reals.Sources.Ramp ope(
    height=0.8,
    duration=300,
    offset=0.2,
    startTime=200)
    "Valve opening signal"
    annotation (Placement(transformation(extent={{-120,-10},{-100,10}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=5000,
    dpFixed_nominal=dp_nominal - val.dpValve_nominal)
    "Modulating valve"
    annotation (Placement(transformation(extent={{10,-10},{-10,10}})));

  Buildings.Controls.OBC.CDL.Logical.Sources.TimeTable y1Pum(
    table=[0,0,0; 1,0,0; 1,1,0; 4,1,1; 4,1,1; 10,1,1],
    timeScale=100,
    period=1000) "Pump Start signal"
    annotation (Placement(transformation(extent={{-120,110},{-100,130}})));
  replaceable Fluid.Movers.SpeedControlled_y pum1 constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    redeclare final package Medium = Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_riseTime=false,
    final per=pum.per,
    addPowerToMedium=false) "Pump"
    annotation (Placement(transformation(extent={{-10,-50},{10,-30}})));
  Fluid.FixedResistances.CheckValve cheVal1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mPum_flow_nominal,
    final dpValve_nominal=pum.dpValve_nominal)
    "Check valve"
    annotation (Placement(transformation(extent={{30,-50},{50,-30}})));
  replaceable Fluid.Movers.SpeedControlled_y pum2 constrainedby
    Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    redeclare final package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    use_riseTime=false,
    final per=pum.per,
    addPowerToMedium=false) "Pump"
    annotation (Placement(transformation(extent={{-10,-90},{10,-70}})));
  Fluid.FixedResistances.CheckValve cheVal2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=mPum_flow_nominal,
    final dpValve_nominal=pum.dpValve_nominal)
    "Check valve"
    annotation (Placement(transformation(extent={{30,-90},{50,-70}})));
  Fluid.Actuators.Valves.TwoWayEqualPercentage val1(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    dpValve_nominal=5000,
    dpFixed_nominal=dp_nominal - val.dpValve_nominal)
    "Modulating valve"
    annotation (Placement(transformation(extent={{10,-130},{-10,-110}})));
  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea[2]
    "Convert to real"
    annotation (Placement(transformation(extent={{80,110},{100,130}})));
  Fluid.Sensors.RelativePressure senRelPre1(redeclare package Medium = Medium)
    "Differential pressure sensor" annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={90,-80})));
  Fluid.Sensors.MassFlowRate senMasFlo1(redeclare package Medium = Medium)
    "Mass flow rate sensor" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={60,-100})));
  Buildings.Controls.OBC.CDL.Reals.Multiply inp1
    "Compute pump input signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,2})));
  Buildings.Controls.OBC.CDL.Reals.Multiply inp2
    "Compute pump input signal" annotation (Placement(transformation(
        extent={{10,-10},{-10,10}},
        rotation=90,
        origin={120,-42})));
equation
  connect(bou.ports[1], pum.port_a)
    annotation (Line(points={{-60,59},{-60,60},{-10,60}}, color={0,127,255}));
  connect(val.port_b, pum.port_a) annotation (Line(points={{-10,0},{-20,0},{-20,
          60},{-10,60}}, color={0,127,255}));
  connect(pum.port_b, senRelPre.port_a)
    annotation (Line(points={{10,60},{30,60}}, color={0,127,255}));
  connect(ope.y, val.y) annotation (Line(points={{-98,0},{-40,0},{-40,20},{0,20},
          {0,12}}, color={0,0,127}));
  connect(y1Pum.y, pum.y1) annotation (Line(points={{-98,120},{-14,120},{-14,68},
          {-12,68}},         color={255,0,255}));
  connect(pum.port_b, senMasFlo.port_a)
    annotation (Line(points={{10,60},{20,60},{20,40}}, color={0,127,255}));
  connect(senMasFlo.port_b, val.port_a)
    annotation (Line(points={{20,20},{20,0},{10,0}}, color={0,127,255}));
  connect(senRelPre.port_b, pum.port_a) annotation (Line(points={{50,60},{60,60},
          {60,74},{-10,74},{-10,60}}, color={0,127,255}));
  connect(pum1.port_b, cheVal1.port_a)
    annotation (Line(points={{10,-40},{30,-40}}, color={0,127,255}));
  connect(pum2.port_b, cheVal2.port_a)
    annotation (Line(points={{10,-80},{30,-80}}, color={0,127,255}));
  connect(val1.port_b, pum2.port_a) annotation (Line(points={{-10,-120},{-40,-120},
          {-40,-80},{-10,-80}}, color={0,127,255}));
  connect(val1.port_b, pum1.port_a) annotation (Line(points={{-10,-120},{-40,-120},
          {-40,-40},{-10,-40}}, color={0,127,255}));
  connect(val1.port_b, bou.ports[2]) annotation (Line(points={{-10,-120},{-60,-120},
          {-60,61}}, color={0,127,255}));
  connect(y1Pum.y, booToRea.u)
    annotation (Line(points={{-98,120},{78,120}}, color={255,0,255}));
  connect(cheVal2.port_b, senMasFlo1.port_a)
    annotation (Line(points={{50,-80},{60,-80},{60,-90}}, color={0,127,255}));
  connect(senMasFlo1.port_b, val1.port_a) annotation (Line(points={{60,-110},{60,
          -120},{10,-120}}, color={0,127,255}));
  connect(cheVal1.port_b, senMasFlo1.port_a)
    annotation (Line(points={{50,-40},{60,-40},{60,-90}}, color={0,127,255}));
  connect(senRelPre1.port_a, senMasFlo1.port_a)
    annotation (Line(points={{80,-80},{60,-80},{60,-90}}, color={0,127,255}));
  connect(senRelPre1.port_b, pum2.port_a) annotation (Line(points={{100,-80},{120,
          -80},{120,-130},{-40,-130},{-40,-80},{-10,-80}}, color={0,127,255}));
  connect(booToRea[1].y, inp1.u2)
    annotation (Line(points={{102,120},{126,120},{126,14}}, color={0,0,127}));
  connect(ope.y, val1.y) annotation (Line(points={{-98,0},{-80,0},{-80,-100},{0,
          -100},{0,-108}}, color={0,0,127}));
  connect(booToRea[2].y, inp2.u2) annotation (Line(points={{102,120},{134,120},{
          134,-20},{126,-20},{126,-30}}, color={0,0,127}));
  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/Plants/Combined/Subsystems/Validation/MultiplePumpsSpeed.mos"
      "Simulate and plot"),
    experiment(
      StopTime=1000,
      Tolerance=1e-06),
  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-140,-140},{140,140}})),
    Documentation(info="<html>
<p>
This base class is used to construct validation models
for the various multiple-pump models within
<a href=\"modelica://Buildings.DHC.Plants.Combined.Subsystems\">
Buildings.DHC.Plants.Combined.Subsystems</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
February 24, 2023, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialMultiplePumps;
