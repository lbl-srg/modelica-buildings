within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case950FF
  "Case 900, but no heating, no cooling, and ventilation as in case 650"
  extends Case900FF(
  staRes(
      minT( Min=-13.4+273.15, Max=-12.5+273.15, Mean=-13.0+273.15),
      maxT( Min=36.1+273.15, Max=37.1+273.15, Mean=36.6+273.15),
      meanT(Min=14.4+273.15, Max=15.0+273.15, Mean=14.7+273.15)),
  multiSum(nu=2));

  BaseClasses.DaySchedule vent(table=[      0, -1409/3600;
                                       7*3600, -1409/3600;
                                       7*3600,             0;
                                      18*3600,             0;
                                      18*3600, -1409/3600;
                                      24*3600, -1409/3600])
    "Ventilation air flow rate"
    annotation (Placement(transformation(extent={{-94,-60},{-86,-52}})));
equation
  connect(multiSum.u[2],vent.y[1]) annotation (Line(
      points={{-78,-74},{-82,-74},{-82,-56},{-85.2,-56}},
      color={0,0,127},
      smooth=Smooth.None));

  annotation (
experiment(Tolerance=1e-06, StopTime=3.1536e+07),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case950FF.mos"
        "Simulate and plot"), Documentation(info="<html>
<p>
This model is used for the test case 950FF of the BESTEST validation suite.
Case 950FF is identical to case 950, except that there is no
heating and no cooling.
</p>
</html>", revisions="<html>
<ul>
<li>
May 12, 2022, by Jianjun Hu:<br/>
Changed the ventilation fan capacity from 1703.16 m3/h to 1700 m3/h and consider the adjustment
for the altitude, eventually to be 1409 m3/h.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3005\">#3005</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Reformulated replaceable class to avoid access of components that are not in the constraining type.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">issue #2471</a>.
</li>
<li>
April 30, 2021, by Michael Wetter:<br/>
Added redeclaration to avoid access of component that is not in constraining type.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2471\">#2471</a>.
</li>
<li>
July 16, 2012, by Michael Wetter:<br/>
Revised implementation to extend from base case to avoid duplicate code.
Merged model into the Buildings library.
</li>
<li>
June 26, 2012, by Markus Nurschinger and Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case950FF;
