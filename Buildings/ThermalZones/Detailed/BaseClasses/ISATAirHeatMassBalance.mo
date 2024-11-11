within Buildings.ThermalZones.Detailed.BaseClasses;
model ISATAirHeatMassBalance
  "Heat and mass balance of the air based on ISAT"
  extends Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance(
    redeclare ISATExchange cfd);

  annotation (Documentation(info="<html>
<p>
Block derived from
<a href=\"modelica://Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance\">
Buildings.ThermalZones.Detailed.BaseClasses.CFDAirHeatMassBalance</a> to compute the heat and 
mass balance of the air using ISAT.
</html>",
revisions="<html>
<ul>
<li>
January 5, 2022, by Xu Han, Cary Faulkner, Wangda Zuo and Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ISATAirHeatMassBalance;
