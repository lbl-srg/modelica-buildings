within Buildings.Fluid.HeatPumps.ModularReversible.Controls.Safety.BaseClasses;
partial model PartialSafety "Safety control with I/O"
  Modelica.Blocks.Interfaces.RealInput ySet
    "Input for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{-152,-16},{-120,16}}),
        iconTransformation(extent={{-152,-16},{-120,16}})));
  Modelica.Blocks.Interfaces.RealOutput yOut
    "Output for relative compressor speed from 0 to 1"
    annotation (Placement(transformation(extent={{120,-10},{140,10}}),
        iconTransformation(extent={{120,-10},{140,10}})));
  Buildings.Fluid.HeatPumps.ModularReversible.BaseClasses.RefrigerantMachineControlBus sigBus
    "Bus-connector for the heat pump" annotation (Placement(transformation(
          extent={{-136,-76},{-102,-46}}), iconTransformation(extent={{-136,-88},
            {-102,-58}})));
  annotation (Icon(coordinateSystem(extent={{-120,-120},{120,120}}),
                   graphics={   Rectangle(
        extent={{-120,-120},{120,120}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
        Polygon(
          points={{-42,20},{0,62},{-42,20}},
          lineColor={28,108,200},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-48,-26},{48,66}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-36,-14},{36,54}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-60,20},{60,-80}},
          lineColor={0,0,0},
          fillColor={91,91,91},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,-30},{10,-70}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Ellipse(
          extent={{-14,-40},{16,-12}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-151,139},{149,99}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name")}),     Diagram(coordinateSystem(
          preserveAspectRatio=false, extent={{-120,-120},{120,120}})),
    Documentation(revisions="<html><ul>
  <li>
    <i>November 26, 2018</i> by Fabian Wuellhorst:<br/>
    First implementation (see issue <a href=
    \"https://github.com/RWTH-EBC/AixLib/issues/577\">AixLib #577</a>)
  </li>
</ul>
</html>", info="<html>
<p>
  Partial block for a safety control. Based on the signals in the
  <code>sigBus</code> either the input signals are equal to the output
  signals or, if an error occurs, set to 0.
</p>
</html>"));
end PartialSafety;
