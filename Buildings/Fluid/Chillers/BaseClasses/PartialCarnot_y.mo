within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialCarnot_y
  "Partial chiller model with performance curve adjusted based on Carnot efficiency"
  extends Carnot(
    final QCon_flow_nominal= P_nominal - QEva_flow_nominal,
    final QEva_flow_nominal = if COP_is_for_cooling
      then -P_nominal * COP_nominal
      else -P_nominal * (COP_nominal-1));
 extends Interfaces.FourPortHeatMassExchanger(
   m1_flow_nominal = QCon_flow_nominal/cp1_default/dTCon_nominal,
   m2_flow_nominal = QEva_flow_nominal/cp2_default/dTEva_nominal,
   T1_start = TEva_nominal,
   T2_start = TCon_nominal,
   vol1(prescribedHeatFlowRate = true),
   redeclare final Buildings.Fluid.MixingVolumes.MixingVolume vol2(
     prescribedHeatFlowRate = true));
   // Above, we use -abs(dTEva_nominal) because in Buildings 2.1,
   // dTEva_nominal was a positive quantity.

  parameter Modelica.SIunits.Power P_nominal
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    "Part load ratio of compressor"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

protected
  final parameter Modelica.SIunits.SpecificHeatCapacity cp1_default=
    Medium1.specificHeatCapacityCp(Medium1.setState_pTX(
      p=  Medium1.p_default,
      T=  Medium1.T_default,
      X=  Medium1.X_default))
    "Specific heat capacity of medium 1 at default medium state";
  final parameter Modelica.SIunits.SpecificHeatCapacity cp2_default=
    Medium2.specificHeatCapacityCp(Medium2.setState_pTX(
      p=  Medium2.p_default,
      T=  Medium2.T_default,
      X=  Medium2.X_default))
    "Specific heat capacity of medium 2 at default medium state";

  // State are calculated according to the design condition, as using the Carnot machine
  // in reverse flow is not meaningful.
  Medium1.ThermodynamicState staA1 = Medium1.setState_phX(
    port_a1.p,
    inStream(port_a1.h_outflow),
    inStream(port_a1.Xi_outflow)) "Medium properties in port_a1";
  Medium1.ThermodynamicState staB1 = Medium1.setState_phX(
    port_b1.p,
    port_b1.h_outflow,
    port_b1.Xi_outflow) "Medium properties in port_b1";
  Medium2.ThermodynamicState staA2 = Medium2.setState_phX(
    port_a2.p,
    inStream(port_a2.h_outflow),
    inStream(port_a2.Xi_outflow)) "Medium properties in port_a2";
  Medium2.ThermodynamicState staB2 = Medium2.setState_phX(
    port_b2.p,
    port_b2.h_outflow,
    port_b2.Xi_outflow) "Medium properties in port_b2";

  Modelica.SIunits.HeatFlowRate QCon_flow_internal(start=QCon_flow_nominal)=
    P - QEva_flow_internal "Condenser heat input";
  Modelica.SIunits.HeatFlowRate QEva_flow_internal(start=QEva_flow_nominal)=
    if COP_is_for_cooling then -COP * P else (1-COP)*P "Evaporator heat input";

  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloEva
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,-50},{-19,-30}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFloCon
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-39,30},{-19,50}})));
  Modelica.Blocks.Sources.RealExpression QEva_flow_in(y=QEva_flow_internal)
    "Evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression QCon_flow_in(y=QCon_flow_internal)
    "Condenser heat flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Modelica.Blocks.Math.Gain PEle(final k=P_nominal)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation
  // Set temperatures that will be used to compute Carnot efficiency
  if effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TCon = Medium1.temperature(staA1);
  elseif effInpCon == Buildings.Fluid.Types.EfficiencyInput.port_b or
         effInpCon == Buildings.Fluid.Types.EfficiencyInput.volume then
    TCon = Medium1.temperature(staB1);
  else
    TCon = 0.5 * (Medium1.temperature(staA1)+Medium1.temperature(staB1));
  end if;

  if effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_a then
    TEva = Medium2.temperature(staA2);
  elseif effInpEva == Buildings.Fluid.Types.EfficiencyInput.port_b or
         effInpEva == Buildings.Fluid.Types.EfficiencyInput.volume then
    TEva = Medium2.temperature(staB2);
  else
    TEva = 0.5 * (Medium2.temperature(staA2)+Medium2.temperature(staB2));
  end if;

  connect(QCon_flow_in.y, preHeaFloCon.Q_flow) annotation (Line(
      points={{-59,40},{-39,40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloCon.port, vol1.heatPort) annotation (Line(
      points={{-19,40},{-10,40},{-10,60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(QEva_flow_in.y, preHeaFloEva.Q_flow) annotation (Line(
      points={{-59,-40},{-39,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(preHeaFloEva.port, vol2.heatPort) annotation (Line(
      points={{-19,-40},{12,-40},{12,-60}},
      color={191,0,0},
      smooth=Smooth.None));
  connect(PEle.y, P)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(PEle.u, y) annotation (Line(points={{58,0},{58,0},{40,0},{40,90},{-92,
          90},{-92,90},{-120,90}}, color={0,0,127}));
  connect(QCon_flow, QCon_flow_in.y) annotation (Line(points={{110,90},{60,90},
          {60,86},{-50,86},{-50,40},{-59,40}}, color={0,0,127}));
  connect(QEva_flow, QEva_flow_in.y) annotation (Line(points={{110,-90},{44,-90},
          {-50,-90},{-50,-40},{-59,-40}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=true, extent={{-100,
            -100},{100,100}}), graphics={
        Rectangle(
          extent={{-56,68},{58,50}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,-52},{58,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,64},{98,54}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-2,54},{98,64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,-56},{100,-66}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-66},{0,-56}},
          lineColor={0,0,127},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,-12},{-32,-12},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,0},{-52,10},{-32,10},{-42,0}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,50},{-40,10}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-44,-12},{-40,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{38,50},{42,-52}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{18,22},{62,-20}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{40,22},{22,-10},{58,-10},{40,22}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-130,128},{-78,106}},
          lineColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(extent={{66,28},{116,14}},   textString="P",
          lineColor={0,0,127}),
        Line(points={{-100,90},{-80,90},{-80,14},{22,14}},
                                                    color={0,0,255}),
        Line(points={{62,0},{100,0}},                 color={0,0,255})}),
defaultComponentName="chi",
Documentation(info="<html>
<p>
This is a partial model of a chiller whose coefficient of performance (COP) changes
with temperatures in the same way as the Carnot efficiency changes.
This base class is used for the Carnot chiller and Carnot heat pump
that uses the leaving fluid temperature as the control signal.
</p>
</html>",
revisions="<html>
<ul>
<li>
January 26, 2016, by Michael Wetter:<br/>
Implemented in the Annex 60 library the models
<a href=\"modelica://Buildings.Fluid.Chillers.Carnot_y\">Buildings.Fluid.Chillers.Carnot_y</a>
and
<a href=\"modelica://Buildings.Fluid.HeatPumps.Carnot_y\">Buildings.Fluid.HeatPumps.Carnot_y</a>
and refactored these models to use the same base class.<br/>
Implemented the removal of the flow direction dependency of
<code>staA1</code>, <code>staB1</code>, <code>staA2</code> and <code>staB2</code> as the
efficiency of the Carnot machine should only be computed in the design flow direction,
as corrected by Damien Picard.
</li>
<li>
December 18, 2015, by Michael Wetter:<br/>
Corrected wrong computation of <code>staB1</code> and <code>staB2</code>
which mistakenly used the <code>inStream</code> operator
for the configuration without flow reversal.
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/476\">
issue 476</a>.
</li>
<li>
November 25, 2015 by Michael Wetter:<br/>
Changed sign convention for <code>dTEva_nominal</code> to be consistent with
other models.
The model will still work with the old values for <code>dTEva_nominal</code>,
but it will write a warning so that users can transition their models.
<br/>
Corrected <code>assert</code> statement for the efficiency curve.
This is for
<a href=\"modelica://https://github.com/lbl-srg/modelica-buildings/issues/468\">
issue 468</a>.
</li>
<li>
September 3, 2015 by Michael Wetter:<br/>
Expanded documentation.
</li>
<li>
May 6, 2015 by Michael Wetter:<br/>
Added <code>prescribedHeatFlowRate=true</code> for <code>vol2</code>.
</li>
<li>
October 9, 2013 by Michael Wetter:<br/>
Reimplemented the computation of the port states to avoid using
the conditionally removed variables <code>sta_a1</code>,
<code>sta_a2</code>, <code>sta_b1</code> and <code>sta_b2</code>.
</li>
<li>
May 10, 2013 by Michael Wetter:<br/>
Added electric power <code>P</code> as an output signal.
</li>
<li>
October 11, 2010 by Michael Wetter:<br/>
Fixed bug in energy balance.
</li>
<li>
March 3, 2009 by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,-100},{
            100,100}})));
end PartialCarnot_y;
