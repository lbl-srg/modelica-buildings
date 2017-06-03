within Buildings.ChillerWSE.BaseClasses;
partial model PartialParallelPlant
  "Partial source plant model with replaceable valves"
  extends Buildings.ChillerWSE.BaseClasses.PartialPlantParallelInterface;
  extends Buildings.Fluid.Actuators.BaseClasses.ValveParameters(
    final deltaM=(deltaM1+deltaM2)/2,
    final m_flow_nominal=(m1_flow_nominal+m2_flow_nominal)/2,
    final dpValve_nominal=(dpValve1_nominal+dpValve2_nominal)/2,
    final rhoStd=Medium1.density_pTX(101325, 273.15+4, Medium1.X_default));

  parameter Modelica.SIunits.PressureDifference dpValve1_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the valves"
    annotation(Dialog(group = "Nominal condition"));
  parameter Modelica.SIunits.PressureDifference dpValve2_nominal(
    min=0,
    displayUnit="Pa",
    fixed= if CvData==Buildings.Fluid.Types.CvTypes.OpPoint then true else false)=6000
    "Pressure difference for the valves"
    annotation(Dialog(group = "Nominal condition"));
  // Advanced
  parameter Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(Evaluate=true, Dialog(tab="Advanced"));

  // valve parameters
  parameter Real l[2](each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Valve"));
  parameter Real kFixed[2](each unit="", each min=0)=
    {m1_flow_nominal / sqrt(dp1_nominal),m2_flow_nominal / sqrt(dp2_nominal)}
    "Flow coefficient of fixed resistance that may be in series with valve 1, k=m_flow/sqrt(dp), with unit=(kg.m)^(1/2)."
   annotation(Dialog(group="Valve"));

  parameter Boolean use_inputFilter=true
    "= true, if opening is filtered with a 2nd order CriticalDamping filter"
    annotation(Dialog(tab="Dynamics", group="Valve"));
  parameter Modelica.SIunits.Time riseTimeValve=120
    "Rise time of the filter (time to reach 99.6 % of an opening step)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Modelica.Blocks.Types.Init initValve=Modelica.Blocks.Types.Init.InitialOutput
    "Type of initialization (no init/steady state/initial state/initial output)"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve1_start[n]=ones(n) "Initial value of output from valve 1"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));
  parameter Real yValve2_start[n]=ones(n) "Initial value of output from valve 2"
    annotation(Dialog(tab="Dynamics", group="Valve",enable=use_inputFilterValve));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2[n](
    redeclare each replaceable package Medium = Medium2,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_nominal=m2_flow_nominal,
    each final dpFixed_nominal=dp2_nominal,
    each final show_T=show_T,
    each final homotopyInitialization=homotopyInitialization,
    each final rhoStd=rhoStd,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final use_inputFilter=use_inputFilter,
    each final deltaM=deltaM2,
    each final l=l[2],
    each final kFixed=kFixed[2],
    final y_start=yValve2_start,
    each final dpValve_nominal=dpValve2_nominal,
    each final CvData=CvData,
    each final Kv=Kv,
    each final Cv=Cv,
    each final Av=Av,
    each final from_dp=from_dp2,
    each final linearized=linearizeFlowResistance2)
    "Valves on medium 2 side for on/off use" annotation (Placement(transformation(
        extent={{-10,10},{10,-10}},
        rotation=270,
        origin={-40,-32})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1[n](
    redeclare each replaceable package Medium = Medium1,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_nominal=m1_flow_nominal,
    each final dpFixed_nominal=dp1_nominal,
    each final show_T=show_T,
    each final homotopyInitialization=homotopyInitialization,
    each final rhoStd=rhoStd,
    each final use_inputFilter=use_inputFilter,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    final y_start=yValve1_start,
    each final deltaM=deltaM1,
    each final l=l[1],
    each final kFixed=kFixed[1],
    each final dpValve_nominal=dpValve1_nominal,
    each final CvData=CvData,
    each final Kv=Kv,
    each final Cv=Cv,
    each final Av=Av,
    each final from_dp=from_dp1,
    each final linearized=linearizeFlowResistance1)
    "Valves on medium 1 side for on/off use" annotation (
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
  connect(on, booToRea.u) annotation (Line(points={{-120,40},{-102,40},{-82,40}},
        color={255,0,255}));
  connect(booToRea.y, val1.y) annotation (Line(points={{-59,40},{-20,40},{20,40},
          {20,32},{28,32}}, color={0,0,127}));
  connect(booToRea.y, val2.y) annotation (Line(points={{-59,40},{-56,40},{-56,-32},
          {-52,-32}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
          Rectangle(extent={{-100,100},{100,-100}}, lineColor={0,0,255})}),
         Diagram(coordinateSystem(preserveAspectRatio=false)));
end PartialParallelPlant;
