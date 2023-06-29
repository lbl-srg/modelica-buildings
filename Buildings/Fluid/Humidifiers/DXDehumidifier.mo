within Buildings.Fluid.Humidifiers;
model DXDehumidifier "DX dehumidifier"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_nominal(
    final min=0)
    "Rated water removal rate, in m3/s"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.MassFlowRate mAir_flow_nominal
    "Nominal mass flow rate of air in the air stream"
    annotation (Dialog(group="Nominal condition"));

  parameter Modelica.Units.SI.PressureDifference dp_nominal(
    displayUnit="Pa")
    "Pressure difference"
    annotation (Dialog(group="Nominal condition"));

  parameter Real eneFac_nominal(
    final min=0)
    "Rated energy factor, in L/kwh"
    annotation (Dialog(group="Nominal condition"));

  parameter Boolean addPowerToMedium = true
    "Transfer power and heat to the fluid medium";

  parameter Buildings.Fluid.Humidifiers.Data.Generic per
    "Performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{60,-56},{80,-36}})));

  Modelica.Blocks.Interfaces.BooleanInput uEna
    "Enable signal"
    annotation (Placement(transformation(extent={{-120,-50},{-100,-30}}),
      iconTransformation(extent={{-120,-50},{-100,-30}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outlet air medium temperature"
    annotation (Placement(transformation(extent={{100,40},{120,60}}),
      iconTransformation(extent={{100,40},{120,60}})));

  Modelica.Blocks.Interfaces.RealOutput Q_flow(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Air heating rate"
    annotation (Placement(transformation(extent={{100,10},{120,30}}),
      iconTransformation(extent={{100,10},{120,30}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W",
    displayUnit="W",
    final quantity="Power")
    "Power consumption rate"
    annotation (Placement(transformation(extent={{100,-30},{120,-10}}),
      iconTransformation(extent={{100,-30},{120,-10}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Heat transfer into medium from dehumidifying action"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Sensor for measuring heat flow rate into medium"
    annotation (Placement(transformation(extent={{-20,50},{0,70}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Temperature sensor"
    annotation (Placement(transformation(extent={{38,50},{58,70}})));

  Modelica.Blocks.Sources.RealExpression u(
    y=if uEna == true
      then watRemMod
      else 0)
    "Remove humidity from inlet air only when component is enabled"
    annotation (Placement(transformation(extent={{-80,-50},{-60,-30}})));

  Modelica.Blocks.Sources.RealExpression QHea(
    y=if uEna == true
      then PDeh.y + (-deHum.mWat_flow)*h_fg
      else 0)
    "Heat transfer into medium only when component is enabled"
    annotation (Placement(transformation(extent={{-80,50},{-60,70}})));

  Modelica.Blocks.Sources.RealExpression PDeh(
    y=if uEna == true
      then VWat_flow_nominal*watRemMod/eneFac_nominal/eneFacMod*1000*1000*3600
      else 0)
    "Power consumed by dehumidification process"
    annotation (Placement(transformation(extent={{-80,-70},{-60,-50}})));

  Buildings.Fluid.Sensors.TemperatureTwoPort senTIn(
    redeclare package Medium = Medium,
    final m_flow_nominal=mAir_flow_nominal)
    "Inlet air temperature sensor"
    annotation (Placement(transformation(extent={{-80,-10},{-60,10}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium,
    m_flow_nominal=mAir_flow_nominal)
    "Inlet air relative humidity sensor"
    annotation (Placement(transformation(extent={{-50,-10},{-30,10}})));

  Buildings.Fluid.Humidifiers.Humidifier_u deHum(
    redeclare package Medium = Medium,
    m_flow_nominal=mAir_flow_nominal,
    dp_nominal=dp_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    mWat_flow_nominal=-VWat_flow_nominal*rhoWat)
    "Baseclass for conditioning fluid medium"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Continuous.Sources.Constant con(
    final k=0) if not addPowerToMedium
    "Zero source for heat flow rate if power is not added to fluid medium"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));

protected
  constant Modelica.Units.SI.SpecificEnthalpy h_fg= Buildings.Utilities.Psychrometrics.Constants.h_fg
       "Latent heat of water vapor";
  constant Modelica.Units.SI.Density rhoWat=1000 "Water density";

  Real watRemMod(each min=0, each nominal=1, each start=1)
    "Water removal modifier factor as a function of temperature and RH";

  Real eneFacMod(each min=0, each nominal=1, each start=1)
    "Energy factor modifier factor as a function of temperature and RH";

equation
    //-------------------------Part-load performance modifiers----------------------------//
    // Compute the water removal and energy factor modifier fractions, using a biquadratic curve.
    // Since the regression for capacity can have negative values
    // (for unreasonable inputs), we constrain its return value to be
    // non-negative.
    watRemMod =Buildings.Utilities.Math.Functions.smoothMax(
        x1=Buildings.Utilities.Math.Functions.biquadratic(
          a=per.watRem,
          x1=Modelica.Units.Conversions.to_degC(senTIn.T),
          x2=senRelHum.phi*100),
        x2=0.001,
        deltaX=0.0001);
    eneFacMod =Buildings.Utilities.Math.Functions.smoothMax(
        x1=Buildings.Utilities.Math.Functions.biquadratic(
          a=per.eneFac,
          x1=Modelica.Units.Conversions.to_degC(senTIn.T),
          x2=senRelHum.phi*100),
        x2=0.001,
        deltaX=0.0001);

  connect(preHeaFlo.port, heaFloSen.port_a)
    annotation (Line(points={{-30,60},{-20,60}}, color={191,0,0}));
  connect(senTem.T, T)
    annotation (Line(points={{59,60},{84,60},{84,50},{110,50}},
                                                color={0,0,127}));
  connect(Q_flow, QHea.y) annotation (Line(points={{110,20},{-54,20},{-54,60},{
          -59,60}},
                color={0,0,127}));
  connect(deHum.port_b, port_b)
    annotation (Line(points={{10,0},{100,0}}, color={0,127,255}));
  connect(heaFloSen.port_b, deHum.heatPort) annotation (Line(points={{0,60},{20,
          60},{20,40},{-20,40},{-20,-6},{-10,-6}}, color={191,0,0}));
  connect(heaFloSen.port_b, senTem.port) annotation (Line(points={{0,60},{38,60}},
                            color={191,0,0}));
  connect(senRelHum.port_b, deHum.port_a)
    annotation (Line(points={{-30,0},{-10,0}}, color={0,127,255}));
  connect(senTIn.port_b, senRelHum.port_a)
    annotation (Line(points={{-60,0},{-50,0}}, color={0,127,255}));
  connect(senTIn.port_a, port_a)
    annotation (Line(points={{-80,0},{-100,0}}, color={0,127,255}));
  connect(PDeh.y, P) annotation (Line(points={{-59,-60},{20,-60},{20,-20},{110,-20}},
        color={0,0,127}));
  connect(u.y, deHum.u) annotation (Line(points={{-59,-40},{-16,-40},{-16,6},{-11,
          6}}, color={0,0,127}));
  connect(con.y, preHeaFlo.Q_flow)
    annotation (Line(points={{-58,30},{-56,30},{-56,60},{-50,60}},
      color={0,0,127}));
  if addPowerToMedium then
    connect(QHea.y, preHeaFlo.Q_flow)
      annotation (Line(points={{-59,60},{-50,60}}, color={0,0,127}));
  end if;
  annotation (
defaultComponentName="dxDeh",
Documentation(info="<html>
<p>
This is a zone air DX dehumidifier model. The model assumes that this equipment 
removes the moisture from the air stream and simultaneously heats the air. 
</p>
<p>
Two performance curves <code>watRemMod</code> and <code>eneFacMod</code> are 
specified to characterize the change in water removal and energy consumption at 
part-load conditions.
</p>
<p>
The amount of exchanged moisture <code>mWat_flow</code> is equal to
</p>
<p align=\"center\"><i>ṁ<sub>wat_flow</sub> = watRemMod &rho; V̇<sub>flow_nominal</sub></i>
</p>
<p>
The amount of heat added to the air stream <code>QHea</code> is equal to 
</p>
<p align=\"center\"><i>Q̇<sub>hea</sub> = ṁ<sub>wat_flow</sub> h<sub>fg</sub> + P<sub>deh</sub> ,</i>
</p>
<p align=\"center\"><i>P<sub>deh</sub> = V̇<sub>flow_nominal</sub> watRemMod / (eneFac<sub>nominal</sub> eneFacMod), </i>
</p>
<p>
where <code>VWat_flow_nominal</code> is the rated water removal flow rate and 
<code>eneFac_nominal</code> is the rated energy factor. h<sub>fg</sub> is the 
enthalpy of vaporization of air.
</p>
<h4>Performance Curve Modifiers</h4>
<p>
The water removal modifier curve <code>watRemMod</code> is a biquadratic curve 
with two independent variables: dry-bulb temperature and relative humidity of the 
air entering the dehumidifier.
</p>
<p align=\"center\"><i>watRemMod(T<sub>in</sub>, phi<sub>in</sub>) = a<sub>1</sub> + a<sub>2</sub> T<sub>in</sub> + a<sub>3</sub> T<sub>in</sub> <sup>2</sup> + a<sub>4</sub> phi<sub>in</sub> + a<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + a<sub>6</sub> T<sub>in</sub> phi<sub>in</sub></i>
</p>
<p>
The energy factor modifier curve <code>eneFacMod</code> is a biquadratic curve 
with two independent variables: dry-bulb temperature and relative humidity of the 
air entering the dehumidifier. 
</p>
<p align=\"center\"><i>eneFacMod(T<sub>in</sub>, phi<sub>in</sub>) = b<sub>1</sub> + b<sub>2</sub> T<sub>in</sub> + b<sub>3</sub> T<sub>in</sub> <sup>2</sup> + b<sub>4</sub> phi<sub>in</sub> + b<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + b<sub>6</sub> T<sub>in</sub> phi<sub>in</sub></i>
</p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Icon(coordinateSystem(extent={{-100,-80},{100,80}}), graphics={
        Rectangle(
          extent={{-70,60},{70,-60}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={95,95,95},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-101,5},{100,-4}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{0,-4},{100,5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={255,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-100,5},{101,-5}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{-70,58},{70,-62}},
          lineColor={0,0,255},
          pattern=LinePattern.None,
          fillColor={0,62,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,42},{54,34},{54,34},{42,28},{42,30},{50,34},{50,34},{42,40},
              {42,42}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Rectangle(
          extent={{58,-54},{54,52}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,10},{54,2},{54,2},{42,-4},{42,-2},{50,2},{50,2},{42,8},{42,
              10}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{42,-26},{54,-34},{54,-34},{42,-40},{42,-38},{50,-34},{50,-34},
              {42,-28},{42,-26}},
          lineColor={255,255,255},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid)}),
    Diagram(coordinateSystem(extent={{-100,-80},{100,80}})));
end DXDehumidifier;
