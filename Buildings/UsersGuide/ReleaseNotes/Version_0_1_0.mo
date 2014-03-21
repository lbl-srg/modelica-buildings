within Buildings.UsersGuide.ReleaseNotes;

class Version_0_1_0 "Version 0.1.0"
  extends Modelica.Icons.ReleaseNotes;
  annotation(preferredView = "info", Documentation(info = "<html>
  <p>
  First release of the library.
  </p>
  <p>
  This version contains basic models for modeling building HVAC systems.
  It also contains new medium models in the package
  <a href=\"modelica://Buildings.Media\">Buildings.Media</a>. These medium models
  have simpler property functions than the ones from
  <a href=\"modelica://Modelica.Media\">Modelica.Media</a>. For example,
  there is medium model with constant heat capacity which is often sufficiently 
  accurate for building HVAC simulation, in contrast to the more detailed models
  from <a href=\"modelica://Modelica.Media\">Modelica.Media</a> that are valid in 
  a larger temperature range, at the expense of introducing non-linearities due
  to the medium properties.
  </p>
  </html>
  "));
end Version_0_1_0;