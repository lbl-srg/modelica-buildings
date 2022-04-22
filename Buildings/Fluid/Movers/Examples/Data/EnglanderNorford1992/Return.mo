within Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992;
record Return "Data for the return fan used in Englander and Norford (1992)"
  extends Buildings.Fluid.Movers.Data.Generic(
    etaHydMet=Buildings.Fluid.Movers.BaseClasses.Types.EfficiencyMethod.PowerCurve,
    speed_rpm_nominal=800,
    power(V_flow={10.2875112309074,24.9775381850853,35.4447439353099,53.414195867026},
          P={29828,44742,51050.622,44742}),
    pressure(V_flow={10.2875112309074,24.9775381850853,35.4447439353099,53.414195867026},
             dp={1453.61155698234,1371.42857142857,1052.9695024077,0}));
  annotation (
defaultComponentPrefixes="parameter",
defaultComponentName="per",
Documentation(info="<html>
<p>
Performance data for the return fan used in Englander and Norford (1992)
(figure below). See the documentation of
<a href=\"modelica://Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992\">
Buildings.Fluid.Movers.Examples.Data.EnglanderNorford1992</a>.
</p>
<p align=\"center\">
<img alt=\"Fan curve\" src=\"modelica://Buildings/Resources/Images/Fluid/Movers/Data/Return.png\"/></p>
</html>"));
end Return;
