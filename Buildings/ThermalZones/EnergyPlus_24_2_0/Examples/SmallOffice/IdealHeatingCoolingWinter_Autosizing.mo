within Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice;
model IdealHeatingCoolingWinter_Autosizing
  "Building with constant fresh air and ideal heating/cooling that exactly meets set point with HVAC sized using autosizing"
  extends IdealHeatingCoolingWinter(
    redeclare Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.BaseClasses.Floor_Autosizing_MultipleSystems flo,
    coo(
      Q_flow_nominal=-{
        flo.sou.sizCoo.QSen_flow,
        flo.eas.sizCoo.QSen_flow,
        flo.nor.sizCoo.QSen_flow,
        flo.wes.sizCoo.QSen_flow,
        flo.cor.sizCoo.QSen_flow}),
    hea(
      Q_flow_nominal={
        flo.sou.sizHea.QSen_flow,
        flo.eas.sizHea.QSen_flow,
        flo.nor.sizHea.QSen_flow,
        flo.wes.sizHea.QSen_flow,
        flo.cor.sizHea.QSen_flow}),
    THeaCoo(
      k={
        flo.sou.sizCoo.TSet,
        flo.eas.sizCoo.TSet,
        flo.nor.sizCoo.TSet,
        flo.wes.sizCoo.TSet,
        flo.cor.sizCoo.TSet}),
    THeaSet(
      k={
        flo.sou.sizHea.TSet,
        flo.eas.sizHea.TSet,
        flo.nor.sizHea.TSet,
        flo.wes.sizHea.TSet,
        flo.cor.sizHea.TSet}));
  annotation(Documentation(
      info="<html>
<p>
Same example as <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.IdealHeatingCoolingWinter\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SmallOffice.IdealHeatingCoolingWinter</a>,
except that the autosizing feature in Spawn is used to define two HVAC systems,
one serving the perimeter zones and one serving the core zone.  The system
serving the perimeter zones has <code>autosizeHVAC=true</code>, while the one serving the 
core zone has <code>autosizeHVAC=false</code>.  The zone level design sensible heating
and cooling loads returned from the Spawn autosizing are used to size the 
ideal heaters and coolers and the design heating and cooling temperature set points 
are used to specify the set points for the controllers.
</p>
</html>",
      revisions="<html>
<ul>
<li>
July 22, 2026, by David Blum:<br/>
First implementation.
</li>
</ul>
</html>"),
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/EnergyPlus_24_2_0/Examples/SmallOffice/IdealHeatingCoolingWinter_Autosizing.mos" "Simulate and plot"),
    experiment(
      StartTime=432000,
      StopTime=864000,
      Tolerance=1e-06));
end IdealHeatingCoolingWinter_Autosizing;
