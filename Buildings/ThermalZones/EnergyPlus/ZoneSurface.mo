within Buildings.ThermalZones.EnergyPlus;
model ZoneSurface
  "Model to exchange heat with a inside-facing surface of a thermal zone"
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.PartialEnergyPlusObject;
  extends Buildings.ThermalZones.EnergyPlus.BaseClasses.Synchronize.ObjectSynchronizer;

  parameter String surfaceName
    "Surface unique name in the EnergyPlus idf file";

  final parameter Modelica.SIunits.Area A(
    final fixed=false,
    min=1E-10)
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
    annotation (Placement(transformation(extent={{100,20},{140,60}}), iconTransformation(extent={{100,40},
            {140,80}})));
  Modelica.Blocks.Interfaces.RealOutput q_flow(
    final unit="W/m2",
    final quantity="HeatFlux")
    "Net heat flux from the thermal zone to the surface (positive if surface is cold)"
    annotation (Placement(transformation(extent={{100,-60},{140,-20}}),
     iconTransformation(extent={{100,-80},{140,-40}})));
protected
  constant Integer nParOut = 1 "Number of parameter values retrieved from EnergyPlus";
  constant Integer nInp = 1 "Number of inputs";
  constant Integer nOut = 1 "Number of outputs";
  constant Integer nDer = 1 "Number of derivatives";
  constant Integer nY = nOut + nDer + 1 "Size of output vector of exchange function";
  parameter Integer nObj(fixed=false, start=0) "Total number of Spawn objects in building";

  Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject adapter=Buildings.ThermalZones.EnergyPlus.BaseClasses.SpawnExternalObject(
    objectType=5,
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
    jsonName = "zoneSurfaces",
    jsonKeysValues = "        \"name\": \"" + surfaceName + "\"",
    parOutNames = {"A"},
    parOutUnits = {"m2"},
    nParOut = nParOut,
    inpNames = {"T"},
    inpUnits = {"K"},
    nInp = nInp,
    outNames = {"Q_flow"},
    outUnits = {"W"},
    nOut = nOut,
    derivatives_structure = {{1, 1}},
    nDer = nDer,
    derivatives_delta = {0.01})
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
  discrete Modelica.SIunits.Temperature TLast
    "Surface temperature at last sampling";
  discrete Modelica.SIunits.HeatFlowRate QLast_flow(
    fixed=false,
    start=0)
    "Surface heat flow rate if T = TLast";
  discrete Real dQ_flow_dT(
    final unit="W/K")
    "Derivative dQCon_flow / dT";

initial equation
  assert(
    not usePrecompiledFMU,
    "Use of pre-compiled FMU is not supported for ZoneSurface.");
  startTime=time;
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
    TLast=T;
    dtLast=time-pre(
      tLast);

    yEP = Buildings.ThermalZones.EnergyPlus.BaseClasses.exchange(
      adapter = adapter,
      initialCall = false,
      nY = nY,
      u = {T, round(time, 1E-3)},
      dummy = A);

    QLast_flow = yEP[1];
    dQ_flow_dT = yEP[2];
    tNext = yEP[3];
    tLast=time;
  end when;
  Q_flow=QLast_flow+(T-TLast)*dQ_flow_dT;
  q_flow = Q_flow/A;

  nObj = synBui.synchronize.done;

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
and receives from EnergyPlus the
net heat flow rate <code>Q_flow</code> from the thermal zone to the surface, consisting of convective heat flow,
absorbed solar radiation, absorbed infrared radiation minus emitted infrared radiation.
</p>
<p>
By convention, <code>Q_flow &gt; 0</code> if there is net heat flow rate from the thermal zone to the surface,
e.g., if the surface is cold.
</p>
<h4>Usage</h4>
<p>
<b>fixme: Update with example snippet, and add an example that uses
<a href=\"modelica://Buildings.Fluid.HeatExchangers.RadiantSlabs\">
Buildings.Fluid.HeatExchangers.RadiantSlabs</a></b>.
This section explain how to use actuators for different EnergyPlus objects.
For other actuators, please see the EnergyPlus EMS Application Guide.
</p>
<!-- Actuator for lights -->
<h5>Configuring an actuator for lights</h5>
<p>
Consider the example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.Actuator.LightsControl\">
Buildings.ThermalZones.EnergyPlus.Validation.Actuator.LightsControl</a>.
In this example, Modelica overwrites the EnergyPlus <code>Lights</code> object.
The idf-file
has the following entry:
</p>
<pre>
  Lights,
    LIVING ZONE Lights,      !- Name
    LIVING ZONE,             !- Zone or ZoneList Name
    HOUSE LIGHTING,          !- Schedule Name
    LightingLevel,           !- Design Level Calculation Method
    1000,                    !- Lighting Level {W}
    ,                        !- Watts per Zone Floor Area {W/m2}
    ,                        !- Watts per Person {W/person}
    0,                       !- Return Air Fraction
    0.2000000,               !- Fraction Radiant
    0.2000000,               !- Fraction Visible
    0,                       !- Fraction Replaceable
    GeneralLights;           !- End-Use Subcategory
