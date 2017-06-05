within Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx;
model Case920 "Case 900, but with windows on East and West side walls"
  extends Buildings.ThermalZones.Detailed.Validation.BESTEST.Cases9xx.Case900(
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
    annualHea(Min=3.313*3.6e9, Max=4.300*3.6e9, Mean=3.973*3.6e9),
    annualCoo(Min=-1.840*3.6e9, Max=-3.092*3.6e9, Mean=-2.552*3.6e9),
    peakHea(Min=3.308*1000, Max=4.061*1000, Mean=3.804*1000),
    peakCoo(Min=-2.385*1000, Max=-3.505*1000, Mean=-3.077*1000)));

  annotation (__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/ThermalZones/Detailed/Validation/BESTEST/Cases9xx/Case920.mos"
        "Simulate and plot"),
        experiment(
      StopTime=3.1536e+07,
      Interval=3600,
      Tolerance=1e-06),
    Documentation(info="<html>
<p>
This model is the case 920 of the BESTEST validation suite.
Case 920 differs from case 900 in that the west and east facing walls
have a window, but there is no window in the south facing wall.
</p>
</html>",
revisions="<html>
<ul>
<li>
July 16, 2012, by Michael Wetter:<br/>
Merged model into library.
</li>
<li>
June 26, 2012, by Roman Ilk and Rafael Velazquez:<br/>
First implementation.
</li>
</ul>
</html>"));
end Case920;
