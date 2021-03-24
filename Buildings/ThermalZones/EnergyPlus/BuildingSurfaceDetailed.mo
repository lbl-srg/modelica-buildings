within Buildings.ThermalZones.EnergyPlus;
model BuildingSurfaceDetailed
  "Model to exchange heat of an opaque construction with EnergyPlus"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;
  extends
    Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.ObjectSynchronizer;

  parameter String surfaceName
    "Surface unique name in the EnergyPlus idf file";

  final parameter Modelica.SIunits.Area A(
    final fixed=false,
    min=1E-10)
    "Surface area";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorFro
    "Heat port for front surface" annotation (Placement(transformation(extent={{-110,
            -10},{-90,10}}),
                        iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorBac
    "Heat port for back surface" annotation (Placement(transformation(extent={{90,-10},
            {110,10}}),iconTransformation(extent={{88,-10},{108,10}})));
  Modelica.SIunits.HeatFlux qFro_flow "Heat flow rate at front surface per unit area";
  Modelica.SIunits.HeatFlux qBac_flow "Heat flow rate at front surface per unit area";
protected
  constant Integer nParOut = 1 "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp = 2 "Number of inputs";
  constant Integer nOut = 2 "Number of outputs";
  constant Integer nDer = 2 "Number of derivatives";
  constant Integer nY = nOut + nDer + 1 "Size of output vector of exchange function";
  parameter Integer nObj(fixed=false, start=0) "Total number of Spawn objects in building";

  Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject(
    objectType=6,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    idfName=idfName,
    weaName=weaName,
    epName=surfaceName,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
    logLevel=logLevel,
    printUnit=false,
    jsonName = "buildingSurfaceDetailed",
    jsonKeysValues = "        \"name\": \"" + surfaceName + "\"",
    parOutNames = {"A"},
    parOutUnits = {"m2"},
    nParOut = nParOut,
    inpNames = {"TFront", "TBack"},
    inpUnits = {"K", "K"},
    nInp = nInp,
    outNames = {"QFront_flow", "QBack_flow"},
    outUnits = {"W", "W"},
    nOut = nOut,
    derivatives_structure = {{1, 1}, {2, 2}},
    nDer = nDer,
    derivatives_delta = {0.01, 0.01})
    "Class to communicate with EnergyPlus";

  Real yEP[nY] "Output of exchange function";

  Modelica.SIunits.Time tNext(
    start=startTime,
    fixed=true)
    "Next sampling time";
  discrete Modelica.SIunits.Time tLast(
    fixed=true,
    start=startTime)
    "Last time of data exchange";
  discrete Modelica.SIunits.Time dtLast
    "Time step since the last synchronization";
  discrete Modelica.SIunits.Temperature TFroLast
    "Front surface temperature at last sampling";
  discrete Modelica.SIunits.Temperature TBacLast
    "Back surface temperature at last sampling";
  discrete Modelica.SIunits.HeatFlowRate QFroLast_flow(
    fixed=false,
    start=0)
    "Surface heat flow rate at front if T = TLast";
  discrete Modelica.SIunits.HeatFlowRate QBacLast_flow(
    fixed=false,
    start=0)
    "Surface heat flow rate at back if T = TLast";
  discrete Real dQFro_flow_dT(
    final unit="W/K")
    "Derivative dQFroCon_flow / dT";
  discrete Real dQBac_flow_dT(
    final unit="W/K")
    "Derivative dQBacCon_flow / dT";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for ZoneSurface.");
  nObj=Buildings.ThermalZones.EnergyPlus.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);

  {A} = Buildings.ThermalZones.EnergyPlus.BaseClasses.getParameters(
    adapter=adapter,
    nParOut = nParOut,
    isSynchronized = nObj);

  assert(
    A > 0,
    "Surface area must not be zero.");
equation
  when {initial(), time >= pre(tNext)} then
    // Initialization of output variables.
    TFroLast=heaPorFro.T;
    TBacLast=heaPorBac.T;
    dtLast=time-pre(
      tLast);

    yEP = Buildings.ThermalZones.EnergyPlus.BaseClasses.exchange(
      adapter = adapter,
      initialCall = false,
      nY = nY,
      u = {heaPorFro.T, heaPorBac.T, round(time, 1E-3)},
      dummy = A);

    QFroLast_flow = yEP[1];
    QBacLast_flow = yEP[2];
    dQFro_flow_dT = yEP[3];
    dQBac_flow_dT = yEP[4];
    tNext = yEP[3];
    tLast=time;
  end when;
  heaPorFro.Q_flow=QFroLast_flow+(heaPorFro.T-TFroLast)*dQFro_flow_dT;
  heaPorBac.Q_flow=QBacLast_flow+(heaPorBac.T-TBacLast)*dQBac_flow_dT;
  qFro_flow = heaPorFro.Q_flow/A;
  qBac_flow = heaPorBac.Q_flow/A;

  nObj = synBui.synchronize.done;

  annotation (
    defaultComponentName="buiSur",
    Documentation(
      info="<html>
      <p>
      fixme: Update for this new model that is no longer a surface.

Block that sends for a room-side facing surface its temperature to EnergyPlus and receives the
room-side heat flow rate from EnergyPlus.
</p>
<p>
This model writes at every EnergyPlus zone time step the value of the input <code>T</code>
to an EnergyPlus surface object with name <code>surfaceName</code>,
and produces at the output <code>Q_flow</code>
the net heat flow rate added to the surface from the air-side.
This heat flow rate consists of
</p>
<p>
<ul>
<li>
convective heat flow rate,
</li>
<li>
absorbed solar radiation,
</li>
<li>
absorbed infrared radiation minus emitted infrared radiation.
</li>
</ul>
</p>
<p>
By convention, <code>Q_flow &gt; 0</code> if there is net heat flow rate from the thermal zone to the surface,
e.g., if the surface cools the thermal zone.
The output <code>q_flow</code> is equal to <code>q_flow = Q_flow/A</code>, where
<code>A</code> is the area of the heat transfer surface as obtained from EnergyPlus.
</p>
<h4>Usage</h4>
<p>
Consider an EnergyPlus input data file that has the following entry:
</p>
<pre>
  BuildingSurface:Detailed,
    Living:Floor,            !- Name
    FLOOR,                   !- Surface Type
    FLOOR:LIVING,            !- Construction Name
    LIVING ZONE,             !- Zone Name
    Surface,                 !- Outside Boundary Condition
    Living:Floor,            !- Outside Boundary Condition Object
    NoSun,                   !- Sun Exposure
    NoWind,                  !- Wind Exposure
    0,                       !- View Factor to Ground
    4,                       !- Number of Vertices
    0,       0,     0,       !- X,Y,Z ==> Vertex 1 {m}
    0,      10.778, 0,       !- X,Y,Z ==> Vertex 2 {m}
    17.242, 10.778, 0,       !- X,Y,Z ==> Vertex 3 {m}
    17.242,  0,     0;       !- X,Y,Z ==> Vertex 4 {m}
</pre>
<p>
To set the temperature of this surface, this model can be used as
</p>
<pre>
Buildings.ThermalZones.EnergyPlus.ZoneSurface flo(surfaceName=\"Living:Floor\");
</pre>
<p>
The temperature of this surface will then be set to the value received
at the connector <code>T</code>, and the net heat flow rate
received from the thermal zone is produced at the output <code>Q_flow</code>.
The output <code>q_flow = Q_flow / A</code> is the heat flux
per unit area of the surface.
</p>
<p>
If used to connect a radiant slab from Modelica to EnergyPlus, this Modelica
model is used twice, once to model the upwards facing surface of the slab, e.g., the floor,
and once to model the downward facing surface, e.g., the ceiling.
If the slab is above soil, then only one of this model may be used, but the downward facing surface
of the slab needs to be connected to a soil model.
Both of these configurations are illustrated in the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling</a>.
</p>
</html>",
revisions="<html>
<ul>
<li>
February 9, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2358\">issue 2358</a>.
</li>
</ul>
</html>"),
    Icon(graphics={
   Rectangle(
    extent={{0,66},{80,-66}},       fillColor={175,175,175},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Rectangle(
    extent={{-80,66},{0,-66}},      fillColor={215,215,215},
   fillPattern=FillPattern.Solid,    lineColor={175,175,175}),
   Line(points={{-92,0},{90,0}},      color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{-18,-40},{-32,-40}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{-12,-32},{-38,-32}},     color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),            Line(points={{-25,0},{-25,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
   Line(points={{32,-40},{18,-40}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),
   Line(points={{38,-32},{12,-32}},       color = {0, 0, 0}, thickness = 0.5,
   smooth = Smooth.None),            Line(points={{25,0},{25,-32}},
   color = {0, 0, 0}, thickness = 0.5, smooth = Smooth.None),
                                     Rectangle(extent={{-60,6},{-40,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{-10,6},{10,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid), Rectangle(extent={{40,6},{60,-6}},
   lineColor = {0, 0, 0}, lineThickness =  0.5, fillColor = {255, 255, 255},
   fillPattern = FillPattern.Solid),
        Text(
          extent={{-76,68},{-50,40}},
          lineColor={0,0,127},
          textString="Front"),
        Text(
          extent={{50,70},{76,42}},
          lineColor={0,0,127},
          textString="Back")}));
end BuildingSurfaceDetailed;
