within Buildings.Examples.VAVReheat;
model ASHRAE2006Euler
  "The same model as ASHRAE2006 but uses the fan uses the Euler number for efficiency estimation"
  extends Buildings.Examples.VAVReheat.ASHRAE2006(
    hvac(fanSup(
      per(
        peak(V_flow=hvac.mAir_flow_nominal/1.2,
             dp=780 + 10 + hvac.dpBuiStaSet,
             eta=0.49),
        etaMet=Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.EulerNumber))));

  annotation (
    Documentation(info="<html>
<p>
This is the same model as
<a href=\"Modelica://Buildings.Examples.VAVReheat.ASHRAE2006\">
Buildings.Examples.VAVReheat.ASHRAE2006</a>
except that it uses the Euler number method to estimate the efficiency and power
of <code>hvac.fanSup</code> instead of using constant values.
</p>
</html>", revisions="<html>
<ul>
<li>
April 25, 2022, by Hongxiang Fu:<br/>
First implementation. This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2668\">#2668</a>.
</li>
</ul>
</html>"),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Examples/VAVReheat/ASHRAE2006Euler.mos"
        "Simulate and plot"),
    experiment(
      StopTime=172800,
      Tolerance=1e-06),
    Icon(coordinateSystem(extent={{-100,-100},{100,100}})));
end ASHRAE2006Euler;
