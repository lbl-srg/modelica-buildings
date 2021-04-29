within Buildings.ThermalZones.EnergyPlus.BaseClasses;
model ThermalZoneAdapter
  "Block that interacts with this EnergyPlus zone"
  extends Modelica.Blocks.Icons.Block;
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.ObjectSynchronizer;
  constant String modelicaNameBuilding
    "Name of the building to which this thermal zone belongs to"
    annotation (HideResult=true);
  constant String modelicaInstanceName=getInstanceName()
    "Name of this instance"
    annotation (HideResult=true);
  parameter String idfName
    "Name of the IDF file that contains this zone";
  parameter String weaName
    "Name of the Energyplus weather file";
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
  parameter Buildings.ThermalZones.EnergyPlus.Types.LogLevels logLevel=Buildings.ThermalZones.EnergyPlus.Types.LogLevels.Warning
    "LogLevels of EnergyPlus output"
    annotation (Dialog(tab="Debug"));
  parameter Integer nFluPor
    "Number of fluid ports (Set to 2 for one inlet and one outlet)";
  final parameter Modelica.SIunits.Area AFlo(
    fixed=false)
    "Floor area";
  final parameter Modelica.SIunits.Volume V(
    fixed=false)
    "Zone volume";
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
  parameter Modelica.SIunits.MassFlowRate m_flow_small(
    fixed=false)
    "Small mass flow rate used to avoid TAveInlet = 0";
  Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject(
    objectType=1,
    startTime=startTime,
    modelicaNameBuilding=modelicaNameBuilding,
    modelicaInstanceName=modelicaInstanceName,
    idfName=idfName,
    weaName=weaName,
    relativeSurfaceTolerance=relativeSurfaceTolerance,
    epName=zoneName,
    usePrecompiledFMU=usePrecompiledFMU,
    fmuName=fmuName,
    buildingsLibraryRoot=Buildings.ThermalZones.EnergyPlus.BaseClasses.buildingsLibraryRoot,
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
  parameter Modelica.SIunits.Time startTime(
    fixed=false)
    "Simulation start time";
  Real yEP[nY]
    "Output of exchange function";
  Modelica.SIunits.Time tNext(
    start=startTime,
    fixed=true)
    "Next sampling time";
  //Modelica.SIunits.Time tNextEP(start=startTime-1, fixed=true) "Next sampling time requested from EnergyPlus";
  // constant Real dT_dtMax(unit="K/s") = 0.000001 "Bound on temperature derivative to reduce or increase time step";
  //  Modelica.SIunits.Time dtMax(displayUnit="min", start=600, fixed=true) "Maximum time step before next sampling";
  discrete Modelica.SIunits.Time tLast(
    fixed=true,
    start=startTime)
    "Last time of data exchange";
  discrete Modelica.SIunits.Time dtLast
    "Time step since the last synchronization";
  discrete Modelica.SIunits.MassFlowRate mInlet_flow
    "Time averaged inlet mass flow rate";
  discrete Modelica.SIunits.Temperature TAveInlet
    "Time averaged inlet temperature";
  discrete Modelica.SIunits.Temperature TRooLast
    "Room air temperature at last sampling";
//  discrete Real dQCon_flow_dT(
//    final unit="W/K")
//    "Derivative dQCon_flow / dT";
  discrete Modelica.SIunits.HeatFlowRate QConLast_flow(
    fixed=false,
    start=0)
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
  startTime=time;
  nObj=Buildings.ThermalZones.EnergyPlus.BaseClasses.initialize(
    adapter=adapter,
    isSynchronized=building.isSynchronized);
  {AFlo,V,mSenFac}=Buildings.ThermalZones.EnergyPlus.BaseClasses.getParameters(
    adapter=adapter,
    nParOut=nParOut,
    isSynchronized=nObj);
  TAveInlet=293.15;
  m_flow_small=V*3*1.2/3600*1E-10;
  assert(
    AFlo > 0,
    "Floor area must not be zero.");
  assert(
    V > 0,
    "Volume must not be zero.");
  assert(
    mSenFac > 0.9999,
    "mSenFac must be bigger or equal than one.");

equation
  if usePrecompiledFMU then
    // For JModelica, this must be in the equation section rather than the initial equation section
    assert(
      Modelica.Utilities.Strings.length(fmuName) > 1,
      "If usePrecompiledFMU = true, must set parameter fmuName");
  end if;
  when {initial(),time >= pre(tNext)} then
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
      (sum(
        if m_flow[i] > 0 then
          TInlet[i]*m_flow[i]
        else
          0 for i in 1:nFluPor)+m_flow_small*pre(TAveInlet))/(mInlet_flow+m_flow_small));
    // Below, the term X_w/(1.-X_w) is for conversion from kg/kg_total_air (Modelica) to kg/kg_dry_air (EnergyPlus)
    yEP=Buildings.ThermalZones.EnergyPlus.BaseClasses.exchange(
      adapter=adapter,
      initialCall=false,
      nY=nY,
      u={T,X_w/(1.-X_w),mInlet_flow,TAveInlet,QGaiRad_flow,round(time,1E-3)},
      dummy=AFlo);
    TRad=yEP[1];
    QConLast_flow=yEP[2];
    QLat_flow=yEP[3];
    QPeo_flow=yEP[4];
    //dQCon_flow_dT=yEP[5];
    //tNext=yEP[6];
    tNext=yEP[5];
    tLast=time;
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
