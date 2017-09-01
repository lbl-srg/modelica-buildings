within Buildings.ChillerWSE.BaseClasses;
partial model PartialPumpParallel "Partial model for pump parallel"

  extends Buildings.Fluid.Interfaces.PartialTwoPortInterface;
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters;

  replaceable parameter Buildings.Fluid.Movers.Data.Generic per[num]
    constrainedby Buildings.Fluid.Movers.Data.Generic
    "Record with performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{70,64},{90,84}})));
 // Pump parameters
  parameter Integer num=2 "The number of pumps";
  parameter Boolean addPowerToMedium=true
    "Set to false to avoid any power (=heat and flow work) being added to medium (may give simpler equations)"
    annotation(Dialog(group="Pump"));
  parameter Modelica.SIunits.Time tau = 30
    "Time constant at nominal flow (if energyDynamics <> SteadyState)"
     annotation (Dialog(tab = "Dynamics", group="Pump"));
  parameter Boolean use_inputFilter=true
    "= true, if speed is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Pump"));
  parameter Modelica.SIunits.Time riseTimePump=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Modelica.Blocks.Types.Init init=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));
  parameter Real[num] yPump_start=fill(0,num) "Initial value of pump signals"
    annotation(Dialog(tab="Dynamics", group="Pump",enable=use_inputFilter));

   // Valve parameters
  parameter Real l=0.0001 "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Shutoff valve"));
  parameter Real kFixed=m_flow_nominal/sqrt(dpValve_nominal)
    "Flow coefficient of fixed resistance that may be in series with valve, 
    k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Shutoff valve"));
  parameter Modelica.SIunits.Time riseTimeValve=30
    "Rise time of the filter (time to reach 99.6 % of the speed)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilter));
  parameter Real[num] yValve_start = fill(0,num)
    "Initial value of pump signals"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilter));

  // Dynamics
  parameter Modelica.Fluid.Types.Dynamics energyDynamics=Modelica.Fluid.Types.Dynamics.DynamicFreeInitial
    "Type of energy balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));
  parameter Modelica.Fluid.Types.Dynamics massDynamics=energyDynamics
    "Type of mass balance: dynamic (3 initialization options) or steady state"
    annotation(Evaluate=true, Dialog(tab = "Dynamics", group="Equations"));

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
  parameter Boolean homotopyInitialization=true
    "= true, use homotopy method"
    annotation (Evaluate=true, Dialog(tab="Flow resistance"));
  parameter Boolean linearizeFlowResistance = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Dialog(tab="Flow resistance"));
  parameter Real threshold(min = 1e-6) = 1e-6
    "Output signal y is true, if input u >= threshold";
  Modelica.Blocks.Interfaces.RealInput u[num]
    "Continuous input signal for the flow machine"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),
      iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealOutput P[num](
    final quantity="Power",
    final unit="W")
    "Electrical power consumed by the pumps"
    annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
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
    final y_start= yPump_start,
    each final energyDynamics=energyDynamics,
    each final massDynamics=massDynamics,
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
    each final kFixed=kFixed,
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
    "Shutoff valves"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.ChillerWSE.BaseClasses.Sign uVal[num](
    each final u1=1,
    each final u2=0,
    each final threshold=threshold)
    "Signal for shutoff valves"
    annotation (Placement(transformation(extent={{-60,50},{-40,70}})));
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
  connect(u, uVal.u) annotation (Line(points={{-120,40},{-80,40},{-80,60},{-62,60}},
        color={0,0,127}));
  connect(uVal.y, val.y)
    annotation (Line(points={{-39,60},{50,60},{50,12}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,16},{100,-14}},
          lineColor={0,0,0},
          fillColor={0,127,255},
          fillPattern=FillPattern.HorizontalCylinder),
        Ellipse(
          extent={{-58,52},{58,-58}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          fillColor={0,100,199}),
        Polygon(
          points={{0,50},{0,-58},{58,-2},{0,50}},
          lineColor={0,0,0},
          pattern=LinePattern.None,
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={255,255,255}),
        Ellipse(
          extent={{0,12},{30,-18}},
          lineColor={0,0,0},
          fillPattern=FillPattern.Sphere,
          visible=energyDynamics <> Modelica.Fluid.Types.Dynamics.SteadyState,
          fillColor={0,100,199})}),                              Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(revisions="<html>
<ul>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPumpParallel;
