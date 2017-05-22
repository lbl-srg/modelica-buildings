within Buildings.ChillerWSE.BaseClasses;
partial model PartialParallelPlant
  "Partial source plant model with replaceable valves"
  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.Interfaces.FourPortFlowResistanceParameters(
     final computeFlowResistance1=true,
     final computeFlowResistance2=true);

  parameter Integer n(min=1)=2 "Number of identical plants";

  parameter Modelica.SIunits.PressureDifference dpValve1_nominal(min=0,displayUnit="Pa")
    "Pressure difference for the valve on Medium 1 side"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve2_nominal(min=0,displayUnit="Pa")
    "Pressure difference for the valve on Medium 2 side"
    annotation(Dialog(group = "Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // valve parameters
  parameter Real l1(min=1e-10, max=1) = 0.0001
    "Valve 1 leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real kFixed1(unit="", min=0) = if dp1_nominal > Modelica.Constants.eps
   then m1_flow_nominal / sqrt(dp1_nominal) else 0
    "Flow coefficient of fixed resistance that may be in series with valve 1, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));
  parameter Real l2(min=1e-10, max=1) = 0.0001
    "Valve 2 leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real kFixed2(unit="", min=0) = if dp2_nominal > Modelica.Constants.eps
   then m2_flow_nominal / sqrt(dp2_nominal) else 0
    "Flow coefficient of fixed resistance that may be in series with valve 2, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
    annotation(Dialog(group="Valve"));
  parameter Real deltaM = 0.02
    "Fraction of nominal flow rate where linearization starts, if y=1"
    annotation(Dialog(group="Valve"));
  parameter Boolean from_dp = false
    "= true, use m_flow = f(dp) else dp = f(m_flow)"
    annotation (Evaluate=true, Dialog(tab="Advanced",group="Valve"));
  parameter Boolean linearized = false
    "= true, use linear relation between m_flow and dp for any flow rate"
    annotation(Evaluate=true, Dialog(tab="Advanced",group="Valve"));
  parameter Modelica.SIunits.Density rhoStd=Medium1.density_pTX(101325, 273.15+4, Medium1.X_default)
    "Inlet density for which valve coefficients are defined"
  annotation(Dialog(group="Valve", tab="Advanced"));
  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.SIunits.Time riseTimeValve=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve1_start=1 "Initial value of output from valve 1"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve2_start=1 "Initial value of output from valve 2"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));

  replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv val2[n](
    redeclare each replaceable package Medium = Medium2,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_nominal=m2_flow_nominal,
    each final dpFixed_nominal=dp2_nominal,
    each final show_T=show_T,
    each final dpValve_nominal=dpValve2_nominal,
    each final deltaM=deltaM,
    each final from_dp=from_dp,
    each final homotopyInitialization=homotopyInitialization,
    each final linearized=linearized,
    each final rhoStd=rhoStd,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final y_start=yValve2_start,
    each final use_inputFilter=use_inputFilter,
    each final l=l2,
    each final kFixed=kFixed2)
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv
    "Valves on medium 2 side" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-32})));
  replaceable Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv val1[n](
    redeclare each replaceable package Medium = Medium1,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_nominal=m1_flow_nominal,
    each final dpFixed_nominal=dp1_nominal,
    each final show_T=show_T,
    each final dpValve_nominal=dpValve1_nominal,
    each final deltaM=deltaM,
    each final from_dp=from_dp,
    each final homotopyInitialization=homotopyInitialization,
    each final linearized=linearized,
    each final rhoStd=rhoStd,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final y_start=yValve1_start,
    each final l=l1,
    each final kFixed=kFixed1)
    constrainedby Buildings.Fluid.Actuators.BaseClasses.PartialTwoWayValveKv
    "Valves on medium 1 side" annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={40,32})));

equation
  for i in 1:n loop
    connect(val1[i].port_b, port_b1)
      annotation (Line(points={{40,42},{40,60},{100,60}}, color={0,127,255}));
    connect(val2[i].port_b, port_b2) annotation (Line(points={{-40,-42},{-40,-60},
            {-100,-60}}, color={0,127,255}));
  end for;
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialParallelPlant;
