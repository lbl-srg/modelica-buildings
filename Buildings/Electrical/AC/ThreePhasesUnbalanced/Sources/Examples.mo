within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources;
package Examples "Package with example models"
  extends Modelica.Icons.ExamplesPackage;
  model FixedVoltageSource
    "This example illustrates how using a fixed voltage source"
    extends Modelica.Icons.Example;
    FixedVoltage                             grid(
      f=60,
      V=480,
      definiteReference=true,
      phiSou=0.17453292519943) "AC one phase electrical grid"
      annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
    Sensors.ProbeWye                  sen(V_nominal=480)
      "Probe that measures the voltage at the load"
      annotation (Placement(transformation(extent={{-10,60},{10,80}})));
    Loads.Inductive loa(P_nominal=-2000, V_nominal=480) "Inductive load"
      annotation (Placement(transformation(extent={{20,30},{40,50}})));
    FixedVoltage_N grid_N(
      f=60,
      V=480,
      definiteReference=true,
      phiSou=0.17453292519943) "AC one phase electrical grid"
      annotation (Placement(transformation(extent={{-40,-70},{-20,-50}})));
    Sensors.ProbeWye_N sen_N(V_nominal=480)
      "Probe that measures the voltage at the load"
      annotation (Placement(transformation(extent={{-10,-40},{10,-20}})));
    Loads.Inductive_N loa_N(P_nominal=-2000, V_nominal=480) "Inductive load"
      annotation (Placement(transformation(extent={{20,-70},{40,-50}})));
  equation
    connect(grid.terminal, loa.terminal) annotation (Line(
        points={{-20,40},{20,40}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(grid.terminal, sen.term) annotation (Line(
        points={{-20,40},{0,40},{0,61}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(grid_N.terminal, loa_N.terminal) annotation (Line(
        points={{-20,-60},{20,-60}},
        color={127,0,127},
        smooth=Smooth.None));
    connect(grid_N.terminal, sen_N.term) annotation (Line(
        points={{-20,-60},{0,-60},{0,-39}},
        color={127,0,127},
        smooth=Smooth.None));
    annotation (      experiment(StopTime=1, Tolerance=1e-05),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/FixedVoltageSource.mos"
          "Simulate and plot"),
      Documentation(revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example shows how to use a fixed voltage generator model.
</p>
</html>"));
  end FixedVoltageSource;

  model PVPanels "This example illustrates how to use PV panel models"
    extends Modelica.Icons.Example;
    ThreePhasesUnbalanced.Loads.Inductive                                             RL(
      mode=Types.Load.VariableZ_y_input,
      P_nominal=-2000,
      V_nominal=480,
      plugPhase3=false) "Load taht consumes the power generted by the PVs"
      annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
    ThreePhasesUnbalanced.Sources.Grid grid(f=60, V=480)
      "Electrical grid model"
             annotation (Placement(transformation(extent={{-60,-20},{-40,0}})));
    Modelica.Blocks.Sources.Constant  load(k=0.5) "Load consumption"
      annotation (Placement(transformation(extent={{78,-50},{58,-30}})));
    BoundaryConditions.SolarIrradiation.DiffusePerez HDifTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Diffuse irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-52,72},{-32,92}})));
    BoundaryConditions.SolarIrradiation.DirectTiltedSurface HDirTil(
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745) "Direct irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-52,32},{-32,52}})));
    BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false,
        filNam="modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
      annotation (Placement(transformation(extent={{-100,72},{-80,92}})));
    Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
      annotation (Placement(transformation(extent={{-12,52},{8,72}})));
    PVsimple                               pvSimple(      V_nominal=480,
      A=100,
      areaFraction={0.5,0.3,0.2}) "PV array simplified"
      annotation (Placement(transformation(extent={{60,0},{40,20}})));
    PVsimpleOriented                               pvOriented(
      V_nominal=480,
      A=100,
      til=0.34906585039887,
      lat=0.65798912800186,
      azi=-0.78539816339745,
      areaFraction={0.5,0.3,0.2}) "PV array oriented"
      annotation (Placement(transformation(extent={{10,0},{-10,20}})));
  equation
    connect(weaDat.weaBus,HDifTil. weaBus) annotation (Line(
        points={{-80,82},{-52,82}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(weaDat.weaBus,HDirTil. weaBus) annotation (Line(
        points={{-80,82},{-66,82},{-66,42},{-52,42}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(HDifTil.H,G. u1) annotation (Line(
        points={{-31,82},{-24,82},{-24,68},{-14,68}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(HDirTil.H,G. u2) annotation (Line(
        points={{-31,42},{-24,42},{-24,56},{-14,56}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(G.y,pvSimple. G) annotation (Line(
        points={{9,62},{50,62},{50,21}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(weaDat.weaBus, pvOriented.weaBus) annotation (Line(
        points={{-80,82},{-66,82},{-66,26},{4.44089e-16,26},{4.44089e-16,19}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(load.y, RL.y2) annotation (Line(
        points={{57,-40},{40,-40}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(load.y, RL.y1) annotation (Line(
        points={{57,-40},{50,-40},{50,-34},{40,-34}},
        color={0,0,127},
        smooth=Smooth.None));
    connect(grid.terminal, RL.terminal) annotation (Line(
        points={{-50,-20},{-50,-40},{20,-40}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(grid.terminal, pvOriented.terminal) annotation (Line(
        points={{-50,-20},{-50,-40},{-18,-40},{-18,10},{-10,10}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(grid.terminal, pvSimple.terminal) annotation (Line(
        points={{-50,-20},{-50,-40},{14,-40},{14,10},{40,10}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (experiment(StopTime=172800, Tolerance=1e-05),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/PVPanels.mos"
          "Simulate and plot"),
      Documentation(revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>",   info="<html>
<p>
This example shows how to use a simple PV model without orientation
as well as a PV model with orientation. The power produced by the PV is
partially consumed by the load, and the remaining part is fed into
the grid.
</p>
<p>
The PV produces different amount of power on each phase according to the fractions
specified by the vector <code>areaFraction={0.5,0.3,0.2}</code>. In this case the 50%
of the power generation is on phase 1, while the remaining is split 30% and 20% between
phase 2 and 3 respectively.
</p>
</html>"));
  end PVPanels;

  model WindTurbine "Example for the WindTurbine AC model"
    import Buildings;
    extends Modelica.Icons.Example;
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.WindTurbine tur(
      table=[3.5, 0;
             5.5,   100;
             12, 900;
             14, 1000;
             25, 1000], h=10,
      scale=10,
      V_nominal=480,
      scaleFraction={0.5,0.25,0.25}) "Wind turbine"
      annotation (Placement(transformation(
          extent={{10,-10},{-10,10}},
          origin={60,0})));
    Buildings.BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
        computeWetBulbTemperature=false,
        filNam="modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos")
      "Weather data"
      annotation (Placement(transformation(extent={{-52,36},{-32,56}})));
    Buildings.BoundaryConditions.WeatherData.Bus weaBus "Weather bus";
    Loads.Resistive                           res(P_nominal=-500, V_nominal=480)
      "Resistive line"
      annotation (Placement(transformation(extent={{-22,-30},{-2,-10}})));
    Grid                                                     sou(f=60, V=480)
      "Voltage source"
      annotation (Placement(transformation(extent={{-80,10},{-60,30}})));
    Sensors.GeneralizedSensor                         sen "Generalized sensor"
      annotation (Placement(transformation(extent={{8,-10},{28,10}})));
    Buildings.Electrical.AC.ThreePhasesUnbalanced.Lines.Line line(
      l=200,
      P_nominal=5000,
      V_nominal=480)
      annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));
  equation
    connect(weaDat.weaBus,weaBus)  annotation (Line(
        points={{-32,46},{26,46}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(weaBus.winSpe,tur. vWin) annotation (Line(
        points={{26,46},{60,46},{60,12}},
        color={255,204,51},
        thickness=0.5,
        smooth=Smooth.None));
    connect(sou.terminal, res.terminal) annotation (Line(
        points={{-70,10},{-70,-20},{-22,-20}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(sen.terminal_p, tur.terminal) annotation (Line(
        points={{28,0},{50,0}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(sou.terminal, line.terminal_n) annotation (Line(
        points={{-70,10},{-70,0},{-40,5.55112e-16}},
        color={0,120,120},
        smooth=Smooth.None));
    connect(line.terminal_p, sen.terminal_n) annotation (Line(
        points={{-20,5.55112e-16},{8,0},{8,6.66134e-16}},
        color={0,120,120},
        smooth=Smooth.None));
    annotation (      experiment(StopTime=172800, Tolerance=1e-05),
Documentation(info="<html>
<p>
This model illustrates the use of the wind turbine model,
which is connected to a AC voltage source and a resistive load.
This voltage source can represent the grid to which the
circuit is connected.
Wind data for San Francisco, CA, are used.
The turbine cut-in wind speed is <i>3.5</i> m/s,
and hence it is off in the first day when the wind speed is low.
</p>
<p>
The wind turbines produce different amount of power on each phase according to the fractions
specified by the vector <code>scaleFraction={0.5,0.25,0.25}</code>. In this case the 50%
of the power generation is on phase 1, while the remaining is split 25% and 25% between
phase 2 and 3 respectively.
As expected the phase with the higher power production has the higher voltage deviation
from the nominal condition.
</p>
</html>",
        revisions="<html>
<ul>
<li>
September 25, 2014, by Marco Bonvini:<br/>
Created model and documentation
</li>
</ul>
</html>"),
      __Dymola_Commands(file=
            "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/WindTurbineAC.mos"
          "Simulate and plot"));
  end WindTurbine;
  annotation (Documentation(info="<html>
<p>
This package contains examples for the use of models that can be found in
<a href=\"modelica://Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources\">
Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources</a>.
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
