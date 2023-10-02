within Buildings.Experimental.DHC.Loads.HotWater;
model ThermostaticMixingValve
  "A model for a thermostatic mixing valve"
  replaceable package Medium = Buildings.Media.Water "Water media model";
  parameter Modelica.Units.SI.MassFlowRate mMix_flow_nominal
    "Nominal mixed water flow rate to fixture";
  parameter Modelica.Units.SI.PressureDifference dpValve_nominal(min=0, displayUnit="Pa") "Nominal pressure drop of valve";
  parameter Real k = 0.1 "Proportional gain of valve controller";
  parameter Modelica.Units.SI.Time Ti = 15 "Integrator time constant of valve controller";
  Modelica.Fluid.Interfaces.FluidPort_b port_mix(
    redeclare package Medium = Medium)
    "Port for mixed water outlet to fixture(s)"
    annotation (Placement(transformation(extent={{90,-10},{110,10}})));

  Modelica.Fluid.Interfaces.FluidPort_a port_hotSou(redeclare package Medium =
        Medium) "Port for hot water supply from source"
    annotation (Placement(transformation(extent={{-110,30},{-90,50}})));
  Modelica.Fluid.Interfaces.FluidPort_a port_col(redeclare package Medium =
        Medium) "Port for domestic cold water supply"
    annotation (Placement(transformation(extent={{-110,-50},{-90,-30}})));
  Modelica.Blocks.Interfaces.RealInput TMixSet(
    final unit="K",
    displayUnit="degC")
    "Temperature setpoint of mixed water outlet"
    annotation (Placement(transformation(extent={{-140,60},{-100,100}})));
  Modelica.Blocks.Interfaces.RealOutput TMix(
    final unit="K",
    displayUnit="degC")
    "Temperature of the outlet hot water supply to fixture"
    annotation (Placement(transformation(extent={{100,50},{120,70}})));

  Buildings.Controls.Continuous.LimPID conPID(
    controllerType=Modelica.Blocks.Types.SimpleController.PI,
    k=k,
    Ti=Ti,
    reset=Buildings.Types.Reset.Parameter)
    "Controller for thermostatic valve"
    annotation (Placement(transformation(extent={{-40,70},{-20,90}})));
  Buildings.Fluid.Sensors.TemperatureTwoPort senTemMix(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Mixed water to fixture temperature sensor"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Fluid.Actuators.Valves.ThreeWayLinear val(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    portFlowDirection_1=Modelica.Fluid.Types.PortFlowDirection.Entering,
    portFlowDirection_2=Modelica.Fluid.Types.PortFlowDirection.Leaving,
    portFlowDirection_3=Modelica.Fluid.Types.PortFlowDirection.Entering,
    riseTime=5,
    final m_flow_nominal=mMix_flow_nominal,
    dpValve_nominal=dpValve_nominal) "Valve" annotation (Placement(
        transformation(
        extent={{10,10},{-10,-10}},
        rotation=180,
        origin={0,0})));

  Buildings.Fluid.Sensors.MassFlowRate senFloMix(redeclare package Medium =
        Medium) "Mass flow rate of mixed water to fixture"
    annotation (Placement(transformation(extent={{50,-10},{70,10}})));
  Modelica.Blocks.Logical.Hysteresis hys(uLow=uLow, uHigh=uHigh)
    "Hysteresis to reset controller if flow starts"
    annotation (Placement(transformation(extent={{-10,30},{-30,50}})));

  Fluid.Sensors.TemperatureTwoPort senTemHot(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Hot water temperature"
    annotation (Placement(transformation(extent={{-60,-10},{-40,10}})));
  Fluid.Sensors.TemperatureTwoPort senTemCol(
    redeclare final package Medium = Medium,
    allowFlowReversal=false,
    final m_flow_nominal=mMix_flow_nominal,
    tau=0) "Cold water temperature"
    annotation (Placement(transformation(extent={{-60,-50},{-40,-30}})));
protected
  parameter Real uLow = 0.01*mMix_flow_nominal "Low hysteresis threshold";
  parameter Real uHigh = 0.05*mMix_flow_nominal "High hysteresis threshold";
equation
  connect(senTemMix.T, conPID.u_m)
    annotation (Line(points={{30,11},{30,60},{-30,60},{-30,68}},
                                               color={0,0,127}));
  connect(val.port_2,senTemMix. port_a) annotation (Line(points={{10,-6.66134e-16},
          {20,-6.66134e-16},{20,0}}, color={0,127,255}));
  connect(conPID.y, val.y) annotation (Line(points={{-19,80},{0,80},{0,12}},
                            color={0,0,127}));
  connect(senTemMix.T,TMix)  annotation (Line(points={{30,11},{30,60},{110,60}},
                            color={0,0,127}));
  connect(senTemMix.port_b,senFloMix. port_a)
    annotation (Line(points={{40,0},{50,0}}, color={0,127,255}));
  connect(senFloMix.port_b,port_mix)
    annotation (Line(points={{70,0},{100,0}}, color={0,127,255}));
  connect(hys.u,senFloMix. m_flow)
    annotation (Line(points={{-8,40},{60,40},{60,11}}, color={0,0,127}));
  connect(hys.y, conPID.trigger)
    annotation (Line(points={{-31,40},{-38,40},{-38,68}}, color={255,0,255}));
  connect(conPID.u_s, TMixSet)
    annotation (Line(points={{-42,80},{-120,80}}, color={0,0,127}));
  connect(val.port_1, senTemHot.port_b)
    annotation (Line(points={{-10,0},{-40,0}}, color={0,127,255}));
  connect(senTemHot.port_a, port_hotSou) annotation (Line(points={{-60,0},{-80,0},
          {-80,40},{-100,40}}, color={0,127,255}));
  connect(port_col, senTemCol.port_a)
    annotation (Line(points={{-100,-40},{-60,-40}}, color={0,127,255}));
  connect(senTemCol.port_b, val.port_3)
    annotation (Line(points={{-40,-40},{0,-40},{0,-10}}, color={0,127,255}));
  annotation (
  defaultComponentName="theMixVal",
  preferredView="info",Documentation(info="<html>
<p>
This model implements a thermostatic mixing valve, which uses
a PI feedback controller to mix hot and cold fluid to achieve a specified 
hot water outlet temperature to send to a fixture(s).
</p>
</html>", revisions="<html>
<ul>
<li>
September 11, 2023 by David Blum:<br/>
Updated for release.
</li>
<li>
June 16, 2022 by Dre Helmns:<br/>
Initial Implementation.
</li>
</ul>
</html>"),Icon(coordinateSystem(preserveAspectRatio=false), graphics={
                                Rectangle(
        extent={{-100,-100},{100,100}},
        lineColor={0,0,127},
        fillColor={255,255,255},
        fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-4,50},{4,-50}},
      fillPattern=FillPattern.Solid,
      fillColor={238,46,47},
          origin={-54,40},
          rotation=90,
          pattern=LinePattern.None),
    Rectangle(
      extent={{-4,50},{4,-50}},
      fillPattern=FillPattern.Solid,
      fillColor={28,108,200},
          origin={-50,-40},
          rotation=90,
          pattern=LinePattern.None),
      Text(
          extent={{-153,147},{147,107}},
          textColor={0,0,255},
          fillPattern=FillPattern.HorizontalCylinder,
          fillColor={0,127,255},
          textString="%name"),
        Polygon(points={{-10,30},{-10,30}}, lineColor={28,108,200}),
        Polygon(
          points={{-20,30},{20,30},{-20,-30},{20,-30},{-20,30}},
          lineColor={0,0,0},
          fillColor={0,0,0},
          fillPattern=FillPattern.Solid),
        Polygon(
          points={{0,0},{30,20},{30,-14},{0,0}},
          lineColor={0,0,0},
          fillColor={255,255,255},
          fillPattern=FillPattern.Solid),
    Rectangle(
      extent={{-4,37},{4,-37}},
      fillPattern=FillPattern.Solid,
      fillColor={102,44,145},
          origin={67,-1.77636e-15},
          rotation=90,
          pattern=LinePattern.None),
    Rectangle(
      extent={{-4,7},{4,-7}},
      fillPattern=FillPattern.Solid,
      fillColor={28,108,200},
          origin={-4.44089e-16,-37},
          rotation=180,
          pattern=LinePattern.None),
    Rectangle(
      extent={{-4,7},{4,-7}},
      fillPattern=FillPattern.Solid,
      fillColor={238,46,47},
          origin={8.88178e-16,37},
          rotation=180,
          pattern=LinePattern.None),
        Line(
          points={{66,4},{64,42}},
          color={0,0,0},
          pattern=LinePattern.None),
        Line(points={{100,60},{98,60},{64,60},{64,4}}, color={0,0,0}),
        Text(
          extent={{-96,98},{-54,66}},
          textColor={0,0,0},
          textString="TSet")}),                                  Diagram(
        coordinateSystem(preserveAspectRatio=false)));
end ThermostaticMixingValve;
