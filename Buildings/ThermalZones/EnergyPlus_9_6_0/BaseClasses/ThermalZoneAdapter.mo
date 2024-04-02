within Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses;
model ThermalZoneAdapter
  "Block that interacts with this EnergyPlus zone"
  extends Modelica.Blocks.Icons.Block;
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.Synchronize.ObjectSynchronizer;

  constant String modelicaNameBuilding
    "Name of the building to which this thermal zone belongs to"
    annotation (HideResult=true);
  constant String modelicaInstanceName=getInstanceName()
    "Name of this instance"
    annotation (HideResult=true);
  constant String spawnExe
      "Name of the spawn executable, without extension, such as spawn-0.2.0-d7f1e095f3"
    annotation (HideResult=true);
  constant String idfVersion
    "IDF version with underscore, used for error report"
     annotation (HideResult=true);

  parameter String idfName
    "Name of the IDF file that contains this zone";
  parameter String epwName
    "Name of the Energyplus weather file including the epw extension";
  parameter Real relativeSurfaceTolerance
    "Relative tolerance of surface temperature calculations";
  parameter String zoneName
    "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Boolean usePrecompiledFMU=false
    "Set to true to use pre-compiled FMU with name specified by fmuName"
    annotation (Dialog(tab="Debug"));
  parameter String fmuName=""
    "Specify if a pre-compiled FMU should be used instead of EnergyPlus (mainly for development)"
    annotation (Dialog(tab="Debug",enable=usePrecompiledFMU));
  parameter Buildings.ThermalZones.EnergyPlus_9_6_0.Types.LogLevels logLevel=Buildings.ThermalZones.EnergyPlus_9_6_0.Types.LogLevels.Warning
    "LogLevels of EnergyPlus output"
    annotation (Dialog(tab="Debug"));
  parameter Boolean setInitialRadiativeHeatGainToZero
    "If true, then the radiative heat gain sent from Modelica to EnergyPlus is zero during the model initialization"
    annotation (Dialog(tab="Advanced"), Evaluate=true);

  parameter Integer nFluPor
    "Number of fluid ports (Set to 2 for one inlet and one outlet)";
  final parameter Modelica.Units.SI.Area AFlo(fixed=false) "Floor area";
  final parameter Modelica.Units.SI.Volume V(fixed=false) "Zone volume";
  final parameter Real mSenFac(
    fixed=false)
    "Factor for scaling the sensible thermal mass of the zone air volume";

  Modelica.Blocks.Interfaces.RealInput T(
    final unit="K",
    displayUnit="degC")
    "Zone air temperature"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}}),iconTransformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealInput X_w(
    final unit="kg/kg")
    "Zone air mass fraction in kg/kg total air"
    annotation (Placement(transformation(extent={{-140,20},{-100,60}}),iconTransformation(extent={{-140,20},{-100,60}})));
  Modelica.Blocks.Interfaces.RealInput m_flow[nFluPor](
    each final unit="kg/s")
    "Mass flow rate"
    annotation (Placement(transformation(extent={{-140,-20},{-100,20}})));
  Modelica.Blocks.Interfaces.RealInput TInlet[nFluPor](
    each final unit="K",
    each displayUnit="degC")
    "Air inlet temperatures"
    annotation (Placement(transformation(extent={{-140,-60},{-100,-20}})));
  Modelica.Blocks.Interfaces.RealInput QGaiRad_flow(
    final unit="W")
    "Radiative heat gain"
    annotation (Placement(transformation(extent={{-140,-100},{-100,-60}}),iconTransformation(extent={{-140,-100},{-100,-60}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{100,50},{120,70}}),iconTransformation(extent={{100,50},{120,70}})));
  Modelica.Blocks.Interfaces.RealOutput QCon_flow(
    final unit="W")
    "Convective sensible heat to be added to zone air"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),iconTransformation(extent={{100,10},{120,30}})));
  Modelica.Blocks.Interfaces.RealOutput QLat_flow(
    final unit="W")
    "Latent heat to be added to zone air"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),iconTransformation(extent={{100,-30},{120,-10}})));
  Modelica.Blocks.Interfaces.RealOutput QPeo_flow(
    final unit="W")
    "Total heat gain from people, to be used for optional computation of CO2 released"
    annotation (Placement(transformation(extent={{100,-70},{120,-50}}),iconTransformation(extent={{100,-70},{120,-50}})));

