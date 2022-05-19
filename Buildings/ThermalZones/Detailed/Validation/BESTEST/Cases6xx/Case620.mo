within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx;
model Case620 "Case 600, but with windows on East and West side walls"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases6xx.Case600(
  roo(
    nConExtWin=2,
    datConExtWin(
      layers={matExtWal, matExtWal},
      each A=6*2.7,
      glaSys={window600, window600},
      each wWin=3,
      each hWin=2,
      each fFra=0.001,
      each til=Z_,
      azi={W_,E_}),
    nConExt=3,
    datConExt(
      layers={roof,matExtWal,matExtWal},
      A={48,8*2.7,8*2.7},
      til={C_,Z_,Z_},
      azi={S_,S_,N_})),
   staRes(
    annualHea(Min=4.094*3.6e9, Max=4.719*3.6e9, Mean=4.413*3.6e9),
    annualCoo(Min=-3.841*3.6e9, Max=-4.404*3.6e9, Mean=-4.090*3.6e9),
    peakHea(Min=3.038*1000, Max=3.385*1000, Mean=3.186*1000),
    peakCoo(Min=-3.955*1000, Max=-4.797*1000, Mean=-4.527*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases6xx/Case620.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model is the case 620 of the BESTEST validation suite.
Case 620 differs from case 600 in that the west and east facing walls
have a window, but there is no window in the south facing wall.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 6, 2012, by Michael Wetter:<br/>
Changed implementation to extend from Case 600, rather
than copying Case 600.
This better shows what is different relative to Case 600
as it avoid duplicate code.
</li>
<li>
May 12, 2012, by Kaustubh Phalak:<br/>
Modified the Case 600 for implementation of Case 620.
</li>
<li>
October 6, 2011, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case620;
