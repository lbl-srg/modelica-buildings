within Buildings.Experimental.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice;
model ASHRAE2006
  "Six zones small office building with VAV reheat"
  extends Buildings.Examples.VAVReheat.ASHRAE2006(
    AFloCor = 149.657 "Floor area, assigned to avoid non-literal value for nominal attribute of variables",
    AFloSou = 113.45,
    AFloNor = 113.45,
    AFloWes = 67.3,
    AFloEas = 67.3,
    redeclare Buildings.Experimental.EnergyPlus.Examples.VAVReheatRefBldgSmallOffice.BaseClasses.Floor flo);

  annotation (Documentation(info="<html>
<p>
Test case with VAV reheat model and small office reference buildings.
</p>
</html>", revisions="<html>
<ul><li>
April 11, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
 __Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Experimental/EnergyPlus/Examples/VAVReheatRefBldgSmallOffice/ASHRAE2006.mos"
        "Simulate and plot"),
experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Diagram(coordinateSystem(preserveAspectRatio=false,extent={{-380,-380},{
            1400,640}})),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ASHRAE2006;
