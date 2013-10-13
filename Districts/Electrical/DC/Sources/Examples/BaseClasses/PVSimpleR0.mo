within Districts.Electrical.DC.Sources.Examples.BaseClasses;
model PVSimpleR0 "Simple PV model with an additional output for reactive power"
  import Districts;
  extends Districts.Electrical.DC.Sources.PVSimple;
  Modelica.SIunits.Power  Q "Reactive power";

equation
  Q = terminal.i[2] * terminal.v[2];

end PVSimpleR0;
