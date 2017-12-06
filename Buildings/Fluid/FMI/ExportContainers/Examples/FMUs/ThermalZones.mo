within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
model ThermalZones
  "Declaration of an FMU that exports multiple thermal zones"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZones(
    redeclare final package Medium = MediumA,
    nPorts =  3,
    nZon = 2);

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Modelica.SIunits.Volume V=6*10*3 "Room volume";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.SIunits.Temperature TASup_nominal = 273.15+18
    "Nominal air temperature supplied to room";
  parameter Modelica.SIunits.Temperature TRooSet = 273.15+24
    "Nominal room air temperature";
  parameter Modelica.SIunits.Temperature TOut_nominal = 273.15+30
    "Design outlet air temperature";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.SIunits.HeatFlowRate QRooInt_flow=
     1000 "Internal heat gains of the room";
  parameter Modelica.SIunits.HeatFlowRate QRooC_flow_nominal=
    -QRooInt_flow-10E3/30*(TOut_nominal-TRooSet)
    "Nominal cooling load of the room";
  parameter Modelica.SIunits.MassFlowRate mA_flow_nominal=
    1.3*QRooC_flow_nominal/1006/(TASup_nominal-TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{150,130},{130,150}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{110,130},{130,150}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{20,-20},
            {-20,20}},
        rotation=90,
        origin={0,-160}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-160})));
  Modelica.Blocks.Interfaces.RealOutput TRad1(final unit="K")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-160,10},{-180,30}})));
  Modelica.Blocks.Interfaces.RealOutput TRad2(final unit="K")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-160,-30},{-180,-10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon1(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea1(Q_flow=
        QRooInt_flow) "Prescribed heat flow for internal gains"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));
  MixingVolumes.MixingVolume vol1(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=3) "Room volume"
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon2(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{30,-26},{50,-6}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea2(Q_flow=
        QRooInt_flow) "Prescribed heat flow for internal gains"
    annotation (Placement(transformation(extent={{100,-56},{80,-36}})));
  MixingVolumes.MixingVolume vol2(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=3) "Room volume"
    annotation (Placement(transformation(extent={{80,-106},{100,-86}})));
  Sensors.MassFlowRate senMasFlo[nPorts](redeclare final package Medium = MediumA)
    "Mass flow rate sensor to connect thermal adapter with thermal zone."
    annotation (Placement(transformation(extent={{-90,90},{-70,110}})));
  Sensors.MassFlowRate senMasFlo1[nPorts](
                                         redeclare final package Medium = MediumA)
    "Mass flow rate sensor to connect thermal adapter with thermal zone."
    annotation (Placement(transformation(extent={{-90,50},{-70,70}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen1
    "Temperature sensor (that approximates the radiative temperature by the air temperature)"
    annotation (Placement(transformation(extent={{-80,10},{-100,30}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen2
    "Temperature sensor (that approximates the radiative temperature by the air temperature)"
    annotation (Placement(transformation(extent={{-80,-30},{-100,-10}})));

equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{130,140},{120,140}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(theCon1.port_b, vol1.heatPort) annotation (Line(points={{50,120},{50,120},
          {60,120},{60,40},{80,40}}, color={191,0,0}));
  connect(preHea1.port, vol1.heatPort) annotation (Line(points={{80,90},{60,90},
          {60,40},{80,40}}, color={191,0,0}));
  connect(TAirOut.T, weaBus.TDryBul) annotation (Line(points={{-32,120},{-40,120},
          {-40,140},{120,140}}, color={0,0,127}), Text(
      string="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TAirOut.port, theCon1.port_a)
    annotation (Line(points={{-10,120},{-10,120},{30,120}}, color={191,0,0}));

  connect(TOut, weaBus.TDryBul) annotation (Line(points={{0,-160},{0,-160},{0,-134},
          {-40,-134},{-40,140},{120,140}},            color={0,0,127}));
  connect(theCon2.port_b, vol2.heatPort) annotation (Line(points={{50,-16},{50,-16},
          {60,-16},{60,-96},{80,-96}}, color={191,0,0}));
  connect(preHea2.port, vol2.heatPort) annotation (Line(points={{80,-46},{60,-46},
          {60,-96},{80,-96}}, color={191,0,0}));
  connect(TAirOut.port, theCon2.port_a) annotation (Line(points={{-10,120},{-10,
          120},{0,120},{0,-16},{30,-16}}, color={191,0,0}));
  connect(vol1.heatPort, theZonAda[1].heaPorAir) annotation (Line(points={{80,
          40},{60,40},{60,152},{-120,152}}, color={191,0,0}));
  connect(vol2.heatPort, theZonAda[2].heaPorAir) annotation (Line(points={{80,
          -96},{60,-96},{60,4},{10,4},{10,152},{-120,152}}, color={191,0,0}));
  connect(theZonAda[2].ports, senMasFlo1.port_a) annotation (Line(points={{-120,
          160},{-112,160},{-112,60},{-90,60}}, color={0,127,255}));
  connect(senMasFlo.port_a, theZonAda[1].ports) annotation (Line(points={{-90,100},
          {-100,100},{-100,160},{-120,160}}, color={0,127,255}));
  connect(senMasFlo1.port_b, vol2.ports[1:3]) annotation (Line(points={{-70,60},
          {-60,60},{-60,-120},{92.6667,-120},{92.6667,-106}}, color={0,127,255}));
  connect(senMasFlo.port_b, vol1.ports[1:3]) annotation (Line(points={{-70,100},
          {-50,100},{-20,100},{-20,22},{92.6667,22},{92.6667,30}}, color={0,127,
          255}));
  connect(temSen1.port, vol1.heatPort) annotation (Line(points={{-80,20},{60,20},
          {60,40},{80,40}}, color={191,0,0}));
  connect(temSen2.port, vol2.heatPort) annotation (Line(points={{-80,-20},{-58,-20},
          {0,-20},{0,-96},{80,-96}}, color={191,0,0}));
  connect(temSen1.T, TRad1)
    annotation (Line(points={{-100,20},{-170,20},{-170,20}}, color={0,0,127}));
  connect(temSen2.T, TRad2) annotation (Line(points={{-100,-20},{-170,-20},{-170,
          -20}}, color={0,0,127}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-22,-112},{28,-132}},
          lineColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}}),
        graphics={
        Rectangle(
          extent={{20,136},{112,10}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{68,132},{106,108}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Very simplified
model of
a thermal zone."),
        Rectangle(
          extent={{20,0},{112,-126}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{68,-4},{106,-28}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          fontSize=12,
          textString="Very simplified
model of
a thermal zone.")}),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model
that contains two thermal zones with convective heat input from the
HVAC system only. The thermal zones are connected to an adaptor so that
they can be coupled
to an air-based HVAC system. The thermal zone is
taken from
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3
</a>.
</p>
<p>
The example extends from
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZones\">
Buildings.Fluid.FMI.ExportContainers.ThermalZones</a>
which provides
the input and output signals that are needed to interface
the acausal thermal zone models with causal connectors of FMI.
The instance <code>theZonAda</code> is the thermal zone adaptor
that contains on the right a fluid port, and on
the left signal ports which are then used to connect at
the top-level of the model to signal ports which are
exposed at the FMU interface.
</p>
</html>", revisions="<html>
<ul>
<li>
December 4, 2017, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>
for weather data file.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/867\">#867</a>.
</li>
<li>
September 14, 2016, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/ThermalZones.mos"
        "Export FMU"));
end ThermalZones;
