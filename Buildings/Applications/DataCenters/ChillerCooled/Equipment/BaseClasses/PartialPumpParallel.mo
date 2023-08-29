within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialPumpParallel "Partial model for pump parallel"

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters;

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per[num](
    each motorCooledByFluid=false)
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{70,64},{90,84}})));

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

 // Pump parameters
  parameter Integer num=2 "The number of pumps";
  parameter Boolean addPowerToMedium=false
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation(Dialog(group="Pump"));
  parameter Modelica.Units.SI.Time tau=1
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
    annotation (Dialog(tab="Dynamics", group="Pump"));
  parameter Boolean use_inputFilter=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.Units.SI.Time riseTimePump=30
    "Rise time of the filter (time to reach 99.6 % of the speed)" annotation (
      Dialog(
      tab="Dynamics",
      group="Pump",
      enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Real[num] yPump_start=fill(0,num) "Initial value of pump signals"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));

   // Valve parameters
  parameter Real l=0.0001 "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Two-way valve"));
  parameter Modelica.Units.SI.Time riseTimeValve=riseTimePump
    "Rise time of the filter (time to become 99.6 % open)" annotation (
      Dialog(
      tab="Dynamics",
      group="Valve",
      enable=use_inputFilter));
  parameter Real[num] yValve_start = fill(1,num)
    "Initial value of valve signals"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilter));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Conservation equations"));

  // Initialization
  parameter Medium.AbsolutePressure p_start = Medium.p_default
    "Start value of pressure"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.Temperature T_start = Medium.T_default
    "Start value of temperature"
    annotation(Dialog(tab = "Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX] = Medium.X_default
    "Start value of mass fractions m_i/m"
    annotation (Dialog(tab="Initialization", enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    final quantity=Medium.extraPropertiesNames)=fill(0, Medium.nC)
    "Start value of trace substances"
    annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
    final quantity=Medium.extraPropertiesNames) = fill(1E-2, Medium.nC)
    "Nominal value of trace substances. (Set to typical order of magnitude.)"
   annotation (Dialog(tab="Initialization", enable=Medium.nC > 0));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance"));
  parameter Real threshold(min = 0.01) = 0.05
    "Hysteresis threshold";
  Modelica.Blocks.Interfaces.RealInput u[num](
    each final unit="1",
    each max=1,
    each min=0)
    "Continuous input signal for the flow machine"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput P[num](
    each final quantity="Power",
    each final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        origin={110,40})));

  replaceable Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine pum[num]
    constrainedby Buildings.Fluid.Movers.BaseClasses.PartialFlowMachine(
    redeclare each final replaceable package Medium = Medium,
    each final inputType=Buildings.Fluid.Types.InputType.Continuous,
    final per=per,
    each final addPowerToMedium=addPowerToMedium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=m_flow_small,
    each final show_T=show_T,
    each final tau=tau,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimePump,
    each final init=init,
    each final energyDynamics=energyDynamics,
    each final p_start=p_start,
    each final T_start=T_start,
    each final X_start=X_start,
    each final C_start=C_start,
    each final C_nominal=C_nominal)
    "Pumps"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val[num](
    redeclare each final replaceable package Medium = Medium,
    each final dpFixed_nominal=0,
    each final l=l,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final allowFlowReversal=allowFlowReversal,
    each final show_T=show_T,
    each final rhoStd=rhoStd,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=init,
    final y_start=yValve_start,
    each final dpValve_nominal=dpValve_nominal,
    each final m_flow_nominal=m_flow_nominal,
    each final deltaM=deltaM,
    each final from_dp=from_dp,
    each final linearized=linearizeFlowResistance,
    each final homotopyInitialization=homotopyInitialization)
    "Isolation valves"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Hysteresis hys[num](
    each final uLow=threshold,
    each final uHigh=2*threshold) "Hysteresis for isolation valves"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Buildings.Controls.OBC.CDL.Reals.Switch swi[num]
    "Switch to enable pump only once the valve is commanded open"
    annotation (Placement(transformation(extent={{-48,-40},{-28,-20}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant zer[num](
    each final k=0.0) "Outputs 0 as the control signal"
    annotation (Placement(transformation(extent={{-90,-70},{-70,-50}})));
protected
  Buildings.Controls.OBC.CDL.Reals.Sources.Constant one[num](each final k=
        1.0) "Outputs 1 as the control signal"
    annotation (Placement(transformation(extent={{-90,-32},{-70,-12}})));
initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  connect(pum.port_b, val.port_a)
    annotation (Line(points={{10,0},{25,0},{40,0}}, color={0,127,255}));
  for i in 1:num loop
  connect(val[i].port_b, port_b)
    annotation (Line(points={{60,0},{80,0},{100,0}}, color={0,127,255}));
  connect(port_a, pum[i].port_a)
    annotation (Line(points={{-100,0},{-56,0},{-10,0}}, color={0,127,255}));
  end for;
  connect(pum.P, P)
    annotation (Line(points={{11,9},{20,9},{20,40},{110,40}},
      color={0,0,127}));
  connect(hys.u, u) annotation (Line(points={{-82,40},{-120,40}},
        color={0,0,127}));
  connect(hys.y, swi.u2) annotation (Line(points={{-58,40},{-52,40},{-52,-30},{
          -50,-30}},              color={255,0,255}));
  connect(zer.y, swi.u3)
    annotation (Line(points={{-68,-60},{-60,-60},{-60,-38},{-50,-38}},
                                                 color={0,0,127}));
  connect(one.y, swi.u1)
    annotation (Line(points={{-68,-22},{-50,-22}}, color={0,0,127}));
  connect(swi.y, val.y) annotation (Line(points={{-26,-30},{28,-30},{28,20},{50,
          20},{50,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-60,60},{60,40}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,-40},{60,-60}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-100,10},{-64,-10}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-30,80},{32,20}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,80},{0,20},{32,52},{0,80}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,58},{20,42}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Ellipse(
          extent={{-30,-20},{32,-80}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,-20},{0,-80},{32,-48},{0,-20}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{4,-42},{20,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199}),
        Rectangle(
          extent={{64,10},{100,-10}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Rectangle(
          extent={{-60,10},{60,-10}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={60,0},
          rotation=90),
        Rectangle(
          extent={{-60,10},{60,-10}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder,
          origin={-60,0},
          rotation=90)}),    Documentation(revisions="<html>
<ul>
<li>
March 1, 2023, by Michael Wetter:<br/>
Changed constants from <code>0</code> to <code>0.0</code> and <code>1</code> to <code>1.0</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/pull/3267#issuecomment-1450587671\">#3267</a>.
</li>
<li>
November 16, 2022, by Michael Wetter:<br/>
Improved sequence to avoid switching pump on when the valve is commanded off.
</li>
<li>
November 15, 2022, by Michael Wetter:<br/>
Set initial state of valve to be open, and changed rise time of valve to be the same as pump.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1659\">IBPSA, issue 1659</a>.
</li>
<li>
March 3, 2022, by Michael Wetter:<br/>
Moved <code>massDynamics</code> to <code>Advanced</code> tab and
added assertion for correct combination of energy and mass dynamics.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1542\">IBPSA, issue 1542</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">IBPSA, Buildings, #1341</a>.
</li>
<li>
September 2, 2017, by Michael Wetter:<br/>
Removed sign with hysteresis to avoid chattering.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>", info="<html>
<p>
Partial model for <code>num</code> parallel pumps, each with an isolation valve to
avoid recirculation.
</p>
</html>"));
end PartialPumpParallel;
