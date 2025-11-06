within Buildings.DHC.ETS.Combined.Validation;
model HeatRecoveryHeatPump
  "Validation of the ETS model with heat recovery heat pump"
  extends Buildings.DHC.ETS.Combined.Examples.HeatRecoveryHeatPump(
    TDisWatSup(
      tableName="tab1",
      table=[
        0,11;
        49,11;
        50,20;
        100,20],
      extrapolation=Modelica.Blocks.Types.Extrapolation.Periodic,
      timeScale=3600,
      offset={273.15},
      columns={2},
      smoothness=Modelica.Blocks.Types.Smoothness.MonotoneContinuousDerivative1),
    loa(
      tableOnFile=false,
      table=[
        0,0,0;
        1,0,0;
        2,0,1;
        3,0,1;
        4,0,0.5;
        5,0,0.5;
        6,0,0.1;
        7,0,0.1;
        8,0,0;
        9,0,0;
        10,0,0;
        11,0,0;
        12,0,0;
        13,1,0;
        14,1,0;
        15,0.5,0;
        16,0.5,0;
        17,0.1,0;
        18,0.1,0;
        19,0,0;
        20,0,0;
        21,0,0;
        22,0,0;
        23,0,0;
        24,0,1;
        25,1,1;
      26,1,0.5;
      27,0.5,0.5;
      28,0.5,0.1;
      29,0.1,0.1;
      30,0.1,0;
      31,0,0;
      32,0,0;
      33,0,0;
      34,0,0;
      35,0,1;
      36,0.1,1;
      37,0.1,0.5;
      38,0.5,0.5;
      39,0.5,0.1;
      40,1,0.1;
      41,1,0;
      42,0,0;
      43,0,0;
      44,0,0;
      45,0,0;
      46,0,0.3;
      47,0.1,0.3;
      48,0.1,0.1;
      49,0.3,0.1;
      50,0.3,0.1;
      51,0.1,0.1;
      52,0.1,0;
      53,0,0;
      54,0,0;
      55,0,0;
      56,0,0;
      57,1,1;
      58,1,1;
      59,0.5,0.5;
      60,0.5,0.5;
      61,0.1,0.1;
      62,0.1,0.1;
      63,0,0;
      64,0,0;
      65,0,0;
      66,0,0;
      67,1,0;
      68,1,1;
      69,0.5,1;
      70,0.5,0.5;
      71,0.1,0.5;
      72,0.1,0.1;
      73,0,0.1;
      74,0,0.1;
      75,0,0;
      76,0,0;
      77,0,0;
      78,0,0;
      79,0.1,0;
      80,0.1,1;
      81,0.5,1;
      82,0.5,0.5;
      83,1,0.5;
      84,1,0.1;
      85,0,0.1;
      86,0,0.1;
      87,0,0;
      88,0,0;
      89,0,0;
      90,0,0;
      91,0.1,0;
      92,0.1,0.3;
      93,0.3,0.3;
      94,0.3,0.1;
      95,0.1,0.1;
      96,0.1,0.1;
      97,0,0.1;
      98,0,0;
      99,0,0],
      timeScale=3600,
      offset={0,0},
      columns={2,3}),
    loaNorHea(k=1),
    loaNorCoo(k=1));

  annotation (
    __Dymola_Commands(
      file="modelica://Buildings/Resources/Scripts/Dymola/DHC/ETS/Combined/Validation/HeatRecoveryHeatPump.mos" "Simulate and plot"),
    experiment(
      StartTime=0,
      StopTime=360000,
      Tolerance=1e-06),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-340,-220},{340,220}})),
    Documentation(
      revisions="<html>
<ul>
<li>
November 3, 2025, by Michael Wetter:<br/>
Moved to <code>Buildings.Obsolete</code>.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/4354\">#4354</a>.
</li>
<li>
August 22, 2025, by Hongxiang Fu:<br/>
Updated the ETS component with modular heat pump model.
</li>
<li>
November 22, 2024, by Michael Wetter:<br/>
Removed duplicate connection.
</li>
<li>
July 31, 2020, by Antoine Gautier:<br/>
First implementation.
</li>
</ul>
</html>",
      info="<html>
<p>
This model validates
<a href=\"modelica://Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump\">
Buildings.DHC.ETS.Combined.HeatRecoveryHeatPump</a>
in a system configuration with a simple district loop, building heating and cooling load.
</p>
<ul>
<li>
A fictitious load profile is used, consisting in the succession of five load
patterns.
</li>
<li>
Each load pattern is simulated with two values of the district water supply
temperature, corresponding to typical extreme values over a whole year
 of operation.
</li>
<li>
The other modeling assumptions are described in
<a href=\"modelica://Buildings.Obsolete.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield\">
Buildings.Obsolete.DHC.ETS.Combined.Validation.BaseClasses.PartialChillerBorefield</a>.
</li>
</ul>
</html>"));
end HeatRecoveryHeatPump;
