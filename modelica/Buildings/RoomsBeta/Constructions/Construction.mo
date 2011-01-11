within Buildings.RoomsBeta.Constructions;
model Construction "Model for an opaque construction that has no window"
  extends Buildings.RoomsBeta.Constructions.BaseClasses.PartialConstruction(
    final AOpa=A);

  annotation (Diagram(coordinateSystem(preserveAspectRatio=true, extent={{-300,-300},
            {300,300}},
        initialScale=0.1), graphics),
                          Icon(coordinateSystem(preserveAspectRatio=true,
          extent={{-300,-300},{300,300}},
        initialScale=0.1), graphics={
        Rectangle(
          extent={{-290,202},{298,198}},
          lineColor={0,0,0},
          fillColor={191,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,254},{-52,140}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward),
        Polygon(
          points={{2,208},{4,208},{6,204},{8,198},{8,194},{6,188},{0,184},{-4,180},
              {-12,178},{-16,182},{-22,188},{-24,198},{-22,204},{-20,208},{-18,210},
              {-16,212},{-12,214},{-8,214},{-2,212},{2,208}},
          lineColor={0,0,0},
          smooth=Smooth.None,
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{34,254},{52,140}},
          lineColor={0,0,0},
          fillColor={192,192,192},
          fillPattern=FillPattern.Backward)}),
    Documentation(
    info="<html>
This model is used to compute heat transfer through opaque constructions inside the 
room model.
The model uses the record <code>layers</code> to access the material properties
of the opaque construction. The heat transfer is computed in the instance
<code>opa</code>, which uses the model 
<a href=\"modelica://Buildings.HeatTransfer.ConductorMultiLayer\">
Buildings.HeatTransfer.ConductorMultiLayer</a>.
</html>",
revisions="<html>
<ul>
<li>
December 6 2010, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Construction;
