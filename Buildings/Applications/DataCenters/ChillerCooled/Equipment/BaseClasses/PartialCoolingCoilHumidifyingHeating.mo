within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialCoolingCoilHumidifyingHeating "Partial AHU model "
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface(
    final show_T=true);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.AHUParameters;
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
    final m_flow_nominal=m1_flow_nominal,
    final rhoStd=Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
    final deltaM = deltaM2);
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
    final computeFlowResistance1=true,
    final computeFlowResistance2=true);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  // Initialization of the fan
  parameter Medium2.AbsolutePressure p_start = Medium2.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium2.Temperature T_start=Medium2.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium2.MassFraction X_start[Medium2.nX](
       quantity=Medium2.substanceNames) = Medium2.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium2.nXi > 0));
  parameter Medium2.ExtraProperty C_start[Medium2.nC](
       quantity=Medium2.extraPropertiesNames)=fill(0, Medium2.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium2.nC > 0));
  parameter Medium2.ExtraProperty C_nominal[Medium2.nC](
       quantity=Medium2.extraPropertiesNames) = fill(1E-2, Medium2.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium2.nC > 0));
  // valve parameters
  parameter Real l(min=1e-10, max=1) = 0.0001
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));

  parameter Boolean use_inputFilterValve=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter for the water-side valve"
    annotation(Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.Units.SI.Time riseTimeValve=120
    "Rise time of the filter for the water-side valve (time to reach 99.6 % of an opening step)"
    annotation (Dialog(
      tab="Dynamics",
      group="Valve",
      enable=use_inputFilterValve));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve_start=1 "Initial value of output"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  // fan parameters
   parameter Buildings.Fluid.Types.InputType inputType = Buildings.Fluid.Types.InputType.Continuous
    "Control input type"
    annotation(Dialog(group="Fan"));
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation(Dialog(group="Fan"));
  parameter Modelica.Units.SI.Time tauFan=1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Fan"));
  parameter Boolean use_inputFilterFan=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Fan"));
  parameter Modelica.Units.SI.Time riseTimeFan=30
    "Rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      group="Fan",
      enable=use_inputFilterFan));
  parameter Modelica.Blocks.Types.Init initFan=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Fan",enable=use_inputFilterFan));
  parameter Real yFan_start(min=0, max=1, unit="1")=0 "Initial value of speed"
    annotation(Dialog(tab="Dynamics", group="Fan",enable=use_inputFilterFan));
  replaceable parameter Buildings.Fluid.Movers.Data.Generic perFan "Performance data for the fan"
    annotation (Placement(transformation(extent={{-80,80},{-60,100}})));

  Modelica.Blocks.Interfaces.RealInput uVal(min=0,max=1,unit="1")
    "Actuator position (0: closed, 1: open) on water side"
    annotation (Placement(transformation(extent={{-140,10},{-100,50}}),
      iconTransformation(extent={{-120,30},{-100,50}})));
  Modelica.Blocks.Interfaces.RealInput uFan
