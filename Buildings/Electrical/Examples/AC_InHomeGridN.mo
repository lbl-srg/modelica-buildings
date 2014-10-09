within Buildings.Electrical.Examples;
model AC_InHomeGridN
  extends Modelica.Icons.Example;
  parameter Boolean linearized = false;
  AC.ThreePhasesUnbalanced.Lines.Network_N network(redeclare
      Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids.GridInHome_AL70
      grid) annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  AC.ThreePhasesUnbalanced.Loads.Resistive_N load[20](
    each P_nominal=1000,
    each mode=Buildings.Electrical.Types.Load.VariableZ_P_input,
    each V_nominal=230,
    PlugPhase1=Phase1,
    PlugPhase2=Phase2,
    PlugPhase3=Phase3,
    each linearized=linearized)
    annotation (Placement(transformation(extent={{20,26},{40,46}})));
  AC.ThreePhasesUnbalanced.Sources.FixedVoltage_N source(
    f=50,
    Phi=0,
    V=230) annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,10})));
  Transmission.Benchmarks.DataSeries_v2 dataSeries
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  /*                                    1     2     3     4     5     6    7    8     9     10   11    12    13    14   15    16   17    18    19   20    */
protected
  final parameter Boolean Phase1[20] = {true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false};
  final parameter Boolean Phase2[20] = {false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true};
  final parameter Boolean Phase3[20] = {false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false};
  final parameter Integer connectionMatrix[16,2]=[1,1; 2,5; 3,6; 4,9; 5,11; 6,14; 7,17; 8,18; 9,19; 10,20; 11,24; 12,27; 13,28; 14,29; 15,32; 16,33];
equation

  for i in 1:20 loop
    connect(network.terminal[i+1], load[i].terminal_p) annotation (Line(
      points={{4.44089e-16,10},{10,10},{10,36},{20,36}},
      color={0,120,120},
      smooth=Smooth.None));

    if mod(i,3)==1 then
      connect(load[i].Pow1, dataSeries.bldg[i]) annotation (Line(
      points={{40,42},{50,42},{50,36},{61,36}},
      color={0,0,127},
      smooth=Smooth.None));
    elseif mod(i,3)==2 then
      connect(load[i].Pow2, dataSeries.bldg[i]) annotation (Line(
      points={{40,36},{61,36}},
      color={0,0,127},
      smooth=Smooth.None));
    else
      connect(load[i].Pow3, dataSeries.bldg[i]) annotation (Line(
      points={{40,30},{50,30},{50,36},{61,36}},
      color={0,0,127},
      smooth=Smooth.None));
    end if;

    end for;

  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{20,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics),
    experiment(
      StopTime=84600,
      Tolerance=1e-06,
      __Dymola_Algorithm="Radau"));
end AC_InHomeGridN;
