within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case900 "Case 600, but with high thermal mass"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
   matExtWal = extWalCase900,
   matFlo =    floorCase900,
   staRes(
    annualHea(Min=1.170*3.6e9, Max=2.041*3.6e9, Mean=1.745*3.6e9),
    annualCoo(Min=-2.132*3.6e9, Max=-3.415*3.6e9, Mean=-2.678*3.6e9),
    peakHea(Min=2.850*1000, Max=3.797*1000, Mean=3.506*1000),
    peakCoo(Min=-2.888*1000, Max=-3.871*1000, Mean=-3.390*1000)));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.ExteriorWallCase900
     extWalCase900 "Exterior wall"
    annotation (Placement(transformation(extent={{60,60},{74,74}})));

  parameter Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.FloorCase900
    floorCase900 "Floor"
    annotation (Placement(transformation(extent={{80,60},{94,74}})));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case900.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900 of the BESTEST validation suite.
Case 900 is a heavy-weight building with room temperature control set to
<i>20&deg;C</i> for heating and <i>27&deg;C</i> for cooling.
The room has no shade and a window that faces south.
</p>
</html>", revisions="<html>
<ul>
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
end Case900;
