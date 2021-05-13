within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case650FF
  "Case 600, no heating, no cooling, and ventilation as in case 650"
  extends Case600FF(
  redeclare Buildings.ThermalZones.Detailed.Validation.BESTEST.Data.StandardResultsFreeFloating staRes(
      minT( Min=-23.0+273.15, Max=-21.6+273.15, Mean=-22.7+273.15),
      maxT( Min=63.2+273.15, Max=68.2+273.15, Mean=64.7+273.15),
      meanT(Min=18.0+273.15, Max=19.6+273.15, Mean=18.7+273.15)),
  multiSum(nu=2));
  BaseClasses.DaySchedule vent(table=[      0, -1703.16/3600;
                                       7*3600, -1703.16/3600;
                                       7*3600,             0;
                                      18*3600,             0;
                                      18*3600, -1703.16/3600;
                                      24*3600, -1703.16/3600])
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{-88,-68},{-80,-60}})));
equation
  connect(multiSum.u[2],vent.y[1]) annotation (Line(
      points={{-72,-44},{-76,-44},{-76,-64},{-79.6,-64}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case650FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 650FF of the BESTEST validation suite.
Case 650FF is identical to case 650, except that there is no
heating and no cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
April 30, 2021, by Michael Wetter:<br/>
Added redeclaration to avoid access of component that is not in constraining type.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">#2471</a>.
</li>
<li>
July 15, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 26, 2012, by Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case650FF;
