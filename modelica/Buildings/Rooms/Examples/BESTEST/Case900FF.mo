within Buildings.Rooms.Examples.BESTEST;
model Case900FF "Case 900 with free floating temperature"
  extends Case900(
    gaiHea(k=0),
    gaiCoo(k=0),
    conCoo(controllerType=Modelica.Blocks.Types.SimpleController.P),
    conHea(controllerType=Modelica.Blocks.Types.SimpleController.P));
  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/BESTEST/Case900FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the basic test case 900FF of the BESTEST validation suite.
Case 900FF is a heavy-weight building.
The room temperature is free floating.
This is achieved by setting <code>gaiHea.k=0</code>
and <code>gaiCoo.k=0</code>.
</p>
</html>", revisions="<html>
<ul>
<li>
October 6, 2011, by Michael Wetter:<br>
First implementation.
</li>
</ul>
</html>"));
end Case900FF;
