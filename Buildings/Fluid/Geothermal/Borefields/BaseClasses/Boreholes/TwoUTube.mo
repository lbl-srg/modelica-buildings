within Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes;
model TwoUTube "Double U-tube borehole heat exchanger"
  extends Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.PartialBorehole;

  Buildings.Fluid.Geothermal.Borefields.BaseClasses.Boreholes.BaseClasses.InternalHEXTwoUTube
    intHex[nSeg](
    redeclare each final package Medium = Medium,
    each final borFieDat=borFieDat,
    each final hSeg=borFieDat.conDat.hBor/nSeg,
    final dp1_nominal={if i == 1 and borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then dp_nominal elseif i == 1 and borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries
         then dp_nominal/2 else 0 for i in 1:nSeg},
    final dp3_nominal={if i == 1 and borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then dp_nominal elseif i == 1 and borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries
         then dp_nominal/2 else 0 for i in 1:nSeg},
    each final dp2_nominal=0,
    each final dp4_nominal=0,
    each final show_T=show_T,
    each final energyDynamics=energyDynamics,
    each final m1_flow_nominal=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then m_flow_nominal/2 else m_flow_nominal,
    each final m2_flow_nominal=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then m_flow_nominal/2 else m_flow_nominal,
    each final m3_flow_nominal=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then m_flow_nominal/2 else m_flow_nominal,
    each final m4_flow_nominal=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then m_flow_nominal/2 else m_flow_nominal,
    each final m1_flow_small=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,
    each final m2_flow_small=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,
    each final m3_flow_small=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,
    each final m4_flow_small=if borFieDat.conDat.borCon == Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel
         then borFieDat.conDat.mBor_flow_small/2 else borFieDat.conDat.mBor_flow_small,
    each final mSenFac=mSenFac,
    each final allowFlowReversal1=allowFlowReversal,
    each final allowFlowReversal2=allowFlowReversal,
    each final allowFlowReversal3=allowFlowReversal,
    each final allowFlowReversal4=allowFlowReversal,
    each final from_dp1=from_dp,
    each final linearizeFlowResistance1=linearizeFlowResistance,
    each final deltaM1=deltaM,
    each final from_dp2=from_dp,
    each final linearizeFlowResistance2=linearizeFlowResistance,
    each final deltaM2=deltaM,
    each final from_dp3=from_dp,
    each final linearizeFlowResistance3=linearizeFlowResistance,
    each final deltaM3=deltaM,
    each final from_dp4=from_dp,
    each final linearizeFlowResistance4=linearizeFlowResistance,
    each final deltaM4=deltaM,
    each final p1_start=p_start,
    each final p2_start=p_start,
    each final p3_start=p_start,
    each final p4_start=p_start,
    final TFlu_start=TFlu_start,
    final TGro_start=TGro_start) "Discretized borehole segments"
    annotation (Placement(transformation(extent={{-10,-30},{10,10}})));

equation
  // Couple borehole port_a and port_b to first borehole segment.
  connect(port_a, intHex[1].port_a1) annotation (Line(
      points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,6},{-10,6}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(port_b, intHex[1].port_b4) annotation (Line(
      points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-27},
          {-10,-27}},
      color={0,127,255},
      smooth=Smooth.None));
  if borFieDat.conDat.borCon == Types.BoreholeConfiguration.DoubleUTubeParallel then
    // 2U-tube in parallel: couple both U-tube to each other.
    connect(port_a, intHex[1].port_a3) annotation (Line(
        points={{-100,5.55112e-016},{-52,5.55112e-016},{-52,-16.4},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(port_b, intHex[1].port_b2) annotation (Line(
        points={{100,5.55112e-016},{28,5.55112e-016},{28,-40},{-32,-40},{-32,-4},
            {-10,-4}},
        color={0,127,255},
        smooth=Smooth.None));
  elseif borFieDat.conDat.borCon == Types.BoreholeConfiguration.DoubleUTubeSeries then
    // 2U-tube in serie: couple both U-tube to each other.
    connect(intHex[1].port_b2, intHex[1].port_a3) annotation (Line(
        points={{-10,-4},{-24,-4},{-24,-16},{-18,-16},{-18,-16.4},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
  end if;

  // Couple each layer to the next one
  for i in 1:nSeg - 1 loop
    connect(intHex[i].port_b1, intHex[i + 1].port_a1) annotation (Line(
        points={{10,6},{10,10},{-10,10},{-10,6}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[i].port_a2, intHex[i + 1].port_b2) annotation (Line(
        points={{10,-4},{10,0},{-10,0},{-10,-4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[i].port_b3, intHex[i + 1].port_a3) annotation (Line(
        points={{10,-16.2},{10,-12},{-10,-12},{-10,-16.4}},
        color={0,127,255},
        smooth=Smooth.None));
    connect(intHex[i].port_a4, intHex[i + 1].port_b4) annotation (Line(
        points={{10,-26},{10,-22},{-10,-22},{-10,-27}},
        color={0,127,255},
        smooth=Smooth.None));
  end for;

  // Close U-tube at bottom layer
  connect(intHex[nSeg].port_b1, intHex[nSeg].port_a2)
    annotation (Line(
      points={{10,6},{16,6},{16,-4},{10,-4}},
      color={0,127,255},
      smooth=Smooth.None));
  connect(intHex[nSeg].port_b3, intHex[nSeg].port_a4)
    annotation (Line(
      points={{10,-16.2},{14,-16.2},{14,-16},{18,-16},{18,-26},{10,-26}},
      color={0,127,255},
      smooth=Smooth.None));

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
          extent={{58,88},{50,-92}},
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
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{22,88},{14,-92}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,88},{-18,-92}},
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
          textString=""), Text(
          extent={{50,-32},{90,-38}},
          textColor={0,0,255},
          textString="")}),
    Documentation(info="<html>
<p>
Model of a double U-tube borehole heat exchanger.
The borehole heat exchanger is vertically discretized into
<i>n<sub>seg</sub></i> elements of height
<i>h=h<sub>Bor</sub>&frasl;n<sub>seg</sub></i>.
Each segment contains a model for the heat transfer in the borehole,
with a uniform borehole wall boundary temperature given by the
<code>port_wall</code> port.
</p>
<p>
The heat transfer in the borehole is computed using a convective heat transfer
coefficient that depends on the fluid velocity, a heat resistance between each
pair of pipes, and a heat resistance between the pipes and the borehole wall.
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
end TwoUTube;