protected
  constant Integer nParOut=3
    "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp=5
    "Number of inputs";
  constant Integer nOut=4
    "Number of outputs";
  constant Integer nDer=0
    "Number of derivatives";
  constant Integer nY=nOut+nDer+1
    "Size of output vector of exchange function";
  parameter Integer nObj(
    fixed=false,
    start=0)
    "Total number of Spawn objects in building";

  Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.SpawnExternalObject(
    objectType=1,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    spawnExe=spawnExe,
    idfVersion=idfVersion,
    idfName=idfName,
    epwName=epwName,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    epName=zoneName,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsRootFileLocation=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.buildingsRootFileLocation,
    logLevel=logLevel,
    printUnit=false,
    jsonName="zones",
    jsonKeysValues="        \"name\": \""+zoneName+"\"",
    parOutNames={"AFlo","V","mSenFac"},
    parOutUnits={"m2","m3","1"},
    nParOut=nParOut,
    inpNames={"T","X","mInlets_flow","TAveInlet","QGaiRad_flow"},
    inpUnits={"K","1","kg/s","K","W"},
    nInp=nInp,
    outNames={"TRad","QConSen_flow","QLat_flow","QPeo_flow"},
    outUnits={"K","W","W","W"},
    nOut=nOut,
    derivatives_structure=fill(fill(nDer,2),nDer),
    nDer=nDer,
    derivatives_delta=fill(0,nDer))
    "Class to communicate with EnergyPlus";
  //////////
  // The derivative structure was:
  //     derivatives_structure={{2,1}},
  //  nDer=nDer,
  //  derivatives_delta={0.1}
  // This has been removed due to numerical noise,
  // see https://github.com/lbl-srg/modelica-buildings/issues/2358#issuecomment-819578850
  //////////

  Real yEP[nY]
    "Output of exchange function";

  parameter Modelica.Units.SI.MassFlowRate m_flow_small(fixed=false)
    "Small mass flow rate used to avoid TAveInlet = 0";
  parameter Modelica.Units.SI.Time startTime(fixed=false)
    "Simulation start time";

  discrete Modelica.Units.SI.Time tNext
    "Next sampling time";
  //Modelica.Units.SI.Time tNextEP(start=startTime-1, fixed=true) "Next sampling time requested from EnergyPlus";
  // constant Real dT_dtMax(unit="K/s") = 0.000001 "Bound on temperature derivative to reduce or increase time step";
  //  Modelica.Units.SI.Time dtMax(displayUnit="min", start=600, fixed=true) "Maximum time step before next sampling";
  discrete Modelica.Units.SI.Time tLast
    "Last time of data exchange";
  discrete Modelica.Units.SI.Time dtLast
    "Time step since the last synchronization";
  discrete Modelica.Units.SI.MassFlowRate mInlet_flow
    "Time averaged inlet mass flow rate";
  discrete Modelica.Units.SI.Temperature TAveInlet
    "Time averaged inlet temperature";
  discrete Modelica.Units.SI.Temperature TRooLast
    "Room air temperature at last sampling";
  discrete Modelica.Units.SI.HeatFlowRate QGaiRadAve_flow
   "Radiative heat flow rate averaged over the past synchronization time step";

  Modelica.Units.SI.Energy EGaiRad(unbounded=true)
   "Radiative energy exchanged since the start of the simulation";
  discrete Modelica.Units.SI.Energy EGaiRadLast(unbounded=true)
   "Radiative energy exchanged at the last synchronization time step";

//  discrete Real dQCon_flow_dT(
//    final unit="W/K")
//    "Derivative dQCon_flow / dT";

  discrete Modelica.Units.SI.HeatFlowRate QConLast_flow(fixed=false, start=0)
    "Convective sensible heat to be added to zone air if T = TRooLast";
  function round
    input Real u;
    input Real accuracy;
    output Real y;

  algorithm
    y :=
      if
        (u > 0) then
        floor(
          u/accuracy+0.5)*accuracy
      else
        ceil(
          u/accuracy-0.5)*accuracy;
  end round;

initial equation
  if usePrecompiledFMU then
    assert(
      Modelica.Utilities.Strings.length(fmuName) > 1,
      "If usePrecompiledFMU = true, must set parameter fmuName");
  end if;

  nObj=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);

  {AFlo, V, mSenFac}=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.getParameters(
    adapter=adapter,
    nParOut=nParOut,
    isSynchronized=nObj);

  m_flow_small=V*3*1.2/3600*1E-10;
  startTime=time;

  // Initialization of output variables.
  TRooLast=T;
  dtLast=0;
  mInlet_flow=0;
  TAveInlet=T;

  QGaiRadAve_flow = if setInitialRadiativeHeatGainToZero then 0 else QGaiRad_flow;
  tLast=time;
  EGaiRad = 0;
  EGaiRadLast = 0;

  // Synchronization with EnergyPlus
  // Below, the term X_w/(1.-X_w) is for conversion from kg/kg_total_air (Modelica) to kg/kg_dry_air (EnergyPlus)
  yEP=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.exchange(
    adapter=adapter,
    nY=nY,
    u={ T, X_w/(1.-X_w), mInlet_flow, TAveInlet, QGaiRadAve_flow, round(time,1E-3)},
    dummy=AFlo);

  TRad=yEP[1];
  QConLast_flow=yEP[2];
  QLat_flow=yEP[3];
  QPeo_flow=yEP[4];
  tNext=yEP[5];

  assert(AFlo > 0, "Floor area must not be zero.");
  assert(V > 0, "Volume must not be zero.");
  assert(mSenFac > 0.9999, "mSenFac must be at least 1.");

