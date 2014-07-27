within Buildings.Fluid.HeatExchangers.Borefield.BaseClasses.GroundHX.Examples;
model correctedBoreFieldWallTemperature
  extends Modelica.Icons.Example;
  import SI = Modelica.SIunits;

  parameter Integer lenSim=3600*24*365 "length of the simulation";

  parameter Modelica.SIunits.Temperature TResSho;

  SI.Temperature TWallCor;
  SI.Temperature TWallCorSteSta=CorrectedBoreFieldWallTemperature(
      t_d=integer(36000*24*365*30/gen.tStep),
      gen=gen,
      soi=soi,
      TResSho=TResSho);

  Integer timeSca "time step size for simulation";
  Integer timeSca_old;
  Integer i;
  Integer i_old;

  Integer t_old(start=0) "help variable for simulation timestep";
  Integer t_new(start=0) "help variable for simulation timestep";

  Data.SoilData.SandStone soi
    annotation (Placement(transformation(extent={{-90,-92},{-70,-72}})));
  Data.FillingData.Bentonite fil
    annotation (Placement(transformation(extent={{-58,-92},{-38,-72}})));
  Data.GeneralData.c8x1_h110_b5_d3600_T283 gen
    annotation (Placement(transformation(extent={{-28,-92},{-8,-72}})));
algorithm
  t_old := t_new;
  t_new := max(t_old, integer(integer(time/timeSca)*timeSca/gen.tStep));

algorithm
  when initial() then
    i := integer(2);
    i_old := i;
    timeSca := integer(gen.tStep);
    timeSca_old := timeSca;
  elsewhen sample(gen.tStep*10^1, gen.tStep*10^i/5) then
    i_old := i;
    i := i_old + 1;
    timeSca := integer(timeSca_old*2);
    timeSca_old := timeSca;
  end when;

equation
  TWallCor =CorrectedBoreFieldWallTemperature(
    t_d=max(t_old, integer(integer(time/timeSca)*timeSca/gen.tStep)),
    gen=gen,
    soi=soi,
    TResSho=TResSho);

  annotation (experiment(StopTime=720000, __Dymola_NumberOfIntervals=100),
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
end correctedBoreFieldWallTemperature;
