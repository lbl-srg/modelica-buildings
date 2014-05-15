within Buildings.Electrical.AC.OnePhase.Lines.Examples;
model AC_IEEE34
  extends Modelica.Icons.Example;
  Network network(redeclare Transmission.Grids.IEEE_34_AL120 grid,
    modelMode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
    useC=false)
    annotation (Placement(transformation(extent={{-20,0},{0,20}})));
  Loads.InductiveLoadP load[33](
      each P_nominal=1000,
    each pf=0.8,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each V_nominal=220,
    each linear=true)
    annotation (Placement(transformation(extent={{20,20},{40,40}})));
  Sources.FixedVoltage source(
    f=50,
    V=220,
    Phi=0)                annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=180,
        origin={30,10})));
  Transmission.Benchmark.DataSeries dataSeries(factorB=4.0)
    annotation (Placement(transformation(extent={{80,30},{60,50}})));
  Loads.CapacitiveLoadP PVloads[16](
    each pf=0.9,
    each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
    each V_nominal=220,
    each linear=false)
    annotation (Placement(transformation(extent={{20,40},{40,60}})));
protected
  final parameter Integer connectionMatrix[16,2]=[1,1; 2,5; 3,6; 4,9; 5,11; 6,14; 7,17; 8,18; 9,19; 10,20; 11,24; 12,27; 13,28; 14,29; 15,32; 16,33];
equation
  connect(source.terminal, network.terminal[1]) annotation (Line(
      points={{20,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(network.terminal[2:34], load[1:33].terminal) annotation (Line(
      points={{0,10},{10,10},{10,30},{20,30}},
      color={0,120,120},
      smooth=Smooth.None));
  for i in 1:33 loop
    connect(dataSeries.bldg[i], load[i].Pow) annotation (Line(
      points={{61,36},{50,36},{50,30},{40,30}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;

  for i in 1:16 loop
    connect(dataSeries.pv[i], PVloads[i].Pow) annotation (Line(
      points={{61,44},{50,44},{50,50},{40,50}},
      color={0,0,127},
      smooth=Smooth.None));
  end for;

  for i in 1:16 loop
    connect(PVloads[connectionMatrix[i,1]].terminal, network.terminal[connectionMatrix[i,2]]) annotation (Line(
      points={{20,50},{10,50},{10,10},{4.44089e-16,10}},
      color={0,120,120},
      smooth=Smooth.None));
  end for;
  annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics));
end AC_IEEE34;