equation
  if usePrecompiledFMU then
    // For JModelica, this must be in the equation section rather than the initial equation section
    assert(Modelica.Utilities.Strings.length(fmuName) > 1,
      "If usePrecompiledFMU = true, must set parameter fmuName");
  end if;

  // Integrate GQaiRad_flow, which breaks any algebraic loop if QGaiRad_flow is
  // a function of TRad
  der(EGaiRad) = QGaiRad_flow;

  // Synchronization with EnergyPlus
  when {time >= pre(tNext)} then
    // Initialization of output variables.
    TRooLast=T;
    dtLast=time-pre(tLast);
    mInlet_flow=noEvent(
      sum(
        if m_flow[i] > 0 then
          m_flow[i]
        else
          0 for i in 1:nFluPor));
    TAveInlet=noEvent(
      sum(
        if m_flow[i] > 0 then
          TInlet[i]*m_flow[i]
        else
          0 for i in 1:nFluPor)+m_flow_small*pre(TAveInlet)/(mInlet_flow+m_flow_small));
    // Below, the term X_w/(1.-X_w) is for conversion from kg/kg_total_air (Modelica) to kg/kg_dry_air (EnergyPlus)
    QGaiRadAve_flow = (EGaiRadLast-pre(EGaiRadLast))/dtLast;

    // Call EnergyPlus
    yEP=Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.exchange(
      adapter=adapter,
      nY=nY,
      u={T,X_w/(1.-X_w),pre(mInlet_flow),TAveInlet,QGaiRadAve_flow,round(time,1E-3)},
      dummy=AFlo);
    // Assign return values of EnergyPlus
    TRad=yEP[1];
    QConLast_flow=yEP[2];
    QLat_flow=yEP[3];
    QPeo_flow=yEP[4];
    tNext=yEP[5];
    tLast=time;
    // Store current value of exchanged radiative heat
    EGaiRadLast = EGaiRad;
  end when;
  //QCon_flow=QConLast_flow+(T-TRooLast)*dQCon_flow_dT;
  QCon_flow=QConLast_flow;

  synBui.synchronize.done=nObj;

  annotation (
    defaultComponentName="fmuZon",
    Icon(
      graphics={
        Bitmap(
          extent={{-92,-82},{82,92}},
          fileName="modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png")}),
    Documentation(
      info="<html>
<p>
Block that exchanges data between Modelica and EnergyPlus.
This block is calling the C functions to initialize EnergyPlus,
exchange data with EnergyPlus, and free the memory, through the destructor
of its class <code>adapter</code>, of EnergyPlus.
</p>
</html>",
      revisions="<html>
<ul>
<li>
March 22, 2024, by Michael Wetter:<br/>
Changed radiative heat flow rate sent to EnergyPlus to be the average over the last
synchronization time step rather than the instantaneuous value, and set the initial value to zero.
This avoids a nonlinear system of equation during the time integration for models in which
the radiative heat gain is a function of the room radiative temperature, such as
when a radiator is connected to the room model.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3707\">Buildings, #3707</a>.
</li>
<li>
February 14, 2024, by Michael Wetter:<br/>
Added <code>pre()</code> operator for inlet mass flow rate and for convective heat gain
to avoid an algebraic loop on discrete variables.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/3659\">Buildings, #3659</a>.
</li>
<li>
February 18, 2021, by Michael Wetter:<br/>
Refactor synchronization of constructors.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2360\">#2360</a>.
</li>
<li>
December 6, 2020, by Michael Wetter:<br/>
Reformulated <code>when</code> condition to avoid using <code>not initial()</code>.
Per the Modelica language definition, <code>when</code> clauses are not meant to contain
<code>not initial()</code>.<br/>
This is for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/2068\">#2068</a>.
</li>
<li>
April 04, 2018, by Thierry S. Nouidui:<br/>
Added additional parameters for parametrizing
the EnergyPlus model.
</li>
<li>
March 21, 2018, by Thierry S. Nouidui:<br/>
Revised implementation for efficiency.
</li>
<li>
February 14, 2018, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end ThermalZoneAdapter;
