within Buildings.Applications.DHC.EnergyTransferStations.FifthGeneration.BaseClasses;
model StratifiedTank "Four pipes buffer tank model"
  extends Buildings.Fluid.Storage.Stratified(show_T=true);

  Modelica.Fluid.Interfaces.FluidPort_a port_a1(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    m_flow(min=if allowFlowReversal then -Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector a (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{90,-70},{110,-50}}),
        iconTransformation(extent={{90,-50},{110,-30}})));
  Modelica.Fluid.Interfaces.FluidPort_b port_b1(
    p(start=Medium.p_default),
    redeclare final package Medium = Medium,
    m_flow(max=if allowFlowReversal then +Modelica.Constants.inf else 0),
    h_outflow(start=Medium.h_default, nominal=Medium.h_default))
    "Fluid connector b (positive design flow direction is from port_a to port_b)"
    annotation (Placement(transformation(extent={{-90,-70},{-110,-50}}),
        iconTransformation(extent={{-90,30},{-110,50}})));
  Modelica.Blocks.Sources.RealExpression mRelative(y=vol[2].ports[1].m_flow/
        VTan/1000*3600)
    "Normalized flow rate through tank, positive if from top to bottom"
    annotation (Placement(transformation(extent={{60,78},{80,98}})));
  Modelica.Blocks.Interfaces.RealOutput wch
    "Water change per hour for the tank volume."
    annotation (Placement(transformation(extent={{100,78},{120,98}}),
        iconTransformation(extent={{100,-80},{120,-60}})));
  Medium.ThermodynamicState sta_a1=
    Medium.setState_phX(port_a1.p,
                         noEvent(actualStream(port_a1.h_outflow)),
                         noEvent(actualStream(port_a1.Xi_outflow))) if show_T
    "Medium properties in port_a1";
  Medium.ThermodynamicState sta_b1=
    Medium.setState_phX(port_b1.p,
                         noEvent(actualStream(port_b1.h_outflow)),
                         noEvent(actualStream(port_b1.Xi_outflow))) if show_T
    "Medium properties in port_b1";
equation
  connect(port_b1, vol[1].ports[3]) annotation (Line(points={{-100,-60},{16,-60},
          {16,-16}},color={0,127,255}));
  connect(port_a1, vol[nSeg].ports[3]) annotation (Line(points={{100,-60},{16,-60},
          {16,-16}},
                color={0,127,255}));
  connect(mRelative.y, wch) annotation (Line(points={{81,88},{110,88}},
                    color={0,0,127}));

annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}), graphics={
        Rectangle(
          extent={{-50,42},{-72,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{74,-38},{50,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-84,42},{-90,38}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{90,-38},{86,-42}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,127},
          fillPattern=FillPattern.Solid)}),
  defaultComponentName="tan",
  Diagram(coordinateSystem(extent={{-100,-100},{100,100}})),
Documentation(info="<html>
<p>
The model represents a four pipes stratified tank. An example of the cold buffer tank 
connections is shown in the figure below
</p>
<p align=\"center\">
<img alt=\"coolingBufferTank\"
src=\"modelica://Buildings/Resources/Images/Applications/DHC/EnergyTransferStations/coolingBufferTank.png\"/>
</p>
</html>",revisions="<html>
<ul>
<li>
January 1, 2020 by Hagar Elarga:<br/>
Added the thermodynamic diagnostics for fluid ports a1 and b1 and 
the documentation.
</li>
<li>
by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end StratifiedTank;
