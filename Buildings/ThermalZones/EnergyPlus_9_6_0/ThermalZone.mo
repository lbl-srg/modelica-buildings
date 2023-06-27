within Buildings.ThermalZones.EnergyPlus_9_6_0;
model ThermalZone
  "Model to connect to an EnergyPlus thermal zone"
  extends Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.PartialEnergyPlusObject;
  parameter String zoneName
    "Name of the thermal zone as specified in the EnergyPlus input";
  parameter Integer nPorts=0
    "Number of fluid ports (equals to 2 for one inlet and one outlet)"
    annotation (Evaluate=true,Dialog(connectorSizing=true,tab="General",group="Ports"));
  ////////////////////////////////////////////////////////////////////////////
  // Media declaration. This is identical to
  // Buildings.Fluid.Interfaces.LumpedVolumeDeclarations, except
  // that the comments have been changed to avoid a confusion about
  // what energyDynamics refers to.
  replaceable package Medium=Modelica.Media.Interfaces.PartialMedium
    "Medium in the component"
    annotation (choicesAllMatching=true);
  // Ports
  parameter Boolean use_C_flow=false
    "Set to true to enable input connector for trace substance that is connected to room air"
    annotation (Dialog(group="Ports"));
  // Initialization
  parameter Medium.AbsolutePressure p_start=Medium.p_default
    "Start value of zone air pressure"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.Temperature T_start=Medium.T_default
    "Start value of zone air temperature"
    annotation (Dialog(tab="Initialization"));
  parameter Medium.MassFraction X_start[Medium.nX](
    quantity=Medium.substanceNames)=Medium.X_default
    "Start value of zone air mass fractions m_i/m"
    annotation (Dialog(tab="Initialization",enable=Medium.nXi > 0));
  parameter Medium.ExtraProperty C_start[Medium.nC](
    quantity=Medium.extraPropertiesNames)=fill(
    0,
    Medium.nC)
    "Start value of zone air trace substances"
    annotation (Dialog(tab="Initialization",enable=Medium.nC > 0));
  parameter Medium.ExtraProperty C_nominal[Medium.nC](
    quantity=Medium.extraPropertiesNames)=fill(
    1E-2,
    Medium.nC)
    "Nominal value of zone air trace substances. (Set to typical order of magnitude.)"
    annotation (Dialog(tab="Initialization",enable=Medium.nC > 0));
  final parameter Modelica.Units.SI.Volume V=fmuZon.V "Zone volume";
  final parameter Modelica.Units.SI.Area AFlo=fmuZon.AFlo "Floor area";
  final parameter Real mSenFac(
    min=1)=fmuZon.mSenFac
    "Factor for scaling the sensible thermal mass of the zone air volume"
    annotation (Dialog(tab="Dynamics",group="Zone air"));
  Modelica.Blocks.Interfaces.RealInput qGai_flow[3](
    each unit="W/m2")
    "Radiant, convective sensible and latent heat input into room (positive if heat gain)"
    annotation (Placement(transformation(extent={{-240,80},{-200,120}})));
  Modelica.Blocks.Interfaces.RealInput[Medium.nC] C_flow if use_C_flow
    "Trace substance mass flow rate added to the medium"
    annotation (Placement(transformation(extent={{-240,-140},{-200,-100}}),iconTransformation(extent={{-240,-120},{-200,-80}})));
  Modelica.Thermal.HeatTransfer.Interfaces.HeatPort_a heaPorAir
    "Heat port to air volume"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));
  Modelica.Fluid.Vessels.BaseClasses.VesselFluidPorts_b ports[nPorts](
    redeclare each package Medium=Medium)
    "Fluid inlets and outlets"
    annotation (Placement(transformation(extent={{40,-10},{-40,10}},rotation=180,origin={0,-150}),iconTransformation(extent={{40,-9},{-40,9}},rotation=180,origin={0,-191})));
  Modelica.Blocks.Interfaces.RealOutput TAir(
    final unit="K",
    displayUnit="degC")
    "Air temperature of the zone"
    annotation (Placement(transformation(extent={{200,-10},{220,10}}),iconTransformation(extent={{200,170},{220,190}})));
  Modelica.Blocks.Interfaces.RealOutput TRad(
    final unit="K",
    displayUnit="degC")
    "Radiative temperature of the zone"
    annotation (Placement(transformation(extent={{200,-50},{220,-30}}),iconTransformation(extent={{200,130},{220,150}})));
  Modelica.Blocks.Interfaces.RealOutput phi(
    final unit="1")
    "Relative humidity"
    annotation (Placement(transformation(extent={{200,-130},{220,-110}}),iconTransformation(extent={{200,90},{220,110}})));

