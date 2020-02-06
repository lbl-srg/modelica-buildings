within Buildings.Fluid.HeatPumps.Examples;
model DOE2Reversible_CoolingHeating
  "Test model for a closed loop of a reverse heat pump based on the DOE 2 model"
 package Medium = Buildings.Media.Water "Medium model";

  parameter Buildings.Fluid.HeatPumps.Data.DOE2Reversible.EnergyPlus per(
   COPCoo_nominal=3)
   "Heat pump performance data"
   annotation (Placement(transformation(extent={{-160,60},{-140,80}})));
  parameter Modelica.SIunits.MassFlowRate m2_flow_nominal=per.m2_flow_nominal
   "Source heat exchanger nominal mass flow rate";
  parameter Modelica.SIunits.MassFlowRate m1_flow_nominal=per.m1_flow_nominal
   "Load heat exchanger nominal mass flow rate";

  Buildings.Fluid.HeatPumps.DOE2Reversible heaPum(
    redeclare package Medium1 = Medium,
    redeclare package Medium2 = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    T1_start=281.4,
    per=per)
   "Water to Water heat pump"
   annotation (Placement(transformation(extent={{-80,-40},{-60,-20}})));
  Sources.MassFlowSource_T souPum(
    redeclare package Medium = Medium,
    m_flow=m2_flow_nominal,
    T=293.15,
    nPorts=1)
   "Source side water pump"
   annotation (Placement(transformation(
      extent={{-10,-10},{10,10}},
      rotation=180,
      origin={-30,-60})));
  Modelica.Fluid.Sources.FixedBoundary souVol(
     redeclare package Medium = Medium,
     nPorts=1)
   "Volume for source side"
   annotation (Placement(transformation(extent={{-140,-70},{-120,-50}})));
  Controls.OBC.CDL.Continuous.Sources.TimeTable timeTable(
    table=[
      0,-   1;
      0.25, 0;
      0.5,  1;
      0.75, 0;
      1.00, -1],
    smoothness=Buildings.Controls.OBC.CDL.Types.Smoothness.ConstantSegments,
    offset={0},
    timeScale=3600) "Heat input into volume"
    annotation (Placement(transformation(extent={{-80,20},{-60,40}})));
  HeatTransfer.Sources.PrescribedHeatFlow heaFlo
    "Prescribed heat flow rate"
    annotation (Placement(transformation(extent={{-24,20},{-4,40}})));
  Movers.FlowControlled_m_flow pum(
    redeclare package Medium = Medium,
    energyDynamics=Modelica.Fluid.Types.Dynamics.SteadyState,
    m_flow_nominal=m1_flow_nominal,
    inputType=Buildings.Fluid.Types.InputType.Constant,
    addPowerToMedium=false,
    nominalValuesDefineDefaultPressureCurve=true,
    use_inputFilter=false,
    constantMassFlowRate=m1_flow_nominal)
    "Chilled water pump"
    annotation (Placement(transformation(extent={{-60,-10},{-80,10}})));
  MixingVolumes.MixingVolume vol(
    redeclare package Medium = Medium,
    T_start=293.15,
    m_flow_nominal=m1_flow_nominal,
    energyDynamics=Modelica.Fluid.Types.Dynamics.FixedInitial,
    V=0.5*3600*m1_flow_nominal/1000,
    nPorts=2)
    "Mixing volume mimics a room to be cooled"
     annotation (Placement(
        transformation(
        extent={{-10,-10},{10,10}},
        rotation=270,
        origin={0,-22})));
  Controls.OBC.CDL.Continuous.Sources.Constant TRooSet(k=273.15 + 20,
    y(final unit="K", displayUnit="degC")) "Set point for room temperature"
    annotation (Placement(transformation(extent={{20,30},{40,50}})));
  Sources.Boundary_pT pre(
      redeclare package Medium = Medium,
      nPorts=1)
    "Pressure source"
    annotation (Placement(transformation(
        extent={{-10,-10},{10,10}},
        rotation=0,
        origin={-130,0})));
  Modelica.Thermal.HeatTransfer.Sensors.TemperatureSensor TRoo
    "Room temperature"
    annotation (Placement(transformation(extent={{20,-10},{40,10}})));
  Controls.OBC.CDL.Continuous.LimPID con(
    controllerType=Buildings.Controls.OBC.CDL.Types.SimpleController.P,
    k=1,
    yMax=1) "Controller"
    annotation (Placement(transformation(extent={{50,30},{70,50}})));
  Controls.OBC.CDL.Continuous.Add THeaPumSet(k1=4) "Set point for heat pump"
    annotation (Placement(transformation(extent={{160,30},{180,50}})));
  Controls.OBC.CDL.Continuous.Hysteresis heaOn(uLow=0.01, uHigh=0.05)
    "Heating on"
    annotation (Placement(transformation(extent={{120,-10},{140,10}})));
  Controls.OBC.CDL.Continuous.Hysteresis cooOn(uLow=0.01, uHigh=0.05)
    "Cooling on"
    annotation (Placement(transformation(extent={{120,-50},{140,-30}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger booToInt(integerTrue=1,
      integerFalse=0) "Type conversion"
    annotation (Placement(transformation(extent={{150,-10},{170,10}})));
  Controls.OBC.CDL.Integers.Add uMod "Heat pump modus"
    annotation (Placement(transformation(extent={{180,-30},{200,-10}})));
  Controls.OBC.CDL.Conversions.BooleanToInteger booToInt1(integerTrue=-1,
      integerFalse=0) "Type conversion"
    annotation (Placement(transformation(extent={{150,-50},{170,-30}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSouMaxLvg(k=273.15 + 30, y(
        final unit="K", displayUnit="degC"))
    "Maximum leaving temperature on source side"
    annotation (Placement(transformation(extent={{-174,-30},{-154,-10}})));
  Controls.OBC.CDL.Continuous.Sources.Constant TSouMin(k=273.15 + 4, y(final
        unit="K", displayUnit="degC"))
    "Minimum leaving temperature on source side"
    annotation (Placement(transformation(extent={{-174,-66},{-154,-46}})));
  Controls.OBC.CDL.Continuous.Gain gai(k=-1) "Change of control signal sign"
    annotation (Placement(transformation(extent={{88,-50},{108,-30}})));
  Controls.OBC.CDL.Continuous.Gain gai1(k=per.hea.QEva_flow_nominal)
    "Gain for heat flow rate"
    annotation (Placement(transformation(extent={{-50,20},{-30,40}})));
  Controls.OBC.CDL.Conversions.IntegerToReal sig "Sign for heating or cooling"
    annotation (Placement(transformation(extent={{120,30},{140,50}})));
equation
  connect(souPum.ports[1], heaPum.port_a2)
   annotation (Line(points={{-40,-60},{-48,-60},{-48,-36},{-60,-36}},
                                                               color={0,127,255}));
  connect(heaPum.port_b2, souVol.ports[1])
   annotation (Line(points={{-80,-36},{-96,-36},{-96,-60},{-120,-60}},
                                                                  color={0,127,255}));
  connect(heaFlo.port, vol.heatPort)
   annotation (Line(points={{-4,30},{0,30},{0,-12}}, color={191,0,0}));
  connect(pum.port_a, vol.ports[1])
   annotation (Line(points={{-60,0},{-22,0},{-22,-20},{-10,-20}},
                                                             color={0,127,255}));
  connect(vol.ports[2], heaPum.port_b1)
   annotation (Line(points={{-10,-24},{-60,-24}},
                                            color={0,127,255}));
  connect(pum.port_b, heaPum.port_a1)
   annotation (Line(points={{-80,0},{-100,0},{-100,-24},{-80,-24}},
                                                            color={0,127,255}));
  connect(heaPum.port_a1, pre.ports[1])
   annotation (Line(points={{-80,-24},{-100,-24},{-100,0},{-120,0}},
                                                       color={0,127,255}));
  connect(vol.heatPort, TRoo.port)
    annotation (Line(points={{0,-12},{0,0},{20,0}}, color={191,0,0}));
  connect(TRooSet.y, con.u_s)
    annotation (Line(points={{42,40},{48,40}}, color={0,0,127}));
  connect(con.u_m, TRoo.T)
    annotation (Line(points={{60,28},{60,0},{40,0}}, color={0,0,127}));
  connect(heaOn.u, con.y) annotation (Line(points={{118,0},{80,0},{80,40},{72,40}},
                color={0,0,127}));
  connect(heaOn.y, booToInt.u)
    annotation (Line(points={{142,0},{148,0}}, color={255,0,255}));
  connect(cooOn.y, booToInt1.u)
    annotation (Line(points={{142,-40},{148,-40}}, color={255,0,255}));
  connect(booToInt.y, uMod.u1) annotation (Line(points={{172,0},{174,0},{174,-14},
          {178,-14}}, color={255,127,0}));
  connect(booToInt1.y, uMod.u2) annotation (Line(points={{172,-40},{174,-40},{174,
          -26},{178,-26}}, color={255,127,0}));
  connect(uMod.y, heaPum.uMod) annotation (Line(points={{202,-20},{230,-20},{230,
          62},{-94,62},{-94,-27},{-81,-27}}, color={255,127,0}));
  connect(TSouMin.y, heaPum.TSouMinLvg) annotation (Line(points={{-152,-56},{-144,
          -56},{-144,-33},{-81,-33}}, color={0,0,127}));
  connect(TSouMaxLvg.y, heaPum.TSouMaxLvg) annotation (Line(points={{-152,-20},{
          -144,-20},{-144,-30},{-81,-30}}, color={0,0,127}));
  connect(cooOn.u, gai.y)
    annotation (Line(points={{118,-40},{110,-40}}, color={0,0,127}));
  connect(gai.u, con.y) annotation (Line(points={{86,-40},{80,-40},{80,40},{72,40}},
                color={0,0,127}));
  connect(gai1.y, heaFlo.Q_flow)
    annotation (Line(points={{-28,30},{-24,30}}, color={0,0,127}));
  connect(timeTable.y[1], gai1.u)
    annotation (Line(points={{-58,30},{-52,30}}, color={0,0,127}));
  connect(uMod.y, sig.u) annotation (Line(points={{202,-20},{208,-20},{208,20},{
          100,20},{100,40},{118,40}}, color={255,127,0}));
  connect(THeaPumSet.y, heaPum.TSet) annotation (Line(points={{182,40},{190,40},
          {190,56},{-90,56},{-90,-21},{-81,-21}}, color={0,0,127}));
  connect(THeaPumSet.u1, sig.y) annotation (Line(points={{158,46},{150,46},{150,
          40},{142,40}}, color={0,0,127}));
  connect(THeaPumSet.u2, TRoo.T) annotation (Line(points={{158,34},{150,34},{150,
          24},{60,24},{60,0},{40,0}}, color={0,0,127}));
     annotation (Icon(coordinateSystem(preserveAspectRatio=false, extent={{-100,
            -100},{100,100}}), graphics={
        Ellipse(lineColor = {75,138,73},
                fillColor={255,255,255},
                fillPattern = FillPattern.Solid,
                extent={{-98,-100},{98,98}}),
        Polygon(lineColor = {0,0,255},
                fillColor = {75,138,73},
                pattern = LinePattern.None,
                fillPattern = FillPattern.Solid,
                points={{-30,64},{70,4},{-30,-56},{-30,64}})}),
              Diagram(
        coordinateSystem(preserveAspectRatio=false, extent={{-180,-100},{240,100}}),
        graphics={Text(
          extent={{-10,-48},{82,-80}},
          lineColor={28,108,200},
          textString="fixme: Check COP at t=2500
Check CR")}),__Dymola_Commands(
  file="modelica://Buildings/Resources/Scripts/Dymola/Fluid/HeatPumps/Examples/DOE2Reversible_CoolingHeating.mos"
        "Simulate and plot"),
         experiment(
      StopTime=7200,
      Tolerance=1e-06,
      __Dymola_Algorithm="Cvode"),
Documentation(info="<html>
<p>
Example that simulates the performance of
<a href=\"modelica://Buildings.Fluid.HeatPumps.DOE2Reversible_CoolingHeating\">
Buildings.Fluid.HeatPumps.DOE2Reversible_CoolingHeating</a>.
The heat pump takes as an input the set point at the load side.
</p>
<p>
The heat pump is connected to a control volume to which heat is added and removed,
and the heat pump is controlled to keep the temperature of this control volume at <i>22</i>&circ;C.
</p>

</html>", revisions="<html>
<ul>
<li>
February 4, 2020, by Michael Wetter:<br/>
First implementation.
</li>
</ul>
</html>"));
end DOE2Reversible_CoolingHeating;
