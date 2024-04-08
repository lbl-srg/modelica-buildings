within Buildings.Fluid.Humidifiers;
model DXDehumidifier "DX dehumidifier"
  extends Buildings.Fluid.Interfaces.PartialTwoPort;

  parameter Boolean addPowerToMedium = true
    "Transfer power and heat to the fluid medium";

  parameter Buildings.Fluid.Humidifiers.Data.Generic per
    "Performance data"
    annotation (choicesAllMatching=true,
      Placement(transformation(extent={{70,-100},{90,-80}})));

  parameter Modelica.Units.SI.VolumeFlowRate VWat_flow_nominal(
    final min=0)
    "Rated water removal rate"
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
    "Rated energy factor, in liter/kWh"
    annotation (Dialog(group="Nominal condition"));

  Modelica.Blocks.Interfaces.BooleanInput uEna
    "Enable signal"
    annotation (Placement(transformation(extent={{-140,-70},{-100,-30}}),
      iconTransformation(extent={{-120,30},{-100,50}})));

  Modelica.Blocks.Interfaces.RealOutput T(
    final unit="K",
    displayUnit="degC",
    final quantity="ThermodynamicTemperature")
    "Outlet air medium temperature"
    annotation (Placement(transformation(extent={{100,30},{140,70}}),
      iconTransformation(extent={{100,30},{120,50}})));

  Modelica.Blocks.Interfaces.RealOutput P(
    final unit="W",
    final quantity="Power")
    "Power consumption rate"
    annotation (Placement(transformation(extent={{100,-50},{140,-10}}),
      iconTransformation(extent={{100,-50},{120,-30}})));

  Modelica.Thermal.HeatTransfer.Sources.PrescribedHeatFlow preHeaFlo
    "Heat transfer into medium from dehumidifying action"
    annotation (Placement(transformation(extent={{-10,40},{10,60}})));

  Modelica.Thermal.HeatTransfer.Sensors.HeatFlowSensor heaFloSen
    "Sensor for measuring heat flow rate into medium during dehumidification"
    annotation (Placement(transformation(extent={{20,40},{40,60}})));

  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor senTem
    "Temperature sensor"
    annotation (Placement(transformation(extent={{60,40},{80,60}})));

  Modelica.Units.SI.MassFraction XOut
    "Outlet air water vapor mass fraction";

  Buildings.Fluid.Sensors.TemperatureTwoPort senTIn(
    redeclare package Medium = Medium,
    final m_flow_nominal=mAir_flow_nominal)
    "Inlet air temperature sensor"
    annotation (Placement(transformation(extent={{-82,-10},{-62,10}})));

  Buildings.Fluid.Humidifiers.Humidifier_u deHum(
    redeclare package Medium = Medium,
    final m_flow_nominal=mAir_flow_nominal,
    final dp_nominal=dp_nominal,
    final energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    final mWat_flow_nominal=-VWat_flow_nominal*rhoWat)
    "Baseclass for conditioning fluid medium"
    annotation (Placement(transformation(extent={{40,-10},{60,10}})));

  Buildings.Controls.OBC.CDL.Reals.Sources.Constant con(
    final k=0) if not addPowerToMedium
    "Zero source for heat flow rate if power is not added to fluid medium"
    annotation (Placement(transformation(extent={{-50,50},{-30,70}})));

  Buildings.Controls.OBC.CDL.Conversions.BooleanToReal booToRea
    "Convert enable signal from Boolean to Real"
    annotation (Placement(transformation(extent={{-90,-60},{-70,-40}})));

  Modelica.Blocks.Routing.RealPassThrough QHea if addPowerToMedium
    "Heat transfer into medium only if required"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));

  Buildings.Controls.OBC.CDL.Reals.Multiply u
    "Calculate non-zero humidity removal from inlet air only when component is enabled"
    annotation (Placement(transformation(extent={{-46,-50},{-26,-30}})));

  Buildings.Fluid.Sensors.MassFractionTwoPort senMasFra(
    redeclare package Medium = Medium,
    final m_flow_nominal=mAir_flow_nominal)
    "Inlet air water vapor mass fraction"
    annotation (Placement(transformation(extent={{-40,-10},{-20,10}})));

  Buildings.Fluid.Sensors.RelativeHumidityTwoPort senRelHum(
    redeclare package Medium = Medium,
    final m_flow_nominal=mAir_flow_nominal)
    "Inlet air relative humidity"
    annotation (Placement(transformation(extent={{-10,-10},{10,10}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter eneFac(
    final k=eneFac_nominal/(1000*1000*3600))
    "Multiply energy factor modifier by nominal energy factor (converted from 
    liter/kWh to m^3/J)"
    annotation (Placement(transformation(extent={{0,-100},{20,-80}})));

  Buildings.Controls.OBC.CDL.Reals.MultiplyByParameter watRemRat(
    final k=VWat_flow_nominal)
    "Calculate water removal rate by multiplying water removal modifier by nominal
    removal rate"
    annotation (Placement(transformation(extent={{0,-70},{20,-50}})));

  Buildings.Controls.OBC.CDL.Reals.Divide PDeh
    "Calculate dehumidification power consumption"
    annotation (Placement(transformation(extent={{40,-80},{60,-60}})));

  BaseClasses.PerformanceCurveModifier perCurMod(per=per)
    "Block for calculating modifier curves"
    annotation (Placement(transformation(extent={{-50,-94},{-30,-74}})));
protected
  constant Modelica.Units.SI.SpecificEnthalpy h_fg= Buildings.Utilities.Psychrometrics.Constants.h_fg
    "Latent heat of water vapor";

  constant Modelica.Units.SI.Density rhoWat=1000
    "Water density";


equation

    XOut= (port_a.m_flow*senMasFra.X + deHum.mWat_flow)/(port_a.m_flow+1e-6);

  connect(preHeaFlo.port, heaFloSen.port_a)
    annotation (Line(points={{10,50},{20,50}},color={191,0,0}));
  connect(senTem.T, T)
    annotation (Line(points={{81,50},{120,50}}, color={0,0,127}));
  connect(heaFloSen.port_b, deHum.heatPort)
    annotation (Line(points={{40,50},{50,50},{50,30},{20,30},{20,-6},{40,-6}},
       color={191,0,0}));
  connect(heaFloSen.port_b, senTem.port)
    annotation (Line(points={{40,50},{60,50}}, color={191,0,0}));
  connect(port_a, senTIn.port_a)
    annotation (Line(points={{-100,0},{-82,0}}, color={0,127,255}));
  connect(senTIn.port_b, senMasFra.port_a)
    annotation (Line(points={{-62,0},{-40,0}}, color={0,127,255}));
  connect(deHum.port_b, port_b)
    annotation (Line(points={{60,0},{100,0}}, color={0,127,255}));
  connect(senMasFra.port_b, senRelHum.port_a)
    annotation (Line(points={{-20,0},{-10,0}}, color={0,127,255}));
  connect(senRelHum.port_b, deHum.port_a)
    annotation (Line(points={{10,0},{40,0}},color={0,127,255}));
  connect(QHea.y, preHeaFlo.Q_flow) annotation (Line(points={{-29,30},{-20,30},{
          -20,50},{-10,50}}, color={0,0,127}));
  connect(u.y, deHum.u) annotation (Line(points={{-24,-40},{30,-40},{30,6},{39,6}},
        color={0,0,127}));
  connect(uEna, booToRea.u)
    annotation (Line(points={{-120,-50},{-92,-50}}, color={255,0,255}));
  connect(booToRea.y, u.u2) annotation (Line(points={{-68,-50},{-54,-50},{-54,-46},
          {-48,-46}},      color={0,0,127}));
  connect(con.y, preHeaFlo.Q_flow) annotation (Line(points={{-28,60},{-20,60},{
          -20,50},{-10,50}},
                         color={0,0,127}));
  connect(u.y, watRemRat.u) annotation (Line(points={{-24,-40},{-10,-40},{-10,-60},
          {-2,-60}}, color={0,0,127}));
  connect(watRemRat.y, PDeh.u1) annotation (Line(points={{22,-60},{30,-60},{30,
          -64},{38,-64}}, color={0,0,127}));
  connect(eneFac.y, PDeh.u2) annotation (Line(points={{22,-90},{30,-90},{30,-76},
          {38,-76}}, color={0,0,127}));
  connect(PDeh.y, QHea.u) annotation (Line(points={{62,-70},{80,-70},{80,-20},{
          -56,-20},{-56,30},{-52,30}}, color={0,0,127}));
  connect(PDeh.y, P) annotation (Line(points={{62,-70},{80,-70},{80,-30},{120,-30}},
        color={0,0,127}));
  connect(senTIn.T, perCurMod.T) annotation (Line(points={{-72,11},{-66,11},{-66,
          -80},{-52,-80}}, color={0,0,127}));
  connect(senRelHum.phi, perCurMod.phi) annotation (Line(points={{0.1,11},{0.1,
          12},{-60,12},{-60,-88},{-52,-88}}, color={0,0,127}));
  connect(perCurMod.watRemMod, u.u1) annotation (Line(points={{-29,-80},{-24,-80},
          {-24,-60},{-52,-60},{-52,-34},{-48,-34}}, color={0,0,127}));
  connect(perCurMod.eneFacMod, eneFac.u) annotation (Line(points={{-29,-88},{-14,
          -88},{-14,-90},{-2,-90}}, color={0,0,127}));
annotation (Icon(coordinateSystem(extent={{-100,-100},{100,100}}),  graphics={
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
defaultComponentName="dxDeh",
Documentation(info="<html>
<p>This is a zone air DX dehumidifier model based on the first principles and other 
calculations as defined in the EnergyPlus model <code>ZoneHVAC:Dehumidifier:DX</code>. 
While the EnergyPlus implementation adds the heat rejected by the condensor coil to the 
zone air heat balance, this model assumes that this rejected heat is added to the 
outlet air stream.</p>
<p>Two performance curves <code>watRemMod</code> 
and <code>eneFacMod</code> are specified to 
characterize the change in water removal and energy consumption at non-rated inlet 
air conditions. </p>
<p>The amount of exchanged moisture <code>mWat_flow</code>
is equal to </p> <p align=\"center\"><i>ṁ<sub>wat_flow</sub> = watRemMod * &rho; *  
V̇<sub>flow_nominal</i></sub> </p>
<p>The amount of heat added to the air stream <code>QHea</code> is equal to </p>
<p align=\"center\"><i>Q̇<sub>hea</sub> = ṁ<sub>wat_flow</sub> * h<sub>fg</sub> + P<sub>deh</sub> </i></p>
<p>Please note that the enthalpy of the exchanged moisture has been considered 
and therefore the added heat flow to the connector equals to P<sub>deh</sub>. </p>
<p align=\"center\"><i>P<sub>deh</sub> = V̇<sub>flow_nominal</sub> * watRemMod /
(eneFac<sub>nominal</sub> * eneFacMod), </i></p>
<p>where <code>VWat_flow_nominal</code> is 
the rated water removal flow rate and <code>eneFac_nominal</code> 
is the rated energy factor. h<sub>fg</sub> is the enthalpy of vaporization of air. </p>
<h4>Performance Curve Modifiers</h4>
<p>The water removal modifier curve <code>watRemMod</code> 
is a biquadratic curve with two independent variables: dry-bulb temperature and
relative humidity of the air entering the dehumidifier. </p>
<p align=\"center\"><i>watRemMod(T<sub>in</sub>, phi<sub>in</sub>) = a<sub>1</sub> 
+ a<sub>2</sub> T<sub>in</sub> + a<sub>3</sub> T<sub>in</sub> <sup>2</sup> + a<sub>4</sub> phi<sub>in</sub> 
+ a<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + a<sub>6</sub> T<sub>in</sub> phi<sub>in</i></sub> </p>
<p>The energy factor modifier curve <code>eneFacMod</code> 
is a biquadratic curve with two independent variables: dry-bulb temperature 
and relative humidity of the air entering the dehumidifier. </p>
<p align=\"center\"><i>eneFacMod(T<sub>in</sub>, phi<sub>in</sub>) = b<sub>1</sub> 
+ b<sub>2</sub> T<sub>in</sub> + b<sub>3</sub> T<sub>in</sub> <sup>2</sup> + 
b<sub>4</sub> phi<sub>in</sub> + b<sub>5</sub> phi<sub>in</sub> <sup>2</sup> + 
b<sub>6</sub> T<sub>in</sub> phi<sub>in</i></sub> </p>
</html>",
revisions="<html>
<ul>
<li>
June 20, 2023, by Xing Lu:<br/>
First implementation.
</li>
</ul>
</html>"),
    Diagram(coordinateSystem(extent={{-100,-120},{100,80}})));
end DXDehumidifier;
