within Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Examples;
model PVPanels "This example illustrates how to use PV panel models"
  extends Modelica.Icons.Example;
  Buildings.Electrical.AC.ThreePhasesBalanced.Loads.Inductive RL(
    mode=Types.Load.VariableZ_y_input,
    P_nominal=-2000,
    V_nominal=480) "Load taht consumes the power generted by the PVs"
    annotation (Placement(transformation(extent={{20,-50},{40,-30}})));
  Buildings.Electrical.AC.ThreePhasesBalanced.Sources.Grid grid(f=60, V=480)
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
  ThreePhasesBalanced.Sources.PVSimple pvSimple(A=10, V_nominal=480)
    "PV array simplified"
    annotation (Placement(transformation(extent={{40,0},{60,20}})));
  ThreePhasesBalanced.Sources.PVSimpleOriented pvOriented(
    A=10,
    V_nominal=480,
    til=0.34906585039887,
    lat=0.65798912800186,
    azi=-0.78539816339745) "PV array oriented"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));
equation
  connect(grid.terminal, RL.terminal)
                                     annotation (Line(
      points={{-50,-20},{-50,-40},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(load.y, RL.y)
                       annotation (Line(
      points={{57,-40},{40,-40}},
      color={0,0,127},
      smooth=Smooth.None));
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
      points={{9,62},{50,62},{50,22}},
      color={0,0,127},
      smooth=Smooth.None));
  connect(pvSimple.terminal, RL.terminal) annotation (Line(
      points={{40,10},{20,10},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  connect(weaDat.weaBus, pvOriented.weaBus) annotation (Line(
      points={{-80,82},{-66,82},{-66,26},{4.44089e-16,26},{4.44089e-16,19}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None));
  connect(pvOriented.terminal, RL.terminal) annotation (Line(
      points={{-10,10},{-28,10},{-28,-40},{20,-40}},
      color={0,120,120},
      smooth=Smooth.None));
  annotation (experiment(StopTime=172800, Tolerance=1e-6),
    __Dymola_Commands(file=
          "modelica://Buildings/Resources/Scripts/Dymola/Electrical/AC/ThreePhasesBalanced/Sources/Examples/PVPanels.mos"
        "Simulate and plot"),
    Documentation(revisions="<html>
<ul>
<li>
September 22, 2014, by Marco Bonvini:<br/>
Created model and documentation.
</li>
</ul>
</html>", info="<html>
<p>
This example shows how to use a simple PV model without orientation
as well as a PV model with orientation. The power produced by the PV is
partially consumed by the load, and the remaining part is fed into
the grid.
</p>
</html>"));
end PVPanels;
