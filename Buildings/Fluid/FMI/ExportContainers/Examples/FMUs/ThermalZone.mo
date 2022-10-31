within Buildings.Fluid.FMI.ExportContainers.Examples.FMUs;
model ThermalZone
  "Declaration of an FMU that exports a thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZone(
    redeclare final package Medium = MediumA,
    nPorts =  2);

  replaceable package MediumA = Buildings.Media.Air "Medium for air";

  parameter Modelica.Units.SI.Volume V=6*10*3 "Room volume";

  /////////////////////////////////////////////////////////
  // Air temperatures at design conditions
  parameter Modelica.Units.SI.Temperature TASup_nominal=273.15 + 18
    "Nominal air temperature supplied to room";
  parameter Modelica.Units.SI.Temperature TRooSet=273.15 + 24
    "Nominal room air temperature";
  parameter Modelica.Units.SI.Temperature TOut_nominal=273.15 + 30
    "Design outlet air temperature";

  /////////////////////////////////////////////////////////
  // Cooling loads and air mass flow rates
  parameter Modelica.Units.SI.HeatFlowRate QRooInt_flow=1000
    "Internal heat gains of the room";
  parameter Modelica.Units.SI.HeatFlowRate QRooC_flow_nominal=-QRooInt_flow -
      10E3/30*(TOut_nominal - TRooSet) "Nominal cooling load of the room";
  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal=1.3*
      QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";

  BoundaryConditions.WeatherData.ReaderTMY3 weaDat(
    pAtmSou=Buildings.BoundaryConditions.Types.DataSource.Parameter,
    TDryBul=TOut_nominal,
    filNam=Modelica.Utilities.Files.loadResource("modelica://Buildings/Resources/weatherdata/USA_IL_Chicago-OHare.Intl.AP.725300_TMY3.mos"),
    TDryBulSou=Buildings.BoundaryConditions.Types.DataSource.File,
    computeWetBulbTemperature=false) "Weather data reader"
    annotation (Placement(transformation(extent={{100,150},{80,170}})));
  BoundaryConditions.WeatherData.Bus weaBus "Weather data bus"
    annotation (Placement(transformation(extent={{-20,150},{0,170}})));
  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{20,-20},
            {-20,20}},
        rotation=90,
        origin={0,-160}),  iconTransformation(
        extent={{20,-20},{-20,20}},
        rotation=90,
        origin={0,-160})));
  Modelica.Blocks.Interfaces.RealOutput TRad(final unit="K")
    "Radiative temperature"
    annotation (Placement(transformation(extent={{-160,-10},{-180,10}})));
  Buildings.HeatTransfer.Sources.PrescribedTemperature TAirOut
    "Outside air temperature"
    annotation (Placement(transformation(extent={{-30,110},{-10,130}})));
  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{30,110},{50,130}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
    QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{100,80},{80,100}})));
  MixingVolumes.MixingVolumeMoistAir vol(
    redeclare package Medium = MediumA,
    m_flow_nominal=mA_flow_nominal,
    V=V,
    mSenFac=3,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2)
    annotation (Placement(transformation(extent={{80,30},{100,50}})));
  Modelica.Blocks.Sources.Constant mWat_flow(k=0.0) "mass flow rate"
    annotation (Placement(transformation(extent={{10,70},{30,90}})));
  Sensors.MassFlowRate senMasFlo[nPorts](redeclare final package Medium = MediumA)
    "Mass flow rate sensor to connect thermal adapter with thermal zone."
    annotation (Placement(transformation(extent={{-88,110},{-68,130}})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor temSen
    "Temperature sensor (that approximates the radiative temperature by the air temperature)"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
equation
  connect(weaDat.weaBus,weaBus)  annotation (Line(
      points={{80,160},{-10,160}},
      color={255,204,51},
      thickness=0.5,
      smooth=Smooth.None), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{50,120},{50,120},{60,120},{60,40},{80,40}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{80,90},{60,90},{60,40},{80,40}},
                                                            color={191,0,0}));
  connect(TAirOut.T, weaBus.TDryBul) annotation (Line(points={{-32,120},{-40,120},
          {-40,160},{-10,160}}, color={0,0,127}), Text(
      textString="%second",
      index=1,
      extent={{6,3},{6,3}}));
  connect(TAirOut.port, theCon.port_a)
    annotation (Line(points={{-10,120},{-10,120},{30,120}}, color={191,0,0}));

  connect(theZonAda.heaPorAir, vol.heatPort) annotation (Line(points={{-120,152},
          {60,152},{60,40},{80,40}},                              color={191,0,0}));
  connect(TOut, weaBus.TDryBul) annotation (Line(points={{0,-160},{0,-160},{0,-120},
          {0,160},{-10,160}},                         color={0,0,127}));
  connect(vol.mWat_flow, mWat_flow.y) annotation (Line(points={{78,48},{78,48},{
          54,48},{54,80},{31,80}}, color={0,0,127}));
  connect(theZonAda.ports, senMasFlo.port_a) annotation (Line(points={{-120,160},
          {-100,160},{-100,120},{-88,120}}, color={0,127,255}));
  connect(senMasFlo.port_b, vol.ports[1:2]) annotation (Line(points={{-68,120},{
          -60,120},{-60,20},{92,20},{92,30}}, color={0,127,255}));
  connect(temSen.port, vol.heatPort) annotation (Line(points={{-60,0},{60,0},{60,
          40},{80,40}}, color={191,0,0}));
  connect(temSen.T, TRad)
    annotation (Line(points={{-80,0},{-170,0}}, color={0,0,127}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-22,-112},{28,-132}},
          textColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}}),
        graphics={
        Rectangle(
          extent={{4,134},{140,4}},
          fillColor={215,215,215},
          fillPattern=FillPattern.Solid,
          pattern=LinePattern.None),
        Text(
          extent={{76,134},{114,110}},
          pattern=LinePattern.None,
          lineColor={0,0,127},
          horizontalAlignment=TextAlignment.Left,
          textString="Simplified model of
a thermal zone.")}),
    Documentation(info="<html>
<p>
This example demonstrates how to export a model
that contains one thermal zone with convective heat input from the
HVAC system only. The thermal zone is connected to an adaptor so that
it can be coupled
to an air-based HVAC system.
The thermal zone is
taken from
<a href=\"modelica://Buildings.Examples.Tutorial.SpaceCooling.System3\">
Buildings.Examples.Tutorial.SpaceCooling.System3</a>.
</p>
<p>
The example extends from
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.ThermalZone
</a>
which provides
the input and output signals that are needed to interface
the acausal thermal zone model with causal connectors of FMI.
The instance <code>theZonAda</code> is the thermal zone adaptor
that contains on the right a fluid port, and on
the left signal ports which are then used to connect at
the top-level of the model to signal ports which are
exposed at the FMU interface.
</p>
</html>", revisions="<html>
<ul>
<li>
March 11, 2020, by Michael Wetter:<br/>
Removed <code>fontSize</code> in annotation.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/pull/1318\">#1318</a>.
</li>
<li>
December 4, 2017, by Michael Wetter:<br/>
Added call to <code>Modelica.Utilities.Files.loadResource</code>
for weather data file.<br/>
This is for
<a href=\"https://github.com/ibpsa/modelica-ibpsa/issues/867\">#867</a>.
</li>
<li>
April 12, 2017, by Michael Wetter:<br/>
Removed temperature that is no longer needed.<br/>
This is for issue
<a href=\"https://github.com/lbl-srg/modelica-buildings/issues/704\">Buildings #704</a>.
</li>
<li>
September 20, 2016, by Thierry S. Nouidui:<br/>
Revised implementation and added mass flow rate sensors
to connect the thermal zone adaptor to the thermal zone.
</li>
<li>
April 28, 2016, by Thierry S. Nouidui:<br/>
First implementation.
</li>
</ul>
</html>"),
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Examples/FMUs/ThermalZone.mos"
        "Export FMU"));
end ThermalZone;
