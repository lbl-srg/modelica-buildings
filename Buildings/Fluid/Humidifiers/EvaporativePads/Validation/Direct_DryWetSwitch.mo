within Buildings.Fluid.Humidifiers.EvaporativePads.Validation;
model Direct_DryWetSwitch
  "Validation model for a direct evaporative pad for both dry and wet modes"
  extends Modelica.Icons.Example;

  replaceable package MediumA = Buildings.Media.Air
    "Medium";
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal = 2
    "Nominal supply air volume flowrate";

  Buildings.Fluid.Humidifiers.EvaporativePads.Direct dirEvaPad1(
    redeclare final package Medium = MediumA,
    final padAre=0.6,
    redeclare Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per)
    "Direct evaporative pad"
    annotation (Placement(transformation(origin={-50,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Humidifiers.EvaporativePads.Direct dirEvaPad2(
    redeclare final package Medium = MediumA,
    final padAre=0.6,
    redeclare Buildings.Fluid.Humidifiers.EvaporativePads.Data.Generic per)
    "Direct evaporative pad"
    annotation (Placement(transformation(origin={70,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sources.Boundary_pT sin(
    redeclare final package Medium = MediumA,
    final nPorts=1)
    "Mass flow sink"
    annotation (Placement(transformation(origin={190,0},
      extent={{10,-10},{-10,10}})));
  Buildings.Fluid.Sources.MassFlowSource_WeatherData sou(
    redeclare final package Medium = MediumA,
    final m_flow=m_flow_nominal,
    final use_C_in=false,
    final use_m_flow_in=false,
    nPorts=1)
    "Mass flow rate source"
    annotation (Placement(transformation(origin={-170,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Controls.OBC.CDL.Logical.Sources.Pulse evaCooAct(
    width=0.5,
    period=86400,
    shift=0)
    "Boolean pulse signal for active evaporative cooling"
    annotation (Placement(transformation(extent={{-180,-80},{-160,-60}})));
  Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    filNam=ModelicaServices.ExternalReferences.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"))
    "Weather data"
    annotation (Placement(transformation(extent={{-220,-10},{-200,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemIn(
    redeclare final package Medium = MediumA,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final m_flow_nominal=m_flow_nominal,
    final T_start=293.15)
    "Inlet air temperature sensor"
    annotation (Placement(transformation(origin={-130,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMid(
    redeclare final package Medium = MediumA,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final m_flow_nominal=m_flow_nominal,
    final T_start=293.15)
    "Middle air temperature sensor"
    annotation (Placement(transformation(origin={-10,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemOut(
    redeclare final package Medium = MediumA,
    final initType=Modelica.Blocks.Types.Init.InitialOutput,
    final m_flow_nominal=m_flow_nominal,
    final T_start=293.15)
    "Outlet air temperature sensor"
    annotation (Placement(transformation(origin={110,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraIn(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m_flow_nominal)
    "Inlet air water mass fraction sensor"
    annotation (Placement(transformation(origin={-90,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraMid(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m_flow_nominal)
    "Middle air water mass fraction sensor"
    annotation (Placement(transformation(origin={30,0},
      extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFraOut(
    redeclare final package Medium = MediumA,
    final m_flow_nominal=m_flow_nominal)
    "Outlet air water mass fraction sensor"
    annotation (Placement(transformation(origin={150,0},
      extent={{-10,-10},{10,10}})));
equation
  connect(dirEvaPad2.port_b, senTemOut.port_a)
    annotation (Line(points={{80,0},{100,0}}, color={0,127,255}));
  connect(senMasFraOut.port_a, senTemOut.port_b)
    annotation (Line(points={{140,0},{120,0}}, color={0,127,255}));
  connect(senMasFraOut.port_b, sin.ports[1])
    annotation (Line(points={{160,0},{180,0}}, color={0,127,255}));
  connect(evaCooAct.y,dirEvaPad2. evaCooAct)
    annotation (Line(points={{-158,-70},{50,-70},{50,-4},{61,-4}},
      color={255,0,255}));
  connect(sou.ports[1], senTemIn.port_a)
    annotation (Line(points={{-160,0},{-140,0}}, color={0,127,255}));
  connect(senTemIn.port_b, senMasFraIn.port_a)
    annotation (Line(points={{-120,0},{-100,0}}, color={0,127,255}));
  connect(senMasFraIn.port_b,dirEvaPad1. port_a)
    annotation (Line(points={{-80,0},{-60,0}}, color={0,127,255}));
  connect(senTemMid.port_a,dirEvaPad1. port_b)
    annotation (Line(points={{-20,0},{-40,0}}, color={0,127,255}));
  connect(senTemMid.port_b, senMasFraMid.port_a)
    annotation (Line(points={{0,0},{20,0}}, color={0,127,255}));
  connect(dirEvaPad2.port_a, senMasFraMid.port_b)
    annotation (Line(points={{60,0},{40,0}}, color={0,127,255}));
  connect(evaCooAct.y,dirEvaPad1. evaCooAct)
    annotation (Line(points={{-158,-70},{-70,-70},{-70,-4},{-59,-4}},
      color={255,0,255}));
  connect(weaDat.weaBus, sou.weaBus)
    annotation (Line(points={{-200,0},{-190,0},{-190,0.2},{-180,0.2}},
      color={255,204,51}, thickness=0.5));
annotation (
  Diagram(coordinateSystem(extent={{-220,-100},{220,100}})),
  experiment(
      StartTime=18144000,
      StopTime=18230400,
      Interval=60,
      Tolerance=1e-06,
      __Dymola_Algorithm="Dassl"),
  Documentation(info="<html>
<p>
This model validates the direct evaporative pad model
<a href=\"modelica://Buildings.Fluid.Humidifiers.EvaporativePads.Direct\">
Buildings.Fluid.Humidifiers.EvaporativePads.Direct</a> by switching between the dry
and wet modes.
</p>
<p>
This validation model connects 2 evaporative pads in series. It uses a Chicago
weather file to represent outside air conditions in the month of August, and it
simulates how the dry bulb temperature and the water vapor mass fraction of the air
change when air passes through the 2 evaporative pads, for both the active
evaporative cooling mode (wet pad) and the inactive mode (dry pad).
</p>
<p>
The validation results demonstrate that the dry bulb temperature of the air
decreases when air passes through both the first and the second evaporative pads.
However, the dry bulb temperature reduction is smaller for the second evaporative
pad compared to the first evaporative pad due to the dry bulb temperature of the air
being closer to the wet bulb temperature of the air after leaving the first
evaporative pad, creating a diminishing return.
</p>
<p>
A similar behavior is observed for the water vapor mass fraction of the air, where
the water vapor mass fraction increases for both the first and the second
evaporative pads. However, the water vapor mass fraction rise is smaller for the
second evaporative pad compared to the first evaporative pad due to the air being
more humid after leaving the first evaporative pad.
</p>
<p>
On the other hand, for the active evaporative cooling mode, the dry bulb temperature
of the air decreases, and the water vapor mass fraction of the air increases. When
evaporative cooling is inactive, the dry bulb temperature and the water vapor mass
fraction of the air do not change.
</p>
<p>
There is pressure drop when air passes through the 2 evaporative pads. The
validation results also show the assumption that the pressure drop does not change
when switching between active and inactive evaporative cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
June 18, 2026, by Weiping Huang:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})),
    __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/Humidifiers/EvaporativePads/Validation/Direct_DryWetSwitch.mos"
        "Simulate and plot"));
end Direct_DryWetSwitch;
