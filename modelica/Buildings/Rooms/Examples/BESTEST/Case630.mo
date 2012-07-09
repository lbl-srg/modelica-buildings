within Buildings.Rooms.Examples.BESTEST;
model Case630
  "Basic test with light-weight construction and dual-setpoint for heating and cooling with windows on East and West side walls with overhang and sidefins"
  extends Buildings.Rooms.Examples.BESTEST.Case620(
  roo(
    datConExtWin(
      ove(
        each wR=0.0,
        each wL=0.0,
        each dep=1.0,
        each gap=0.5),
      sidFin(
        each h=0.5,
        each dep=1.0,
        each gap=0.0))));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Rooms/Examples/BESTEST/Case630.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+007,
      Interval=3600,
      Tolerance=1e-006,
      Algorithm="Radau"),                  Diagram(coordinateSystem(
          preserveAspectRatio=true, extent={{-100,-100},{100,100}}), graphics),
    experimentSetupOutput,
    Documentation(info="<html>
<p>
This model is case 630 of the BESTEST validation suite.
Case 630 differs from case 620 in that the 
windows on the west and east walls have an overhang and side fins.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 7, 2012, by Kaustubh Phalak:<br>
Extended from case 620 for side fins and overhang.
</li>
</ul>
</html>"));
end Case630;
