within Buildings.ThermalZones.EnergyPlus_24_2_0;
model ZoneSurface
  "Model to exchange heat with a inside-facing surface of a thermal zone"
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.PartialEnergyPlusObject;
  extends Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.Synchronize.ObjectSynchronizer;
  parameter String surfaceName
    "Surface unique name in the EnergyPlus idf file";
  final parameter Modelica.Units.SI.Area A(final fixed=false, min=1E-10)
    "Surface area";
  Modelica.Blocks.Interfaces.RealInput T(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Surface temperature"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final unit="W",
    final quantity="Power")
    "Net heat flow rate from the thermal zone to the surface (positive if surface is cold)"
    annotation (Placement(transformation(extent={{100,20},{140,60}}),iconTransformation(extent={{100,40},{140,80}})));
  Modelica.Blocks.Interfaces.RealOutput q_flow(
    final unit="W/m2",
    final quantity="HeatFlux")
    "Net heat flux from the thermal zone to the surface (positive if surface is cold)"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),iconTransformation(extent={{100,-80},{140,-40}})));

protected
  constant Integer nParOut=1
    "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp=1
    "Number of inputs";
  constant Integer nOut=1
    "Number of outputs";
  constant Integer nDer=0
    "Number of derivatives";
  constant Integer nY=nOut+nDer+1
    "Size of output vector of exchange function";
  parameter Integer nObj(
    fixed=false,
    start=0)
    "Total number of Spawn objects in building";
  Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.SpawnExternalObject(
    objectType=5,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    spawnExe=spawnExe,
    idfVersion=idfVersion,
    idfName=idfName,
    epwName=epwName,
    epName=surfaceName,
    hvacZone="n/a",
    autosizeHVAC=autosizeHVAC,
    use_sizingPeriods=use_sizingPeriods,
    runPeriod=runPeriod,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsRootFileLocation=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.buildingsRootFileLocation,
    logLevel=logLevel,
    printUnit=false,
    jsonName="zoneSurfaces",
    jsonKeysValues="        \"name\": \""+surfaceName+"\"",
    parOutNames={"A"},
    parOutUnits={"m2"},
    nParOut=nParOut,
    inpNames={"T"},
    inpUnits={"K"},
    nInp=nInp,
    outNames={"Q_flow"},
    outUnits={"W"},
    nOut=nOut,
    derivatives_structure=fill(fill(nDer,2),nDer),
    nDer=nDer,
    derivatives_delta=fill(0,nDer))
    "Class to communicate with EnergyPlus";
  //////////
  // The derivative structure was:
  //  derivatives_structure={{1,1}},
  //  nDer=nDer,
  //  derivatives_delta={0.1}
  // This has been removed due to numerical noise,
  // see https://github.com/lbl-srg/modelica-buildings/issues/2358#issuecomment-819578850
  //////////
  Real yEP[nY]
    "Output of exchange function";
  Modelica.Units.SI.Time tNext(start=startTime, fixed=true)
    "Next sampling time";
  discrete Modelica.Units.SI.Time tLast(fixed=true, start=startTime)
    "Last time of data exchange";
  discrete Modelica.Units.SI.Time dtLast
    "Time step since the last synchronization";
  discrete Modelica.Units.SI.Temperature TLast
    "Surface temperature at last sampling";
  discrete Modelica.Units.SI.HeatFlowRate QLast_flow(fixed=false, start=0)
    "Surface heat flow rate if T = TLast";
//  discrete Real dQ_flow_dT(
//    final unit="W/K")
//    "Derivative dQCon_flow / dT";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for ZoneSurface.");
  nObj=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);
  {A}=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.getParameters(
    adapter=adapter,
    nParOut=nParOut,
    isSynchronized=nObj);
  assert(
    A > 0,
    "Surface area must not be zero.");

equation
  when {initial(),time >= pre(tNext)} then
    // Initialization of output variables.
    TLast=T;
    dtLast=time-pre(tLast);
    yEP=Buildings.ThermalZones.EnergyPlus_24_2_0.BaseClasses.exchange(
      adapter=adapter,
      nY=nY,
      u={T,round(time,1E-3)},
      dummy=A);
    QLast_flow=yEP[1];
    //dQ_flow_dT=yEP[2];
    //tNext=yEP[3];
    tNext=yEP[2];
    tLast=time;
  end when;
  //Q_flow=QLast_flow+(T-TLast)*dQ_flow_dT;
  Q_flow=QLast_flow;
  q_flow=Q_flow/A;
  nObj=synBui.synchronize.done;
  annotation (
    defaultComponentName="sur",
    Documentation(
      info="<html>
<p>
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
<ul>
<li>
convective heat flow rate,
</li>
<li>
absorbed solar radiation, and
</li>
<li>
absorbed infrared radiation minus emitted infrared radiation.
</li>
</ul>
<p>
By convention, <code>Q_flow &gt; 0</code> if there is net heat flow rate from the thermal zone to the surface,
e.g., if the surface cools the thermal zone.
The output <code>q_flow</code> is equal to <code>q_flow = Q_flow/A</code>, where
<code>A</code> is the area of the heat transfer surface as obtained from EnergyPlus.
</p>
<p>
Note that for most applications that require interfacing the front-facing and back-side facing surface with the
building model, the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.OpaqueConstruction\">
Buildings.ThermalZones.EnergyPlus_24_2_0.OpaqueConstruction</a>
is easier to use.
</p>
<h4>Usage</h4>
<p>
This model is typically used for a radiant slab above soil if the ground heat transfer is also modeled in Modelica.
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
Buildings.ThermalZones.EnergyPlus_24_2_0.ZoneSurface flo(surfaceName=\"Living:Floor\");
</pre>
<p>
The temperature of this surface will then be set to the value received
at the connector <code>T</code>, and the net heat flow rate
received from the thermal zone is produced at the output <code>Q_flow</code>.
The output <code>q_flow = Q_flow / A</code> is the heat flux
per unit area of the surface.
</p>
<p>
The model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer\">
Buildings.ThermalZones.EnergyPlus_24_2_0.Examples.SingleFamilyHouse.HeatPumpRadiantHeatingGroundHeatTransfer</a>
illustrates this use. Note that if the ground heat transfer were modeled in EnergyPlus, then
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_24_2_0.OpaqueConstruction\">
Buildings.ThermalZones.EnergyPlus_24_2_0.OpaqueConstruction</a>
should have been used, which is simpler to setup.
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
    Icon(
      graphics={
        Rectangle(
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-78,-64},{70,68}}),
        Rectangle(
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          extent={{56,-50},{-62,56}}),
        Rectangle(
          extent={{-62,-44},{56,-50}},
          lineColor={238,46,47},
          fillColor={238,46,47},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-112,72},{-136,29}},
          textColor={0,0,0},
          textString="T"),
        Text(
          extent={{144,110},{106,71}},
          textColor={0,0,0},
          textString="Q_flow"),
        Text(
          extent={{144,-10},{106,-49}},
          textColor={0,0,0},
          textString="q_flow")}));
end ZoneSurface;
