within Buildings.Fluid.HeatExchangers.BaseClasses;
model DuctManifoldFlowDistributor
  "Manifold for duct inlet that distributes the mass flow rate equally"
  extends PartialDuctManifold;

  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal
    "Mass flow rate at port_a" annotation (Dialog(group="Nominal Condition"));

protected
  Sensors.MassFlowRate senMasFlo(redeclare final package Medium = Medium)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));

  Modelica.Blocks.Math.Gain gain(final k=1/nPipPar/nPipSeg)
    "Gain for mass flow distribution to manifold"
    annotation (Placement(transformation(extent={{-20,60},{0,80}})));

  Modelica.Blocks.Sources.Constant dpDis(final k=0)
    "Pressure drop of distribution"
    annotation (Placement(transformation(extent={{-20,20},{0,40}})));

  Movers.BaseClasses.IdealSource sou0(
    redeclare final package Medium = Medium,
    allowFlowReversal=allowFlowReversal,
    m_flow_small=1E-4*abs(m_flow_nominal/nPipPar/nPipSeg),
    final control_m_flow=false,
    m_flow_start=mStart_flow_a/nPipPar/nPipSeg,
    final dp_start=0,
    final show_V_flow=false,
    final show_T=false) "Mass flow rate source with fixed dp"
    annotation (Placement(transformation(extent={{0,-10},{20,10}})));

  Movers.BaseClasses.IdealSource sou1[nPipPar-1](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=1E-4*abs(m_flow_nominal/nPipPar/nPipSeg),
    each final control_m_flow=true,
    each m_flow_start=mStart_flow_a/nPipPar/nPipSeg,
    each final show_V_flow=false,
    each final show_T=false) "Mass flow rate source with fixed m_flow"
    annotation (Placement(transformation(extent={{20,-40},{40,-20}})));

  Movers.BaseClasses.IdealSource sou2[nPipPar,nPipSeg-1](
    redeclare each final package Medium = Medium,
    each final allowFlowReversal=allowFlowReversal,
    each final m_flow_small=1E-4*abs(m_flow_nominal/nPipPar/nPipSeg),
    each final control_m_flow=true,
    each m_flow_start=mStart_flow_a/nPipPar/nPipSeg,
    each final show_V_flow=false,
    each final show_T=false) "Mass flow rate source with fixed m_flow"
    annotation (Placement(transformation(extent={{40,-72},{60,-52}})));
equation
  connect(port_a, senMasFlo.port_a) annotation (Line(
      points={{-100,0},{-60,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(senMasFlo.m_flow, gain.u) annotation (Line(
      points={{-50,11},{-50,70},{-22,70}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connect the model that imposes zero pressure drop in the manifold
  connect(senMasFlo.port_b, sou0.port_a) annotation (Line(
      points={{-40,0},{0,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(sou0.port_b, port_b[1, 1]) annotation (Line(
      points={{20,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(dpDis.y, sou0.dp_in) annotation (Line(
      points={{1,30},{16,30},{16,8}},
      color={0,0,127},
      smooth=Smooth.None));

  // Connect the models that impose the mass flow rates
  for i in 1:nPipPar-1 loop
      connect(senMasFlo.port_b, sou1[i].port_a) annotation (Line(
      points={{-40,0},{-20,0},{-20,-30},{20,-30}},
      color={0,127,255},
      smooth=Smooth.None));
      connect(sou1[i].port_b, port_b[i+1, 1]) annotation (Line(
      points={{40,-30},{80,-30},{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
      connect(gain.y, sou1[i].m_flow_in) annotation (Line(
      points={{1,70},{24,70},{24,-22}},
      color={0,0,127},
      smooth=Smooth.None));
    end for;

  for i in 1:nPipPar loop
    for j in 1:nPipSeg-1 loop
      connect(senMasFlo.port_b, sou2[i, j].port_a) annotation (Line(
      points={{-40,0},{-20,0},{-20,-62},{40,-62}},
      color={0,127,255},
      smooth=Smooth.None));
      connect(sou2[i, j].port_b, port_b[i, j+1]) annotation (Line(
      points={{60,-62},{80,-62},{80,0},{100,0}},
      color={0,127,255},
      smooth=Smooth.None));
      connect(gain.y, sou2[i, j].m_flow_in) annotation (Line(
      points={{1,70},{44,70},{44,-54}},
      color={0,0,127},
      smooth=Smooth.None));
    end for;
  end for;
annotation (Documentation(info="<html>
<p>
This model distributes the mass flow rates equally between all instances
of <code>port_b</code>.
</p>
<p>
The model connects the flows between the ports without
modeling flow friction.
The model is used in conjunction with
a manifold that
is added to the other side of the heat exchanger registers.
</p>
<p>
<b>Note:</b> It is important that there is an equal pressure drop
in each flow leg between this model, and the model that collects the flows.
Otherwise, no solution may exist. Hence, only use this model if you know
what you are doing.
</p>
</html>",
revisions="<html>
<ul>
<li>
November 8, 2016, by Michael Wetter:<br/>
Removed wrong usage of <code>each</code> keyword.
</li>
<li>
November 13, 2014, by Michael Wetter:<br/>
Rewrote the model to make it compile in OpenModelica.
</li>
<li>
August 10, 2014, by Michael Wetter:<br/>
Reformulated the multiple iterators in the <code>sum</code> function
as this language construct is not supported in OpenModelica.
</li>
<li>
June 29, 2014, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{100,100}}),
        graphics={
        Polygon(
          points={{26,48},{50,72},{54,72},{30,48},{26,48}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{26,-12},{50,12},{54,12},{30,-12},{26,-12}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255}),
        Polygon(
          points={{26,-72},{50,-48},{54,-48},{30,-72},{26,-72}},
          lineColor={0,0,255},
          smooth=Smooth.None,
          fillPattern=FillPattern.Solid,
          fillColor={0,0,255})}));
end DuctManifoldFlowDistributor;
