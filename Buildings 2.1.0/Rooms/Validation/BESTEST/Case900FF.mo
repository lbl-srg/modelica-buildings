within Buildings.Rooms.Validation.BESTEST;
model Case900FF "Case 600FF, but with high thermal mass"
  extends Case600FF(
    matExtWal = extWalCase900,
    matFlo =    floorCase900,
    staRes(
      minT( Min=-6.4+273.15, Max=-1.6+273.15, Mean=-4.2+273.15),
      maxT( Min=41.6+273.15, Max=44.8+273.15, Mean=43.1+273.15),
      meanT(Min=24.5+273.15, Max=25.9+273.15, Mean=25.2+273.15)));

  Buildings.Rooms.Validation.BESTEST.Data.ExteriorWallCase900
     extWalCase900 "Exterior wall"
    annotation (Placement(transformation(extent={{32,50},{46,64}})));

  Buildings.Rooms.Validation.BESTEST.Data.FloorCase900
    floorCase900 "Floor"
    annotation (Placement(transformation(extent={{60,50},{74,64}})));

  annotation (
experiment(StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Validation/BESTEST/Case900FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 900FF of the BESTEST validation suite.
Case 900FF is a heavy-weight building.
The room temperature is free floating.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case900FF;
