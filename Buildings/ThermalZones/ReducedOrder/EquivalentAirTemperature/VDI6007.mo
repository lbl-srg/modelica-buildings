within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007 "Equivalent air temperature as defined in VDI 6007 Part 1"
  extends BaseClasses.PartialVDI6007;

initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGro - 1) < 0.1),
  "The sum of the weighting factors (walls,windows and ground)  is
  <0.9 or >1.1. Normally, the sum should be 1.", level=AssertionLevel.warning);

equation
  delTEqLWWin=delTEqLW;
  TEqAir = TEqWall*wfWall + TEqWin*wfWin +  TGroSouSel.y*wfGro;
  annotation (defaultComponentName = "equAirTem",Documentation(revisions="<html>
  <ul>
  <li>
  May 5, 2023, by Philip Groesdonk:<br/>
  Added an option for non-constant ground temperature from an input connector.
  This is for
  <a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/1744\">#1744</a>.
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
  </html>", info="<html>
  <p><code>VDI6007</code> is a strict implementation of the calculations defined
  in VDI 6007 Part 1. The sum of all weightfactors should be one.</p>
  </html>"));
end VDI6007;
