within Buildings.Electrical.AC.ThreePhasesUnbalanced.Sources.Examples;
model PVPanels_N
  "This example illustrates how to use PV panel models with neutral cable"
  extends Modelica.Icons.Example;
  ThreePhasesUnbalanced.Loads.Inductive_N                                             RL(
    mode=Types.Load.VariableZ_y_input,
    P_nominal=-2000,
    V_nominal=480,
    plugPhase3=false) "Load taht consumes the power generted by the PVs"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  ThreePhasesUnbalanced.Sources.Grid_N grid(f=60, V=480)
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
      filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_CA_San.Francisco.Intl.AP.724940_TMY3.mos"))
    annotation (Placement(transformation(extent={{-100,72},{-80,92}})));
  Modelica.Blocks.Math.Add G "Total irradiation on tilted surface"
    annotation (Placement(transformation(extent={{-12,52},{8,72}})));
  PVsimple_N                               pvSimple(      V_nominal=480,
    A=100,
    plugPhase2=false,
    areaFraction={0.4,0.0,0.6}) "PV array simplified"
    annotation (Placement(transformation(extent={{60,0},{40,20}})));
  PVsimpleOriented_N                               pvOriented(
    V_nominal=480,
    A=100,
    plugPhase2=false,
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745,
    areaFraction={0.4,0.0,0.6}) "PV array oriented"
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
      points={{57,-40},{50,-40},{50,-40},{42,-40}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(load.y, RL.y1) annotation (Line(
      points={{57,-40},{50,-40},{50,-32},{42,-32}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(grid.terminal, RL.terminal) annotation (Line(
      points={{-50,-20},{-50,-40},{20,-40}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(grid.terminal, pvOriented.terminal) annotation (Line(
      points={{-50,-20},{-50,-40},{-20,-40},{-20,10},{-10,10}},
      color={127,0,127},
      smooth=Smooth.None));
  connect(grid.terminal, pvSimple.terminal) annotation (Line(
      points={{-50,-20},{-50,-40},{14,-40},{14,10},{40,10}},
      color={127,0,127},
      smooth=Smooth.None));
  annotation (experiment(StopTime=172800, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesUnbalanced/Sources/Examples/PVPanels_N.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
January 10, 2015, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how to use a simple PV model with neutral cable connection and without orientation
as well as a PV model with orientation. The power produced by the PV is
partially consumed by the load, and the remaining part is fed into
the grid.
</p>
<p>
The PV produces different amounts of power on each phase according to the fractions
specified by the vector <code>areaFraction={0.4,0.0,0.6}</code>. In this example, 40%
of the power generation is on phase 1, 0% on phase 2 (disconnected) and 60% on phase 3.
</p>
</html>"));
end PVPanels_N;
