within Buildings.Templates.Plants.HeatPumps.Components;
model HeatRecoveryChiller
  "Heat recovery chiller for sidestream integration"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    redeclare final package Medium1=MediumHeaWat,
    redeclare final package Medium2=MediumChiWat,
    final m1_flow_nominal=datHrc.mCon_flow_nominal,
    final m2_flow_nominal=datHrc.mChiWat_flow_nominal)
    annotation (IconMap(extent={{-600,600},{600,-600}}));
  /* RFE(AntoineGautier): IconMap is used above until the following PR is completed:
  https://github.com/ibpsa/modelica-ibpsa/issues/1781
  Note that the extent annotation results in flipping the icon vertically (port_*2 at the top),
  which allows better integration into the HP plant diagram.
  Ideally, with PR#1781, port_a1 and port_b1 should be moved to be vertically
  aligned with port_a2 and port_b2, respectively.
  */replaceable package MediumChiWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "CHW medium"
    annotation (__Linkage(enable=false));
  replaceable package MediumHeaWat=Buildings.Media.Water
    constrainedby Modelica.Media.Interfaces.PartialMedium
    "HW medium"
    annotation (__Linkage(enable=false));
  parameter Buildings.Templates.Components.Data.PumpSingle datPumChiWat
    "HRC CHW pump parameters"
    annotation (Placement(transformation(extent={{60,20},{80,40}})));
  parameter Buildings.Templates.Components.Data.PumpSingle datPumHeaWat
    "HRC HW pump parameters"
    annotation (Placement(transformation(extent={{60,-8},{80,12}})));
  parameter Buildings.Templates.Components.Data.Chiller datHrc
    "HRC parameters"
    annotation (Placement(transformation(extent={{60,-40},{80,-20}})));
  parameter Modelica.Units.SI.Time tauHrc=30
    "HRC – Time constant at nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
    __ctrlFlow(enable=false));
  parameter Modelica.Units.SI.Time tauPum=1
    "Pump – Time constant of fluid volume for nominal flow, used if energy or mass balance is dynamic"
    annotation (Dialog(tab="Dynamics",group="Nominal condition",
      enable=energyDynamics<>Modelica.Fluid.Types.Dynamics.SteadyState),
    __ctrlFlow(enable=false));
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation (Evaluate=true,
    Dialog(tab="Dynamics",group="Conservation equations"),
    __ctrlFlow(enable=false));
  Buildings.Templates.Plants.HeatPumps.Interfaces.Bus bus
    "Plant control bus"
    annotation (Placement(transformation(extent={{-20,80},{20,120}}),
      iconTransformation(extent={{-20,200},{20,240}})));
  Buildings.Templates.Components.Chillers.Compression hrc(
    redeclare final package MediumChiWat=MediumChiWat,
    redeclare final package MediumCon=MediumHeaWat,
    final dat=datHrc,
    final typ=Buildings.Templates.Components.Types.Chiller.WaterCooled,
    final have_switchover=true,
    final energyDynamics=energyDynamics,
    final tau=tauHrc,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final show_T=show_T)
    "Heat recovery chiller"
    annotation (Placement(transformation(extent={{-10,-4},{10,16}})));
  Buildings.Templates.Components.Pumps.Single pumChiWat(
    have_var=false,
    have_valChe=false,
    redeclare final package Medium=MediumChiWat,
    final dat=datPumChiWat,
    final energyDynamics=energyDynamics,
    final tau=tauPum,
    final allowFlowReversal=allowFlowReversal2,
    final show_T=show_T)
    "HRC CHW pump"
    annotation (Placement(transformation(extent={{50,-70},{30,-50}})));
  Buildings.Templates.Components.Pumps.Single pumHeaWat(
    have_var=false,
    have_valChe=false,
    redeclare final package Medium=MediumHeaWat,
    final dat=datPumHeaWat,
    final energyDynamics=energyDynamics,
    final tau=tauPum,
    final allowFlowReversal=allowFlowReversal1,
    final show_T=show_T)
    "HRC HW pump"
    annotation (Placement(transformation(extent={{-70,50},{-50,70}})));
