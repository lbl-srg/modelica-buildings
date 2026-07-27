within Buildings.Fluid.Geothermal.Borefields.Examples;
model BorefieldsDarcyPressureDrop
  "Validation model for Darcy-Weisbach pressure drop in borefields"
  extends Buildings.Fluid.Geothermal.Borefields.Examples.Borefields(
    borFieUTubDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.SingleUTube,
        use_DarcyPressureDrop=true)),
    borFie2UTubParDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeParallel,
        use_DarcyPressureDrop=true)),
    borFie2UTubSerDat(
      conDat=Buildings.Fluid.Geothermal.Borefields.Data.Configuration.Example(
        borCon=Buildings.Fluid.Geothermal.Borefields.Types.BoreholeConfiguration.DoubleUTubeSeries,
        use_DarcyPressureDrop=true)));

  annotation (
    __Dymola_Commands(file=
      "modelica://Buildings/Resources/Scripts/Dymola/Fluid/Geothermal/Borefields/Examples/BorefieldsDarcyPressureDrop.mos"
      "Simulate and plot"),
    Documentation(info="<html>
<p>
This validation model extends
<a href=\"modelica://Buildings.Fluid.Geothermal.Borefields.Examples.Borefields\">
Buildings.Fluid.Geothermal.Borefields.Examples.Borefields</a>
and enables the Darcy-Weisbach pressure-drop calculation for all borefield
configurations.
</p>
<p>
The model compares three borefield configurations:
</p>
<ul>
<li>
single U-tube,
</li>
<li>
double U-tube with the two U-tube circuits connected in parallel,
</li>
<li>
double U-tube with the two U-tube circuits connected in series.
</li>
</ul>
<p>
The mass-flow rates are constant and equal to the nominal borefield mass-flow
rates. Therefore, this validation checks the Darcy-Weisbach pressure drop at
the nominal operating point.
</p>
<p>
The expected pressure-drop magnitude ordering is
</p>
<pre>
abs(borFie2UTubPar.dp) &lt; abs(borFieUTub.dp) &lt; abs(borFie2UTubSer.dp)
</pre>
<p>
The double U-tube parallel configuration has the lowest pressure drop because
the flow is split over two U-tube circuits. The double U-tube series
configuration has the highest pressure drop because the flow passes through
both U-tube circuits in series.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 2026, by Lone Meertens:<br/>
First implementation for validating Darcy-Weisbach pressure drop in borefields
at constant mass-flow conditions.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4656\">Buildings, #4656</a>.
</li>
</ul>
</html>"),
    experiment(
      StopTime=36000,
      Tolerance=1e-6));
end BorefieldsDarcyPressureDrop;