</pre>
<p>
and the EnergyPlus EMS Application Guide specifies
<em>An actuator called \"Lights\" is available with a control type called
\"Electric Power Level\" (in W).
This allows you to set the lighting power associated with each Lights input object.
The unique identifier is the name of the Lights input object.</em>
</p>
<p>
Therefore, the <code>Lights</code> object can be overwritten
by specifying the Modelica instance
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus.Actuator actLig(
    variableName=\"LIVING ZONE Lights\",
    componentType=\"Lights\",
    controlType=\"Electric Power Level\",
    unit=Buildings.ThermalZones.EnergyPlus.Types.Units.Power)
      \"Actuator for lights\";
</pre>
<p>
and setting its input to the required power in Watts.
</p>
<!-- Actuator for a shade -->
<h5>Configuring an actuator for a shade</h5>
<p>
Consider the example
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus.Validation.Actuator.ShadeControl\">
Buildings.ThermalZones.EnergyPlus.Validation.Actuator.ShadeControl</a>.
In this example, the idf-file
has the following entry:
</p>
<pre>
  EnergyManagementSystem:Actuator,
    Zn001_Wall001_Win001_Shading_Deploy_Status,  !- Name
    Zn001:Wall001:Win001,    !- Actuated Component Unique Name
    Window Shading Control,  !- Actuated Component Type
    Control Status;          !- Actuated Component Control Type
</pre>
<p>
This causes EnergyPlus to overwrite the shade of the
<code>FenestrationSurface:Detailed</code> with name
<code>Zn001:Wall001:Win001</code>.
According to the EnergyPlus EMS Application Guide,
the EnergyPlus <code>Control Status</code> can be set
to <i>0</i> to remove the shade, or
to <i>6</i> to activate the interior blind.
</p>
<p>
Therefore, in Modelica, the instantiation
</p>
<pre>
  Buildings.ThermalZones.EnergyPlus.Actuator actSha(
    variableName=\"Zn001:Wall001:Win001\",
    componentType=\"Window Shading Control\",
    controlType=\"Control Status\",
    unit=Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized)
      \"Actuator for window shade\"
</pre>
<p>
will write to the <code>Window Shading Control</code> of the EnergyPlus object
<code>FenestrationSurface:Detailed</code> with name <code>Zn001:Wall001:Win001</code>.
The entry <code>units=Buildings.ThermalZones.EnergyPlus.Types.Units.Normalized</code>
will cause the input value of the Modelica instance <code>actSha</code>
to be sent to EnergyPlus without any unit conversion. Hence,
in the example, the input <code>actSha.u</code> is set to <i>0</i> or <i>6</i>.
</p>
<p>
Note that the entry <code>EnergyManagementSystem:Actuator</code> in the idf-file is optional.
If specified, it will be ignored and the Modelica object be used instead.
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
          lineColor={0,0,0},
          textString="T"),
        Text(
          extent={{144,110},{106,71}},
          lineColor={0,0,0},
          textString="Q_flow"),
        Text(
          extent={{144,-10},{106,-49}},
          lineColor={0,0,0},
          textString="q_flow")}));
end ZoneSurface;