if not inputType == Buildings.Fluid.Types.InputType.Stages
   "Continuous input signal for the fan"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));
  Modelica.Blocks.Interfaces.RealOutput PFan(
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the fan"
     annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=-90,
        origin={-20,-110})));
  Modelica.Blocks.Interfaces.RealOutput yVal(
    min=0,
    max=1,
    final unit="1") "Actual valve position"
    annotation (Placement(transformation(extent={{100,30},{120,50}}),
               iconTransformation(extent={{100,30},{120,50}})));
  Modelica.Blocks.Interfaces.IntegerInput stage
 if inputType == Buildings.Fluid.Types.InputType.Stages
    "Stage input signal for the pressure head"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
        iconTransformation(extent={{-120,-50},{-100,-30}})));

  Fluid.HeatExchangers.WetCoilEffectivenessNTU cooCoi(
    redeclare final package Medium1 = Medium1,
    redeclare final package Medium2 = Medium2,
    final UA_nominal=UA_nominal,
    final r_nominal=r_nominal,
    final allowFlowReversal1=allowFlowReversal1,
    final allowFlowReversal2=allowFlowReversal2,
    final show_T=show_T,
    final m1_flow_small=m1_flow_small,
    final m2_flow_small=m2_flow_small,
    final energyDynamics=energyDynamics,
    final m1_flow_nominal=m1_flow_nominal,
    final m2_flow_nominal=m2_flow_nominal,
    final dp1_nominal=0,
    final dp2_nominal=dp2_nominal)
    "Cooling coil"
    annotation (Placement(transformation(extent={{60,-64},{80,-44}})));
  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine fan
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
      redeclare final package Medium = Medium2,
      final per=perFan,
      final allowFlowReversal=allowFlowReversal2,
      final show_T=show_T,
      final energyDynamics=energyDynamics,
      final inputType=inputType,
      final tau=tauFan,
      final addPowerToMedium=addPowerToMedium,
      final use_inputFilter=use_inputFilterFan,
      final riseTime=riseTimeFan,
      final init=initFan,
      final p_start=p_start,
      final T_start=T_start,
      final X_start=X_start,
      final C_start=C_start,
      final C_nominal=C_nominal,
      final m_flow_small=m2_flow_small)
    "Fan"
    annotation (Placement(transformation(extent={{-50,-70},{-70,-50}})));
  replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv watVal
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv(
      redeclare final package Medium = Medium1,
      final allowFlowReversal=allowFlowReversal1,
      final show_T=show_T,
      final l=l,
      final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
      final from_dp=from_dp1,
      final homotopyInitialization=homotopyInitialization,
      final linearized=linearizeFlowResistance1,
      final rhoStd=rhoStd,
      final use_inputFilter=use_inputFilterValve,
      final riseTime=riseTimeValve,
      final init=initValve,
      final y_start=yValve_start,
      final dpValve_nominal=dpValve_nominal,
      final m_flow_nominal=m_flow_nominal,
      final deltaM=deltaM1,
      final dpFixed_nominal=dp1_nominal)
    "Two-way valve"
     annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={80,-10})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(port_a1, cooCoi.port_a1) annotation (Line(points={{-100,60},{50,60},
          {50,-48},{60,-48}}, color={0,127,255}));
  connect(cooCoi.port_a2, port_a2) annotation (Line(points={{80,-60},{80,-60},
          {84,-60},{100,-60}}, color={0,127,255}));
  connect(cooCoi.port_b1, watVal.port_a) annotation (Line(points={{80,-48},{80,
          -48},{80,-26},{80,-34},{80,-20}}, color={0,127,255}));
  connect(watVal.port_b, port_b1)
   annotation (Line(points={{80,0},{80,0},{80,60},{100,60}},
                 color={0,127,255}));
  connect(fan.P, PFan)
   annotation (Line(points={{-71,-51},{-80,-51},{-80,-80},
               {-20,-80},{-20,-110}},color={0,0,127}));
  connect(watVal.y, uVal)
   annotation (Line(points={{68,-10},{62,-10},{62,30},{-62,30},{-120,30}},
                                             color={0,0,127}));
  connect(port_b2, fan.port_b)
   annotation (Line(points={{-100,-60},{-70,-60}},
                 color={0,127,255}));
  connect(fan.stage, stage)
   annotation (Line(points={{-60,-48},{-60,-40},{-90,-40},
         {-90,-50},{-120,-50}},color={255,127,0}));
  connect(yVal, watVal.y_actual) annotation (Line(points={{110,40},{92,40},{73,
          40},{73,-5}}, color={0,0,127}));
  annotation (      Diagram(coordinateSystem(preserveAspectRatio=false),
        graphics={Text(extent={{50,74},{76,68}},textColor={0,0,255},
                     textString="Waterside",textStyle={TextStyle.Bold}),
                 Text(extent={{58,-70},{84,-76}},textColor={0,0,255},
                     textString="Airside",textStyle={TextStyle.Bold})}),
    Documentation(info="<html>
<p>
This model describes a partial air handling unit model, which contains a water-side valve, a cooling coil and a fan model.
</p>
<p>
The valve and fan are partial models, and should be redeclared when used in the air handling unit model.
</p>
</html>", revisions="<html>
<ul>
<li>
June 30, 2021, by Antoine Gautier:<br/>
Changed cooling coil model. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2549\">issue #2549</a>.
</li>
<li>
April 9, 2021, by Kathryn Hinkelman:<br/>
Removed <code>kFixed</code> redundancies. See
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1472\">IBPSA, #1472</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, #1341</a>.
</li>
<li>May 12, 2017 by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialCoolingCoilHumidifyingHeating;
