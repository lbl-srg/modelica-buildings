within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model AC_InHomeGrid
  extends Modelica.Icons.Example;
  Network network(redeclare
      Buildings.Electrical.Transmission.Grids.GridInHome_AL70                       grid,
    modelMode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    use_C=false)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Loads.ResistiveLoadP load[20](
      each P_nominal=1000,
    each V_nominal=230,
    each linear=false,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input)
    annotation (Placement(transformation(extent={{20,26},{40,46}})));
  Sources.FixedVoltage source(
    f=50,
    V=230,
    Phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,10})));
  Transmission.Benchmark.DataSeries_v2
                                    dataSeries
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
protected
  final parameter Integer connectionMatrix[16,2]=[1,1; 2,5; 3,6; 4,9; 5,11; 6,14; 7,17; 8,18; 9,19; 10,20; 11,24; 12,27; 13,28; 14,29; 15,32; 16,33];
equation
  for i in 1:20 loop
    connect(network.terminal[i+1], load[i].terminal) annotation (Line(
      points={{4.44089e-16,10},{10,10},{10,36},{20,36}},
      color={0,120,120},
      smooth=Smooth.None));
    connect(dataSeries.bldg[i], load[i].Pow) annotation (Line(
      points={{61,36},{40,36}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;

  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{20,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));

  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AC_InHomeGrid;
