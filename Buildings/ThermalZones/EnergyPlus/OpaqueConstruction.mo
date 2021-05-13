within Buildings.ThermalZones.EnergyPlus;
model OpaqueConstruction
  "Model to exchange heat of an opaque construction with EnergyPlus"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.ObjectSynchronizer;
  parameter String surfaceName
    "Surface unique name in the EnergyPlus idf file";
  final parameter Modelica.SIunits.Area A(
    final fixed=false,
    min=1E-10)
    "Surface area";
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorFro
    "Heat port for front surface"
    annotation (Placement(transformation(extent={{-110,-10},{-90,10}}),iconTransformation(extent={{-110,-10},{-90,10}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_b heaPorBac
    "Heat port for back surface"
    annotation (Placement(transformation(extent={{90,-10},{110,10}}),iconTransformation(extent={{88,-10},{108,10}})));
  Modelica.SIunits.HeatFlux qFro_flow
    "Heat flow rate at front surface per unit area";
  Modelica.SIunits.HeatFlux qBac_flow
    "Heat flow rate at front surface per unit area";

protected
  constant Integer nParOut=1
    "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp=2
    "Number of inputs";
  constant Integer nOut=2
    "Number of outputs";
  constant Integer nDer=0
    "Number of derivatives";
  constant Integer nY=nOut+nDer+1
    "Size of output vector of exchange function";
  parameter Integer nObj(
    fixed=false,
    start=0)
    "Total number of Spawn objects in building";
  Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject(
    objectType=6,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    idfName=idfName,
    weaName=weaName,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    epName=surfaceName,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
    logLevel=logLevel,
    printUnit=false,
    jsonName="buildingSurfaceDetailed",
    jsonKeysValues="        \"name\": \""+surfaceName+"\"",
    parOutNames={"A"},
    parOutUnits={"m2"},
    nParOut=nParOut,
    inpNames={"TFront","TBack"},
    inpUnits={"K","K"},
    nInp=nInp,
    outNames={"QFront_flow","QBack_flow"},
    outUnits={"W","W"},
    nOut=nOut,
    derivatives_structure=fill(fill(nDer,2),nDer),
    nDer=nDer,
    derivatives_delta=fill(0,nDer))
    "Class to communicate with EnergyPlus";
  //////////
  // The derivative structure was:
  //  derivatives_structure={{1,1},{2,2}},
  //  nDer=nDer,
  //  derivatives_delta={0.01,0.01}
  // This has been removed due to numerical noise,
  // see https://github.com/lbl-srg/modelica-buildings/issues/2358#issuecomment-819578850
  //////////
  Real yEP[nY]
    "Output of exchange function";
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
//   discrete Real dQFro_flow_dT(
//     final unit="W/K")
//     "Derivative dQFroCon_flow / dT";
//   discrete Real dQBac_flow_dT(
//     final unit="W/K")
//     "Derivative dQBacCon_flow / dT";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for ZoneSurface.");
  nObj=Buildings.ThermalZones.EnergyPlus.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);
  {A}=Buildings.ThermalZones.EnergyPlus.BaseClasses.getParameters(
    adapter=adapter,
    nParOut=nParOut,
    isSynchronized=nObj);
  assert(
    A > 0,
    "Surface area must not be zero.");
equation
  // Make sure the heat ports are connected.
  // These statements must be in the equation section. Otherwise,
  // Dymola 2021 does trigger an error during the symbolic processing
  // rather than these assertions if the heat port is not connected.
  assert(cardinality(heaPorFro) > 0,
    "In " + getInstanceName() +": The heat port heaPorFro must be connected to another heat port.");
  assert(cardinality(heaPorBac) > 0,
    "In " + getInstanceName() +": The heat port heaPorBac must be connected to another heat port.");

  when {initial(),time >= pre(tNext)} then
    // Initialization of output variables.
    TFroLast=heaPorFro.T;
    TBacLast=heaPorBac.T;
    dtLast=time-pre(tLast);
    yEP=Buildings.ThermalZones.EnergyPlus.BaseClasses.exchange(
      adapter=adapter,
      initialCall=false,
      nY=nY,
      u={heaPorFro.T,heaPorBac.T,round(time,1E-3)},
      dummy=A);
    QFroLast_flow=-yEP[1];
    QBacLast_flow=-yEP[2];
    //dQFro_flow_dT=-yEP[3];
    //dQBac_flow_dT=-yEP[4];
    tNext=yEP[3];
    tLast=time;
  end when;
  heaPorFro.Q_flow=QFroLast_flow; //+(heaPorFro.T-TFroLast)*dQFro_flow_dT;
  heaPorBac.Q_flow=QBacLast_flow; //+(heaPorBac.T-TBacLast)*dQBac_flow_dT;
  qFro_flow=heaPorFro.Q_flow/A;
  qBac_flow=heaPorBac.Q_flow/A;
  nObj=synBui.synchronize.done;
  annotation (
    defaultComponentName="opaCon",
    Documentation(
      info="<html>
<p>
Model that interfaces with the EnergyPlus object <code>BuildingSurface:Detailed</code>.
It sets in EnergyPlus the temperature of the front and back surface
to the values obtained from Modelica through the heat ports
of this model,
and imposes the heat flow rate obtained from EnergyPlus at the heat ports
of this model.
</p>
<p>
For the front surface, this heat flow rate consists of
</p>
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
<p>
For the back-side surface, the above quanties, but now for the back-side of the construction,
are also returned if the back-side faces another thermal zone or the outside.
If the back-side surface is above ground, then the heat flow rate from the ground is returned.
</p>
<h4>Usage</h4>
<p>
This model allows for example coupling of a radiant slab that is modeled in Modelica to the EnergyPlus thermal zone model.
Examples of such radiant systems include a floor slab with embedded pipes and a radiant cooling panel that is suspended from a ceiling.
The model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling</a> illustrates the use of this model for a floor and ceiling slab.
</p>
<p>
Note that if the ground heat transfer of the floor slab is modeled in Modelica,
then the model
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.ZoneSurface\">
Buildings.ThermalZones.EnergyPlus.ZoneSurface</a>
can be used, as shown for the floor slab
in
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingWithGroundHeatTransfer\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingWithGroundHeatTransfer</a>.
</p>
<p>
By convention, if a surface cools the thermal zone,
then <code>heaPorFro.Q_flow &lt; 0</code> for a front surface and <code>heaPorBac.Q_flow &lt; 0</code> for a back surface.
</p>
<p>
The variable <code>qFro_flow</code> is equal to <code>qFro_flow = heaPorFor.Q_flow/A</code>, where
<code>A</code> is the area of the heat transfer surface as obtained from EnergyPlus.
Similarly, use <code>qBac_flow</code> to check the back side heat flux.
</p>
<h4>Configuration for EnergyPlus</h4>
<p>
Consider an EnergyPlus input data file that has the following entry for the surface of an attic above a living room:
</p>
<pre>
  BuildingSurface:Detailed,
    Attic:LivingFloor,       !- Name
    FLOOR,                   !- Surface Type
    reverseCEILING:LIVING,   !- Construction Name
    ATTIC ZONE,              !- Zone Name
    Surface,                 !- Outside Boundary Condition
    Living:Ceiling,          !- Outside Boundary Condition Object
    NoSun,                   !- Sun Exposure
    NoWind,                  !- Wind Exposure
    0.5000000,               !- View Factor to Ground
    4,                       !- Number of Vertices
    0,0,2.4384,  !- X,Y,Z ==> Vertex 1 {m}
    0,10.778,2.4384,  !- X,Y,Z ==> Vertex 2 {m}
    17.242,10.778,2.4384,  !- X,Y,Z ==> Vertex 3 {m}
    17.242,0,2.4384;  !- X,Y,Z ==> Vertex 4 {m}
</pre>
<p>
If this construction is modeled with a radiant slab, that may have pipes embedded near the ceiling
to cool the living room, then this model can be used as
</p>
<pre>
Buildings.ThermalZones.EnergyPlus.OpaqueConstruction attFlo(surfaceName=\"Attic:LivingFloor\")
    \"Floor of the attic above the living room\";
</pre>
<p>
The heat port <code>attFlo.heaPorFor</code> can then be connected to the heat port of the upward facing
surface of a radiant slab, and the
heat port <code>attFlo.heaPorBac</code> can be connected to the downward facing surface of the radiant slab
that cool the living room via the surface <code>Living:Ceiling</code>.
This configuration is illustrated in the example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling\">
Buildings.ThermalZones.EnergyPlus.Examples.SingleFamilyHouse.RadiantHeatingCooling</a>.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 24, 2021, by Michael Wetter:<br/>
First implementation.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2358\">issue 2358</a>.
</li>
</ul>
</html>"),
    Icon(
      graphics={
        Rectangle(
          extent={{0,66},{80,-66}},
          fillColor={175,175,175},
          fillPattern=FillPattern.Solid,
          lineColor={175,175,175}),
        Rectangle(
          extent={{-80,66},{0,-66}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          lineColor={175,175,175}),
        Line(
          points={{-92,0},{90,0}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-18,-40},{-32,-40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-12,-32},{-38,-32}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{-25,0},{-25,-32}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{32,-40},{18,-40}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{38,-32},{12,-32}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Line(
          points={{25,0},{25,-32}},
          color={0,0,0},
          thickness=0.5,
          smooth=Smooth.None),
        Rectangle(
          extent={{-60,6},{-40,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-10,6},{10,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{40,6},{60,-6}},
          lineColor={0,0,0},
          lineThickness=0.5,
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Text(
          extent={{-76,68},{-50,40}},
          lineColor={0,0,127},
          textString="Front"),
        Text(
          extent={{50,70},{76,42}},
          lineColor={0,0,127},
          textString="Back")}));
end OpaqueConstruction;
