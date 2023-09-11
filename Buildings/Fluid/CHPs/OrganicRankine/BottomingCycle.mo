within Buildings.Fluid.CHPs.OrganicRankine;
model BottomingCycle
  "Organic Rankine cycle with heat exchangers as a bottoming cycle"

  extends Buildings.Fluid.Interfaces.PartialFourPortInterface;
  extends Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Declarations;

  parameter Modelica.Units.SI.ThermalConductance UA
    "Thermal conductance of the evaporator"
    annotation(Dialog(group="Evaporator"));

  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.BottomingCycle ORC(
    final pro=pro,
    final TEva=TEva,
    final TCon=TCon,
    final dTSup=dTSup,
    final etaExp=etaExp) "Organic Rankine cycle"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.HeaterCooler_Q con(
    redeclare final package Medium = Medium2,
    allowFlowReversal=false,
    final m_flow_nominal=m2_flow_nominal,
    final from_dp=false,
    dp_nominal=0,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState) "Condenser"
    annotation (Placement(transformation(extent={{10,-70},{-10,-50}})));
  Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.EvaporatorLimited eva(
    redeclare final package Medium = Medium1,
    final m_flow_nominal=m1_flow_nominal,
    dp_nominal=0,
    final TWorFlu=TEva,
    final UA=UA) "Evaporator"
    annotation (Placement(transformation(extent={{-10,50},{10,70}})));
  Modelica.Blocks.Interfaces.RealOutput P(
    min=0,
    final quantity="Power",
    final unit="W") "Power output of the expander"
                                   annotation (Placement(transformation(extent={{100,20},
            {120,40}}),            iconTransformation(extent={{100,20},{120,40}})));
  Modelica.Blocks.Interfaces.RealOutput etaThe(min=0, final unit="1")
                    "Thermal efficiency"
    annotation (Placement(
        transformation(extent={{100,-10},{120,10}}),  iconTransformation(extent={{100,-40},
            {120,-20}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(final quantity="Power",
      final unit="W") "Heat rejected through condensation"
    annotation (Placement(transformation(extent={{100,-100},{120,-80}}),
        iconTransformation(extent={{100,-110},{120,-90}})));
  Modelica.Blocks.Interfaces.RealOutput QEva_flow(final quantity="Power",
      final unit="W") "Heat added through evaporation" annotation (Placement(
        transformation(extent={{100,82},{120,102}}), iconTransformation(extent={
            {100,90},{120,110}})));
equation
  connect(con.port_a, port_a2)
    annotation (Line(points={{10,-60},{100,-60}}, color={0,127,255}));
  connect(con.port_b, port_b2)
    annotation (Line(points={{-10,-60},{-100,-60}}, color={0,127,255}));
  connect(ORC.QCon_flow, con.Q_flow) annotation (Line(points={{11,-6},{20,-6},{20,
          -54},{12,-54}}, color={0,0,127}));
  connect(eva.Q_flow, ORC.QEva_flow) annotation (Line(points={{11,54},{20,54},{20,
          30},{-20,30},{-20,6},{-12,6}}, color={0,0,127}));
  connect(eva.port_b, port_b1)
    annotation (Line(points={{10,60},{100,60}}, color={0,127,255}));
  connect(eva.port_a, port_a1)
    annotation (Line(points={{-10,60},{-100,60}}, color={0,127,255}));
  connect(ORC.P, P) annotation (Line(points={{11,6},{80,6},{80,30},{110,30}},
        color={0,0,127}));
  connect(ORC.etaThe, etaThe)
    annotation (Line(points={{11,0},{110,0}}, color={0,0,127}));
  connect(ORC.QCon_flow, QCon_flow) annotation (Line(points={{11,-6},{20,-6},{20,
          -90},{110,-90}}, color={0,0,127}));
  connect(eva.Q_flow, QEva_flow) annotation (Line(points={{11,54},{20,54},{20,92},
          {110,92}}, color={0,0,127}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false), graphics={
        Rectangle(
          extent={{-100,100},{100,-100}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-103,65},{98,56}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-74,-60},{-42,-20},{2,32},{26,60},{38,60},{40,30},{34,2},{38,
              -38},{44,-58}},
          color={0,0,0},
          smooth=Smooth.Bezier,
          thickness=0.5),
        Rectangle(
          extent={{-99,-55},{102,-64}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Line(
          points={{-8,20},{38,20},{52,-6},{36,-18},{-40,-18}},
          color={0,0,0},
          thickness=0.5,
          pattern=LinePattern.Dash),
        Rectangle(
          extent={{-2,56},{98,65}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,-64},{0,-55}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid)}), Diagram(coordinateSystem(
          preserveAspectRatio=false)),
Documentation(info="<html>
<p>
This model implements the organic Rankine cycle as a bottoming cycle.
</p>
<p>
The thermodynamic equations are implemented in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations\">
Buildings.Fluid.CHPs.OrganicRankine.BaseClasses.Equations</a>.
The cycle is determined through the input of
the evaporator temperature <code>TEva</code>,
the condenser temperature <code>TCon</code>,
the expander efficiency <code>etaExp</code>,
and optionally the superheating temperature differential <code>dTSup</code> (default zero).
The model neglects the enthalpy difference between the pump inlet and outlet
or the pressure loss along any pipe of the cycle components.
While the model considers potential superheating before the expander inlet,
it does not consider subcooling before the pump inlet.
</p>
<p><img src=\"modelica://Buildings/Resources/Images/Fluid/CHPs/OrganicRankine/cycle.png\"
alt=\"Cycle\"/></p>
<p>
The property queries of the working fluid are not performed by medium models,
but by interpolating data records in
<a href=\"Modelica://Buildings.Fluid.CHPs.OrganicRankine.Data\">
Buildings.Fluid.CHPs.OrganicRankine.Data</a>.
Specific enthalpy and specific entropy values are provided as support points
on the saturated liquid line, the saturated vapour line,
and a superheated vapour line.
</p>
<p>
Important state points in the Rankine cycle are determined by various schemes
of inter-/extrapolation along isobaric lines (assumed near linear):
</p>
<ul>
<li>
The pump <code>Pum</code> and expander inlet <code>ExpInl</code>
are both located on a saturation line. They are determined simply by
smooth interpolation.
</li>
<li>
When there is superheating (determined by <i>&Delta;T<sub>Sup</sub> > 0.1 K</i>),
<code>ExpInl</code> is elevated. Its specific enthaply and specific entropy
are then found by linear inter-/extrapolation between the saturated and
superheated (\"ref\") vapour lines along the isobaric line at the evaporator
pressure:<br/>
<p align=\"center\" style=\"font-style:italic;\">
(s<sub>ExpInl</sub> - s<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup</sub>
= (s<sub>SupVap,ref</sub> - s<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup,ref</sub><br/>
(h<sub>ExpInl</sub> - h<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup</sub>
= (h<sub>SupVap,ref</sub> - h<sub>SatVap</sub>)
&frasl; &Delta;T<sub>Sup,ref</sub>
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
</html>", revisions="<html>
<ul>
<li>
September 8, 2023, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3433\">#3433</a>.
</li>
</ul>
</html>"));
end BottomingCycle;
