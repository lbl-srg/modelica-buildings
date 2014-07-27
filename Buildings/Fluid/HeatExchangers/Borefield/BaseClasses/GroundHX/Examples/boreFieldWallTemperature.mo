within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.Examples;
model boreFieldWallTemperature
  extends Modelica.Icons.Example;

  parameter Data.GeneralData.c8x1_h110_b5_d3600_T283 gen;
  parameter Data.SoilData.SandStone soi;

  Modelica.SIunits.Temperature TWall;

equation
  if time < gen.tStep then
    TWall = 273.15;
  else
    TWall = BoreFieldWallTemperature(
      t_d=integer(time/gen.tStep),
      gen=gen,
      soi=soi);
  end if;

  annotation (experiment(StopTime=700000, __Dymola_NumberOfIntervals=100),
      __Dymola_experimentSetupOutput, Documentation(info="<html>
        <p>Test implementation of boreFieldWallTemperature function.</p>
</html>", revisions="<html>
<ul>
<li>
July 2014, by Damien Picard:<br>
First implementation.
</li>
</ul>
</html>"));
end boreFieldWallTemperature;
