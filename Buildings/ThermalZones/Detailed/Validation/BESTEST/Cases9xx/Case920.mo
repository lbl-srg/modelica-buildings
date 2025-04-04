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
    annualHea(Min=2.956*3.6e9, Max=3.607*3.6e9, Mean=3.326*3.6e9),
    annualCoo(Min=-2.549*3.6e9, Max=-3.128*3.6e9, Mean=-2.786*3.6e9),
    peakHea(Min=2.512*1000, Max=2.895*1000, Mean=2.710*1000),
    peakCoo(Min=-2.710*1000, Max=-3.481*1000, Mean=-3.127*1000)),
   heaCri(lowerLimit=2.55*3.6e9, upperLimit=4.2*3.6e9),
   cooCri(lowerLimit=-2.43*3.6e9, upperLimit=-3.08*3.6e9));

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
May 12, 2023, by Jianjun Hu:<br/>
Added test acceptance criteria limits.
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3396\">issue 3396</a>.
</li> 
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
