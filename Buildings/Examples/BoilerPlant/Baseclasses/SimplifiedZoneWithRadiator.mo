within Buildings.Examples.BoilerPlant.Baseclasses;
model SimplifiedZoneWithRadiator "Zone model"

  replaceable package MediumW =Buildings.Media.Water
    "Water medium model";

  parameter Modelica.Units.SI.HeatFlowRate Q_flow_nominal = 4359751.36
    "Nominal heat flow rate of radiator"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Temperature TRadSup_nominal = 273.15+70
    "Radiator nominal supply water temperature"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Temperature TRadRet_nominal = 273.15+50
    "Radiator nominal return water temperature"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.MassFlowRate mRad_flow_nominal=0.000604*1000
    "Radiator nominal mass flow rate"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.PressureDifference dpRad_nominal = 0
    "Nominal pressure drop across radiator"
    annotation(Dialog(group="Radiator"));

  parameter Modelica.Units.SI.Volume V=1200
    "Room volume"
    annotation(Dialog(group="Zone"));

  parameter Real zonTheCap(
    final unit="J/K",
    displayUnit="J/K",
    final quantity="HeatCapacity") = 2*V*1.2*1500+V*1.2*1006
    "Zone thermal capacitance"
    annotation(Dialog(group="Zone"));

  parameter Modelica.Units.SI.Temperature TAir_nominal=273.15 + 23.9
    "Air temperature at nominal condition"
    annotation(Dialog(group="Zone"));

  parameter Modelica.Units.SI.MassFlowRate mA_flow_nominal = V*1.2*6/3600
    "Nominal mass flow rate"
    annotation(Dialog(group="Zone"));

  Buildings.Controls.OBC.CDL.Interfaces.RealInput QFlo
    "Power added to zone"
    annotation (Placement(transformation(extent={{-138,-20},{-98,20}}),
      iconTransformation(extent={{-140,-20},{-100,20}})));

  Buildings.Controls.OBC.CDL.Interfaces.RealOutput TZon(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Measured zone temperature"
    annotation (Placement(transformation(extent={{100,-20},{140,20}}),
      iconTransformation(extent={{100,-20},{140,20}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_a(
    redeclare package Medium = MediumW)
    "HHW inlet port"
    annotation (Placement(transformation(extent={{-50,-110},{-30,-90}}),
      iconTransformation(extent={{-50,-110},{-30,-90}})));

  Modelica.Fluid.Interfaces.FluidPort_b port_b(
    redeclare package Medium = MediumW)
    "HHW outlet port"
    annotation (Placement(transformation(extent={{30,-110},{50,-90}}),
      iconTransformation(extent={{30,-110},{50,-90}})));

  Buildings.Fluid.HeatExchangers.Radiators.RadiatorEN442_2 rad(
    redeclare package Medium = MediumW,
    final m_flow_nominal=mRad_flow_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final Q_flow_nominal=Q_flow_nominal,
    final T_a_nominal=TRadSup_nominal,
    final T_b_nominal=TRadRet_nominal,
    final TAir_nominal=TAir_nominal,
    final dp_nominal=dpRad_nominal)
    "Radiator for zone heating loads"
    annotation (Placement(transformation(extent={{-10,-60},{10,-40}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor zonTem
    "Zone temperature sensor"
    annotation (Placement(transformation(extent={{60,-10},{80,10}})));

  Modelica.Thermal.HeatTransfer.Components.HeatCapacitor heaCap(
    final C=zonTheCap,
    final T(fixed=true))
    "Heat capacity for furniture and walls"
    annotation (Placement(transformation(extent={{-10,0},{10,20}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHea
    "Apply heating load on the zone"
    annotation (Placement(transformation(extent={{-58,-10},{-38,10}})));

equation
  connect(zonTem.T, TZon)
    annotation (Line(points={{81,0},{120,0}},  color={0,0,127}));
  connect(QFlo, preHea.Q_flow)
    annotation (Line(points={{-118,0},{-58,0}},  color={0,0,127}));
  connect(port_a, rad.port_a) annotation (Line(points={{-40,-100},{-40,-50},{-10,
          -50}},  color={0,127,255}));
  connect(port_b, rad.port_b) annotation (Line(points={{40,-100},{40,-50},{10,-50}},
        color={0,127,255}));
  connect(zonTem.port, heaCap.port) annotation (Line(points={{60,0},{0,0}},
                        color={191,0,0}));
  connect(preHea.port, heaCap.port)
    annotation (Line(points={{-38,0},{0,0}}, color={191,0,0}));
  connect(rad.heatPortCon, heaCap.port)
    annotation (Line(points={{-2,-42.8},{-2,0},{0,0}},  color={191,0,0}));
  connect(rad.heatPortRad, heaCap.port)
    annotation (Line(points={{2,-42.8},{2,0},{0,0}},  color={191,0,0}));
  annotation (defaultComponentName="zon",
    Icon(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}}),
      graphics={Rectangle(
        extent={{-100,100},{100,-100}},
        lineColor={0,0,0},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
      Text(
        extent={{-100,140},{100,100}},
        textColor={0,0,255},
        textString="%name")}),
    Diagram(
      coordinateSystem(
        preserveAspectRatio=false,
        extent={{-100,-100},{100,100}})),
    Documentation(info="<html>
      <p>
      This is a simplified zone model consisting of a thermal capacitor <code>zonTheCap</code>
      to represent the termal capacity of the zone. The heating load on the zone is 
      applied by the ideal source <code>QFlo</code> and is met by the radiator 
      <code>rad</code>.
      </p>
      </html>", revisions="<html>
      <ul>
      <li>
      November 25, 2022, by Karthik Devaprasad:<br/>
      First implementation.
      </li>
      </ul>
      </html>"));
end SimplifiedZoneWithRadiator;
