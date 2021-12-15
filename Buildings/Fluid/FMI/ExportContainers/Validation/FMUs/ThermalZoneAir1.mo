within Buildings.Fluid.FMI.ExportContainers.Validation.FMUs;
block ThermalZoneAir1 "Validation of simple thermal zone"
  extends Buildings.Fluid.FMI.ExportContainers.ThermalZone(
    redeclare package Medium = Buildings.Media.Air,
    nPorts =  2);

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
  parameter Modelica.Units.SI.MassFlowRate m_flow_nominal=1.3*
      QRooC_flow_nominal/1006/(TASup_nominal - TRooSet)
    "Nominal air mass flow rate, increased by factor 1.3 to allow for recovery after temperature setback";

  Modelica.Blocks.Interfaces.RealOutput TOut(final unit="K")
    "Outdoor temperature" annotation (Placement(transformation(extent={{-20,-20},
            {20,20}},
        rotation=90,
        origin={0,200}),   iconTransformation(
        extent={{-20,-20},{20,20}},
        rotation=90,
        origin={0,200})));

  Buildings.HeatTransfer.Sources.PrescribedTemperature TOut1
    "Outside temperature"
    annotation (Placement(transformation(extent={{-60,102},{-40,122}})));

  Modelica.Thermal.HeatTransfer.Components.ThermalConductor theCon(G=10000/30)
    "Thermal conductance with the ambient"
    annotation (Placement(transformation(extent={{-20,102},{0,122}})));
  Modelica.Thermal.HeatTransfer.Sources.FixedHeatFlow preHea(Q_flow=
    QRooInt_flow) "Prescribed heat flow"
    annotation (Placement(transformation(extent={{60,102},{40,122}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    m_flow_nominal=m_flow_nominal,
    V=V,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    nPorts=2,
    mSenFac=3)
    annotation (Placement(transformation(extent={{40,52},{60,72}})));
  Modelica.Blocks.Sources.Constant TOutSou(k=303.15) "Outdoor temperature"
    annotation (Placement(transformation(extent={{-100,102},{-80,122}})));
protected
  FixedResistances.PressureDrop res1(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=10,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{80,150},{100,170}})));
  FixedResistances.PressureDrop res2(
    redeclare final package Medium = Medium,
    final m_flow_nominal=m_flow_nominal,
    final dp_nominal=10,
    linearized=true) "Flow resistance"
    annotation (Placement(transformation(extent={{80,130},{100,150}})));
public
  Sensors.MassFlowRate senMasFlo[nPorts](redeclare final package Medium = Medium)
    "Mass flow rate sensor to connect thermal adapter with thermal zone."
    annotation (Placement(transformation(extent={{-106,150},{-86,170}})));
equation
  connect(theCon.port_b,vol. heatPort)
    annotation (Line(points={{0,112},{0,112},{20,112},{20,62},{40,62}},
                                                    color={191,0,0}));
  connect(preHea.port,vol. heatPort)
    annotation (Line(points={{40,112},{20,112},{20,62},{40,62}},
                                                            color={191,0,0}));
  connect(TOut1.port,theCon. port_a)
    annotation (Line(points={{-40,112},{-40,112},{-20,112}},
                                                     color={191,0,0}));
  connect(vol.heatPort, theZonAda.heaPorAir) annotation (Line(points={{40,62},{40,
          62},{20,62},{20,140},{-114,140},{-120,140},{-120,152}},
                                            color={191,0,0}));
  connect(TOutSou.y, TOut1.T)
    annotation (Line(points={{-79,112},{-62,112}}, color={0,0,127}));
  connect(TOut, TOutSou.y) annotation (Line(points={{0,200},{0,162},{-70,162},{-70,
          112},{-79,112}}, color={0,0,127}));
  connect(res2.port_b, vol.ports[1]) annotation (Line(points={{100,140},{110,
          140},{110,38},{48,38},{48,52}}, color={0,127,255}));
  connect(res1.port_b, vol.ports[2]) annotation (Line(points={{100,160},{112,160},
          {114,160},{114,44},{114,42},{52,42},{52,52}},      color={0,127,255}));
  connect(senMasFlo.port_a, theZonAda.ports) annotation (Line(points={{-106,160},
          {-114,160},{-114,160},{-120,160}}, color={0,127,255}));
  connect(senMasFlo[1].port_b, res1.port_a) annotation (Line(points={{-86,160},{
          -20,160},{80,160}}, color={0,127,255}));
  connect(senMasFlo[2].port_b, res2.port_a) annotation (Line(points={{-86,160},
          {-86,160},{30,160},{30,140},{80,140}},                  color={0,127,255}));
    annotation (
              Icon(coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},
            {160,180}}), graphics={
        Text(
          extent={{-26,176},{24,156}},
          textColor={0,0,127},
          textString="TOut")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-160,-140},{160,180}})),
    Documentation(info="<html>
<p>
This example validates that
<a href=\"modelica://Buildings.Fluid.FMI.ExportContainers.ThermalZone\">
Buildings.Fluid.FMI.ExportContainers.ThermalZone
</a>
exports correctly as an FMU.
</p>
</html>", revisions="<html>
<ul>
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
__Dymola_Commands(file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/FMI/ExportContainers/Validation/FMUs/ThermalZoneAir1.mos"
        "Export FMU"));
end ThermalZoneAir1;
