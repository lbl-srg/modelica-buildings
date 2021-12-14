within Buildings.ThermalZones.Detailed.Constructions;
model Construction "Model for an opaque construction that has no window"
  extends Buildings.ThermalZones.Detailed.Constructions.BaseClasses.PartialConstruction(
    final AOpa=A);

  annotation (
defaultComponentName="conOpa",
Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},
            {300,300}})), Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}}), graphics={
        Rectangle(
          extent={{-290,202},{298,198}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,260},{60,60}},
          lineColor={0,0,0},
          fillColor={135,135,135},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-56,260},{0,60}},
          lineColor={0,0,0},
          fillColor={183,183,121},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-80,260},{-56,60}},
          lineColor={0,0,0},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-56,260},{-70,274},{-18,274},{0,260},{-56,260}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={183,183,121},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-80,260},{-88,274},{-70,274},{-56,260},{-80,260}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,260},{-18,274},{40,274},{60,260},{0,260}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{-88,274},{-88,82},{-80,60},{-80,260},{-88,274}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid)}),
    Documentation(
    info="<html>
This model is used to compute heat transfer through opaque constructions inside the
room model.
The model uses the record <code>layers</code> to access the material properties
of the opaque construction. The heat transfer is computed in the instance
<code>opa</code>, which uses the model
<a href=\"modelica://Buildings.HeatTransfer.Conduction.MultiLayer\">
Buildings.HeatTransfer.Conduction.MultiLayer</a>.
</html>",
revisions="<html>
<ul>
<li>
December 6 2010, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Construction;
