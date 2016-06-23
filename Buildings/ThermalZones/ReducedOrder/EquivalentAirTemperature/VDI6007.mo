within Buildings.ThermalZones.ReducedOrder.EquivalentAirTemperature;
model VDI6007 "Equivalent air temperature as defined in VDI 6007 Part 1"
  extends BaseClasses.PartialVDI6007;

initial equation
  assert(noEvent(abs(sum(wfWall) + sum(wfWin) + wfGro - 1) < 0.1),
  "The sum of the weighting factors (walls,windows and ground)  is
  <0.9 or >1.1. Normally, the sum should be 1.", level=AssertionLevel.warning);
  
equation
  delTEqLW=(TBlaSky-TDryBul)*(eExt*alphaRadWall/(alphaRadWall+alphaWallOut*0.93));
  delTEqSW=HSol*aExt/(alphaRadWall+alphaWallOut);
  if withLongwave then
    TEqWin=TDryBul.+delTEqLW*abs(sunblind.-1);
    TEqWall=TDryBul.+delTEqLW.+delTEqSW;
  else
    TEqWin=TDryBul*ones(n);
    TEqWall=TDryBul.+delTEqSW;
  end if;
  TEqAir = TEqWall*wfWall + TEqWin*wfWin + TGro*wfGro;
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
  </html>", info="<html>
  <p><code>VDI6007</code> is a strict implementation of the calculations defined
  in VDI 6007 Part 1. The sum of all weightfactors should be one.</p>
  </html>"),
  Diagram(coordinateSystem(preserveAspectRatio=false,
  extent={{-100,-100},{100,100}})));
end VDI6007;
