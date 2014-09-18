within Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  model ACline
    extends Modelica.Icons.Example;

    Sources.FixedVoltage fixedVoltage(
      f=50,
      V=380,
      Phi=0) annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));
    Line line(
      l=2000,
      P_nominal=5000,
      V_nominal=380,
      mode=Buildings.Electrical.Types.CableMode.commercial,
      voltageLevel=Buildings.Electrical.Types.VoltageLevel.Low,
      commercialCable_low=
          Buildings.Electrical.Transmission.LowVoltageCables.PvcAl70())
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
    Loads.Inductive inductiveLoadP(
      mode=Buildings.Electrical.Types.Assumption.FixedZ_steady_state,
      V_nominal=380,
      P_nominal=-4000)
      annotation (Placement(transformation(extent={{0,-10},{20,10}})));
  equation
    connect(fixedVoltage.terminal, line.terminal_n) annotation (Line(
        points={{-60,0},{-40,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line.terminal_p, inductiveLoadP.terminal_p) annotation (Line(
        points={{-20,0},{-4.44089e-16,0}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{-100,
              -100},{100,100}}), graphics));
  end ACline;

  model MatrixRLCLine
    "Model of a AC three phase unbalanced line with matrix representation"
    extends Modelica.Icons.Example;

    Sources.FixedVoltage fixedVoltage(
      f=50,
      V=380,
      Phi=0,
      angle120(displayUnit="rad"))
             annotation (Placement(transformation(extent={{-80,0},{-60,20}})));
    TwoPortMatrixRL line(
      Z12={0,0},
      Z13={0,0},
      Z23={0,0},
      Z11={0,0},
      Z22={0,0},
      Z33={0,0})
      annotation (Placement(transformation(extent={{-34,0},{-14,20}})));
    Loads.Resistive load(
      P_nominal=-5000,
      V_nominal=380,
      loadConn=Buildings.Electrical.Types.LoadConnection.wye_to_delta,
      PlugPhase1=false,
      PlugPhase2=false,
      PlugPhase3=true)
      annotation (Placement(transformation(extent={{10,0},{30,20}})));
  equation
    connect(fixedVoltage.terminal, line.terminal_n) annotation (Line(
        points={{-60,10},{-34,10}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line.terminal_p, load.terminal_p) annotation (Line(
        points={{-14,10},{10,10}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (Diagram(coordinateSystem(preserveAspectRatio=false, extent={{
              -100,-100},{100,100}}), graphics));
  end MatrixRLCLine;

  model AC_InHomeGrid
    extends Modelica.Icons.Example;
    parameter Boolean linearized = false;
    Network network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids.GridInHome_AL70
        grid)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Loads.Resistive load[20](
      each P_nominal=1000,
      each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
      each V_nominal=230,
      PlugPhase1=Phase1,
      PlugPhase2=Phase2,
      PlugPhase3=Phase3,
      each linearized=linearized)
      annotation (Placement(transformation(extent={{20,26},{40,46}})));
    Sources.FixedVoltage source(
      f=50,
      Phi=0,
      V=230)                annotation (Placement(transformation(
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
              -100},{100,100}}), graphics));
  end AC_InHomeGrid;

  model AC_InHomeGridN
    extends Modelica.Icons.Example;
    parameter Boolean linearized = false;
    NetworkN network(redeclare
        Buildings.Electrical.Transmission.Benchmarks.BenchmarkGrids.GridInHome_AL70
        grid)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Loads.Resistive_N load[20](
      each P_nominal=1000,
      each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
      each V_nominal=230,
      PlugPhase1=Phase1,
      PlugPhase2=Phase2,
      PlugPhase3=Phase3,
      each linearized=linearized)
      annotation (Placement(transformation(extent={{20,26},{40,46}})));
    Sources.FixedVoltage_N source(
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

  model AC_IEEE34_GridN
    extends Modelica.Icons.Example;
    parameter Boolean linearized = false;
    NetworkN network(
                    redeclare
        Buildings.Electrical.Transmission.Grids.IEEE_34_AL120 grid)
      annotation (Placement(transformation(extent={{-20,0},{0,20}})));
    Loads.Resistive_N load[33](
      each P_nominal=1000,
      each mode=Buildings.Electrical.Types.Assumption.VariableZ_P_input,
      each V_nominal=230,
      PlugPhase1=Phase1,
      PlugPhase2=Phase2,
      PlugPhase3=Phase3,
      each linearized=linearized)
      annotation (Placement(transformation(extent={{20,26},{40,46}})));
    Sources.FixedVoltage_N source(
      f=50,
      Phi=0,
      V=230) annotation (Placement(transformation(
          extent={{-10,-10},{10,10}},
          rotation=180,
          origin={30,10})));
    Transmission.Benchmarks.DataSeries_v2 dataSeries
      annotation (Placement(transformation(extent={{80,30},{60,50}})));
    /*                                    1     2     3     4     5     6    7    8     9     10   11    12    13    14   15    16   17    18    19   20   21     22    23    24   25    26   27    28   29    30    31    32    33  */
  protected
    final parameter Boolean Phase1[33] = {true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false};
    final parameter Boolean Phase2[33] = {false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false};
    final parameter Boolean Phase3[33] = {false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true,false,false,true};
    final parameter Integer connectionMatrix[16,2]=[1,1; 2,5; 3,6; 4,9; 5,11; 6,14; 7,17; 8,18; 9,19; 10,20; 11,24; 12,27; 13,28; 14,29; 15,32; 16,33];
  equation

    for i in 1:33 loop
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
              -100},{100,100}}), graphics));
  end AC_IEEE34_GridN;
  annotation (Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines</a>.
</p>
</html>", revisions="<html>
<ul>
<li>
August 25, 2014, by Marco Bonvini:<br/>
Revised documentation.
</li>
</ul>
</html>"));
end Examples;
