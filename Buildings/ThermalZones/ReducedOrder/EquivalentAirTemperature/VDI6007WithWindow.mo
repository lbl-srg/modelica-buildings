within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007WithWindow
  "Equivalent air temperature as defined in VDI 6007 Part 1 with modifications"
  extends BaseClasses.PartialVDI6007;

  parameter Modelica.SIunits.Emissivity aWin
    "Coefficient of absorption of the windows";
  parameter Modelica.SIunits.Emissivity eWin
    "Coefficient of emission of the windows";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaWinOut
    "Windows' convective coefficient of heat transfer (outdoor)";
  parameter Modelica.SIunits.CoefficientOfHeatTransfer alphaRadWin
    "Coefficient of heat transfer for linearized radiation for windows";

  Modelica.SIunits.TemperatureDifference delTEqLWWin
    "Equivalent long wave temperature for windows";
  Modelica.SIunits.TemperatureDifference delTEqSWWin[n]
    "Eqiuvalent short wave temperature for windows";
    
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
  delTEqLW=(TBlaSky-TDryBul)*(eExt*alphaRadWall/(alphaRadWall+alphaWallOut));
  delTEqLWWin=(TBlaSky-TDryBul)*(eWin*alphaRadWin/(alphaRadWin+alphaWinOut));
  delTEqSW=HSol*aExt/(alphaRadWall+alphaWallOut);
  delTEqSWWin=HSol*aWin/(alphaRadWin+alphaWinOut);
  if withLongwave then
    TEqWin=TDryBul.+(delTEqLWWin.+delTEqSWWin).*abs(sunblind.-1);
    TEqWall=TDryBul.+delTEqLW.+delTEqSW;
  else
    TEqWin=TDryBul.+delTEqSWWin.*abs(sunblind.-1);
    TEqWall=TDryBul.+delTEqSW;
  end if;
  TEqAir = TEqWall*wfWall + TGro*wfGro;
  TEqAirWin = TEqWin*wfWin;
  annotation (defaultComponentName = "equAirTem",Documentation(revisions="<html>
  <ul>
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
  case heat transfer through windows and exterior walls is handled seperately in
  the Reduced Order Model. The sum of all weightfactors for windows should be
  one as well as the sum for all wall elements.</p>
  </html>"),
  Icon(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}})),
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}})));
end VDI6007WithWindow;
