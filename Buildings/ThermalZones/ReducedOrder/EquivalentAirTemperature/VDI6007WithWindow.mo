within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007WithWindow
  "Equivalent air temperature as defined in VDI 6007 Part 1 with modifications"
  extends BaseClasses.PartialVDI6007;

  parameter Modelica.Units.SI.CoefficientOfHeatTransfer hConWinOut
    "Windows' convective coefficient of heat transfer (outdoor)";

  Modelica.Blocks.Interfaces.RealOutput TEqAirWin(final unit="K")
    "Equivalent air temperature for windows (no short-wave radiation)"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),
    iconTransformation(extent={{100,28},{120,48}})));

initial equation
  assert(noEvent(abs(sum(wfWall) + wfGro - 1) < 0.1),
  "The sum of the weightfactors (walls and ground)  is <0.9 or >1.1.
   Normally, the sum should be 1.", level=AssertionLevel.warning);
  assert(noEvent(abs(sum(wfWin) - 1) < 0.1),
  "The sum of the weightfactors (windows)  is <0.9 or >1.1.
  Normally, the sum should be 1.", level=AssertionLevel.warning);

equation
  delTEqLWWin=(TBlaSky - TDryBul)*hRad/(hRad + hConWinOut);
  TEqAir = TEqWall*wfWall + TGro*wfGro;
  TEqAirWin = TEqWin*wfWin;
  annotation (defaultComponentName = "equAirTem",Documentation(revisions="<html>
  <ul>
  <li>
  July 11, 2019, by Katharina Brinkmann:<br/>
  Renamed <code>alphaWinOut</code> to <code>hConWinOut</code>
  </li>
  <li>
  September 26, 2016, by Moritz Lauster:<br/>
  Moved calculations to <a href=\"modelica://Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007\">
  Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature.BaseClasses.PartialVDI6007</a>.
  </li>
  <li>September 2015, by Moritz Lauster:<br/>
  Got rid of cardinality
  and used assert for warnings.<br/>
  Adapted to Annex 60 requirements.
  </li>
  <li>
  October 2014, by Peter Remmen:<br/>
  Implemented.
  </li>
  </ul>
  </html>",
  info="<html>
  <p>This model is a variant of the calculations defined in
  VDI 6007 Part 1. It adds a second equivalent air temperature for windows in
  case heat transfer through windows and exterior walls is handled separately in
  the Reduced Order Model. The sum of all weightfactors for windows should be
  one as well as the sum for all wall elements.</p>
  </html>"));
end VDI6007WithWindow;
