within Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses;
partial model PartialPlantParallel
  "Partial source plant model with associated valves"
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.PartialPlantParallelInterface;
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.ValvesParameters(
    final numVal = 2,
    final m_flow_nominal = {m1_flow_nominal,m2_flow_nominal},
    rhoStd = {Medium1.density_pTX(101325, 273.15+4, Medium1.X_default),
            Medium2.density_pTX(101325, 273.15+4, Medium2.X_default)},
    final deltaM=deltaM1);
  extends Buildings.Applications.DataCenters.ChillerCooled.Equipment.BaseClasses.SignalFilter(
    final numFil=num);

  constant Boolean homotopyInitialization = true "= true, use homotopy method"
    annotation(HideResult=true);

  // Isolation valve parameters
  parameter Real l[2](each min=1e-10, each max=1) = {0.0001,0.0001}
    "Valve leakage, l=Kv(y=0)/Kv(y=1)"
    annotation(Dialog(group="Two-way valve"));

  Buildings.Fluid.Actuators.Valves.TwoWayLinear val2[num](
    redeclare each replaceable package Medium = Medium2,
    each final allowFlowReversal=allowFlowReversal2,
    each final m_flow_nominal=m2_flow_nominal,
    each dpFixed_nominal=dp2_nominal,
    each final show_T=show_T,
    each final homotopyInitialization=homotopyInitialization,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    each final use_inputFilter=true,
    each final deltaM=deltaM2,
    each final l=l[2],
    final y_start=yValve_start,
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final from_dp=from_dp2,
    each final linearized=linearizeFlowResistance2,
    each final rhoStd=rhoStd[2],
    each final dpValve_nominal=dpValve_nominal[2])
    "Isolation valves on medium 2 side for on/off use"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={-40,-32})));
  Buildings.Fluid.Actuators.Valves.TwoWayLinear val1[num](
    redeclare each replaceable package Medium = Medium1,
    each final allowFlowReversal=allowFlowReversal1,
    each final m_flow_nominal=m1_flow_nominal,
    each dpFixed_nominal=dp1_nominal,
    each final show_T=show_T,
    each final homotopyInitialization=homotopyInitialization,
    each final use_inputFilter=false,
    each final riseTime=riseTimeValve,
    each final init=initValve,
    final y_start=yValve_start,
    each final deltaM=deltaM1,
    each final l=l[1],
    each final dpValve_nominal=dpValve_nominal[1],
    each final CvData=Buildings.Fluid.Types.CvTypes.OpPoint,
    each final from_dp=from_dp1,
    each final linearized=linearizeFlowResistance1,
    each final rhoStd=rhoStd[1])
    "Isolation valves on medium 1 side for on/off use"
    annotation (
      Placement(transformation(
        extent={{10,10},{-10,-10}},
        rotation=270,
        origin={40,32})));

initial equation
  assert(homotopyInitialization, "In " + getInstanceName() +
    ": The constant homotopyInitialization has been modified from its default value. This constant will be removed in future releases.",
    level = AssertionLevel.warning);

equation
  for i in 1:num loop
    connect(val1[i].port_b, port_b1)
      annotation (Line(points={{40,42},{40,60},{100,60}}, color={0,127,255}));
    connect(val2[i].port_b, port_b2)
      annotation (Line(points={{-40,-42},{-40,-60},{-100,-60}},
        color={0,127,255}));
  end for;
  if use_inputFilter then
    connect(booToRea.y, filter.u)
      annotation (Line(points={{-67.4,40},{-60,40},{-60,84},{-55.2,84}},
        color={0,0,127}));
  else
    connect(booToRea.y, y_actual)
      annotation (Line(points={{-67.4,40},{-60,40},{-60,74},{-20,74}},
        color={0,0,127}));
  end if;
  connect(on, booToRea.u)
    annotation (Line(points={{-120,40},{-81.2,40},{-81.2,40}},
      color={255,0,255}));
  connect(y_actual, val1.y)
    annotation (Line(points={{-20,74},{-20,66},{20,66},
          {20,32},{28,32}},color={0,0,127}));
  connect(y_actual, val2.y)
    annotation (Line(points={{-20,74},{-20,-32},{-28,-32}}, color={0,0,127}));
  annotation (    Documentation(info="<html>
<p>
Partial model that can be extended to construct parallel chillers such as
<a href=\"modelica://Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel\">
Buildings.Applications.BaseClasses.Equipment.ElectricChillerParallel</a>
and water-side economizers <a href=\"modelica://Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer\">
Buildings.Applications.DataCenters.ChillerCooled.Equipment.WatersideEconomizer</a>.
</p>
<p>
The associated valve group <code>val1</code> and <code>val2</code>
on <code>medium 1</code> and <code>medium 2</code> side are for on/off use only.
The number of valves in each group is specified by the parameter <code>n</code>.
The valve parameters can be specified differently.
</p>
<p>
The signal filter is used to smoothe the on/off signal for the valves.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 4, 2024, by Jianjun Hu:<br/>
Added input filter to the isolation valve 2.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3989\">issue 3989</a>.
</li>
<li>
April 14, 2020, by Michael Wetter:<br/>
Changed <code>homotopyInitialization</code> to a constant.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1341\">Buildings, #1341</a>.
</li>
<li>
June 30, 2017, by Yangyang Fu:<br/>
First implementation.
</li>
</ul>
</html>"));
end PartialPlantParallel;
