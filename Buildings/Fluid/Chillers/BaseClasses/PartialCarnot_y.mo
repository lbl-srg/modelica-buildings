within Buildings.Fluid.Chillers.BaseClasses;
partial model PartialCarnot_y
  "Partial chiller model with performance curve adjusted based on Carnot efficiency"
  extends Carnot(
    final QCon_flow_nominal= P_nominal - QEva_flow_nominal,
    final QEva_flow_nominal = if COP_is_for_cooling
                              then -P_nominal * COP_nominal
                              else -P_nominal * (COP_nominal-1),
    redeclare HeatExchangers.HeaterCooler_u con(
      final from_dp=from_dp1,
      final dp_nominal=dp1_nominal,
      final linearizeFlowResistance=linearizeFlowResistance1,
      final deltaM=deltaM1,
      final tau=tau1,
      final T_start=T1_start,
      final energyDynamics=energyDynamics,
      final homotopyInitialization=homotopyInitialization,
      final Q_flow_nominal=QCon_flow_nominal),
      redeclare HeatExchangers.HeaterCooler_u eva(
      final from_dp=from_dp2,
      final dp_nominal=dp2_nominal,
      final linearizeFlowResistance=linearizeFlowResistance2,
      final deltaM=deltaM2,
      final tau=tau2,
      final T_start=T2_start,
      final energyDynamics=energyDynamics,
      final homotopyInitialization=homotopyInitialization,
      final Q_flow_nominal=QEva_flow_nominal));

  parameter Modelica.Units.SI.Power P_nominal(min=0)
    "Nominal compressor power (at y=1)"
    annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Interfaces.RealInput y(min=0, max=1, unit="1")
    "Part load ratio of compressor"
    annotation (Placement(transformation(extent={{-140,70},{-100,110}})));

protected
  Modelica.Units.SI.HeatFlowRate QCon_flow_internal(start=QCon_flow_nominal) =
    P - QEva_flow_internal "Condenser heat input";
  Modelica.Units.SI.HeatFlowRate QEva_flow_internal(start=QEva_flow_nominal) =
    if COP_is_for_cooling then -COP*P else (1 - COP)*P "Evaporator heat input";

  Modelica.Blocks.Sources.RealExpression yEva_flow_in(
    y=QEva_flow_internal/QEva_flow_nominal)
    "Normalized evaporator heat flow rate"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));
  Modelica.Blocks.Sources.RealExpression yCon_flow_in(
    y=QCon_flow_internal/QCon_flow_nominal)
    "Normalized condenser heat flow rate"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));

  Modelica.Blocks.Math.Gain PEle(final k=P_nominal)
    "Electrical power consumption"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));
equation

  connect(PEle.y, P)
    annotation (Line(points={{81,0},{110,0}}, color={0,0,127}));
  connect(PEle.u, y) annotation (Line(points={{58,0},{58,0},{40,0},{40,90},{-92,
          90},{-120,90}},          color={0,0,127}));
  connect(yEva_flow_in.y, eva.u) annotation (Line(points={{-59,-40},{20,-40},{20,
          -54},{12,-54}}, color={0,0,127}));
  connect(yCon_flow_in.y, con.u) annotation (Line(points={{-59,40},{-48,40},{-40,
          40},{-40,66},{-12,66}}, color={0,0,127}));
  connect(con.Q_flow, QCon_flow) annotation (Line(points={{11,66},{20,66},{80,66},
          {80,90},{110,90}}, color={0,0,127}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{-11,-54},{-20,-54},{-20,
          -90},{110,-90}}, color={0,0,127}));
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
          textColor={0,0,127},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          textString="y"),
        Text(extent={{66,28},{116,14}},   textString="P",
          textColor={0,0,127}),
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
June 15, 2017, by Michael Wetter:<br/>
Added <code>min</code> attribute to parameter <code>P_nominal</code>.
</li>
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
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/476\">
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
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/468\">
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
</html>"));
end PartialCarnot_y;