equation
  connect(port_a1, pumHeaWat.port_a)
    annotation (Line(points={{-100,60},{-70,60}},color={0,127,255}));
  connect(port_a2, pumChiWat.port_a)
    annotation (Line(points={{100,-60},{50,-60}},color={0,127,255}));
  connect(pumChiWat.port_b, hrc.port_a2)
    annotation (Line(points={{30,-60},{10,-60},{10,0}},color={0,127,255}));
  connect(hrc.port_b2, port_b2)
    annotation (Line(points={{-10,0},{-10,-60},{-100,-60}},color={0,127,255}));
  connect(pumHeaWat.port_b, hrc.port_a1)
    annotation (Line(points={{-50,60},{-10,60},{-10,12}},color={0,127,255}));
  connect(hrc.port_b1, port_b1)
    annotation (Line(points={{10,12},{10,60},{100,60}},color={0,127,255}));
  connect(bus.hrc, hrc.bus)
    annotation (Line(points={{0,100},{0,100},{0,16}},color={255,204,51},thickness=0.5),
      Text(string="%first",index=-1,extent={{-3,6},{-3,6}},horizontalAlignment=TextAlignment.Right));
  connect(bus.pumHeaWatHrc, pumHeaWat.bus)
    annotation (Line(points={{0,100},{0,70},{-60,70}},color={255,204,51},thickness=0.5));
  connect(bus.pumChiWatHrc, pumChiWat.bus)
    annotation (Line(points={{0,100},{0,70},{40,70},{40,-50}},color={255,204,51},thickness=0.5));
  annotation (
    defaultComponentName="hrc",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-600,-600},{600,600}}),
      graphics={
        Line(
          points={{-600,-362},{-600,-82},{-476,-82},{-420,-62},{-200,-62}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
        Line(
          points={{600,362},{600,42},{476,42},{420,62},{200,62}},
          color={0,0,0},
          thickness=5,
          pattern=LinePattern.Dash),
        Bitmap(
          extent={{-60,100},{60,220}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Boilers/ControllerOnboard.svg"),
        Text(
          extent={{-140,-50},{140,50}},
          textColor={0,0,0},
          textString="HRC"),
        Rectangle(
          extent={{-200,-100},{200,100}},
          lineColor={0,0,0},
          lineThickness=1),
        Line(
          points={{470,120},{470,82}},
          color={0,0,0}),
        Bitmap(
          extent={{520,-12},{420,88}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
        Bitmap(
          extent={{340,20},{260,100}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
          visible=pumChiWat.have_valChe),
        Bitmap(
          extent={{-520,-132},{-420,-32}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Pumps/Single.svg"),
        Bitmap(
          extent={{-340,-100},{-260,-20}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Valves/Check.svg",
          visible=pumHeaWat.have_valChe),
        Bitmap(
          extent={{420,120},{520,220}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
        Line(
          points={{-600,360},{-600,60},{-200,60}},
          color={0,0,0},
          thickness=5),
        Line(
          points={{600,-360},{600,-60},{200,-60}},
          color={0,0,0},
          thickness=5),
        Bitmap(
          extent={{-520,-260},{-420,-160}},
          fileName=
            "modelica://Buildings/Resources/Images/Templates/Components/Actuators/MotorStarter.svg"),
        Line(
          points={{-470,-124},{-470,-160}},
          color={0,0,0})}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false)),
    Documentation(
      info="<html>
<p>
Model of a heat recovery chiller with constant speed CHW and HW pumps.
The model is intended to represent the sidestream integration of a HRC
into a heating and cooling plant.
In such a configuration, the condenser is connected to the HW
return and the evaporator is connected to the CHW return.
</p>
<h4>Control points</h4>
<p>
The following input and output points are available.
</p>
<ul>
<li>Chiller: Refer to the documentation of
<a href=\"modelica://Buildings.Templates.Components.Chillers.Compression\">
Buildings.Templates.Components.Chillers.Compression</a>
considering <code>have_switchover=true</code> and
<code>typ=Buildings.Templates.Components.Types.Chiller.WaterCooled</code>.
</li>
<li>CHW pump or HW pump: Refer to the documentation of
<a href=\"modelica://Buildings.Templates.Components.Pumps.Single\">
Buildings.Templates.Components.Pumps.Single</a>.
</li>
</ul>
</html>",
      revisions="<html>
<ul>
<li>
May 31, 2024, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>"));
end HeatRecoveryChiller;
