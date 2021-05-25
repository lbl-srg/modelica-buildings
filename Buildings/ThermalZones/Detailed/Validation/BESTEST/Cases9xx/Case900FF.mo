within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case900FF "Case 600FF, but with high thermal mass"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600FF(
    matExtWal = extWalCase900,
    matFlo =    floorCase900,
    redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResultsFreeFloating staRes(
      minT( Min=-6.4+273.15, Max=-1.6+273.15, Mean=-4.2+273.15),
      maxT( Min=41.6+273.15, Max=44.8+273.15, Mean=43.1+273.15),
      meanT(Min=24.5+273.15, Max=25.9+273.15, Mean=25.2+273.15)));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase900
     extWalCase900 "Exterior wall"
    annotation (Placement(transformation(extent={{60,60},{74,74}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.FloorCase900
    floorCase900 "Floor"
    annotation (Placement(transformation(extent={{80,60},{94,74}})));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case900FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 900FF of the BESTEST validation suite.
Case 900FF is a heavy-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
July 29, 2016, by Michael Wetter:<br/>
Added missing parameter declarations.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/543\">issue 543</a>.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case900FF;
