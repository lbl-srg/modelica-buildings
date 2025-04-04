within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes;
model OneUTube "Single U-tube borehole heat exchanger"
  extends Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole;

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXOneUTube
    intHex[nSeg](
    redeclare each final package Medium = Medium,
    each final hSeg=borFieDat.conDat.hBor/nSeg,
    each final from_dp1=from_dp,
    each final from_dp2=from_dp,
    each final linearizeFlowResistance1=linearizeFlowResistance,
    each final linearizeFlowResistance2=linearizeFlowResistance,
    each final deltaM1=deltaM,
    each final deltaM2=deltaM,
    each final energyDynamics=energyDynamics,
    each final mSenFac=mSenFac,
    final dp1_nominal={if i == 1 then dp_nominal else 0 for i in 1:nSeg},
    each final dp2_nominal=0,
    each final m1_flow_nominal=m_flow_nominal,
    each final m2_flow_nominal=m_flow_nominal,
    each final borFieDat=borFieDat,
    each final allowFlowReversal1=allowFlowReversal,
    each final allowFlowReversal2=allowFlowReversal,
    each final show_T=show_T,
    each final p1_start=p_start,
    each final p2_start=p_start,
    final TFlu_start=TFlu_start,
    final TGro_start=TGro_start) "Borehole segments"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

equation
  connect(port_a, intHex[1].port_a1) annotation (Line(
      points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, intHex[1].port_b2) annotation (Line(
      points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-6},{
          -10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHex[nSeg].port_b1, intHex[nSeg].port_a2)
    annotation (Line(
      points={{10,6},{20,6},{20,-6},{10,-6}},
      color={0,127,255},
      smooth=Smooth.None));
  for i in 1:nSeg - 1 loop
    connect(intHex[i].port_b1, intHex[i + 1].port_a1) annotation (Line(
        points={{10,6},{10,20},{-10,20},{-10,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[i].port_a2, intHex[i + 1].port_b2) annotation (Line(
        points={{10,-6},{10,-20},{-10,-20},{-10,-6}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;
  connect(intHex.port_wall, port_wall)
    annotation (Line(points={{0,10},{0,10},{0,100}}, color={191,0,0}));
  annotation (
    defaultComponentName="borHol",
    Icon(coordinateSystem(
        preserveAspectRatio=true,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={
        Rectangle(
          extent={{56,88},{48,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-52,-92},{-44,88}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-50,-84},{56,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}},
        grid={2,2},
        initialScale=0.5), graphics={Text(
          extent={{60,72},{84,58}},
          textColor={0,0,255},
          textString="")}),
    Documentation(info="<html>
<p>
Model of a single U-tube borehole heat exchanger.
The borehole heat exchanger is vertically discretized into
<i>n<sub>seg</sub></i> elements of height
<i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
Each segment contains a model for the heat transfer in the borehole,
with a uniform borehole wall boundary temperature given by the
<code>port_wall</code> port.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer
coefficient that depends on the fluid velocity, a heat resistance between the
two pipes, and a heat resistance between the pipes and the borehole wall.
The heat capacity of the fluid and the heat capacity of the grout are taken
into account. The vertical heat flow is assumed to be zero.
</p>
</html>", revisions="<html>
<ul>
<li>
May 17, 2024, by Michael Wetter:<br/>
Updated model due to removal of parameter <code>dynFil</code>.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1885\">IBPSA, #1885</a>.
</li>
<li>
July 2018, by Alex Laferri&egrave;re:<br/>
Following major changes to the structure of the Buildings.Fluid.HeatExchangers.Ground package,
the documentation has been changed to reflect the new role of this model.
Additionally, this model now extends a partial borehole model.
</li>
<li>
July 2014, by Damien Picard:<br/>
First implementation.
</li>
</ul>
</html>"));
end OneUTube;
