within Buildings.Fluid.CHPs.Rankine;
model Cycle "Model for the Rankine cycle"

  parameter Buildings.Fluid.CHPs.Rankine.Data.Generic pro
    "Property records of the working fluid"
    annotation(choicesAllMatching = true);

  // Input properties
  parameter Modelica.Units.SI.Temperature TEva
    "Evaporator temperature";
  parameter Modelica.Units.SI.Temperature TCon
    "Condenser temperature";
  parameter Modelica.Units.SI.TemperatureDifference dTSup = 0
    "Superheating differential temperature ";
  parameter Real etaExp "Expander efficiency";

  Buildings.Fluid.CHPs.Rankine.BaseClasses.Equations equ(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Core equations for the Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a port_a
    "Working fluid connector a (corresponding to the evaporator)"
    annotation (Placement(transformation(extent={{-10,90},{10,110}}),
      iconTransformation(extent={{-10,90},{10,110}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b port_b(final T=TCon)
    "Working fluid connector b (corresponding to the condenser)"
    annotation (Placement(transformation(extent={{10,-110},{-10,-90}}),
      iconTransformation(extent={{10,-110},{-10,-90}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W")
    "Power output of the expander" annotation (Placement(transformation(extent={{100,30},
            {120,50}}),            iconTransformation(extent={{100,-50},{120,-30}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(
    min=0,
    final unit="1") "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),  iconTransformation(extent
          ={{100,-90},{120,-70}})));
  Buildings.HeatTransfer.Sources.FixedTemperature preTemEva(final T=TEva)
    "Working fluid temperature on the evaporator side"
    annotation (Placement(transformation(extent={{-80,60},{-60,80}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSenEva
    "Heat flow on the evaporator side"
    annotation (Placement(transformation(extent={{-40,60},{-20,80}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulExp "Expander work"
    annotation (Placement(transformation(extent={{42,30},{62,50}})));
  Buildings.Controls.OBC.CDL.Continuous.Multiply mulCon "Condenser heat flow"
    annotation (Placement(transformation(extent={{0,-60},{20,-40}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    annotation (Placement(transformation(extent={{40,-60},{60,-40}})));

equation
  connect(preTemEva.port, heaFloSenEva.port_a)
    annotation (Line(points={{-60,70},{-40,70}}, color={191,0,0}));
  connect(heaFloSenEva.port_b, port_a)
    annotation (Line(points={{-20,70},{0,70},{0,100}}, color={191,0,0}));
  connect(heaFloSenEva.Q_flow, mulExp.u1)
    annotation (Line(points={{-30,59},{-30,46},{40,46}}, color={0,0,127}));
  connect(equ.etaThe, mulExp.u2)
    annotation (Line(points={{11,4},{32,4},{32,34},{40,34}}, color={0,0,127}));
  connect(mulExp.y, P)
    annotation (Line(points={{64,40},{110,40}}, color={0,0,127}));
  connect(equ.etaThe, etaThe) annotation (Line(points={{11,4},{94,4},{94,0},{110,
          0}},   color={0,0,127}));
  connect(heaFloSenEva.Q_flow, mulCon.u1)
    annotation (Line(points={{-30,59},{-30,-44},{-2,-44}}, color={0,0,127}));
  connect(equ.rConEva, mulCon.u2) annotation (Line(points={{11,-4},{32,-4},{32,
          -20},{-10,-20},{-10,-56},{-2,-56}}, color={0,0,127}));
  connect(mulCon.y, preHeaFlo.Q_flow)
    annotation (Line(points={{22,-50},{40,-50}}, color={0,0,127}));
  connect(preHeaFlo.port, port_b) annotation (Line(points={{60,-50},{64,-50},{64,
          -86},{0,-86},{0,-100}}, color={191,0,0}));
annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Line(points={{-80,-67},{57,-67}}, color={0,0,0}),
        Line(
          points={{-60,-60},{-28,-20},{16,32},{40,60},{52,60},{54,30},{48,2},{52,
              -38},{58,-58}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Line(
          points={{6,20},{52,20},{66,-6},{50,-18},{-26,-18}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Line(points={{-66,61},{-66,-78}}, color={0,0,0}),
        Polygon(
          points={{-66,73},{-74,51},{-58,51},{-66,73}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{63,-67},{41,-59},{41,-75},{63,-67}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-100,100},{-64,58}},
          textColor={0,0,0},
          textString="T"),
        Text(
          extent={{64,-58},{100,-100}},
          textColor={0,0,0},
          textString="s")}),                                   Diagram(
        coordinateSystem(preserveAspectRatio=false)),
    Documentation(info="<html>
<p>
[fixme: draft implementation.]<br/>
Implemented in this model is a Rankine cycle.
The cycle is determined through the input of
the evaporator temperature <code>TEva</code>,
the condenser temperature <code>TCon</code>,
the expander efficiency <code>etaExp</code>,
and optionally the superheating temperature differential <code>dTSup</code>.
The model neglects the enthalpy difference between the pump inlet and outlet
or the pressure loss along any pipe of they cycle components.
While the model considers potential superheating before the expander inlet,
it does not consider subcooling before the pump inlet.
</p>
<p><img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/Rankine/cycle.png\"
alt=\"Cycle\"/></p>
<p>
The property queries of the working fluid are not performed by medium models,
but by interpolating data records in
<a href=\"Modelica://Buildings.Fluid.CHPs.Rankine.Data\">
Buildings.Fluid.CHPs.Rankine.Data</a>.
Specific enthalpy and specific entropy values are provided as support points
on the saturated liquid line, the saturated vapour line,
and a superheated vapour line. Support points on all three lines correspond
with the same pressures. The points on the superheated vapour line have a
constant temperature differential from their corresponding points on the
saturated vapour line.
</p>
<p>
Important state points in the Rankine cycle are determined by various schemes
of inter-/extrapolation along isobaric lines (assumed near linear):
</p>
<ul>
<li>
The pump inlet <code>Pum</code> and expander inlet <code>ExpInl</code>
are both located on a saturation line. They are determined simply by
smooth interpolation.
</li>
<li>
When there is superheating (determined by <code>dTSup > 0.1</code>),
<code>ExpInl</code> is elevated. Its specific enthaply and specific entropy
are then found by linear inter-/extrapolation between the saturated and
superheated (\"ref\") vapour lines along the isobaric line:<br/>
<p align=\"center\" style=\"font-style:italic;\">
(s<sub>ExpInl</sub> - s<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup</sub>
= (s<sub>SupVap,ref</sub> - s<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup,ref</sub>)<br/>
(h<sub>ExpInl</sub> - h<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup</sub>
= (h<sub>SupVap,ref</sub> - h<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup,ref</sub>)
</p>
</li>
<li>
The isentropic expander outlet <code>ExpOut_i</code> is found also by linear
inter-/extrapolation, but with entropy instead of temperature.
<ul>
<li>
If <code>ExpOut_i</code> lands outside of the dome, the inter-/extrapolation
is performed between the saturated and superheated (\"ref\") lines:<br/>
<p align=\"center\" style=\"font-style:italic;\">
(h<sub>ExpOut_i</sub> - h<sub>SatVap</sub>)
&frasl; (s<sub>ExpInl</sub> - s<sub>SatVap</sub>)
= (h<sub>SupVap,ref</sub> - h<sub>SatVap</sub>)
&frasl; (s<sub>SupVap,ref</sub> - s<sub>SatVap</sub>)
</p>
</li>
<li>
If it lands inside the dome, interpolation is performed between
the two saturation lines:<br/>
<p align=\"center\" style=\"font-style:italic;\">
(h<sub>ExpOut_i</sub> - h<sub>Pum</sub>)
&frasl; (s<sub>ExpInl</sub> - s<sub>Pum</sub>)
= (h<sub>SatVap</sub> - h<sub>Pum</sub>)
&frasl; (s<sub>SatVap</sub> - s<sub>Pum</sub>)
</p>
In this case the results are accurate.
</li>
</ul>
</li>
</ul>
</html>"));
end Cycle;
