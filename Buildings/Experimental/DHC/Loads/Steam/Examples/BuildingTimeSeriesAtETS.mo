within Buildings.Experimental.DHC.Loads.Steam.Examples;
model BuildingTimeSeriesAtETS
  "Example model for time series load with external read-in file."
  extends Modelica.Icons.Example;

  package MediumSte = Buildings.Media.Steam (p_default=400000,
    T_default=273.15+143.61,
    h_default=2738100) "Steam medium";
  package MediumWat =
    Buildings.Media.Specialized.Water.TemperatureDependentDensity
    "Water medium";

  parameter Modelica.Units.SI.AbsolutePressure pSat=400000
    "Saturation pressure";
  parameter Modelica.Units.SI.Temperature TSat=
     MediumSte.saturationTemperature(pSat)
     "Saturation temperature";
  parameter Modelica.Units.SI.Power Q_flow_nominal= 2e4
    "Nominal heat flow rate";

  Buildings.Experimental.DHC.Loads.Steam.BuildingTimeSeriesAtETS bui(
    redeclare package MediumSte = MediumSte,
    redeclare package MediumWat = MediumWat,
    have_prv=true,
    pLow_nominal=200000,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    dp_nominal=3000,
    tableOnFile=false,
    final Q_flow_nominal=Q_flow_nominal,
    final pSte_nominal=pSat,
    QHeaLoa=[0,Q_flow_nominal*0.2; 6,Q_flow_nominal; 16,Q_flow_nominal*0.1; 24,Q_flow_nominal*0.2],
    columns={2},
    smoothness=Modelica.Blocks.Types.Smoothness.ContinuousDerivative,
    timeScale(displayUnit="h") = 3600,
    show_T=true)
    "Building model with time series load at the ETS"
    annotation (Placement(transformation(extent={{-60,0},{-40,20}})));
  Buildings.Fluid.Sources.Boundary_pT souSte(
    redeclare final package Medium = MediumSte,
    p(displayUnit="Pa") = pSat,
    T=TSat,
    nPorts=1)
    "Steam source"
    annotation (Placement(transformation(extent={{42,30},{22,50}})));
  Buildings.Fluid.Sources.Boundary_pT watSin(
    redeclare final package Medium = MediumWat,
    p=101325,
    nPorts=1)
    "Water sink"
    annotation (Placement(transformation(extent={{42,-6},{22,14}})));
equation
  connect(souSte.ports[1], bui.port_a)
    annotation (Line(points={{22,40},{10,40},{10,10},{-40,10}},
                                              color={0,127,255}));
  connect(bui.port_b, watSin.ports[1]) annotation (Line(points={{-40,4},{22,4}},
                           color={0,127,255}));
  annotation (Icon(coordinateSystem(preserveAspectRatio=false)), Diagram(
        coordinateSystem(preserveAspectRatio=false)),
  experiment(
      StartTime=1728000,
      StopTime=1814400,
      Tolerance=1e-06),
__Dymola_Commands(file=
  "modelica://Buildings/Resources/Scripts/Dymola/Experimental/DHC/Loads/Steam/Examples/BuildingTimeSeriesAtETS.mos"
  "Simulate and plot"),
    Documentation(info="<html>
<p>
Example model for the steam building model with heat flow 
rate prescribed as a time series at the district-side 
of the energy transfer station (ETS).
</p>
</html>", revisions="<html>
<ul>
<li>
March 2, 2022, by Kathryn Hinkelman:<br/>
First implementation.
</li>
</ul>
</html>"));
end BuildingTimeSeriesAtETS;