protected
  constant Modelica.Units.SI.SpecificEnergy h_fg=Medium.enthalpyOfCondensingGas(
      273.15 + 37) "Latent heat of water vapor";
  final parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=V*3/3600
    "Nominal mass flow rate (used for regularization)";
  Buildings.ThermalZones.EnergyPlus_9_6_0.BaseClasses.ThermalZoneAdapter fmuZon(
    final modelicaNameBuilding=modelicaNameBuilding,
    final modelicaInstanceName=modelicaInstanceName,
    final spawnExe=spawnExe,
    final idfVersion=idfVersion,
    final idfName=idfName,
    final epwName=epwName,
    final relativeSurfaceTolerance=relativeSurfaceTolerance,
    final zoneName=zoneName,
    final nFluPor=nPorts,
    final usePrecompiledFMU=usePrecompiledFMU,
    final fmuName=fmuName,
    final logLevel=logLevel)
    "FMU zone adapter"
    annotation (Placement(transformation(extent={{82,-60},{102,-40}})));
  Buildings.Fluid.Interfaces.ConservationEquation vol(
    redeclare final package Medium=Medium,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final massDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final p_start=p_start,
    final T_start=T_start,
    final X_start=X_start,
    final C_start=C_start,
    final C_nominal=C_nominal,
    final mSenFac=mSenFac,
    final use_mWat_flow=Medium.nXi > 0,
    final use_C_flow=use_C_flow,
    final fluidVolume=V,
    final nPorts=nPorts)
    "Air volume of the thermal zone"
    annotation (Placement(transformation(extent={{-10,-52},{10,-32}})));
  Buildings.ThermalZones.Detailed.BaseClasses.HeatGain heaGai(
    final AFlo=AFlo)
    "Model to convert internal heat gains"
    annotation (Placement(transformation(extent={{-180,90},{-160,110}})));
  Modelica.Blocks.Math.Gain mWat_flow(
    final k(
      unit="kg/J")=1/h_fg,
    u(final unit="W"),
    y(final unit="kg/s"))
    "Water flow rate due to latent heat gain"
    annotation (Placement(transformation(extent={{-82,-64},{-62,-44}})));
  Modelica.Blocks.Math.Add QLat_flow(final k1=1, final k2=1)
    "Total latent heat gains of the zone"
    annotation (Placement(transformation(extent={{-120,20},{-100,40}})));
  Modelica.Blocks.Math.Add QGaiSenLat_flow(
    final k1=1,
    final k2=1)
    "Sensible and latent heat gains of the zone"
    annotation (Placement(transformation(extent={{-80,30},{-60,50}})));
  Modelica.Blocks.Math.Add QConSen_flow(
    final k1=1,
    final k2=1)
    "Convective sensible heat gains of the zone from EnergyPlus and Modelica input connector qGai_flow"
    annotation (Placement(transformation(extent={{-120,52},{-100,72}})));
  Buildings.HeatTransfer.Sources.PrescribedHeatFlow conQCon_flow
    "Converter for convective heat flow rate"
    annotation (Placement(transformation(extent={{-40,30},{-20,50}})));
  final parameter String substanceName="CO2"
    "Name of trace substance";
  final parameter Modelica.Units.SI.MolarMass MM=Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM
    "Molar mass of the trace substance";
  Modelica.Blocks.Routing.Replicator QPeaRep(
    nout=Medium.nC) if use_C_flow
    "Replicator to convert QPea_flow into a vector"
    annotation (Placement(transformation(extent={{-120,-120},{-100,-100}})));
  Modelica.Blocks.Math.Add CTot_flow[Medium.nC](
    each final k1=1,
    final k2={
      if
        (Modelica.Utilities.Strings.isEqual(
        string1=Medium.extraPropertiesNames[i],
        string2=substanceName,
        caseSensitive=false)) then
        3.82E-8*Modelica.Media.IdealGases.Common.SingleGasesData.CO2.MM/Modelica.Media.IdealGases.Common.SingleGasesData.Air.MM
      else
        0 for i in 1:Medium.nC},
    u1(
      each final unit="W")) if use_C_flow
    "Total trace substance flow rate"
    annotation (Placement(transformation(extent={{-80,-100},{-60,-80}})));
  Buildings.Fluid.Sensors.MassFlowRate senMasFlo[nPorts](
    redeclare each final package Medium=Medium,
    each final allowFlowReversal=true)
    "Mass flow rate sensor"
    annotation (Placement(transformation(extent={{-10,10},{10,-10}},rotation=90,origin={0,-100})));
  Modelica.Blocks.Sources.RealExpression TAirIn[nPorts](
    y=Medium.temperature(
      state=Medium.setState_phX(
        p=ports.p,
        h=inStream(ports.h_outflow),
        X=inStream(ports.Xi_outflow)))) if nPorts > 0
    "Temperature that the air has if it were flowing into the room"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));
  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Heat flow sensor"
    annotation (Placement(transformation(extent={{-20,-20},{-40,0}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature preTem
    "Port temperature"
    annotation (Placement(transformation(extent={{-80,-20},{-60,0}})));
  Modelica.Blocks.Sources.RealExpression TFlu(
    y=Medium.temperature_phX(
      p=vol.medium.p,
      h=vol.hOut,
      X=cat(1,vol.XiOut,{1-sum(vol.XiOut)})))
    "Air temperature of control volume"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Modelica.Blocks.Sources.RealExpression pFlu(
    y=vol.medium.p)
    "Air pressure"
    annotation (Placement(transformation(extent={{122,2},{142,22}})));
  Utilities.Psychrometrics.Phi_pTX relHum
    "Relative humidity"
    annotation (Placement(transformation(extent={{156,12},{176,32}})));
  Controls.OBC.CDL.Continuous.Divide X_w
    "Water vapor mass fraction per kg total air"
    annotation (Placement(transformation(extent={{40,-32},{60,-12}})));

initial equation
  assert(
    idfName <> "",
    "Must provide the name of the fmu file.");
  assert(
    zoneName <> "",
    "Must provide the name of the zone.");
// assert(nPorts >= 2, "The zone must have at least one air inlet and outlet.");

equation
  connect(heaGai.qGai_flow,qGai_flow)
    annotation (Line(points={{-182,100},{-220,100}},color={0,0,127}));
  connect(fmuZon.TRad,TRad)
    annotation (Line(points={{103,-44},{180,-44},{180,-40},{210,-40}},color={0,0,127}));
  connect(heaGai.QRad_flow,fmuZon.QGaiRad_flow)
    annotation (Line(points={{-158,106},{74,106},{74,-58},{80,-58}},color={0,0,127}));
  connect(QGaiSenLat_flow.u1,QConSen_flow.y)
    annotation (Line(points={{-82,46},{-90,46},{-90,62},{-99,62}},color={0,0,127}));
  connect(QGaiSenLat_flow.u2, QLat_flow.y) annotation (Line(points={{-82,34},{-90,
          34},{-90,30},{-99,30}}, color={0,0,127}));
  connect(QGaiSenLat_flow.y,conQCon_flow.Q_flow)
    annotation (Line(points={{-59,40},{-40,40}},color={0,0,127}));
  connect(conQCon_flow.port,heaPorAir)
    annotation (Line(points={{-20,40},{0,40},{0,0}},color={191,0,0}));
  connect(QLat_flow.y, mWat_flow.u) annotation (Line(points={{-99,30},{-96,30},{
          -96,-54},{-84,-54}}, color={0,0,127}));
  connect(mWat_flow.y,vol.mWat_flow)
    annotation (Line(points={{-61,-54},{-36,-54},{-36,-40},{-12,-40}},color={0,0,127}));
  connect(CTot_flow.y,vol.C_flow)
    annotation (Line(points={{-59,-90},{-26,-90},{-26,-46},{-12,-46}},color={0,0,127}));
  connect(C_flow,CTot_flow.u1)
    annotation (Line(points={{-220,-120},{-142,-120},{-142,-84},{-82,-84}},color={0,0,127}));
  for i in 1:nPorts loop
    connect(ports[i],senMasFlo[i].port_a)
      annotation (Line(points={{0,-150},{0,-110}},color={0,127,255}));
    connect(fmuZon.m_flow[i],senMasFlo[i].m_flow)
      annotation (Line(points={{80,-50},{30,-50},{30,-100},{11,-100}},color={0,0,127}));
    connect(senMasFlo[i].port_b,vol.ports[i])
      annotation (Line(points={{5.55112e-16,-90},{0,-90},{0,-52}},color={0,127,255}));
  end for;
  connect(fmuZon.TInlet,TAirIn.y)
    annotation (Line(points={{80,-54},{64,-54},{64,-70},{61,-70}},color={0,0,127}));
  connect(TFlu.y,preTem.T)
    annotation (Line(points={{41,0},{50,0},{50,18},{-90,18},{-90,-10},{-82,-10}},color={0,0,127}));
  connect(heaFloSen.port_b,preTem.port)
    annotation (Line(points={{-40,-10},{-60,-10}},color={191,0,0}));
  connect(heaFloSen.port_a,heaPorAir)
    annotation (Line(points={{-20,-10},{-10,-10},{-10,0},{0,0}},color={191,0,0}));
  connect(TFlu.y,fmuZon.T)
    annotation (Line(points={{41,0},{70,0},{70,-42},{80,-42}},color={0,0,127}));
  connect(TFlu.y,TAir)
    annotation (Line(points={{41,0},{210,0}},color={0,0,127}));
  connect(heaFloSen.Q_flow,vol.Q_flow)
    annotation (Line(points={{-30,-21},{-30,-36},{-12,-36}},color={0,0,127}));
  connect(vol.XiOut[1],fmuZon.X_w)
    annotation (Line(points={{0,-31},{0,-24},{30,-24},{30,-46},{80,-46}},color={0,0,127}));
  connect(X_w.y,relHum.X_w)
    annotation (Line(points={{62,-22},{64,-22},{64,22},{155,22}},color={0,0,127}));
  connect(vol.mXiOut[1],X_w.u1)
    annotation (Line(points={{11,-44},{20,-44},{20,-16},{38,-16}},color={0,0,127}));
  connect(vol.mOut,X_w.u2)
    annotation (Line(points={{11,-36},{24,-36},{24,-28},{38,-28}},color={0,0,127}));
  connect(TFlu.y,relHum.T)
    annotation (Line(points={{41,0},{120,0},{120,30},{155,30}},color={0,0,127}));
  connect(pFlu.y,relHum.p)
    annotation (Line(points={{143,12},{150,12},{150,14},{155,14}},color={0,0,127}));
  connect(relHum.phi,phi)
    annotation (Line(points={{177,22},{192,22},{192,-120},{210,-120}},color={0,0,127}));
  connect(QPeaRep.y,CTot_flow.u2)
    annotation (Line(points={{-99,-110},{-90,-110},{-90,-96},{-82,-96}},color={0,0,127}));
  connect(QPeaRep.u,fmuZon.QPeo_flow)
    annotation (Line(points={{-122,-110},{-132,-110},{-132,-130},{110,-130},{110,-56},{103,-56}},color={0,0,127}));
  connect(QConSen_flow.u2,heaGai.QCon_flow)
    annotation (Line(points={{-122,56},{-134,56},{-134,100},{-158,100}},color={0,0,127}));
  connect(fmuZon.QCon_flow,QConSen_flow.u1)
    annotation (Line(points={{103,-48},{110,-48},{110,80},{-130,80},{-130,68},{-122,68}},color={0,0,127}));
  connect(fmuZon.QLat_flow, QLat_flow.u1) annotation (Line(points={{103,-52},{114,
          -52},{114,84},{-140,84},{-140,36},{-122,36}}, color={0,0,127}));
  connect(heaGai.QLat_flow, QLat_flow.u2) annotation (Line(points={{-158,94},{-144,
          94},{-144,24},{-122,24}}, color={0,0,127}));
  annotation (
    defaultComponentName="zon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-200},{200,200}}),
      graphics={
        Rectangle(
          lineColor={95,95,95},
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid,
          extent={{-200,-200},{200,200}}),
        Rectangle(
          lineColor={117,148,176},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          extent={{-176,182},{180,-182}}),
        Bitmap(
          visible=false,
          extent={{62,-190},{164,-88}},
          fileName="modelica://Buildings/Resources/Images/Fluid/FMI/FMI_icon.png"),
        Text(
          visible=false,
          extent={{-144,162},{-40,132}},
          textString="%idfName"),
        Text(
          extent={{-142,130},{-38,100}},
          textString="%zoneName"),
        Rectangle(
          lineColor={95,95,95},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid,
          extent={{180,70},{200,-70}}),
        Text(
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          extent={{120,148},{170,120}},
          textString="TRad"),
        Text(
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          extent={{-60,12},{-22,-10}},
          textString="air"),
        Rectangle(
          lineColor={95,95,95},
          fillColor={170,213,255},
          fillPattern=FillPattern.Solid,
          extent={{186,70},{194,-70}}),
        Text(
          extent={{-202,118},{-126,86}},
          textString="q"),
        Text(
          visible=false,
          textColor={0,0,127},
          extent={{-188,-94},{-112,-126}},
          textString="C_flow"),
        Text(
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          extent={{124,182},{174,154}},
          textString="TAir",
          horizontalAlignment=TextAlignment.Right),
        Text(
          textColor={0,0,255},
          extent={{-58,244},{56,204}},
          textString="%name"),
        Text(
          textColor={255,255,255},
          extent={{174,-126},{54,-176}},
          textString=""),
        Bitmap(
          visible=false,
          extent={{134,-176},{174,-146}},
          fileName="modelica://Buildings/Resources/Images/ThermalZones/EnergyPlus_9_6_0/EnergyPlusLogo.png"),
        Text(
          fillColor={61,61,61},
          fillPattern=FillPattern.Solid,
          extent={{132,114},{182,86}},
          textString="phi")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-200,-140},{200,140}})),
    Documentation(
      info="<html>
<p>
Model for a thermal zone that is implemented in EnergyPlus.
</p>
<p>
This model instantiates the FMU with the name <code>idfName</code> and
connects to the thermal zone with name <code>zoneName</code>.
The <code>idfName</code> needs to be specified in an instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Building\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Building</a>
that is named <code>building</code>, and that is placed at this
or at a higher hierarchy-level of the model.
If the FMU is already instantiated by another instance of this model,
it will use the already instantiated FMU. Hence, for each thermal zone
in an EnergyPlus FMU, one instance of this model needs to be used.
See <a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide\">
Buildings.ThermalZones.EnergyPlus_9_6_0.UsersGuide</a>
for how zones are simulated that are declared in the EnergyPlus input data file
but not in Modelica.
</p>
<p>
If there are two instances that declare the same <code>zoneName</code>
and have in the model hierarchy the same instance of
<a href=\"modelica://Buildings.ThermalZones.EnergyPlus_9_6_0.Building\">
Buildings.ThermalZones.EnergyPlus_9_6_0.Building</a>,
then the simulation will stop with an error.
</p>
<h4>Main Equations</h4>
<p>
This model computes in Modelica the air energy, mass and species
balance. Outside air infiltration needs to be modeled in Modelica,
because any infiltration that the EnergyPlus model may specify is ignored.
The convective heat transfer with the building fabric,
the long-wave and the short-wave radiation are computed by EnergyPlus.
</p>
<h5>Heat and mass balance</h5>
<p>
The zone uses a volume of air that is fully mixed. The size of this volume,
and its floor area, which is used to scale the heat gains <code>q_flow</code>,
are obtained from the EnergyPlus model.
</p>

<h5>Contaminant balance</h5>
<p>
The model has a parameter <code>use_C_flow</code>. If set to <code>true</code>,
then an input connector <code>C_flow</code> is enabled, which allows adding trace substances
to the room air. Note that this requires a medium model that has trace substances enabled.
</p>
<h5>Heat gains and CO2 added by people</h5>
<p>
If the EnergyPlus model computes internal heat gains
such as from people or equipment, then their sensible convective
and latent heat gains are automatically added to this room model,
and the radiant fraction is added to the EnergyPlus envelope and thus
treated correctly.
In addition, if desired, radiant, convective and latent heat gains
in units of <i>W/m<sup>2</sup></i>
can be added using the input connector <code>qGai_flow</code>.
</p>
<p>
Similarly, if people are modeled in EnergyPlus (using the
EnergyPlus <code>People</code> object), <i>and</i> if the
Modelica <code>Medium</code> contains CO2 (e.g., if
<code>Medium.nC &gt; 0</code> and
there is a <code>Medium.substanceName = \"CO2\"</code>),
then the CO2 emitted by the people is automatically added to this volume.
However, the \"Generic Contaminant\" modeled in EnergyPlus is not
added to the air volume. (Because EnergyPlus does not declare the
name of the species or its molar mass and hence it cannot be matched
to species in Modelica or converted to emitted mass flow rate.)
</p>
<p>
Also, note that while CO2 emitted from people simulated in EnergyPlus is added automatically to
the air balance of this model,
there is no CO2 added automatically for the heat gain specified through the input connector
<code>qGai_flow</code>. Hence, if <code>qGai_flow</code> accounts for people and CO2 should be modelled,
then the CO2 emitted by the people specified in <code>qGai_flow</code>
needs to be added manually to the input connector <code>C_flow</code>.
(This manual addition is needed because <code>qGai_flow</code> can also contain heat gains not caused
by people.)
</p>
</html>",
      revisions="<html>
<ul>
<li>
November 22, 2019, by Michael Wetter:<br/>
Replaced volume with dynamic balance.<br/>
This is for
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1657\">issue 1657</a>.
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
First implementation for <a href=\"https://github.com/lbl-srg/modelica-buildings/issues/1129\">issue 1129</a>.
</li>
</ul>
</html>"));
end ThermalZone;
